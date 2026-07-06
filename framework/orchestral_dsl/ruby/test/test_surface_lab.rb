# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "sigillum/orchestral_dsl"

class SurfaceLabTest < Minitest::Test
  ROOT = File.expand_path("../../../../experiments/orchestral_dsl/surface_lab", __dir__)
  FILES = {
    key_relative_degrees: "degree_key_32.rb",
    relative_intervals: "relative_interval_32.rb",
    split_pitch_rhythm: "split_pitch_rhythm_32.rb",
    staff_grid: "staff_grid_32.rb",
    phrase_placement: "phrase_placement_32.rb",
    hybrid_phrase_staff: "hybrid_phrase_staff_32.rb"
  }.freeze

  def test_all_alternative_surfaces_load_as_32_bar_studies
    FILES.each do |family, filename|
      study = load_study(filename)

      assert_equal family, study.family
      assert_equal 1..32, study.bars
      assert_equal 4, study.records_of(:section).length
    end
  end

  def test_surface_examples_do_not_use_old_fused_pitch_duration_tokens
    FILES.each_value do |filename|
      text = File.read(File.join(ROOT, filename))

      refute_match(/[A-G](?:b|#)?[0-9]:[0-9.]/, text, filename)
      refute_match(/\bnotes\s+["%]/, text, filename)
    end
  end

  def test_staff_grid_exposes_all_bars_as_vertical_layout
    study = load_study("staff_grid_32.rb")

    assert_equal 32, study.records_of(:staff_bar).length
    first_bar = study.records_of(:staff_bar).first
    assert_equal 1, first_bar.id
    assert_includes first_bar.field(:foreground), "clarinet"
    assert_includes first_bar.field(:bass), "cello"
  end

  def test_phrase_placement_keeps_placements_explicit
    study = load_study("phrase_placement_32.rb")
    placements = study.records_of(:placement)

    assert_equal 8, placements.length
    assert_equal :call_8, placements.first.id
    assert_equal :clarinet, placements.first.attrs[:part]
    assert_equal "bar 1 beat 1", placements.first.attrs[:at]
  end

  def test_hybrid_surface_has_phrase_layer_and_staff_checkpoints
    study = load_study("hybrid_phrase_staff_32.rb")

    assert_equal 2, study.records_of(:phrase).length
    assert_equal 5, study.records_of(:placement).length
    assert_equal 8, study.records_of(:staff_bar).length
  end

  def test_readouts_are_available_for_comparison
    study = load_study("degree_key_32.rb")
    structure = Sigillum::OrchestralDSL::SurfaceLab.readout(study, :structure)

    assert_includes structure, "32-bar key-relative degree surface"
    assert_includes structure, "foreground_32"
    assert_includes structure, "degrees"
  end

  private

  def load_study(filename)
    Sigillum::OrchestralDSL::SurfaceLab.load_file(File.join(ROOT, filename))
  end
end
