# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "fileutils"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/composition_workflow_helper"

class EvaluationLabTest < Minitest::Test
  include CompositionWorkflowTestSupport
  Evaluation = Partitura::Production::Evaluation

  def test_score_measurement_reports_mechanics_and_non_quality_diagnostics
    with_source do |source|
      profile = Evaluation::ScoreMeasurement.from_source(source)

      assert profile.dig(:mechanical, :valid)
      assert_equal 6, profile.dig(:diagnostics, :requirements, :declared)
      assert_equal 1, profile.dig(:diagnostics, :identity, :returns_to_count)
      assert_equal 1, profile.dig(:diagnostics, :seams, :boundary_count)
      assert_operator profile.dig(:diagnostics, :reserve, :silence_ratio), :>, 0.0
      assert_match(/\Asha256:/, profile.dig(:fingerprints, :score))
      assert_equal %i[midi musicxml], profile.fetch(:artifact_digests).keys.sort
    end
  end

  def test_invalid_score_is_a_measured_result
    with_source do |source|
      File.write(source, "production_piece \"broken\" do\n")
      profile = Evaluation::ScoreMeasurement.from_source(source)

      refute profile.dig(:mechanical, :valid)
      refute profile.dig(:mechanical, :source_load)
      assert_equal "ruby_syntax_error", profile.dig(:failure, "code")
    end
  end

  def test_score_review_is_blinded_and_preference_is_held_out
    with_source do |source, directory|
      variant = create_variant(source, directory)
      bundle = review_bundle(source, variant)
      bundle_path = bundle.write(File.join(directory, "bundles"))
      assert_public_review(bundle_path)
      stored = store_review(directory, bundle.review)
      assert_preference(directory, stored)
    end
  end

  private

  def create_variant(source, directory)
    variant = File.join(directory, "variant.rb")
    content = File.read(source).sub('pitch_bars "C5 E5 | G5 E5"',
                                    'pitch_bars "C5 F5 | G5 E5"')
    File.write(variant, content)
    variant
  end

  def review_bundle(source, variant)
    Evaluation::ScoreReviewBuilder.new.build(
      benchmark_id: "whole-score-v1", case_id: "study",
      criterion: :coherence, left_run_id: "run:one-shot",
      left_source: source, right_run_id: "run:deterministic",
      right_source: variant, seed: "test-seed"
    )
  end

  def assert_public_review(bundle_path)
    manifest = JSON.parse(File.read(File.join(bundle_path, "review.json")))
    assert_equal "coherence", manifest.fetch("criterion")
    assert_equal %w[A B], manifest.fetch("subjects").map { |item| item.fetch("label") }
    refute_includes JSON.generate(manifest), "run:one-shot"
    refute_includes JSON.generate(manifest), "run:deterministic"
    %w[A.musicxml A.mid B.musicxml B.mid].each do |filename|
      assert File.exist?(File.join(bundle_path, filename))
    end
  end

  def store_review(directory, review)
    store = Evaluation::ScoreReviewStore.new(File.join(directory, "reviews.jsonl"))
    store.append(review)
    loaded = store.fetch(review.review_id)
    assert_equal %w[run:deterministic run:one-shot], loaded.subjects.map(&:run_id).sort
    loaded
  end

  def assert_preference(directory, review)
    preference = Evaluation::ScorePreference.create(
      review: review, outcome: :a, rater_id: "rater:1",
      reason: "A has the stronger whole-score arc.", confidence: 0.75
    )
    store = Evaluation::ScorePreferenceStore.new(
      File.join(directory, "preferences.jsonl")
    )
    store.append(preference)
    loaded = store.load.fetch(0)
    assert_equal :completed_score_evaluation, loaded.to_h.fetch(:purpose)
    assert_equal review.subject("A").run_id, loaded.preferred_run_id
    error = assert_raises(Evaluation::Error) { store.append(preference) }
    assert_equal "duplicate_evaluation_record", error.code
  end
end
