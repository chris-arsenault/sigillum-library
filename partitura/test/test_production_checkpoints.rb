# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ProductionCheckpointsTest < Minitest::Test
  def test_matching_checkpoint_compiles
    piece = checkpoint_piece(foreground: "fl: C5 _ D5 E5", pulse: "dr: X . X X")
    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_wrong_slot_pitch_is_a_checkpoint_mismatch
    piece = checkpoint_piece(foreground: "fl: C5 D5 _ E5")
    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "checkpoint_mismatch", response.fetch(:code)
    assert_equal 2, response.fetch(:slot)
    assert_equal "foreground", response.fetch(:lane).to_s
  end

  def test_phantom_lane_for_silent_part_is_a_checkpoint_mismatch
    piece = checkpoint_piece(pulse: "dr: X X X X")
    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "checkpoint_mismatch", response.fetch(:code)
    assert_includes response.fetch(:message), "no attack"
  end

  def test_prose_lane_is_unparseable
    piece = checkpoint_piece(foreground: "clarinet degree 5 = C5")
    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "checkpoint_lane_unparseable", response.fetch(:code)
  end

  def test_subdivided_slot_token_verifies_ordered_attacks
    piece = Partitura::Production.piece("Subdivision") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :line, surface: :absolute do
            events "C5:1.5 Bb4:.25 A4:.25 F4:2"
          end
          placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground
          staff_bar 1 do
            foreground "fl: C5 _ _ Bb4/A4 F4 _ _ _"
          end
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  private

  # One 4/4 bar: fl plays C5:1 (sustain) D5:1 E5:1 r:1 -> slots C5 _ D5 E5? No:
  # C5:2 D5:1 E5:1 gives slots C5 _ D5 E5. dr attacks beats 1, 3, 4.
  def checkpoint_piece(foreground: nil, pulse: nil)
    Partitura::Production.piece("Checkpoint") do
      meter "4/4"
      roster do
        part :fl, "Flute", music21: "Flute"
        part :dr, "Drum", music21: "Percussion", family: :percussion
      end
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :line, surface: :absolute do
            events "C5:2 D5:1 E5:1"
          end
          placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground

          phrase :beats, surface: :absolute do
            events "C3:1 r:1 C3:1 C3:1"
          end
          placement :beats, part: :dr, at: "bar 1 beat 1", role: :pulse

          staff_bar 1 do
            foreground foreground if foreground
            pulse pulse if pulse
          end
        end
      end
    end
  end
end
