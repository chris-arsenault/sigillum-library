# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceValidationErrorsTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_meter_changes_must_land_on_bar_boundaries
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Bad meter change") do
        meter "4/4"
        meter do
          change "3/4", at: "bar 2 beat 2"
        end
      end
    end

    assert_equal "bad_meter_change_location", error.response.fetch(:code)

    zero_error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Bad meter change") do
        meter "4/4"
        meter do
          change "3/4", at: "bar 0"
        end
      end
    end

    assert_equal "bad_meter_change_location", zero_error.response.fetch(:code)
  end

  def test_duplicate_phrase_ids_across_spans_return_structured_repair_data
    piece = Partitura::Production.piece("Duplicate phrase ids") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "One", bars: 1..2 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end

        span bars: 2..2 do
          phrase :call, surface: :absolute do
            events "D5:1"
          end
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "duplicate_phrase_id", response.fetch(:code)
    assert_includes response.fetch(:repair_instruction), "unique"
    assert_includes response.fetch(:docs), "docs/architecture/partitura/surfaces/phrase_placement.md"
  end

  def test_duplicate_phrase_ids_inside_same_span_return_structured_repair_data
    piece = Partitura::Production.piece("Duplicate phrase ids") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end

          phrase :call, surface: :absolute do
            events "D5:1"
          end
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "duplicate_phrase_id", response.fetch(:code)
    assert_includes response.fetch(:message), "Phrase id call"
    assert_includes response.fetch(:docs), "docs/architecture/partitura/surfaces/phrase_placement.md"
  end

  def test_transport_readout_returns_json
    piece = load_piece
    parsed = JSON.parse(Partitura.production_readout(piece, :transport))

    assert_equal "partitura.transport", parsed.fetch("schema")
    assert_equal "production_hybrid", parsed.fetch("source_model")
    assert_equal "C5", parsed.fetch("timed_events").find { |event|
 event.fetch("offset_label") == "b1:1" && event.fetch("part") == "clarinet" }.fetch("pitch")
  end

  def test_mismatched_streams_return_structured_repair_data
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.events_from_absolute("C5 D5", "1")
    end

    response = error.response
    assert_equal "error", response.fetch(:status)
    assert_equal "surface_event_count_mismatch", response.fetch(:code)
    assert_equal :split_pitch_rhythm, response.fetch(:help_topic)
    assert_includes response.fetch(:repair_instruction), "align event-by-event"
    assert_includes response.fetch(:docs), "docs/architecture/partitura/surfaces/split_pitch_rhythm.md"
  end

  def test_bad_absolute_pitch_reports_absolute_surface_docs
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.events_from_absolute_events("H4:1")
    end

    response = error.response
    assert_equal "bad_pitch", response.fetch(:code)
    assert_equal :absolute, response.fetch(:help_topic)
    assert_includes response.fetch(:docs), "docs/architecture/partitura/surfaces/absolute.md"
  end

  def test_compile_response_checks_control_and_tempo_anchor_references
    piece = Partitura::Production.piece("Missing anchor") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      tempo do
        ritardando from: "bar 1 beat 1", to: :missing_anchor
      end

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "unknown_anchor", response.fetch(:code)
  end

  def test_compile_response_rejects_control_targets_that_match_nothing
    piece = Partitura::Production.piece("Bad target") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind }

      control do
        dynamic :mf, at: "bar 1 beat 1", for: :typo_part
      end

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "unknown_control_target", response.fetch(:code)
    assert_includes response.fetch(:docs), "docs/architecture/partitura/surfaces/controls.md"
  end

  def test_compile_response_rejects_placement_outside_containing_span
    piece = Partitura::Production.piece("Bad placement") do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }

      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1"
          end
          placement :call, part: :clarinet, at: "bar 2 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "placement_outside_span", response.fetch(:code)
  end

end
