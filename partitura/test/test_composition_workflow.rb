# frozen_string_literal: true

require "minitest/autorun"
require "fileutils"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/composition_workflow_helper"

class CompositionWorkflowTest < Minitest::Test
  include CompositionWorkflowTestSupport
  Workflow = CompositionWorkflowTestSupport::Workflow

  def test_scheduler_targets_partial_bass_before_dependent_return
    with_source do |source|
      state = Workflow::State.new(
        snapshot: Workflow::CandidateExecutor.new.load_snapshot(source)
      )
      action = Workflow::DeterministicScheduler.new.next_action(state).action

      assert_equal :bind_requirement, action.kind
      assert_equal "span:statement", action.target_path.to_s
      assert_equal :voice_leading, action.lens
      assert_equal :realize_span, action.operator
      assert_includes action.requirement_key, "bass_line"
      assert_equal ["placement:statement_bass_cello"], action.context_paths.map(&:to_s)
    end
  end

  def test_executor_validates_in_sandbox_and_preserves_accepted_source
    with_source do |source|
      original = File.binread(source)
      executor, snapshot, action, candidate = execution_setup(source)
      execution = executor.execute(
        source_path: source, snapshot: snapshot, action: action,
        candidate: candidate, export: true
      )

      assert execution.passed
      assert execution.score_changed?
      assert_equal %i[musicxml midi], execution.artifacts.map(&:kind)
      musicxml = execution.artifacts.find { |artifact| artifact.kind == :musicxml }
      assert_equal(
        musicxml.digest,
        execution.score_observation.dig("source", "source_digest")
      )
      assert_match(
        /\Asha256:[0-9a-f]{64}\z/,
        execution.score_observation.fetch("observation_digest")
      )
      assert_match(/\Asha256:[0-9a-f]{64}\z/, execution.candidate_source_digest)
      assert_includes execution.candidate_source, 'pitch_bars "C3 G2 | B2 G2"'
      assert_equal original, File.binread(source)
    end
  end

  def test_executor_records_compile_failure_without_mutating_source
    with_source do |source|
      original = File.binread(source)
      executor, snapshot, action, = execution_setup(source)
      candidate = inline_candidate(action, patch: invalid_patch(File.basename(source)))
      execution = executor.execute(
        source_path: source, snapshot: snapshot, action: action,
        candidate: candidate, export: false
      )

      refute execution.passed
      assert_nil execution.score_observation
      assert_equal :compile, execution.stage
      assert_equal "compile_failed", execution.failure_code
      refute execution.mechanical_result(action).passed
      assert_equal original, File.binread(source)
    end
  end

  def test_promotion_refuses_concurrent_source_change
    with_source do |source|
      executor, snapshot, action, candidate = execution_setup(source)
      execution = executor.execute(
        source_path: source, snapshot: snapshot, action: action,
        candidate: candidate, export: false
      )
      changed = "#{File.read(source)}\n# concurrent edit\n"
      File.write(source, changed)
      error = assert_raises(Workflow::Error) do
        Workflow::CandidatePromoter.new(executor: executor).promote(
          source_path: source, before_snapshot: snapshot, action: action,
          candidate: candidate, execution: execution
        )
      end

      assert_equal "promotion_stale", error.code
      assert_equal changed, File.read(source)
    end
  end

  def test_promotion_installs_the_exact_validated_candidate_bytes
    with_source do |source|
      executor, snapshot, action, candidate = execution_setup(source)
      execution = executor.execute(
        source_path: source, snapshot: snapshot, action: action,
        candidate: candidate, export: false
      )

      Workflow::CandidatePromoter.new(executor: executor).promote(
        source_path: source, before_snapshot: snapshot, action: action,
        candidate: candidate, execution: execution
      )

      assert_equal execution.candidate_source, File.binread(source)
    end
  end

  def test_promotion_restores_exact_original_bytes_when_persistence_fails
    with_source do |source|
      original = File.binread(source)
      executor, snapshot, action, candidate = execution_setup(source)
      execution = executor.execute(
        source_path: source, snapshot: snapshot, action: action,
        candidate: candidate, export: false
      )

      error = assert_raises(Workflow::Error) do
        Workflow::CandidatePromoter.new(executor: executor).promote(
          source_path: source, before_snapshot: snapshot, action: action,
          candidate: candidate, execution: execution
        ) { raise IOError, "trajectory append failed" }
      end

      assert_equal "promotion_verification_failed", error.code
      assert_equal original, File.binread(source)
    end
  end

  def test_trajectory_store_rejects_duplicate_append
    with_source do |source, directory|
      store = Workflow::TrajectoryStore.new(File.join(directory, "trajectory.jsonl"))
      loop = Workflow::CompositionLoop.new(
        trajectory_store: store, export_candidates: false
      )
      state = loop.load_state(source_path: source)
      step = loop.advance(
        state, source_path: source,
        provider: OriginalProvider.new(method(:invalid_patch))
      )

      error = assert_raises(Workflow::Error) { store.append(step.transition) }

      assert_includes %w[trajectory_not_contiguous duplicate_transition], error.code
      assert_equal 1, store.load.length
    end
  end

  private

  class OriginalProvider
    def initialize(patch_method)
      @patch_method = patch_method
    end

    def propose(request)
      candidate = Workflow::Candidate.inline(
        request.action,
        source_patch: @patch_method.call(request.source_name),
        description: "Exercise rejection."
      )
      Workflow::ProposalResponse.create(
        request: request, producer: "test-proposer", candidates: [candidate]
      )
    end

    def select(request)
      Workflow::SelectionResponse.create(
        request: request,
        producer: "test-policy",
        selected_candidate_id: Workflow::Protocol::ORIGINAL_CANDIDATE_ID,
        reason: "Keep the original after mechanical rejection."
      )
    end
  end

  def execution_setup(source)
    executor = Workflow::CandidateExecutor.new
    snapshot = executor.load_snapshot(source)
    action = scheduled_action(snapshot)
    [executor, snapshot, action, inline_candidate(action)]
  end
end
