# frozen_string_literal: true

require_relative "models"

module Partitura
  module Production
    module Evaluation
      class ScorePreference
        attr_reader :schema_version, :preference_id, :review_id, :benchmark_id,
                    :case_id, :criterion, :outcome, :preferred_run_id,
                    :other_run_id, :rater_id, :reason, :confidence, :recorded_at

        def initialize(schema_version:, preference_id:, review_id:, benchmark_id:,
                       case_id:, criterion:, outcome:, rater_id:, reason:, recorded_at:,
                       preferred_run_id: nil, other_run_id: nil, confidence: nil)
          @schema_version = Integer(schema_version)
          @preference_id = Validation.text(preference_id, "preference_id")
          @review_id = Validation.text(review_id, "preference review_id")
          @benchmark_id = Validation.text(benchmark_id, "preference benchmark_id")
          @case_id = Validation.text(case_id, "preference case_id")
          @criterion = Validation.enum(criterion, CRITERIA, "preference criterion")
          @outcome = Validation.enum(outcome, OUTCOMES, "preference outcome")
          @preferred_run_id = preferred_run_id&.to_s
          @other_run_id = other_run_id&.to_s
          @rater_id = Validation.text(rater_id, "preference rater_id")
          @reason = Validation.text(reason, "preference reason")
          @confidence = confidence.nil? ? nil : Float(confidence)
          @recorded_at = Validation.text(recorded_at, "preference recorded_at")
          validate_preference
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_evaluation_record", "preference numeric value is invalid")
        end

        def self.create(review:, outcome:, rater_id:, reason:, confidence: nil)
          normalized = Validation.enum(outcome, OUTCOMES, "preference outcome")
          preferred, other = resolved_runs(review, normalized)
          identity = {
            review_id: review.review_id, outcome: normalized,
            rater_id: rater_id, reason: reason
          }
          digest = CompositionGraph::Canonical.digest(identity).split(":", 2).last
          new(
            schema_version: PREFERENCE_SCHEMA_VERSION,
            preference_id: "evaluation-preference:#{digest[0, 20]}",
            review_id: review.review_id,
            benchmark_id: review.benchmark_id,
            case_id: review.case_id,
            criterion: review.criterion,
            outcome: normalized,
            preferred_run_id: preferred,
            other_run_id: other,
            rater_id: rater_id,
            reason: reason,
            confidence: confidence,
            recorded_at: Time.now.utc.iso8601(6)
          )
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          unless data[:kind] == "score_evaluation_preference" && data[:blind] == true
            raise Error.new("invalid_evaluation_record", "preference must be blinded")
          end
          new(**data.slice(
            :schema_version, :preference_id, :review_id, :benchmark_id,
            :case_id, :criterion, :outcome, :preferred_run_id,
            :other_run_id, :rater_id, :reason, :confidence, :recorded_at
          ))
        end

        def to_h
          {
            schema_version: schema_version, kind: "score_evaluation_preference",
            preference_id: preference_id, review_id: review_id,
            benchmark_id: benchmark_id, case_id: case_id, criterion: criterion,
            outcome: outcome, preferred_run_id: preferred_run_id,
            other_run_id: other_run_id, rater_id: rater_id,
            purpose: :held_out_evaluation, reason: reason, confidence: confidence,
            blind: true, recorded_at: recorded_at
          }.compact
        end

        class << self
          private

          def resolved_runs(review, outcome)
            return [nil, nil] if %i[tie abstain].include?(outcome)

            preferred = outcome == :a ? review.subject("A") : review.subject("B")
            other = outcome == :a ? review.subject("B") : review.subject("A")
            [preferred.run_id, other.run_id]
          end
        end

        private

        def validate_preference
          unless schema_version == PREFERENCE_SCHEMA_VERSION
            raise Error.new("unsupported_schema", "evaluation preference schema is unsupported")
          end
          unless confidence.nil? || confidence.between?(0.0, 1.0)
            raise Error.new("invalid_evaluation_record", "confidence must be between zero and one")
          end
          resolved = [preferred_run_id, other_run_id]
          return if %i[a b].include?(outcome) && resolved.all? && resolved.uniq.length == 2
          return if %i[tie abstain].include?(outcome) && resolved.compact.empty?

          raise Error.new("invalid_evaluation_record", "preference outcome and runs disagree")
        end
      end
    end
  end
end
