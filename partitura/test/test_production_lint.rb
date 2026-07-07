# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ProductionLintTest < Minitest::Test
  def test_long_phrase_warns_then_errors_at_thresholds
    warn_piece = piece_with_pad_bars(10)
    lints = Partitura::Production::Lint.run(warn_piece)
    warn_lint = lints.find { |lint| lint[:rule] == "phrase_length" }
    assert_equal "warn", warn_lint.fetch(:level)
    assert_equal "ok", warn_piece.compile_response.fetch(:status)
    assert_includes warn_piece.compile_response.fetch(:lints), warn_lint

    error_piece = piece_with_pad_bars(30)
    response = error_piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "lint_error", response.fetch(:code)
    assert(response.fetch(:lints).any? { |lint| lint[:level] == "error" })
  end

  def test_lint_thresholds_are_configurable_per_piece
    piece = piece_with_pad_bars(30, length_thresholds: { warn: 40, error: 60 })

    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_empty(Partitura::Production::Lint.run(piece).select { |lint| lint[:rule] == "phrase_length" })
  end

  def test_diatonic_absolute_line_gets_degrees_nudge
    piece = Partitura::Production.piece("Nudge") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :tune, surface: :split_pitch_rhythm do
            pitches "C5 D5 E5 F5 | G5 A5 B5 C6"
            rhythm  "1 1 1 1 | 1 1 1 1"
          end
          placement :tune, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    lints = Partitura::Production::Lint.run(piece)
    nudge = lints.find { |lint| lint[:rule] == "surface_nudge" && lint[:help_topic] == "degrees" }
    assert nudge, "expected a degrees surface nudge, got #{lints.inspect}"
    assert_equal "warn", nudge.fetch(:level)
  end

  def test_surface_nudges_can_be_disabled
    piece = Partitura::Production.piece("No nudge") do
      meter "4/4"
      lint { rule :surface_nudges, enabled: false }
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :tune, surface: :split_pitch_rhythm do
            pitches "C5 D5 E5 F5 | G5 A5 B5 C6"
            rhythm  "1 1 1 1 | 1 1 1 1"
          end
          placement :tune, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    assert_empty(Partitura::Production::Lint.run(piece).select { |lint| lint[:rule] == "surface_nudge" })
  end

  def test_repeated_transposed_cell_gets_intervals_nudge
    piece = Partitura::Production.piece("Cell") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :cells, surface: :split_pitch_rhythm do
            pitches "C5 Eb5 D5 G5 | E5 G5 F#5 B5"
            rhythm  "1 1 1 1 | 1 1 1 1"
          end
          placement :cells, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    lints = Partitura::Production::Lint.run(piece)
    assert(lints.any? { |lint| lint[:rule] == "surface_nudge" && lint[:help_topic] == "intervals" },
           "expected an intervals nudge, got #{lints.inspect}")
  end

  def test_lint_view_renders
    readout = Partitura.production_readout(piece_with_pad_bars(10), :lint)
    assert_includes readout, "# Lint"
    assert_includes readout, "phrase_length"
  end

  private

  def piece_with_pad_bars(bars, length_thresholds: nil)
    Partitura::Production.piece("Lint length #{bars}") do
      meter "4/4"
      lint { rule :phrase_length, **length_thresholds } if length_thresholds
      roster { part :va, "Viola", music21: "Viola" }
      section :s1, "One", bars: 1..bars do
        span bars: 1..bars do
          phrase :pad, surface: :absolute do
            events "C3:#{bars * 4}"
          end
          placement :pad, part: :va, at: "bar 1 beat 1", role: :pad
        end
      end
    end
  end
end
