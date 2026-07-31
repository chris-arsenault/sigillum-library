# frozen_string_literal: true

require "time"
require_relative "state_models"

module Partitura
  module Production
    module CompositionWorkflow
      REVIEW_SCHEMA_VERSION = 2
      PREFERENCE_SCHEMA_VERSION = 2
      HUMAN_REVIEW_SCALES = %i[local seam section global export].freeze
      HUMAN_REVIEW_CRITERIA = %i[coherence identity seams orchestration reserve].freeze
      PREFERENCE_OUTCOMES = %i[a b tie abstain].freeze
      PREFERENCE_PURPOSES = %i[training held_out_evaluation].freeze

      class ReviewVariant
        LABELS = %w[A B].freeze

        attr_reader :label, :candidate_id, :snapshot_digest, :artifacts

        def initialize(label:, candidate_id:, snapshot_digest:, artifacts:)
          @label = Validation.text(label, "review variant label")
          @candidate_id = Validation.text(candidate_id, "review candidate_id")
          @snapshot_digest = Validation.digest(snapshot_digest, "review snapshot digest")
          @artifacts = normalize_artifacts(artifacts)
          validate_label
          freeze
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(**data.slice(:label, :candidate_id, :snapshot_digest, :artifacts))
        end

        def to_h
          {
            label: label,
            candidate_id: candidate_id,
            snapshot_digest: snapshot_digest,
            artifacts: artifacts
          }
        end

        def public_h
          { label: label, artifacts: artifacts }
        end

        private

        def normalize_artifacts(value)
          normalized = value.to_h.transform_keys(&:to_s).sort.to_h
          unless normalized.keys.sort == %w[midi musicxml]
            raise Error.new(
              "invalid_review", "review variants require MusicXML and MIDI artifacts"
            )
          end
          normalized.each_value do |artifact|
            filename = Validation.text(artifact.fetch("filename", artifact[:filename]), "artifact filename")
            digest = Validation.digest(artifact.fetch("digest", artifact[:digest]), "artifact digest")
            unless filename == File.basename(filename)
              raise Error.new("invalid_review", "artifact filename must not contain a path")
            end
          end
          CompositionGraph::Canonical.immutable(CompositionGraph::Canonical.value(normalized))
        rescue KeyError
          raise Error.new("invalid_review", "artifact evidence is incomplete")
        end

        def validate_label
          return if LABELS.include?(label)

          raise Error.new("invalid_review", "review variant label must be A or B")
        end
      end

      class PairwiseReview
        attr_reader :schema_version, :review_id, :transition_id, :scale, :criterion,
                    :seed_digest, :bundle_name, :variants, :recorded_at

        def initialize(schema_version:, review_id:, transition_id:, scale:, criterion:,
                       seed_digest:, bundle_name:, variants:, recorded_at:)
          @schema_version = Integer(schema_version)
          @review_id = Validation.text(review_id, "review_id")
          @transition_id = Validation.text(transition_id, "review transition_id")
          @scale = Validation.enum(scale, HUMAN_REVIEW_SCALES, "review scale")
          @criterion = Validation.enum(
            criterion, HUMAN_REVIEW_CRITERIA, "review criterion"
          )
          @seed_digest = Validation.digest(seed_digest, "review seed digest")
          @bundle_name = safe_bundle_name(bundle_name)
          @variants = variants.freeze
          @recorded_at = Validation.text(recorded_at, "review recorded_at")
          validate_review
          freeze
        end

        def self.create(transition_id:, scale:, criterion:, seed_digest:, variants:)
          identity = {
            transition_id: transition_id,
            scale: scale,
            criterion: criterion,
            seed_digest: seed_digest,
            variants: variants.map { |variant| [variant.label, variant.candidate_id] }
          }
          digest = CompositionGraph::Canonical.digest(identity).split(":", 2).last
          review_id = "review:#{digest[0, 20]}"
          new(
            schema_version: REVIEW_SCHEMA_VERSION,
            review_id: review_id,
            transition_id: transition_id,
            scale: scale,
            criterion: criterion,
            seed_digest: seed_digest,
            bundle_name: review_id.tr(":", "-"),
            variants: variants,
            recorded_at: Time.now.utc.iso8601(6)
          )
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          unless data[:kind] == "pairwise_review" && data[:blind] == true
            raise Error.new("invalid_review", "private review record must preserve blind mapping")
          end
          new(
            schema_version: data.fetch(:schema_version),
            review_id: data.fetch(:review_id),
            transition_id: data.fetch(:transition_id),
            scale: data.fetch(:scale),
            criterion: data.fetch(:criterion),
            seed_digest: data.fetch(:seed_digest),
            bundle_name: data.fetch(:bundle_name),
            variants: data.fetch(:variants).map { |item| ReviewVariant.from_h(item) },
            recorded_at: data.fetch(:recorded_at)
          )
        rescue KeyError => e
          raise Error.new("invalid_review", "review lacks #{e.key}")
        end

        def variant(label)
          variants.find { |item| item.label == label.to_s.upcase }
        end

        def to_h
          {
            schema_version: schema_version,
            kind: "pairwise_review",
            review_id: review_id,
            transition_id: transition_id,
            scale: scale,
            criterion: criterion,
            seed_digest: seed_digest,
            bundle_name: bundle_name,
            blind: true,
            variants: variants.map(&:to_h),
            recorded_at: recorded_at
          }
        end

        def public_h
          {
            schema_version: schema_version,
            kind: "blinded_pairwise_review",
            review_id: review_id,
            scale: scale,
            criterion: criterion,
            blind: true,
            variants: variants.map(&:public_h)
          }
        end

        private

        def safe_bundle_name(value)
          name = Validation.text(value, "review bundle_name")
          return name if name == File.basename(name)

          raise Error.new("invalid_review", "review bundle_name must not contain a path")
        end

        def validate_review
          unless schema_version == REVIEW_SCHEMA_VERSION
            raise Error.new("unsupported_schema", "review schema version is unsupported")
          end
          labels = variants.map(&:label)
          candidates = variants.map(&:candidate_id)
          return if labels.sort == ReviewVariant::LABELS && candidates.uniq.length == 2

          raise Error.new("invalid_review", "review requires distinct A and B candidates")
        end
      end

      class PreferenceRecord
        attr_reader :schema_version, :preference_id, :review_id, :transition_id,
                    :outcome, :preferred_candidate_id, :other_candidate_id,
                    :scale, :criterion, :rater_id, :purpose, :reason, :confidence,
                    :recorded_at

        def initialize(schema_version:, preference_id:, review_id:, transition_id:, outcome:,
                       scale:, criterion:, rater_id:, purpose:, reason:, recorded_at:,
                       preferred_candidate_id: nil, other_candidate_id: nil, confidence: nil)
          @schema_version = Integer(schema_version)
          @preference_id = Validation.text(preference_id, "preference_id")
          @review_id = Validation.text(review_id, "preference review_id")
          @transition_id = Validation.text(transition_id, "preference transition_id")
          @outcome = Validation.enum(outcome, PREFERENCE_OUTCOMES, "preference outcome")
          @preferred_candidate_id = preferred_candidate_id&.to_s
          @other_candidate_id = other_candidate_id&.to_s
          @scale = Validation.enum(scale, HUMAN_REVIEW_SCALES, "preference scale")
          @criterion = Validation.enum(
            criterion, HUMAN_REVIEW_CRITERIA, "preference criterion"
          )
          @rater_id = Validation.text(rater_id, "preference rater_id")
          @purpose = Validation.enum(purpose, PREFERENCE_PURPOSES, "preference purpose")
          @reason = Validation.text(reason, "preference reason")
          @confidence = confidence.nil? ? nil : Float(confidence)
          @recorded_at = Validation.text(recorded_at, "preference recorded_at")
          validate_preference
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_preference", "preference confidence must be numeric")
        end

        def self.create(review:, outcome:, rater_id:, purpose:, reason:, confidence: nil)
          normalized = Validation.enum(outcome, PREFERENCE_OUTCOMES, "preference outcome")
          preferred, other = resolved_candidates(review, normalized)
          identity = {
            review_id: review.review_id,
            outcome: normalized,
            rater_id: rater_id,
            purpose: purpose,
            reason: reason
          }
          digest = CompositionGraph::Canonical.digest(identity).split(":", 2).last
          new(
            schema_version: PREFERENCE_SCHEMA_VERSION,
            preference_id: "preference:#{digest[0, 20]}",
            review_id: review.review_id,
            transition_id: review.transition_id,
            outcome: normalized,
            preferred_candidate_id: preferred,
            other_candidate_id: other,
            scale: review.scale,
            criterion: review.criterion,
            rater_id: rater_id,
            purpose: purpose,
            reason: reason,
            confidence: confidence,
            recorded_at: Time.now.utc.iso8601(6)
          )
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          unless data[:kind] == "human_preference" && data[:blind] == true
            raise Error.new("invalid_preference", "preference must be a blinded human record")
          end
          new(**data.slice(
            :schema_version, :preference_id, :review_id, :transition_id, :outcome,
            :preferred_candidate_id, :other_candidate_id, :scale, :criterion, :rater_id,
            :purpose, :reason, :confidence, :recorded_at
          ))
        end

        def to_h
          {
            schema_version: schema_version,
            kind: "human_preference",
            preference_id: preference_id,
            review_id: review_id,
            transition_id: transition_id,
            outcome: outcome,
            preferred_candidate_id: preferred_candidate_id,
            other_candidate_id: other_candidate_id,
            scale: scale,
            criterion: criterion,
            rater_id: rater_id,
            purpose: purpose,
            reason: reason,
            confidence: confidence,
            blind: true,
            recorded_at: recorded_at
          }.compact
        end

        class << self
          private

          def resolved_candidates(review, outcome)
            return [nil, nil] if %i[tie abstain].include?(outcome)

            preferred_label = outcome == :a ? "A" : "B"
            other_label = outcome == :a ? "B" : "A"
            [review.variant(preferred_label).candidate_id, review.variant(other_label).candidate_id]
          end
        end

        private

        def validate_preference
          unless schema_version == PREFERENCE_SCHEMA_VERSION
            raise Error.new("unsupported_schema", "preference schema version is unsupported")
          end
          unless confidence.nil? || confidence.between?(0.0, 1.0)
            raise Error.new("invalid_preference", "preference confidence must be between zero and one")
          end
          resolved = [preferred_candidate_id, other_candidate_id]
          if %i[a b].include?(outcome)
            return if resolved.all? && resolved.uniq.length == 2
          elsif resolved.compact.empty?
            return
          end

          raise Error.new("invalid_preference", "preference outcome and candidate ids disagree")
        end
      end
    end
  end
end
