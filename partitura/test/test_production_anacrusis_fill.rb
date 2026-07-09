# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionAnacrusisFillTest < Minitest::Test
  include ProductionSurfaceHelpers

  def test_phrase_anacrusis_starts_before_placement_downbeat
    piece = Partitura::Production.piece("Pickup") do
      meter "4/4"; key "C"
      roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      section :s1, "One", bars: 1..2 do
        span bars: 2..2 do
          phrase :call, surface: :absolute do
            anacrusis 1
            events "G4:1 | C5:4"
          end
          placement :call, part: :flute, at: "bar 2 beat 1", role: :foreground
        end
      end
    end

    events = piece.timed_events(include_rests: false)
    assert_equal "b1:4", piece.format_offset(events.first.offset)
    assert_equal "b2:1", piece.format_offset(events.last.offset)
    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_inline_fill_creates_short_fill_role_with_pickup
    piece = Partitura::Production.piece("Fill") do
      meter "4/4"; key "C"
      roster { part :snare, "Snare", music21: "Percussion", family: :percussion, range: "C3-C3" }
      section :s1, "One", bars: 1..2 do
        span bars: 2..2 do
          fill :setup, part: :snare, at: "bar 2 beat 1", anacrusis: 1, surface: :absolute do
            events "C3:.5{accent} C3:.5"
          end
        end
      end
    end

    placement = piece.placements.first
    assert_equal :fill, placement.role
    assert_equal true, placement.fill
    assert_equal "b1:4", piece.format_offset(piece.timed_events.first.offset)
    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_reusable_fill_material_realizes_cross_voice_transforms
    piece = Partitura::Production.piece("Reusable fill") do
      meter "4/4"; key "C"
      fill_material :turn, surface: :intervals do
        anchor "C5"
        intervals "0 -2 +1 +4"
        rhythm ".25 .25 .25 .25"
      end
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind, range: "C4-C7"
        part :oboe, "Oboe", music21: "Oboe", family: :woodwind, range: "Bb3-F6"
      end
      section :s1, "One", bars: 1..2 do
        span bars: 2..2 do
          fill :flute_turn, from: :turn, part: :flute, at: "bar 2 beat 1", anacrusis: 1, transpose_to: "D5"
          fill :oboe_turn, from: :turn, part: :oboe, at: "bar 2 beat 1", anacrusis: 1 do
            transpose_to "E5"
            invert
          end
        end
      end
    end

    flute = piece.timed_events.select { |event| event.part == :flute }.map(&:pitch_label)
    oboe = piece.timed_events.select { |event| event.part == :oboe }.map(&:pitch_label)
    assert_equal %w[D5 C5 C#5 F5], flute
    assert_equal %w[E5 F#5 F5 C#5], oboe
    assert(piece.placements.all?(&:fill))
  end

  def test_degree_fill_material_key_matches_target_key
    piece = Partitura::Production.piece("Key matched fill") do
      meter "4/4"; key "C"
      fill_material :turn, surface: :degrees do
        key_context "C4"
        degrees "1 2 3 5"
        rhythm ".25 .25 .25 .25"
      end
      roster { part :flute, "Flute", music21: "Flute", family: :woodwind, range: "C4-C7" }
      section :s1, "One", bars: 1..2 do
        span bars: 2..2 do
          fill :g_turn, from: :turn, part: :flute, at: "bar 2 beat 1", anacrusis: 1, key_match: "G4"
        end
      end
    end

    assert_equal %w[G4 A4 B4 D5], piece.timed_events.map(&:pitch_label)
  end

  def test_fill_material_must_stay_shorter_than_one_bar
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.piece("Bad fill") do
        meter "4/4"; key "C"
        fill_material(:too_long, surface: :absolute) { events "C5:4" }
      end
    end

    assert_equal "fill_material_too_long", error.response.fetch(:code)
  end

  def test_anacrusis_spilling_before_the_piece_is_rejected
    piece = Partitura::Production.piece("Too early") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase :call, surface: :absolute do
            anacrusis 1
            events "G4:1 | C5:3"
          end
          placement :call, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "anacrusis_before_start", response.fetch(:code)
  end

  def test_non_positive_anacrusis_is_rejected
    piece = Partitura::Production.piece("Bad pickup") do
      meter "4/4"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 2..2 do
          phrase :call, surface: :absolute do
            events "C5:4"
          end
          placement :call, part: :fl, at: "bar 2 beat 1", role: :foreground, anacrusis: -1
        end
      end
    end

    response = piece.compile_response
    assert_equal "error", response.fetch(:status)
    assert_equal "bad_anacrusis", response.fetch(:code)
  end

  def test_retrograde_flips_spanner_marks
    piece = Partitura::Production.piece("Backwards slur") do
      meter "4/4"
      roster { part :ob, "Oboe", music21: "Oboe" }
      fill_material :turn, surface: :absolute do
        events "A4:.25{slur(} B4:.25 A4:.25 G4:.25{slur)}"
      end
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          fill :back_turn, from: :turn, part: :ob, at: "bar 1 beat 4" do
            retrograde
          end
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
    marks = piece.timed_events.map(&:marks)
    assert_equal ["slur("], marks.first
    assert_equal ["slur)"], marks.last
  end

  def test_degree_fill_material_inherits_the_piece_key
    piece = Partitura::Production.piece("Minor fill") do
      meter "4/4"
      key "d"
      roster { part :ob, "Oboe", music21: "Oboe" }
      fill_material :tail, pitch: :degrees do
        degrees "5 6 7"
        rhythm  ".25 .25 .5"
      end
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          fill :ob_tail, from: :tail, part: :ob, at: "bar 1 beat 4"
        end
      end
    end

    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_equal %w[A4 Bb4 C5], piece.timed_events.map(&:pitch)
  end

  def test_texture_line_accepts_anacrusis
    piece = Partitura::Production.piece("Texture pickup") do
      meter "4/4"; key "C"
      roster { part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, range: "F#3-D6" }
      section :s1, "One", bars: 1..2 do
        span bars: 2..2 do
          texture :arrival, bars: 2..2 do
            line :call, part: :trumpet, role: :foreground, surface: :intervals do
              anacrusis 1
              anchor "G4"
              intervals "0 | +5"
              rhythm "1 | 4"
            end
          end
        end
      end
    end

    assert_equal "b1:4", piece.format_offset(piece.timed_events.first.offset)
    assert_equal "ok", piece.compile_response.fetch(:status)
  end
end
