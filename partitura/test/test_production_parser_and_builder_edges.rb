# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionParserAndBuilderEdgesTest < Minitest::Test
  def test_tempo_parser_normalizes_common_beat_units_to_quarter_bpm
    cases = {
      "whole = 30" => 120,
      "half = 45" => 90,
      "quarter = 96" => 96,
      "eighth = 132" => 66,
      "16th = 200" => 50,
      "32nd = 240" => 30
    }

    cases.each do |text, expected_bpm|
      assert_equal expected_bpm, Partitura::Production.bpm_from_text(text), text
    end
  end

  def test_tempo_parser_preserves_written_unit_dots_and_per_minute
    tempo = Partitura::Production.tempo_from_text("dotted-quarter = 52")
    assert_equal(
      { bpm: 78, beat_unit: "quarter", beat_unit_dots: 1, per_minute: 52 },
      tempo
    )
    assert_equal 174, Partitura::Production.bpm_from_text("dotted-quarter = 116")

    assert_equal 70, Partitura::Production.bpm_from_text("double-dotted-quarter = 40")
    assert_equal 60, Partitura::Production.bpm_from_text("triple dotted quarter = 32")

    approximate = Partitura::Production.tempo_from_text("dotted-quarter = ca. 52")
    assert_equal 78, approximate.fetch(:bpm)
    assert_equal "ca. 52", approximate.fetch(:per_minute)

    ranged = Partitura::Production.tempo_from_text("eighth = 132-144")
    assert_equal 69, ranged.fetch(:bpm)
    assert_equal "132-144", ranged.fetch(:per_minute)

    float_tempo = Partitura::Production.tempo_from_text("dotted-sixteenth = 80.5")
    assert_equal "16th", float_tempo.fetch(:beat_unit)
    assert_equal 80.5, float_tempo.fetch(:per_minute)
    assert_in_delta 30.1875, float_tempo.fetch(:bpm)
  end

  def test_tempo_parser_retains_legacy_numeric_fallback
    assert_equal 72.5, Partitura::Production.bpm_from_text("Allegro 72.5")
    assert_equal 148, Partitura::Production.bpm_from_text("Fast march tempo=148")
    assert_equal 148, Partitura::Production.tempo_from_text("Fast march q=148").fetch(:bpm)
    assert_equal 96, Partitura::Production.tempo_from_text("quarter = 96 unhurried").fetch(:bpm)
    assert_nil Partitura::Production.bpm_from_text("senza misura")
  end

  def test_tempo_parser_rejects_malformed_typed_marks_and_unrepresentable_playback
    assert_tempo_error("undotted-quarter = 60", "bad_tempo_mark")
    assert_tempo_error("dotted-quarter = fast", "bad_tempo_mark")
    assert_tempo_error("quarter = 144-132", "bad_tempo_mark")
    assert_tempo_error("quarter = 0", "tempo_out_of_midi_range")
    assert_tempo_error("32nd = 20", "tempo_out_of_midi_range")
    assert_tempo_error("quarter = 120000001", "tempo_out_of_midi_range")
  end

  def test_note_parser_rejects_bad_tokens_and_non_positive_durations
    assert_parse_error("C5")
    assert_parse_error("C5:0", "duration must be positive")
    assert_parse_error("[]:1", "empty chord")
  end

  def test_parse_bar_range_accepts_single_range_and_deduplicated_lists
    assert_equal 5..8, Partitura::Production.parse_bar_range("5-8")
    assert_equal [2, 4, 8, 9, 10], Partitura::Production.parse_bar_range("2,4,8-10,9")
  end

  def test_parse_bar_range_rejects_malformed_ranges_and_lists
    assert_raises_with_message(ArgumentError, "bar range must look") do
      Partitura::Production.parse_bar_range("bar 5")
    end
    assert_raises_with_message(ArgumentError, "bar list must look") do
      Partitura::Production.parse_bar_range("2, nope")
    end
  end

  def test_surface_parsers_report_bad_degrees_intervals_and_bar_counts
    degree = assert_compile_error("bad_degree") do
      Partitura::Production.events_from_degrees("1 8", "1 1", "C4")
    end
    assert_equal "degrees", degree.response.fetch(:help_topic)

    interval = assert_compile_error("bad_interval") do
      Partitura::Production.events_from_intervals("0 nope", "1 1", "C4")
    end
    assert_equal "intervals", interval.response.fetch(:help_topic)

    mismatch = assert_compile_error("surface_bar_count_mismatch") do
      Partitura::Production.events_from_absolute("C5 | D5", "1", help_topic: :split_pitch_rhythm)
    end
    assert_includes mismatch.response.fetch(:repair_instruction), "bar separators"
  end

  def test_phrase_builder_requires_surface_fields_and_rejects_unknown_surface
    missing = assert_compile_error("missing_phrase_field") do
      Partitura::Production.piece("Missing phrase field") do
        roster { part :flute, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..1 do
          span bars: 1..1 do
            phrase(:line, surface: :degrees) { rhythm "1" }
          end
        end
      end
    end
    assert_includes missing.response.fetch(:message), "missing degrees"

    unknown = assert_compile_error("unknown_surface") do
      Partitura::Production.piece("Unknown surface") do
        roster { part :flute, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..1 do
          span bars: 1..1 do
            phrase(:line, surface: :made_up) do
              pitches "C5"
              rhythm "1"
            end
          end
        end
      end
    end
    assert_equal "decision", unknown.response.fetch(:help_topic)
  end

  def test_builder_errors_cover_missing_music21_target_role_and_bad_locations
    assert_compile_error("missing_music21_instrument") do
      Partitura::Production.piece("Missing instrument") { roster { part :flute, "Flute" } }
    end

    assert_compile_error("missing_control_target") do
      Partitura::Production.piece("Missing control target") do
        control { dynamic :mf, at: "bar 1 beat 1" }
      end
    end

    assert_compile_error("missing_placement_role") do
      one_bar_piece("Missing role", include_role: false)
    end

    assert_compile_error("bad_location") do
      one_bar_piece("Bad placement location", placement_at: "measure 1")
    end
  end

  def test_compile_response_reports_span_and_meter_validation_errors
    span_error = one_bar_piece("Span outside section", span_bars: 1..2).compile_response
    assert_equal "span_outside_section", span_error.fetch(:code)

    duplicate_meter = Partitura::Production.piece("Duplicate meters") do
      meter "4/4"
      meter { change "3/4", at: "bar 2"; change "5/8", at: "bar 2" }
      roster { part :flute, "Flute", music21: "Flute" }
    end.compile_response
    assert_equal "duplicate_meter_change", duplicate_meter.fetch(:code)
  end

  private

  def assert_tempo_error(text, code)
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.tempo_from_text(text)
    end
    assert_equal code, error.response.fetch(:code)
    assert_equal "controls", error.response.fetch(:help_topic)
  end

  def assert_parse_error(text, message = "bad note token")
    error = assert_raises(Partitura::ParseError) { Partitura::NoteParser.parse(text) }
    assert_includes error.message, message
  end

  def assert_compile_error(code)
    error = assert_raises(Partitura::Production::CompileError) { yield }
    assert_equal code, error.response.fetch(:code)
    error
  end

  def assert_raises_with_message(error_class, message)
    error = assert_raises(error_class) { yield }
    assert_includes error.message, message
  end

  def one_bar_piece(title, span_bars: 1..1, placement_at: "bar 1 beat 1", include_role: true)
    Partitura::Production.piece(title) do
      meter "4/4"
      key "C"
      roster { part :flute, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: span_bars do
          phrase(:line, surface: :absolute) { events "C5:4" }
          if include_role
            placement :line, part: :flute, at: placement_at, role: :foreground
          else
            placement :line, part: :flute, at: placement_at
          end
        end
      end
    end
  end
end
