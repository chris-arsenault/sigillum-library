# frozen_string_literal: true

require "minitest/autorun"
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ProductionPerceptualTimelineTest < Minitest::Test
  def piece
    Partitura.production_piece("Expression and scene changes") do
      meter "6/8", beat_pattern: [3, 3]
      meter do
        change "3/4", at: "bar 3", beat_pattern: [1, 1, 1]
      end
      tempo do
        mark "dotted-quarter = 40", at: "bar 1 beat 1"
        change "quarter = 120", at: "bar 2 beat 1"
      end
      roster do
        part :voice, "Voice", music21: "Soprano", family: :voice
        part :wind, "Wind", music21: "Clarinet", family: :woodwind
        part :harp, "Harp", music21: "Harp", family: :plucked
      end
      section :s, "Study", bars: 1..4 do
        span bars: 1..4 do
          phrase(:v, surface: :absolute) do
            events "C5:1{mp} D5:1 E5:1 | F5:3{p} | G5:1{f} A5:2 | r:1{pp} C5:2"
          end
          phrase(:w, surface: :absolute) { events "G3:3 | G3:3 | G3:3 | G3:3" }
          phrase(:h, surface: :absolute) { events "r:2 C4:1{lv} | r:3 | C4:1{lv} r:2 | r:3" }
          placement :v, part: :voice, at: "bar 1 beat 1", role: :foreground
          placement :w, part: :wind, at: "bar 1 beat 1", role: :bass
          placement :h, part: :harp, at: "bar 1 beat 1", role: :counterline
        end
      end
      control do
        dynamic :pp, at: "bar 1 beat 1", for: :voice
        dynamic :p, at: "bar 1 beat 1", for: :woodwind
        crescendo from: "bar 2 beat 1", to: "bar 3 beat 1", for: :voice
        crescendo from: "bar 1 beat 1", to: "bar 2 beat 1", for: :wind
        dynamic :pp, at: "bar 3 beat 1", for: :wind
        diminuendo from: "bar 3 beat 1", to: "bar 4 beat 1", for: :wind
      end
    end
  end

  def test_local_dynamics_persist_and_override_scoped_marks_without_leaking_parts
    model = Partitura::Production::SoundingReadout::PerceptualDynamics.new(piece)
    assert_equal(-15, model.level(:voice, 0))
    assert_equal(-15, model.level(:voice, 1))
    assert_equal(-15, model.level(:voice, 2))
    assert_equal(-21, model.level(:wind, 0))
    assert_equal(-27, model.level(:voice, 10), "dynamic on a rest persists")
  end

  def test_hairpins_reach_explicit_targets_hold_endpoints_and_reset
    model = Partitura::Production::SoundingReadout::PerceptualDynamics.new(piece)
    assert_in_delta(-12, model.level(:voice, 4.5))
    assert_in_delta(-3, model.level(:voice, 6))
    assert_in_delta(-3, model.level(:voice, 8))
    assert_in_delta(-15, model.level(:wind, 3), 0.001, "unquantified crescendo holds its endpoint")
    assert_in_delta(-27, model.level(:wind, 6), 0.001, "old crescendo must not survive the pp reset")
    assert_in_delta(-30, model.level(:wind, 7.5))
    assert_in_delta(-33, model.level(:wind, 10))
  end

  def test_sustained_partial_follows_hairpin_and_peak_report_still_works
    readout = Partitura::Production::Readout.new(piece)
    partial = readout.send(:perceptual_cloud).find { |p| p.part == :voice && p.onset == 3 && p.attack }
    start = readout.send(:partial_amp_at, partial, 3)
    middle = readout.send(:partial_amp_at, partial, 4.5)
    assert_in_delta 10.0**(9.0 / 20), middle / start
    assert_includes readout.render(:peak_axes), "dynamic max: f"
    assert_kind_of Array, readout.send(:dynamic_timeline)
  end

  def test_timing_integrates_normalized_tempo_changes_and_decay_crosses_boundary
    score = piece
    timing = Partitura::Production::SoundingReadout::PerceptualTiming.new(score)
    assert_in_delta 3.0, timing.seconds_at(3)
    assert_in_delta 4.5, timing.seconds_at(6)
    assert_in_delta 5.0, timing.offset_at(4.0)
    readout = Partitura::Production::Readout.new(score)
    partial = readout.send(:perceptual_cloud).find { |p| p.part == :harp && p.onset == 2 && p.attack }
    ratio = readout.send(:partial_amp_at, partial, 4) / partial.amp
    assert_in_delta Math.exp(-1.5 / partial.tau), ratio
    expected_end = timing.offset_at(2 + -Math.log(0.04) * partial.tau)
    assert_in_delta expected_end, partial.audible_end
  end

  def test_macro_beats_follow_meter_changes
    readout = Partitura::Production::Readout.new(piece)
    assert_equal [0, Rational(3, 2)], readout.send(:macro_phases, 1)
    assert_equal [0, 1, 2], readout.send(:macro_phases, 3)
  end

  def test_semitone_neighbor_is_not_reinforcement
    readout = Partitura::Production::Readout.new(piece)
    partial = Partitura::Production::SoundingReadout::Perceptual::Partial
    attack = partial.new(midi: 60)
    refute readout.send(:reinforces?, partial.new(midi: 61), attack)
    assert readout.send(:reinforces?, partial.new(midi: 60), attack)
    assert readout.send(:reinforces?, partial.new(midi: 72), attack)
  end

  def test_inline_hairpin_and_tie_continuation_dynamic_affect_following_notes
    score = Partitura.production_piece("Tied dynamics") do
      meter "4/4"
      roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      section :s, "Study", bars: 1..2 do
        span bars: 1..2 do
          phrase(:line, surface: :absolute) do
            events "C5:2{p,cresc(,tie(} C5:2{f,cresc),tie)} | D5:4"
          end
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
    model = Partitura::Production::SoundingReadout::PerceptualDynamics.new(score)
    assert_in_delta(-12, model.level(:flute, 1))
    assert_equal(-3, model.level(:flute, 4))
  end
end
