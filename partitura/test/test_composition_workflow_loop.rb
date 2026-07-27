# frozen_string_literal: true

require "minitest/autorun"
require "fileutils"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/composition_workflow_helper"

class CompositionWorkflowLoopTest < Minitest::Test
  include CompositionWorkflowTestSupport
  Workflow = CompositionWorkflowTestSupport::Workflow

  def test_loop_promotes_selected_candidate_and_appends_trajectory
    with_source do |source, directory|
      store = Workflow::TrajectoryStore.new(File.join(directory, "trajectory.jsonl"))
      loop = Workflow::CompositionLoop.new(
        trajectory_store: store, export_candidates: false
      )
      provider = AcceptingProvider.new(method(:bass_patch))
      step = loop.advance(
        loop.load_state(source_path: source), source_path: source, provider: provider
      )

      assert_equal :accept, step.transition.decision
      assert_equal provider.selected_candidate_id, step.transition.selected_candidate_id
      assert_includes File.read(source), 'pitch_bars "C3 G2 | B2 G2"'
      assert_equal step.state.snapshot.snapshot_digest,
                   Workflow::CandidateExecutor.new.load_snapshot(source).snapshot_digest
      assert_equal [step.transition.to_h], store.load.map(&:to_h)
      assert_equal 0.75, learned_result(step).score
      assert_transition_evidence(step.transition, store.context)
    end
  end

  def test_loop_keeps_original_and_records_candidate_evidence
    with_source do |source, directory|
      original = File.binread(source)
      store = Workflow::TrajectoryStore.new(File.join(directory, "trajectory.jsonl"))
      loop = Workflow::CompositionLoop.new(
        trajectory_store: store, export_candidates: false
      )
      provider = RejectingProvider.new(method(:invalid_patch))
      step = loop.advance(
        loop.load_state(source_path: source), source_path: source, provider: provider
      )

      assert_equal :keep_original, step.transition.decision
      assert_nil step.transition.selected_candidate_id
      refute step.transition.candidates.first.mechanically_valid?
      assert_equal original, File.binread(source)
      assert_equal step.transition.transition_id, store.load.first.transition_id
      stored = JSON.parse(File.read(store.path))
      assert_equal invalid_patch("study.rb"),
                   stored.dig("candidates", 0, "candidate", "source_patch")
    end
  end

  private

  class AcceptingProvider
    attr_reader :selected_candidate_id

    def initialize(patch_method)
      @patch_method = patch_method
    end

    def propose(request)
      candidate = Workflow::Candidate.inline(
        request.action,
        source_patch: @patch_method.call(request.source_name),
        description: "Complete the scheduled bass."
      )
      @selected_candidate_id = candidate.candidate_id
      Workflow::ProposalResponse.create(
        request: request, producer: "test-proposer", candidates: [candidate]
      )
    end

    def select(request)
      Workflow::SelectionResponse.create(
        request: request,
        producer: "test-policy",
        selected_candidate_id: selected_candidate_id,
        reason: "Prefer the mechanically valid completion.",
        critic_results: [learned_critic(request)]
      )
    end

    private

    def learned_critic(request)
      Workflow::CriticResult.new(
        critic: "test-learned-critic",
        scale: :local,
        target_path: request.action.target_path,
        candidate_id: selected_candidate_id,
        features: { "learned_feature" => 0.5 },
        score: 0.75,
        confidence: 0.8
      )
    end
  end

  class RejectingProvider
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

  def learned_result(step)
    step.transition.candidates.first.critic_results.find do |result|
      result.critic == "test-learned-critic"
    end
  end

  def assert_transition_evidence(transition, context)
    assert_equal Workflow::TRAJECTORY_SCHEMA_VERSION, transition.schema_version
    assert_equal transition.before_graph_digest,
                 transition.before_snapshot.fetch("graph_digest")
    assert_equal transition.before_snapshot_digest,
                 transition.before_snapshot.fetch("snapshot_digest")
    assert_equal "study.rb", transition.source_name
    assert_match(/pitch_bars "C3 G2"/, transition.before_source)
    assert_equal(
      Workflow::Validation.source_digest(transition.before_source),
      transition.before_source_digest
    )
    assert_equal(
      { run_id: context.run_id, origin: :deterministic, quality_label: :unrated },
      transition.trajectory_context.to_h
    )
  end
end
