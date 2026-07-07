# frozen_string_literal: true

require_relative "support/production_surface_helpers"

# Compile guards added by the LLM-first remediation: closed mark vocabulary, bar
# marker/onset/span-overflow alignment, roster range enforcement, and error context.
class ProductionAlignmentGuardsTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_unknown_inline_mark_is_a_compile_error_with_vocabulary
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Bad mark") do
        roster { part :fl, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..1 do
          span bars: 1..1 do
            phrase :call, surface: :absolute do
              events "C5:1{staccato}"
            end
          end
        end
      end
    end

    response = error.response
    assert_equal "unknown_mark", response.fetch(:code)
    assert_equal "marks", response.fetch(:help_topic)
    assert_equal "call", response.fetch(:phrase).to_s
    assert_includes response.fetch(:message), "staccato"
    assert(response.fetch(:vocabulary).any? { |line| line.include?("stacc") })
  end

  def test_txt_marks_and_vocabulary_marks_compile
    piece = Partitura::Production.piece("Good marks") do
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:1{mf,stacc,slur(,txt:con_sord.} D5:1{slur),arp:down} r:2"
          end
          placement :call, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_bar_marker_must_land_on_barline
    piece = Partitura::Production.piece("Misaligned marker") do
        meter "4/4"
        roster { part :fl, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..2 do
          span bars: 1..2 do
            phrase :line, surface: :split_pitch_rhythm do
              pitches "C5 D5 E5 | F5 G5"
              rhythm  "1 1 1 | 1 1"
            end
            placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground
          end
        end
      end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "bar_marker_misaligned", response.fetch(:code)
    assert_includes response.fetch(:message), "barline"
  end

  def test_pickup_placement_aligns_markers_against_the_meter
    piece = Partitura::Production.piece("Pickup") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :pickup_line, surface: :split_pitch_rhythm do
            pitches "C5 D5 | E5 F5 G5 r"
            rhythm  ".5 .5 | 1 1 1 1"
          end
          placement :pickup_line, part: :fl, at: "bar 1 beat 4", role: :foreground
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_attacks_crossing_barline_without_marker_are_rejected
    piece = Partitura::Production.piece("Missing markers") do
        meter "4/4"
        roster { part :fl, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..2 do
          span bars: 1..2 do
            phrase :wall, surface: :split_pitch_rhythm do
              pitches "C5 D5 E5 F5 G5 A5"
              rhythm  "1 1 1 1 1 1"
            end
            placement :wall, part: :fl, at: "bar 1 beat 1", role: :foreground
          end
        end
      end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "bar_onsets_cross_barline", response.fetch(:code)
  end

  def test_sustains_may_cross_barlines_without_markers
    piece = Partitura::Production.piece("Pad") do
      meter "4/4"
      roster { part :va, "Viola", music21: "Viola" }
      section :s1, "One", bars: 1..4 do
        span bars: 1..4 do
          phrase :pad, surface: :absolute do
            events "C3:8 | r:4 [C3,G3]:4"
          end
          placement :pad, part: :va, at: "bar 1 beat 1", role: :pad
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_phrase_sounding_past_span_end_is_rejected
    piece = Partitura::Production.piece("Overflow") do
        meter "4/4"
        roster { part :fl, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..1 do
          span bars: 1..1 do
            phrase :long, surface: :absolute do
              events "C5:5"
            end
            placement :long, part: :fl, at: "bar 1 beat 1", role: :foreground
          end
        end
      end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "phrase_exceeds_span", response.fetch(:code)
  end

  def test_bar_markers_align_across_meter_changes
    piece = Partitura::Production.piece("Meter change") do
      meter "4/4"
      meter do
        change "3/4", at: "bar 2"
      end
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..3 do
        span bars: 1..3 do
          phrase :line, surface: :split_pitch_rhythm do
            pitches "C5 D5 E5 F5 | G5 A5 B5 | C6 B5 A5"
            rhythm  "1 1 1 1 | 1 1 1 | 1 1 1"
          end
          placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_bar_marker_misaligned_after_meter_change_is_rejected
    piece = Partitura::Production.piece("Meter change bad") do
      meter "4/4"
      meter do
        change "3/4", at: "bar 2"
      end
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..3 do
        span bars: 1..3 do
          phrase :line, surface: :split_pitch_rhythm do
            pitches "C5 D5 E5 F5 | G5 A5 | D6 E6"
            rhythm  "1 1 1 1 | 1 3 | 1 1"
          end
          placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "bar_marker_misaligned", response.fetch(:code)
  end

  def test_stream_errors_carry_phrase_and_container_context
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Mismatch") do
        roster { part :fl, "Flute", music21: "Flute" }
        section :s9, "One", bars: 1..2 do
          span bars: 1..2 do
            phrase :long_line, surface: :split_pitch_rhythm do
              pitches "C5 D5 E5"
              rhythm  "1 1"
            end
          end
        end
      end
    end

    response = error.response
    assert_equal "surface_event_count_mismatch", response.fetch(:code)
    assert_equal "long_line", response.fetch(:phrase).to_s
    assert_equal "s9", response.fetch(:section).to_s
    assert_equal "1-2", response.fetch(:span_bars)
    assert_includes response.fetch(:message), "long_line"
  end

end
