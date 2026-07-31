# frozen_string_literal: true

require "tmpdir"
require_relative "executor"
require_relative "protocol"
require_relative "review_bundle"

module Partitura
  module Production
    module CompositionWorkflow
      class ReviewRender
        attr_reader :candidate_id, :snapshot_digest, :artifacts

        def initialize(candidate_id:, snapshot_digest:, artifacts:)
          @candidate_id = candidate_id.to_s.freeze
          @snapshot_digest = snapshot_digest.to_s.freeze
          @artifacts = artifacts.freeze
          freeze
        end
      end

      class PairwiseReviewBuilder
        def initialize(executor: CandidateExecutor.new)
          @executor = executor
        end

        def build(transition:, candidate_id:, against_id:, scale:, criterion:, seed: "default")
          candidate_ids = validate_candidate_ids(candidate_id, against_id)
          review_scale = Validation.enum(scale, HUMAN_REVIEW_SCALES, "review scale")
          review_criterion = Validation.enum(
            criterion, HUMAN_REVIEW_CRITERIA, "review criterion"
          )
          seed_digest = Validation.source_digest(Validation.text(seed, "review seed"))
          ordered_ids = blinded_order(
            transition.transition_id, candidate_ids, review_scale, review_criterion,
            seed_digest
          )
          rendered = render_variants(transition, ordered_ids)
          variants = review_variants(rendered)
          review = PairwiseReview.create(
            transition_id: transition.transition_id,
            scale: review_scale,
            criterion: review_criterion,
            seed_digest: seed_digest,
            variants: variants
          )
          ReviewBundle.new(
            review: review,
            rendered: rendered.to_h { |label, item| [label, item.artifacts] }
          )
        end

        private

        def validate_candidate_ids(candidate_id, against_id)
          ids = [
            Validation.text(candidate_id, "review candidate"),
            Validation.text(against_id, "review comparison candidate")
          ]
          return ids if ids.uniq.length == 2

          raise Error.new("invalid_review", "pairwise review requires two distinct candidates")
        end

        def blinded_order(transition_id, candidate_ids, scale, criterion, seed_digest)
          sorted = candidate_ids.sort
          identity = [transition_id, sorted, scale, criterion, seed_digest]
          digest = CompositionGraph::Canonical.digest(identity)
          digest[-1].to_i(16).odd? ? sorted.reverse : sorted
        end

        def render_variants(transition, ordered_ids)
          Dir.mktmpdir("partitura-review-") do |directory|
            source_path = File.join(directory, transition.source_name)
            File.binwrite(source_path, transition.before_source)
            snapshot = @executor.load_snapshot(source_path)
            validate_snapshot(transition, snapshot)
            return ordered_ids.each_with_index.to_h do |candidate_id, index|
              label = ReviewVariant::LABELS.fetch(index)
              [label, render_variant(transition, source_path, snapshot, candidate_id)]
            end
          end
        end

        def validate_snapshot(transition, snapshot)
          live = CompositionGraph::Canonical.value(snapshot.to_h)
          return if live == transition.before_snapshot

          raise Error.new(
            "review_replay_mismatch",
            "stored source does not recreate the transition's before snapshot"
          )
        end

        def render_variant(transition, source_path, snapshot, candidate_id)
          if candidate_id == Protocol::ORIGINAL_CANDIDATE_ID
            return ReviewRender.new(
              candidate_id: candidate_id,
              snapshot_digest: snapshot.snapshot_digest,
              artifacts: @executor.render_accepted(
                source_path: source_path, snapshot: snapshot
              )
            )
          end

          render_candidate(transition, source_path, snapshot, candidate_id)
        end

        def render_candidate(transition, source_path, snapshot, candidate_id)
          assessment = transition.candidates.find do |item|
            item.candidate.candidate_id == candidate_id
          end
          unless assessment
            raise Error.new("unknown_candidate", "#{candidate_id} is absent from the transition")
          end
          unless assessment.mechanically_valid?
            raise Error.new(
              "invalid_review_candidate",
              "#{candidate_id} did not pass the recorded mechanical critics"
            )
          end

          execution = @executor.execute(
            source_path: source_path,
            snapshot: snapshot,
            action: transition.action,
            candidate: assessment.candidate,
            export: true
          )
          validate_replay(assessment, execution)
          ReviewRender.new(
            candidate_id: candidate_id,
            snapshot_digest: execution.after_snapshot.snapshot_digest,
            artifacts: execution.artifacts
          )
        end

        def validate_replay(assessment, execution)
          unless execution.passed
            raise Error.new(
              "review_replay_failed",
              "#{assessment.candidate.candidate_id}: #{execution.failure_message}"
            )
          end
          recorded = assessment.candidate_snapshot
          unless recorded && recorded.fetch("snapshot_digest", nil) ==
                             execution.after_snapshot.snapshot_digest
            raise Error.new(
              "review_replay_mismatch",
              "#{assessment.candidate.candidate_id} no longer recreates its recorded snapshot"
            )
          end
          validate_artifact_digests(assessment, execution)
        end

        def validate_artifact_digests(assessment, execution)
          return if assessment.artifact_digests.empty?

          replayed = execution.artifacts.to_h { |artifact| [artifact.kind.to_s, artifact.digest] }
          return if replayed == assessment.artifact_digests

          raise Error.new(
            "review_replay_mismatch",
            "#{assessment.candidate.candidate_id} artifact digests changed on replay"
          )
        end

        def review_variants(rendered)
          rendered.map do |label, item|
            ReviewVariant.new(
              label: label,
              candidate_id: item.candidate_id,
              snapshot_digest: item.snapshot_digest,
              artifacts: item.artifacts.to_h do |artifact|
                extension = artifact.kind == :musicxml ? "musicxml" : "mid"
                [
                  artifact.kind.to_s,
                  { filename: "#{label}.#{extension}", digest: artifact.digest }
                ]
              end
            )
          end
        end
      end
    end
  end
end
