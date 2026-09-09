# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

# The perceptual projections are a virtual render: instrument recipes expand
# events into partials, dynamics become levels, and the views report masking,
# roughness, beat salience, binding, and ring. These tests pin the defect
# classes the views exist to catch (from the Basin Aria correction cycle).
class ProductionPerceptualViewsTest < Minitest::Test
  def test_masking_flags_a_quiet_line_under_a_loud_same_band_wall
    piece = Partitura.production_piece("Masked") do
      meter "6/8", beat_pattern: [3, 3]
      key "d"
      tempo { mark "quarter = 60", at: "bar 1 beat 1" }
      roster do
        part :wall, "Wall", music21: "Viola", family: :string, range: "C2-C6"
        part :buried, "Buried", music21: "Violin", family: :string, range: "C2-C6"
      end
      section :s1, "S", bars: 1..1, type: :study do
        span bars: 1..1, texture: :t do
          phrase :wall_p, surface: :absolute do
            events "[D3,A3,D4]:3"
          end
          phrase :buried_p, surface: :absolute do
            events "r:1 E3:1 r:1"
          end
          placement :wall_p, part: :wall, at: "bar 1 beat 1", role: :foreground
          placement :buried_p, part: :buried, at: "bar 1 beat 1", role: :counterline
        end
      end
      control do
        dynamic :ff, at: "bar 1 beat 1", for: :wall
        dynamic :pp, at: "bar 1 beat 1", for: :buried
      end
    end

    report = Partitura.production_readout(piece, :masking_report)
    assert_includes report, "buried"
    assert_match(/buried (BURIED|at risk)/, report)
    assert_includes report, "masked by wall"
  end

  def test_binding_check_flags_a_far_register_offbeat_entry_and_passes_a_near_one
    piece = Partitura.production_piece("Binding") do
      meter "6/8", beat_pattern: [3, 3]
      key "d"
      tempo { mark "quarter = 60", at: "bar 1 beat 1" }
      roster do
        part :voice, "Voice", music21: "Soprano", family: :voice, range: "C3-C6"
        part :near, "Near", music21: "Viola", family: :string, range: "C2-C6"
        part :far, "Far", music21: "BassClarinet", family: :woodwind, range: "C1-C5"
      end
      section :s1, "S", bars: 1..2, type: :study do
        span bars: 1..2, texture: :t do
          phrase :voice_p, surface: :absolute do
            events "A4:2 r:1 | A4:2 r:1"
          end
          phrase :near_p, surface: :absolute do
            events "r:1 C5:.5 r:1.5 | r:3"
          end
          phrase :far_p, surface: :absolute do
            events "r:3 | r:1 D1:.5 r:1.5"
          end
          placement :voice_p, part: :voice, at: "bar 1 beat 1", role: :foreground
          placement :near_p, part: :near, at: "bar 1 beat 1", role: :counterline
          placement :far_p, part: :far, at: "bar 1 beat 1", role: :bass
        end
      end
    end

    report = Partitura.production_readout(piece, :binding_check)
    assert_includes report, "far D1 enters UNBOUND"
    refute_includes report, "near C5 enters UNBOUND"
  end

  def test_beat_salience_flags_bars_whose_strongest_attack_is_off_the_macro_beats
    piece = Partitura.production_piece("Salience") do
      meter "6/8", beat_pattern: [3, 3]
      key "d"
      tempo { mark "quarter = 60", at: "bar 1 beat 1" }
      roster do
        part :drum, "Drum", music21: "SteelDrum", family: :pitched_percussion, range: "C2-C6"
      end
      section :s1, "S", bars: 1..2, type: :study do
        span bars: 1..2, texture: :t do
          phrase :drum_p, surface: :absolute do
            events "D3:.5{f} A3:.5 D3:.5{f} A3:.5 D3:.5 A3:.5 | r:.5 A4:.5{ff} r:2"
          end
          placement :drum_p, part: :drum, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    report = Partitura.production_readout(piece, :beat_salience)
    assert_includes report, "b2 strongest attack at +0.5 ql (off the macro-beats)"
    assert_includes report, "1 bars whose strongest attack is off the macro-beats"
  end

  def test_ringing_grid_shows_lv_ring_past_the_notated_duration_and_sustain_does_not
    piece = Partitura.production_piece("Ring") do
      meter "6/8", beat_pattern: [3, 3]
      key "d"
      tempo { mark "quarter = 60", at: "bar 1 beat 1" }
      roster do
        part :pan, "Pan", music21: "SteelDrum", family: :pitched_percussion, range: "C2-C6"
        part :wind, "Wind", music21: "BassClarinet", family: :woodwind, range: "C1-C5"
      end
      section :s1, "S", bars: 1..2, type: :study do
        span bars: 1..2, texture: :t do
          phrase :pan_p, surface: :absolute do
            events "D3:.5{lv} r:2.5 | r:3"
          end
          phrase :wind_p, surface: :absolute do
            events "D2:.5 r:2.5 | r:3"
          end
          placement :pan_p, part: :pan, at: "bar 1 beat 1", role: :foreground
          placement :wind_p, part: :wind, at: "bar 1 beat 1", role: :bass
        end
      end
    end

    report = Partitura.production_readout(piece, :ringing_grid)
    bar1 = report[/--- b1.*?(?=--- b2)/m]
    pan_audible = bar1[/pan\s+(\S+)/, 1].count("^.")
    wind_audible = bar1[/wind\s+(\S+)/, 1].count("^.")
    assert_equal 2, wind_audible, "sustained wind sounds only its notated half-ql (two slots)"
    assert_operator pan_audible, :>, wind_audible + 2, "lv pan must ring well past its notated end"
  end

  def test_spectrum_and_roughness_render_and_low_seconds_read_rougher_than_high_ninths
    piece = Partitura.production_piece("Rough") do
      meter "6/8", beat_pattern: [3, 3]
      key "d"
      tempo { mark "quarter = 60", at: "bar 1 beat 1" }
      roster do
        part :a, "A", music21: "Viola", family: :string, range: "C1-C7"
        part :b, "B", music21: "Violoncello", family: :string, range: "C1-C7"
      end
      section :s1, "S", bars: 1..2, type: :study do
        span bars: 1..2, texture: :t do
          phrase :a_p, surface: :absolute do
            events "C2:3 | D5:3"
          end
          phrase :b_p, surface: :absolute do
            events "D2:3 | C4:3"
          end
          placement :a_p, part: :a, at: "bar 1 beat 1", role: :foreground
          placement :b_p, part: :b, at: "bar 1 beat 1", role: :counterline
        end
      end
    end

    spectrum = Partitura.production_readout(piece, :spectrum_grid)
    assert_includes spectrum, "--- b1"
    rough = Partitura.production_readout(piece, :roughness_profile)
    low_second = rough[/b1\s+(\d+)/, 1].chars.map(&:to_i).max
    high_ninth = rough[/b2\s+(\d+)/, 1].chars.map(&:to_i).max
    assert_operator low_second, :>, high_ninth,
                    "a low major second must read rougher than a compound ninth"
  end
end
