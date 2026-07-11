# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "json"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class GuidedRunsTest < Minitest::Test
  BRIEF = "a giddy polka in E major, very fast, in the spirit of Rossini"

  PASS_NOTE = <<~NOTE
    decisions: test decision
    carries: none
    improvements: none
    musical_verdict: proceeds as planned
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
      assert_includes error.message, "musical_verdict"
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

  def test_iterative_stage_rejects_bare_commit_and_enforces_coverage
    with_run do |dir|
      run = Partitura::Guided::Run.locate(dir)
      run.state["current_stage"] = "s5"
      run.state["stages"]["s5"]["status"] = "in_progress"
      run.save

      bare = assert_raises(Partitura::Guided::RunError) { Partitura::Guided.commit(dir: dir, notes: PASS_NOTE) }
      assert_includes bare.message, "iterative"

      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE, unit: "bars 1-1")
      run, = Partitura::Guided.status(dir)
      assert_equal "s5", run.current_stage_id
      assert_equal ["bars 1-1"], run.units_committed

      partial = assert_raises(Partitura::Guided::GateFailure) do
        Partitura::Guided.commit(dir: dir, notes: PASS_NOTE, stage_complete: true)
      end
      assert(partial.results.any? { |result| result.gate == "units_cover_source_bars" && !result.ok })

      _, unit_payload = Partitura::Guided.commit(dir: dir, notes: PASS_NOTE, unit: "bars 2-2")
      assert_includes unit_payload, "work instructions unchanged"
      refute_includes unit_payload, "## Work"

      run, complete_payload = Partitura::Guided.commit(dir: dir, notes: PASS_NOTE, stage_complete: true)
      assert_equal "s6", run.current_stage_id
      assert_includes complete_payload, "## Work"
    end
  end

  def test_pass_notes_feed_forward_as_open_threads
    with_run do |dir|
      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      note = PASS_NOTE.sub("carries: none",
                           "carries: bar 2 accompaniment depends on the s8 harmony pass to resolve")
      _, payload = Partitura::Guided.commit(dir: dir, notes: note)
      assert_includes payload, "OPEN THREADS"
      assert_includes payload, "[s0] carries: bar 2 accompaniment depends on the s8 harmony pass to resolve"
      refute_includes payload, "[s0] improvements:"

      run = Partitura::Guided::Run.locate(dir)
      data = Partitura::Guided::Payload.data(run)
      assert_equal 1, data.fetch(:open_threads).length
    end
  end

  def test_reopened_stage_payload_carries_prior_pass_note
    with_run do |dir|
      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      Partitura::Guided.commit(dir: dir, notes: PASS_NOTE.sub("test decision", "original s0 decision"))
      _, payload = Partitura::Guided.back(dir: dir, to: "s0", reason: "revisit")
      assert_includes payload, "REOPENED STAGE"
      assert_includes payload, "original s0 decision"
      assert_includes payload, "editing pass, not a"
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
      existing = assert_raises(Partitura::Guided::RunError) do
        Partitura::Guided.start(dir, source: "dsl/piece.rb", brief: BRIEF)
      end
      assert_includes existing.message, "--force-new"
      run, = Partitura::Guided.start(dir, source: "dsl/piece.rb", force_new: true, brief: BRIEF)
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
      run, payload = Partitura::Guided.start(dir, source: "dsl/piece.rb", miniature: true, brief: BRIEF)
      assert_equal "miniature", run.mode
      assert_includes payload, "Brief, Form, And Destination + Form And Texture Contract"

      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      File.write(File.join(dir, "procedure", "form_contract.md"), "contract")
      run, = Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      assert_equal "s2", run.current_stage_id
    end
  end

  def test_composition_runs_require_a_brief_from_the_caller
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "dsl"))
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE)
      error = assert_raises(Partitura::Guided::RunError) { Partitura::Guided.start(dir, source: "dsl/piece.rb") }
      assert_includes error.message, "--brief"
    end
  end

  def test_the_brief_shows_as_commission_only_during_the_opening_stage
    with_run do |dir|
      run, payload = Partitura::Guided.status(dir)
      assert_equal BRIEF, run.state["brief"]
      assert_includes payload, "COMMISSION: #{BRIEF}"

      File.write(File.join(dir, "procedure", "brief.md"), "brief")
      _, payload = Partitura::Guided.commit(dir: dir, notes: PASS_NOTE)
      refute_includes payload, "COMMISSION", "the commission shows only while the opening stage is in progress"
    end
  end

  def test_pass_notes_accept_utf8_from_ascii_tagged_input
    note = (+PASS_NOTE).sub("test decision", "crescendo \xE2\x80\x94 then hush").force_encoding("US-ASCII")
    fields = Partitura::Guided::PassNote.parse(note, %w[decisions carries improvements musical_verdict])
    assert_includes fields["decisions"], "—"
  end

  private

  def with_run
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "dsl"))
      File.write(File.join(dir, "dsl", "piece.rb"), SOURCE)
      Partitura::Guided.start(dir, source: "dsl/piece.rb", brief: BRIEF)
      yield dir
    end
  end
end
