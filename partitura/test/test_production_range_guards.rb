# frozen_string_literal: true

require_relative "support/production_surface_helpers"

# Roster range enforcement (note_out_of_range / bad_part_range) and the range_check
# sounding projection.
class ProductionRangeGuardsTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_note_outside_declared_roster_range_is_rejected
    piece = Partitura::Production.piece("Range") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute", range: "C4-C7" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :low, surface: :absolute do
            events "G3:1 r:3"
          end
          placement :low, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "note_out_of_range", response.fetch(:code)
    assert_includes response.fetch(:message), "G3"
    assert_equal "C4-C7", response.fetch(:declared_range)
  end

  def test_bad_roster_range_string_is_rejected
    piece = Partitura::Production.piece("Bad range") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute", range: "low to high" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            events "C5:4"
          end
          placement :call, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "bad_part_range", response.fetch(:code)
  end

  def test_range_check_view_reports_sounding_span
    piece = Partitura::Production.piece("Range view") do
      meter "4/4"
      roster do
        part :fl, "Flute", music21: "Flute", range: "C4-C7"
        part :va, "Viola", music21: "Viola"
      end
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :a, surface: :absolute do
            events "C5:2 G5:2"
          end
          phrase :b, surface: :absolute do
            events "C3:4"
          end
          placement :a, part: :fl, at: "bar 1 beat 1", role: :foreground
          placement :b, part: :va, at: "bar 1 beat 1", role: :bass
        end
      end
    end

    readout = Partitura.production_readout(piece, :range_check)
    assert_includes readout, "fl: sounds C5-G5; declared C4-C7"
    assert_includes readout, "va: sounds C3-C3; no range: declared"
  end

end
