# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "json"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class GuidedRunsTest < Minitest::Test
  PASS_NOTE = <<~NOTE
    bars: all
    decisions: test decision
    weaknesses: none
    revisions: none
    outputs: none
    verdict: proceed
  NOTE

  SOURCE = <<~RUBY
    production_piece "Guided Test Piece" do
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

  def test_start_status_commit_flow_with_gates
    with_run do |dir|
      run, payload = Partitura::Guided.status(dir)
      assert_equal "s0", run.current_stage_id
      assert_includes payload, "Stage s0"
      assert_includes payload, "## Work"

      failure = assert_raises(Partitura::Guided::GateFailure) do
        Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      end
      assert(failure.results.any? { |result| result.gate == "artifact_exists:brief" && !result.ok })

      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      _, payload = Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      assert_includes payload, "Stage s1"
    end
  end

  def test_pass_note_must_be_complete
    with_run do |dir|
      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      error = assert_raises(Partitura::Guided::PassNoteError) do
        Partitura::Guided.commit(dir: dir, notes: "decisions: something")
      end
      assert_includes error.message, "verdict"
    end
  end

  def test_skip_requires_reason_and_blocks_closeout
    with_run do |dir|
      run, = Partitura::Guided.skip(dir: dir, reason: "testing skip")
      assert_equal ["s0"], run.stages_with_status("skipped")

      assert_raises(Partitura::Guided::RunError) { Partitura::Guided.skip(dir: dir, reason: "  ") }

      stage10 = run.manifest.stage("s10")
      results = Partitura::Guided::Gates.evaluate(["no_open_skips"], run: run, stage: stage10, note: {})
      refute results.first.ok
    end
  end

  def test_iterative_stage_accumulates_units_then_completes
    with_run do |dir|
      run = Partitura::Guided::Run.locate(dir)
      run.state["current_stage"] = "s5"
      run.state["stages"]["s5"]["status"] = "in_progress"
      run.save

      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE, unit: "bars 1-1")
      run, = Partitura::Guided.status(dir)
      assert_equal "s5", run.current_stage_id
      assert_equal ["bars 1-1"], run.units_committed

      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE, stage_complete: true)
      run, = Partitura::Guided.status(dir)
      assert_equal "s6", run.current_stage_id
    end
  end

  def test_back_marks_later_stages_stale
    with_run do |dir|
      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      File.write(File.join(dir, "procedure", "form_contract.md"), "contract")
      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)

      run, = Partitura::Guided.back(dir: dir, to: "s0", reason: "revisit brief")
      assert_equal "s0", run.current_stage_id
      assert_equal %w[s1], run.stages_with_status("stale")

      stage10 = run.manifest.stage("s10")
      results = Partitura::Guided::Gates.evaluate(["no_stale_stages"], run: run, stage: stage10, note: {})
      refute results.first.ok
    end
  end

  def test_source_compiles_gate_reports_compile_errors
    with_run do |dir|
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE.sub("F5:4", "F5:9"))
      run = Partitura::Guided::Run.locate(dir)
      result = Partitura::Guided::Gates.evaluate(["source_compiles"], run: run, stage: run.current_stage,
                                                                      note: {}).first
      refute result.ok
      assert_includes result.detail, "phrase_exceeds_span"
    end
  end

  def test_run_log_is_append_only_jsonl
    with_run do |dir|
      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      run = Partitura::Guided::Run.locate(dir)
      events = run.log_entries.map { |entry| entry.fetch("event") }
      assert_equal %w[run_started stage_committed], events
      assert_equal "test decision", run.log_entries.last.dig("pass_note", "decisions")
    end
  end

  def test_start_refuses_existing_run_without_force_new
    with_run do |dir|
      assert_raises(Partitura::Guided::RunError) { Partitura::Guided.start(dir, source: "dsl/piece.rb") }
      run, = Partitura::Guided.start(dir, source: "dsl/piece.rb", force_new: true)
      assert_equal "s0", run.current_stage_id
      assert(Dir[File.join(dir, "procedure_archived_*")].any?)
    end
  end

  def test_abandon_closes_the_run
    with_run do |dir|
      Partitura::Guided.abandon(dir: dir, reason: "test over")
      run = Partitura::Guided::Run.locate(dir)
      assert run.closed?
      assert_raises(Partitura::Guided::RunError) { Partitura::Guided.commit(dir: dir, notes: PASS_NOTE) }
      payload = Partitura::Guided::Payload.render(run)
      assert_includes payload, "abandoned"
    end
  end

  def test_miniature_mode_walks_collapsed_stages
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "dsl"))
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE)
      run, payload = Partitura::Guided.start(dir, source: "dsl/piece.rb", miniature: true)
      assert_equal "miniature", run.mode
      assert_includes payload, "Brief, Form, And Destination + Form And Texture Contract"

      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      File.write(File.join(dir, "procedure", "form_contract.md"), "contract")
      run, = Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      assert_equal "s2", run.current_stage_id
    end
  end

  private

  def with_run
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "dsl"))
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE)
      Partitura::Guided.start(dir, source: "dsl/piece.rb")
      yield dir
    end
  end
end
