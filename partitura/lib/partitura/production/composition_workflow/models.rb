# frozen_string_literal: true

require_relative "../composition_graph"

module Partitura
  module Production
    module CompositionWorkflow
      SCHEMA_VERSION = 1
      TRAJECTORY_SCHEMA_VERSION = 2
      DIGEST_PATTERN = /\Asha256:[0-9a-f]{64}\z/
      LABEL_PATTERN = /\A[a-z][a-z0-9_:-]*\z/

      ACTION_KINDS = %i[bind_requirement refine global_review export_review].freeze
      LENSES = %i[
        form primary_material harmony rhythm role_texture voice_leading return_identity
        seam orchestration pacing idiom detail audition mechanical
      ].freeze
      OPERATORS = %i[
        plan establish_material realize_span realize_harmony transform_return revise_verticals
        interleave_seam detail subtract recompose review audition
      ].freeze
      DECISIONS = %i[accept keep_original backtrack defer].freeze
      CRITIC_SCALES = %i[mechanical local seam section global export human].freeze
      TRAJECTORY_ORIGINS = %i[deterministic agent].freeze
      TRAJECTORY_QUALITY_LABELS = %i[unrated medium].freeze

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
          raise Error.new("invalid_workflow_record", "#{label} must be non-empty") if string.strip.empty?

          string.freeze
        end

        def digest(value, label)
          string = value.to_s
          unless DIGEST_PATTERN.match?(string)
            raise Error.new("invalid_workflow_record", "#{label} must be a sha256 digest")
          end

          string.freeze
        end

        def enum(value, allowed, label)
          symbol = value&.to_sym
          unless allowed.include?(symbol)
            raise Error.new("invalid_workflow_record", "#{label} has unsupported value #{value.inspect}")
          end

          symbol
        end

        def label(value, description)
          string = text(value, description)
          unless LABEL_PATTERN.match?(string)
            raise Error.new(
              "invalid_workflow_record",
              "#{description} must be a lowercase identifier"
            )
          end

          string.to_sym
        end

        def path(value, label)
          parsed = value.is_a?(CompositionGraph::Path) ? value : CompositionGraph::Path.parse(value)
          raise Error.new("invalid_workflow_record", "#{label} must be a typed graph path") unless parsed

          parsed
        end

        def positive_integer(value, label)
          integer = Integer(value)
          raise Error.new("invalid_workflow_record", "#{label} must be positive") unless integer.positive?

          integer
        rescue ArgumentError, TypeError
          raise Error.new("invalid_workflow_record", "#{label} must be a positive integer")
        end

        def source_digest(value)
          "sha256:#{Digest::SHA256.hexdigest(value.to_s)}"
        end

        def source_text(value, label)
          source = value.to_s.dup.force_encoding(Encoding::UTF_8)
          unless source.valid_encoding? && !source.empty?
            raise Error.new("invalid_workflow_record", "#{label} must be non-empty UTF-8")
          end

          source.freeze
        end
      end

      class TrajectoryContext
        attr_reader :run_id, :origin, :quality_label

        def initialize(run_id:, origin:, quality_label:)
          @run_id = Validation.text(run_id, "trajectory run_id")
          @origin = Validation.enum(origin, TRAJECTORY_ORIGINS, "trajectory origin")
          @quality_label = Validation.enum(
            quality_label, TRAJECTORY_QUALITY_LABELS, "trajectory quality_label"
          )
          validate_quality
          freeze
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(**data.slice(:run_id, :origin, :quality_label))
        end

        def to_h
          { run_id: run_id, origin: origin, quality_label: quality_label }
        end

        private

        def validate_quality
          expected = origin == :agent ? :medium : :unrated
          return if quality_label == expected

          raise Error.new(
            "invalid_trajectory_quality",
            "#{origin} trajectories must be labeled #{expected}"
          )
        end
      end

      class Action
        attr_reader :action_id, :kind, :base_graph_digest, :base_snapshot_digest,
                    :target_path, :lens, :operator, :reason, :attempt, :context_paths,
                    :requirement_key, :need_id, :review_key

        def initialize(action_id:, kind:, base_graph_digest:, base_snapshot_digest:, target_path:,
                       lens:, operator:, reason:, attempt: 1, context_paths: [],
                       requirement_key: nil, need_id: nil, review_key: nil)
          @action_id = Validation.text(action_id, "action_id")
          @kind = Validation.enum(kind, ACTION_KINDS, "action kind")
          @base_graph_digest = Validation.digest(base_graph_digest, "action graph digest")
          @base_snapshot_digest = Validation.digest(base_snapshot_digest, "action snapshot digest")
          @target_path = Validation.path(target_path, "action target_path")
          @lens = Validation.enum(lens, LENSES, "action lens")
          @operator = Validation.enum(operator, OPERATORS, "action operator")
          @reason = Validation.text(reason, "action reason")
          @attempt = Validation.positive_integer(attempt, "action attempt")
          @context_paths = context_paths.map { |path| Validation.path(path, "action context path") }.freeze
          @requirement_key = requirement_key&.to_s
          @need_id = need_id&.to_s
          @review_key = review_key&.to_s
          validate_selectors
          freeze
        end

        def self.create(snapshot:, kind:, target_path:, lens:, operator:, reason:, attempt: 1,
                        context_paths: [], requirement_key: nil, need_id: nil, review_key: nil)
          identity = {
            kind: kind, graph_digest: snapshot.graph_digest,
            snapshot_digest: snapshot.snapshot_digest, target_path: target_path.to_s,
            lens: lens, operator: operator, requirement_key: requirement_key,
            need_id: need_id, review_key: review_key, attempt: attempt
          }
          new(
            action_id: "action:#{CompositionGraph::Canonical.digest(identity).split(':', 2).last[0, 20]}",
            kind: kind,
            base_graph_digest: snapshot.graph_digest,
            base_snapshot_digest: snapshot.snapshot_digest,
            target_path: target_path,
            lens: lens,
            operator: operator,
            reason: reason,
            attempt: attempt,
            context_paths: context_paths,
            requirement_key: requirement_key,
            need_id: need_id,
            review_key: review_key
          )
        end

        def to_h
          {
            action_id: action_id,
            kind: kind,
            base_graph_digest: base_graph_digest,
            base_snapshot_digest: base_snapshot_digest,
            target_path: target_path.to_s,
            lens: lens,
            operator: operator,
            reason: reason,
            attempt: attempt,
            context_paths: context_paths.map(&:to_s),
            requirement_key: requirement_key,
            need_id: need_id,
            review_key: review_key
          }.compact
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(**data.slice(
            :action_id, :kind, :base_graph_digest, :base_snapshot_digest, :target_path,
            :lens, :operator, :reason, :attempt, :context_paths, :requirement_key,
            :need_id, :review_key
          ))
        end

        private

        def validate_selectors
          selectors = [requirement_key, need_id, review_key].compact
          raise Error.new("invalid_workflow_record", "action must identify exactly one work item") unless selectors.one?
          if kind == :bind_requirement && !requirement_key
            raise Error.new("invalid_workflow_record", "bind_requirement action requires requirement_key")
          end
          if kind == :refine && !need_id
            raise Error.new("invalid_workflow_record", "refine action requires need_id")
          end
          if %i[global_review export_review].include?(kind) && !review_key
            raise Error.new("invalid_workflow_record", "review action requires review_key")
          end
          if context_paths.uniq.length != context_paths.length
            raise Error.new("invalid_workflow_record", "action context paths must be unique")
          end
        end
      end

      class Candidate
        attr_reader :candidate_id, :base_snapshot_digest, :target_path, :lens, :operator,
                    :patch_digest, :touched_paths, :description, :source_patch, :artifact

        def initialize(candidate_id:, base_snapshot_digest:, target_path:, lens:, operator:,
                       patch_digest:, touched_paths:, description:, source_patch: nil, artifact: nil)
          @candidate_id = Validation.text(candidate_id, "candidate_id")
          @base_snapshot_digest = Validation.digest(base_snapshot_digest, "candidate snapshot digest")
          @target_path = Validation.path(target_path, "candidate target_path")
          @lens = Validation.enum(lens, LENSES, "candidate lens")
          @operator = Validation.enum(operator, OPERATORS, "candidate operator")
          @patch_digest = Validation.digest(patch_digest, "candidate patch_digest")
          @touched_paths = touched_paths.map { |path| Validation.path(path, "candidate touched path") }.freeze
          @description = Validation.text(description, "candidate description")
          @source_patch = source_patch
          @artifact = artifact
          validate_payload
          freeze
        end

        def self.inline(action, source_patch:, description:, touched_paths: nil, candidate_id: nil)
          digest = Validation.source_digest(source_patch)
          new(
            candidate_id: candidate_id || "candidate:#{digest.split(':', 2).last[0, 20]}",
            base_snapshot_digest: action.base_snapshot_digest,
            target_path: action.target_path,
            lens: action.lens,
            operator: action.operator,
            patch_digest: digest,
            touched_paths: touched_paths || [action.target_path],
            description: description,
            source_patch: source_patch
          )
        end

        def validate_for(action)
          unless base_snapshot_digest == action.base_snapshot_digest &&
                 target_path == action.target_path && lens == action.lens && operator == action.operator
            raise Error.new("candidate_contract_mismatch", "#{candidate_id} does not implement #{action.action_id}")
          end

          true
        end

        def to_h(include_source: true)
          {
            candidate_id: candidate_id,
            base_snapshot_digest: base_snapshot_digest,
            target_path: target_path.to_s,
            lens: lens,
            operator: operator,
            patch_digest: patch_digest,
            touched_paths: touched_paths.map(&:to_s),
            description: description,
            source_patch: include_source ? source_patch : nil,
            artifact: artifact
          }.compact
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(**data.slice(
            :candidate_id, :base_snapshot_digest, :target_path, :lens, :operator,
            :patch_digest, :touched_paths, :description, :source_patch, :artifact
          ))
        end

        private

        def validate_payload
          unless [source_patch, artifact].compact.one?
            raise Error.new("invalid_workflow_record", "candidate needs exactly one patch payload")
          end
          if source_patch && Validation.source_digest(source_patch) != patch_digest
            raise Error.new("candidate_digest_mismatch", "candidate source patch digest does not match")
          end
          if touched_paths.empty? || !touched_paths.include?(target_path) ||
             touched_paths.uniq.length != touched_paths.length
            raise Error.new("invalid_workflow_record", "candidate touched paths must be unique and include target")
          end
        end
      end

      class CriticResult
        attr_reader :critic, :scale, :target_path, :candidate_id, :findings,
                    :features, :passed, :score, :confidence

        def initialize(critic:, scale:, target_path:, candidate_id:, findings: [], features: {},
                       passed: nil, score: nil, confidence: nil)
          @critic = Validation.text(critic, "critic")
          @scale = Validation.enum(scale, CRITIC_SCALES, "critic scale")
          @target_path = Validation.path(target_path, "critic target_path")
          @candidate_id = Validation.text(candidate_id, "critic candidate_id")
          @findings = findings.map { |item| Validation.text(item, "critic finding") }.freeze
          @features = features.to_h.transform_keys(&:to_s).transform_values { |item| Float(item) }.sort.to_h.freeze
          @passed = passed
          @score = score.nil? ? nil : Float(score)
          @confidence = confidence.nil? ? nil : Float(confidence)
          validate_values
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_workflow_record", "critic scores and features must be numeric")
        end

        def to_h
          {
            critic: critic, scale: scale, target_path: target_path.to_s,
            candidate_id: candidate_id, findings: findings, features: features,
            passed: passed, score: score, confidence: confidence
          }.compact
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(**data.slice(
            :critic, :scale, :target_path, :candidate_id, :findings,
            :features, :passed, :score, :confidence
          ))
        end

        private

        def validate_values
          unless passed.nil? || passed == true || passed == false
            raise Error.new("invalid_workflow_record", "critic passed must be boolean")
          end
          return if confidence.nil? || confidence.between?(0.0, 1.0)

          raise Error.new("invalid_workflow_record", "critic confidence must be between zero and one")
        end
      end

      class Assessment
        attr_reader :candidate, :critic_results, :candidate_snapshot, :artifact_digests

        def initialize(candidate:, critic_results:, candidate_snapshot: nil, artifact_digests: {})
          @candidate = candidate
          @critic_results = critic_results.freeze
          @candidate_snapshot = candidate_snapshot && CompositionGraph::Canonical.immutable(candidate_snapshot)
          @artifact_digests = artifact_digests.to_h.transform_keys(&:to_s).sort.to_h.freeze
          validate_results
          freeze
        end

        def mechanically_valid?
          mechanical = critic_results.select { |result| result.scale == :mechanical }
          !mechanical.empty? && mechanical.all? { |result| result.passed == true }
        end

        def to_h(include_source: true)
          {
            candidate: candidate.to_h(include_source: include_source),
            critic_results: critic_results.map(&:to_h),
            candidate_snapshot: candidate_snapshot,
            artifact_digests: artifact_digests
          }.compact
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          new(
            candidate: Candidate.from_h(data.fetch(:candidate)),
            critic_results: data.fetch(:critic_results).map { |item| CriticResult.from_h(item) },
            candidate_snapshot: data[:candidate_snapshot],
            artifact_digests: data.fetch(:artifact_digests, {})
          )
        end

        private

        def validate_results
          identities = critic_results.map { |result| [result.critic, result.scale] }
          if identities.uniq.length != identities.length
            raise Error.new("invalid_workflow_record", "candidate has duplicate critic results")
          end
          unless critic_results.all? { |result| result.candidate_id == candidate.candidate_id }
            raise Error.new("invalid_workflow_record", "critic result belongs to another candidate")
          end
        end
      end

    end
  end
end
