# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "fileutils"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/composition_workflow_helper"

class CompositionWorkflowReviewTest < Minitest::Test
  include CompositionWorkflowTestSupport
  Workflow = CompositionWorkflowTestSupport::Workflow

  def test_agent_trajectories_require_the_known_medium_quality_label
    error = assert_raises(Workflow::Error) do
      Workflow::TrajectoryContext.new(
        run_id: "run:agent", origin: :agent, quality_label: :unrated
      )
    end

    assert_equal "invalid_trajectory_quality", error.code
    context = Workflow::TrajectoryContext.new(
      run_id: "run:agent", origin: :agent, quality_label: :medium
    )
    assert_equal(
      { run_id: "run:agent", origin: :agent, quality_label: :medium },
      context.to_h
    )
  end

  def test_blinded_review_replays_score_and_keeps_identity_private
    with_source do |source, directory|
      transition = accepted_transition(source, directory)
      candidate_id = transition.selected_candidate_id
      bundle = review_bundle(transition, candidate_id)
      bundle_path = bundle.write(File.join(directory, "bundles"))
      assert_public_bundle(bundle_path, candidate_id)
      stored_review = store_review(directory, bundle.review, candidate_id)
      assert_preference(directory, stored_review)
    end
  end

  private

  class AcceptingProvider
    def initialize(patch_method)
      @patch_method = patch_method
    end

    def propose(request)
      candidate = Workflow::Candidate.inline(
        request.action,
        source_patch: @patch_method.call(request.source_name),
        description: "Complete the bass for human comparison."
      )
      Workflow::ProposalResponse.create(
        request: request, producer: "review-test-proposer", candidates: [candidate]
      )
    end

    def select(request)
      Workflow::SelectionResponse.create(
        request: request,
        producer: "review-test-policy",
        selected_candidate_id: request.candidate_ids.first,
        reason: "Retain the mechanically valid candidate for review."
      )
    end
  end

  def accepted_transition(source, directory)
    store = Workflow::TrajectoryStore.new(File.join(directory, "trajectory.jsonl"))
    loop = Workflow::CompositionLoop.new(
      trajectory_store: store, export_candidates: false
    )
    step = loop.advance(
      loop.load_state(source_path: source),
      source_path: source,
      provider: AcceptingProvider.new(method(:bass_patch))
    )
    store.load.fetch(0)
  end

  def review_bundle(transition, candidate_id)
    Workflow::PairwiseReviewBuilder.new.build(
      transition: transition,
      candidate_id: candidate_id,
      against_id: Workflow::Protocol::ORIGINAL_CANDIDATE_ID,
      scale: :global,
      criterion: :coherence,
      seed: "review-test"
    )
  end

  def assert_public_bundle(bundle_path, candidate_id)
    manifest = JSON.parse(File.read(File.join(bundle_path, "review.json")))
    labels = manifest.fetch("variants").map { |item| item.fetch("label") }
    assert_equal %w[A B], labels
    %w[A.musicxml A.mid B.musicxml B.mid].each do |filename|
      assert File.exist?(File.join(bundle_path, filename))
    end
    refute_includes JSON.generate(manifest), candidate_id
    refute_includes JSON.generate(manifest), "source_patch"
    refute manifest.key?("transition_id")
  end

  def store_review(directory, review, candidate_id)
    store = Workflow::ReviewStore.new(File.join(directory, "reviews.jsonl"))
    store.append(review)
    stored = store.fetch(review.review_id)
    expected = [candidate_id, Workflow::Protocol::ORIGINAL_CANDIDATE_ID].sort
    assert_equal expected, stored.variants.map(&:candidate_id).sort
    assert_equal :coherence, stored.criterion
    stored
  end

  def assert_preference(directory, review)
    preference = Workflow::PreferenceRecord.create(
      review: review, outcome: :a, rater_id: "rater:anonymous-1",
      purpose: :listening_study,
      reason: "A has a clearer long-range bass trajectory.", confidence: 0.8
    )
    store = Workflow::PreferenceStore.new(File.join(directory, "preferences.jsonl"))
    store.append(preference)
    loaded = store.load.fetch(0)
    assert_equal :listening_study, loaded.purpose
    assert_equal :coherence, loaded.criterion
    assert_equal review.variant("A").candidate_id, loaded.preferred_candidate_id
    assert_equal review.variant("B").candidate_id, loaded.other_candidate_id
    assert loaded.to_h.fetch(:blind)
    invalid = assert_raises(Workflow::Error) do
      Workflow::PreferenceRecord.create(
        review: review, outcome: :b, rater_id: "rater:anonymous-2",
        purpose: "Invalid Label", reason: "Purpose labels remain machine-addressable."
      )
    end
    assert_equal "invalid_workflow_record", invalid.code
    duplicate = Workflow::PreferenceRecord.create(
      review: review, outcome: :b, rater_id: "rater:anonymous-1",
      purpose: :follow_up_review, reason: "A second judgment for the same review."
    )
    error = assert_raises(Workflow::Error) { store.append(duplicate) }
    assert_equal "duplicate_review_preference", error.code
  end
end
