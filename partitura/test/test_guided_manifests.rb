# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "json"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

# Guided-procedure manifests: stage order, miniature collapse, gate wiring.
class GuidedManifestsTest < Minitest::Test
  SOURCE = <<~RUBY
    production_piece "Guided Manifest Piece" do
      meter "4/4"
      key "C"
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase :line, surface: :absolute do
            events "C5:2 D5:1 E5:1 | F5:4"
          end
          placement :line, part: :fl, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  RUBY

  def test_manifest_loads_with_ordered_stages_and_miniature_collapse
    manifest = Partitura::Guided::Manifest.load("dsl_composition")
    assert_equal "dsl_composition", manifest.id
    assert_equal (0..10).map { |n| "s#{n}" }, manifest.stages.map(&:id)
    assert manifest.stage("s5").iterative
    assert(manifest.stages.all? { |stage| stage.docs.all? { |doc| File.exist?(doc) } })
    assert File.exist?(manifest.principles_path)

    miniature = manifest.stages("miniature")
    assert miniature.length < manifest.stages.length
    combined = miniature.find { |stage| stage.id == "s0" }
    assert_equal 2, combined.docs.length
    assert(combined.gates.include?("artifact_exists:form_contract"))
  end

  def test_procedure_list_names_all_manifests
    assert_includes Partitura::Guided::Manifest.list, "dsl_composition"
    assert_includes Partitura::Guided::Manifest.list, "section_recomposition"
  end

  def test_section_recomposition_manifest_loads_and_runs
    manifest = Partitura::Guided::Manifest.load("section_recomposition")
    assert_equal %w[s0 s1 s2 s3 s4], manifest.stages.map(&:id)
    assert manifest.stage("s2").iterative
    assert_equal "passage", manifest.stage("s2").unit
    assert(manifest.stages.all? { |stage| stage.docs.all? { |doc| File.exist?(doc) } })
    assert_equal 3, manifest.stages("miniature").length

    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "dsl"))
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE)
      run, payload = Partitura::Guided.start(dir, procedure: "section_recomposition", source: "dsl/piece.rb")
      assert_equal "s0", run.current_stage_id
      assert_includes payload, "Diagnose"
      assert_includes payload, "procedure/diagnosis.md"
    end
  end

  def test_closeout_stage_requires_an_audit_unit
    manifest = Partitura::Guided::Manifest.load("dsl_composition")
    stage = manifest.stage("s10")
    assert stage.iterative
    assert_equal "audit", stage.unit
    assert_includes stage.stage_complete_gates, "min_units:1"

    with_run do |dir|
      run = Partitura::Guided::Run.locate(dir)
      result = Partitura::Guided::Gates.evaluate(["min_units:1"], run: run, stage: stage, note: {}).first
      refute result.ok
      assert_includes result.detail, "at least 1"
    end
  end

  private

  def with_run
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "dsl"))
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE)
      Partitura::Guided.start(dir, source: "dsl/piece.rb", brief: "a bright gavotte in G, brisk")
      yield dir
    end
  end
end
