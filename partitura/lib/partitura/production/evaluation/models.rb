# frozen_string_literal: true

require "digest"
require "time"
require_relative "../composition_graph"

module Partitura
  module Production
    module Evaluation
      PROFILE_SCHEMA_VERSION = 1
      REVIEW_SCHEMA_VERSION = 1
      PREFERENCE_SCHEMA_VERSION = 1
      CRITERIA = %i[coherence identity seams orchestration reserve overall].freeze
      OUTCOMES = %i[a b tie abstain].freeze
      LABELS = %w[A B].freeze
      DIGEST_PATTERN = /\Asha256:[0-9a-f]{64}\z/

      class Error < StandardError
        attr_reader :code, :details

        def initialize(code, message, details: {})
          @code = code.to_s
          @details = details.freeze
          super(message)
        end

        def to_h
          { status: "error", code: code, message: message }.merge(details)
        end
      end

      module Validation
        module_function

        def text(value, label)
          string = value.to_s
          raise Error.new("invalid_evaluation_record", "#{label} must be non-empty") if string.strip.empty?

          string.freeze
        end

        def digest(value, label)
          string = text(value, label)
          return string.freeze if DIGEST_PATTERN.match?(string)

          raise Error.new("invalid_evaluation_record", "#{label} must be a sha256 digest")
        end

        def enum(value, allowed, label)
          symbol = value&.to_sym
          return symbol if allowed.include?(symbol)

          raise Error.new("invalid_evaluation_record", "#{label} has unsupported value #{value.inspect}")
        end

        def sha256(value)
          "sha256:#{Digest::SHA256.hexdigest(value)}"
        end
      end

      class Artifact
        attr_reader :kind, :filename, :digest, :content

        def initialize(kind:, filename:, content:)
          @kind = kind.to_sym
          @filename = Validation.text(filename, "artifact filename")
          @content = content.b.freeze
          @digest = Validation.sha256(@content)
          unless filename == File.basename(filename)
            raise Error.new("invalid_evaluation_record", "artifact filename must not contain a path")
          end

          freeze
        end
      end

      class ReviewSubject
        attr_reader :label, :run_id, :source_digest, :snapshot_digest, :artifacts

        def initialize(label:, run_id:, source_digest:, snapshot_digest:, artifacts:)
          @label = Validation.text(label, "review label")
          @run_id = Validation.text(run_id, "review run_id")
          @source_digest = Validation.digest(source_digest, "review source digest")
          @snapshot_digest = Validation.digest(snapshot_digest, "review snapshot digest")
          @artifacts = immutable_artifacts(artifacts)
          validate_subject
          freeze
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(**data.slice(:label, :run_id, :source_digest, :snapshot_digest, :artifacts))
        end

        def to_h
          {
            label: label, run_id: run_id, source_digest: source_digest,
            snapshot_digest: snapshot_digest, artifacts: artifacts
          }
        end

        def public_h
          { label: label, artifacts: artifacts }
        end

        private

        def immutable_artifacts(value)
          artifacts = CompositionGraph::Canonical.value(value)
          unless artifacts.keys.sort == %w[midi musicxml]
            raise Error.new("invalid_evaluation_record", "review requires MusicXML and MIDI")
          end
          artifacts.each_value do |artifact|
            Validation.text(artifact.fetch("filename"), "artifact filename")
            Validation.digest(artifact.fetch("digest"), "artifact digest")
          end
          CompositionGraph::Canonical.immutable(artifacts)
        rescue KeyError
          raise Error.new("invalid_evaluation_record", "review artifact evidence is incomplete")
        end

        def validate_subject
          return if LABELS.include?(label)

          raise Error.new("invalid_evaluation_record", "review label must be A or B")
        end
      end

      class ScoreReview
        attr_reader :schema_version, :review_id, :benchmark_id, :case_id,
                    :criterion, :seed_digest, :bundle_name, :subjects, :recorded_at

        def initialize(schema_version:, review_id:, benchmark_id:, case_id:, criterion:,
                       seed_digest:, bundle_name:, subjects:, recorded_at:)
          @schema_version = Integer(schema_version)
          @review_id = Validation.text(review_id, "review_id")
          @benchmark_id = Validation.text(benchmark_id, "benchmark_id")
          @case_id = Validation.text(case_id, "case_id")
          @criterion = Validation.enum(criterion, CRITERIA, "review criterion")
          @seed_digest = Validation.digest(seed_digest, "review seed digest")
          @bundle_name = safe_bundle_name(bundle_name)
          @subjects = subjects.freeze
          @recorded_at = Validation.text(recorded_at, "review recorded_at")
          validate_review
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_evaluation_record", "review schema_version must be an integer")
        end

        def self.create(benchmark_id:, case_id:, criterion:, seed_digest:, subjects:)
          identity = {
            benchmark_id: benchmark_id, case_id: case_id, criterion: criterion,
            seed_digest: seed_digest,
            subjects: subjects.map { |subject| [subject.label, subject.run_id] }
          }
          digest = CompositionGraph::Canonical.digest(identity).split(":", 2).last
          review_id = "evaluation-review:#{digest[0, 20]}"
          new(
            schema_version: REVIEW_SCHEMA_VERSION,
            review_id: review_id,
            benchmark_id: benchmark_id,
            case_id: case_id,
            criterion: criterion,
            seed_digest: seed_digest,
            bundle_name: review_id.tr(":", "-"),
            subjects: subjects,
            recorded_at: Time.now.utc.iso8601(6)
          )
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          unless data[:kind] == "score_evaluation_review" && data[:blind] == true
            raise Error.new("invalid_evaluation_record", "review must preserve its blind mapping")
          end
          new(
            schema_version: data.fetch(:schema_version),
            review_id: data.fetch(:review_id),
            benchmark_id: data.fetch(:benchmark_id),
            case_id: data.fetch(:case_id),
            criterion: data.fetch(:criterion),
            seed_digest: data.fetch(:seed_digest),
            bundle_name: data.fetch(:bundle_name),
            subjects: data.fetch(:subjects).map { |item| ReviewSubject.from_h(item) },
            recorded_at: data.fetch(:recorded_at)
          )
        rescue KeyError => e
          raise Error.new("invalid_evaluation_record", "review lacks #{e.key}")
        end

        def subject(label)
          subjects.find { |item| item.label == label.to_s.upcase }
        end

        def to_h
          {
            schema_version: schema_version, kind: "score_evaluation_review",
            review_id: review_id, benchmark_id: benchmark_id, case_id: case_id,
            criterion: criterion, seed_digest: seed_digest, bundle_name: bundle_name,
            blind: true, subjects: subjects.map(&:to_h), recorded_at: recorded_at
          }
        end

        def public_h
          {
            schema_version: schema_version, kind: "blinded_score_evaluation",
            review_id: review_id, criterion: criterion, blind: true,
            subjects: subjects.map(&:public_h)
          }
        end

        private

        def safe_bundle_name(value)
          name = Validation.text(value, "review bundle_name")
          return name if name == File.basename(name)

          raise Error.new("invalid_evaluation_record", "bundle_name must not contain a path")
        end

        def validate_review
          unless schema_version == REVIEW_SCHEMA_VERSION
            raise Error.new("unsupported_schema", "evaluation review schema is unsupported")
          end
          labels = subjects.map(&:label)
          runs = subjects.map(&:run_id)
          return if labels.sort == LABELS && runs.uniq.length == 2

          raise Error.new("invalid_evaluation_record", "review requires distinct A and B runs")
        end
      end
    end
  end
end
