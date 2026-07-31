# frozen_string_literal: true

require "json"
require_relative "models"

module Partitura
  module Production
    module CompositionWorkflow
      module Protocol
        ORIGINAL_CANDIDATE_ID = "original"
        MESSAGE_KINDS = %w[
          proposal_request proposal_response selection_request selection_response
        ].freeze

        module_function

        def request_id(kind, payload)
          digest = CompositionGraph::Canonical.digest(kind: kind, payload: payload)
          "#{kind}:#{digest.split(':', 2).last}"
        end

        def parse_json(value)
          parsed = JSON.parse(value)
          unless parsed.is_a?(Hash)
            raise Error.new("invalid_protocol_message", "protocol message must be a JSON object")
          end

          parsed
        rescue JSON::ParserError => e
          raise Error.new("invalid_protocol_message", "invalid protocol JSON: #{e.message}")
        end

        def read_json(path, stdin: $stdin)
          parse_json(path == "-" ? stdin.read : File.read(path, encoding: Encoding::UTF_8))
        rescue Errno::ENOENT
          raise Error.new("missing_protocol_message", "protocol message does not exist: #{path}")
        end

        def validate_header(data, kind)
          version = Integer(data.fetch(:schema_version))
          raise Error.new("unsupported_schema", "workflow protocol schema is unsupported") unless version == SCHEMA_VERSION
          unless data.fetch(:kind).to_s == kind
            raise Error.new("invalid_protocol_message", "expected #{kind}, got #{data.fetch(:kind).inspect}")
          end
        rescue KeyError, ArgumentError, TypeError => e
          raise Error.new("invalid_protocol_message", "invalid protocol header: #{e.message}")
        end
      end

      class ProposalRequest
        attr_reader :schema_version, :kind, :request_id, :snapshot, :action,
                    :source_name, :source_digest

        def initialize(schema_version:, kind:, request_id:, snapshot:, action:,
                       source_name:, source_digest:)
          @schema_version = Integer(schema_version)
          @kind = kind.to_s.freeze
          @request_id = Validation.text(request_id, "proposal request_id")
          @snapshot = CompositionGraph::Canonical.immutable(snapshot)
          @action = action
          @source_name = Validation.text(source_name, "proposal source_name")
          @source_digest = Validation.digest(source_digest, "proposal source_digest")
          validate_request
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_protocol_message", "proposal schema_version must be an integer")
        end

        def self.create(snapshot:, action:, source_name:, source_digest:)
          payload = {
            snapshot: snapshot.to_h,
            action: action.to_h,
            source_name: source_name,
            source_digest: source_digest
          }
          new(
            schema_version: SCHEMA_VERSION,
            kind: "proposal_request",
            request_id: Protocol.request_id("proposal_request", payload),
            snapshot: payload.fetch(:snapshot),
            action: action,
            source_name: source_name,
            source_digest: source_digest
          )
        end

        def to_h
          {
            schema_version: schema_version,
            kind: kind,
            request_id: request_id,
            snapshot: snapshot,
            action: action.to_h,
            source_name: source_name,
            source_digest: source_digest
          }
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          Protocol.validate_header(data, "proposal_request")
          new(
            schema_version: data.fetch(:schema_version),
            kind: data.fetch(:kind),
            request_id: data.fetch(:request_id),
            snapshot: data.fetch(:snapshot),
            action: Action.from_h(data.fetch(:action)),
            source_name: data.fetch(:source_name),
            source_digest: data.fetch(:source_digest)
          )
        rescue KeyError => e
          raise Error.new("invalid_protocol_message", "proposal request lacks #{e.key}")
        end

        private

        def validate_request
          Protocol.validate_header(to_h, "proposal_request")
          unless snapshot.fetch("graph_digest") == action.base_graph_digest &&
                 snapshot.fetch("snapshot_digest") == action.base_snapshot_digest
            raise Error.new("protocol_mismatch", "proposal action and snapshot do not match")
          end
          expected = Protocol.request_id(
            kind,
            snapshot: snapshot,
            action: action.to_h,
            source_name: source_name,
            source_digest: source_digest
          )
          raise Error.new("protocol_mismatch", "proposal request_id is invalid") unless request_id == expected
        rescue KeyError => e
          raise Error.new("invalid_protocol_message", "proposal snapshot lacks #{e.key}")
        end
      end

      class ProposalResponse
        attr_reader :schema_version, :kind, :request_id, :producer, :candidates

        def initialize(schema_version:, kind:, request_id:, producer:, candidates:)
          @schema_version = Integer(schema_version)
          @kind = kind.to_s.freeze
          @request_id = Validation.text(request_id, "proposal response request_id")
          @producer = Validation.text(producer, "proposal producer")
          @candidates = candidates.freeze
          Protocol.validate_header(to_h, "proposal_response")
          ids = candidates.map(&:candidate_id)
          unless ids.uniq.length == ids.length
            raise Error.new("invalid_protocol_message", "proposal candidate ids must be unique")
          end
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_protocol_message", "proposal schema_version must be an integer")
        end

        def self.create(request:, producer:, candidates:)
          new(
            schema_version: SCHEMA_VERSION,
            kind: "proposal_response",
            request_id: request.request_id,
            producer: producer,
            candidates: candidates
          ).tap { |response| response.validate_for(request) }
        end

        def validate_for(request)
          unless request_id == request.request_id
            raise Error.new("protocol_mismatch", "proposal response belongs to another request")
          end
          candidates.each { |candidate| candidate.validate_for(request.action) }
          true
        end

        def to_h
          {
            schema_version: schema_version,
            kind: kind,
            request_id: request_id,
            producer: producer,
            candidates: candidates.map(&:to_h)
          }
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          Protocol.validate_header(data, "proposal_response")
          new(
            schema_version: data.fetch(:schema_version),
            kind: data.fetch(:kind),
            request_id: data.fetch(:request_id),
            producer: data.fetch(:producer),
            candidates: data.fetch(:candidates).map { |item| Candidate.from_h(item) }
          )
        rescue KeyError => e
          raise Error.new("invalid_protocol_message", "proposal response lacks #{e.key}")
        end
      end

      class SelectionRequest
        attr_reader :schema_version, :kind, :request_id, :proposal_request_id,
                    :snapshot, :action, :original_candidate_id, :assessments,
                    :candidate_observations

        def initialize(schema_version:, kind:, request_id:, proposal_request_id:, snapshot:,
                       action:, original_candidate_id:, assessments:,
                       candidate_observations: {})
          @schema_version = Integer(schema_version)
          @kind = kind.to_s.freeze
          @request_id = Validation.text(request_id, "selection request_id")
          @proposal_request_id = Validation.text(
            proposal_request_id, "selection proposal_request_id"
          )
          @snapshot = CompositionGraph::Canonical.immutable(snapshot)
          @action = action
          @original_candidate_id = Validation.text(
            original_candidate_id, "original candidate id"
          )
          @assessments = CompositionGraph::Canonical.immutable(
            CompositionGraph::Canonical.value(assessments)
          )
          @candidate_observations = CompositionGraph::Canonical.immutable(
            CompositionGraph::Canonical.value(candidate_observations)
          )
          validate_request
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_protocol_message", "selection schema_version must be an integer")
        end

        def self.create(proposal_request:, assessments:, candidate_observations: {})
          payload = {
            proposal_request_id: proposal_request.request_id,
            snapshot: proposal_request.snapshot,
            action: proposal_request.action.to_h,
            original_candidate_id: Protocol::ORIGINAL_CANDIDATE_ID,
            assessments: assessments.map { |item| item.to_h(include_source: false) },
            candidate_observations: candidate_observations
          }
          new(
            schema_version: SCHEMA_VERSION,
            kind: "selection_request",
            request_id: Protocol.request_id("selection_request", payload),
            proposal_request_id: proposal_request.request_id,
            snapshot: proposal_request.snapshot,
            action: proposal_request.action,
            original_candidate_id: Protocol::ORIGINAL_CANDIDATE_ID,
            assessments: payload.fetch(:assessments),
            candidate_observations: payload.fetch(:candidate_observations)
          )
        end

        def candidate_ids
          assessments.map { |assessment| assessment.fetch("candidate").fetch("candidate_id") }
        end

        def to_h
          {
            schema_version: schema_version,
            kind: kind,
            request_id: request_id,
            proposal_request_id: proposal_request_id,
            snapshot: snapshot,
            action: action.to_h,
            original_candidate_id: original_candidate_id,
            assessments: assessments,
            candidate_observations: candidate_observations
          }
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          Protocol.validate_header(data, "selection_request")
          new(
            schema_version: data.fetch(:schema_version),
            kind: data.fetch(:kind),
            request_id: data.fetch(:request_id),
            proposal_request_id: data.fetch(:proposal_request_id),
            snapshot: data.fetch(:snapshot),
            action: Action.from_h(data.fetch(:action)),
            original_candidate_id: data.fetch(:original_candidate_id),
            assessments: data.fetch(:assessments),
            candidate_observations: data.fetch(:candidate_observations, {})
          )
        rescue KeyError => e
          raise Error.new("invalid_protocol_message", "selection request lacks #{e.key}")
        end

        private

        def validate_request
          Protocol.validate_header(to_h, "selection_request")
          unless original_candidate_id == Protocol::ORIGINAL_CANDIDATE_ID
            raise Error.new("invalid_protocol_message", "selection request must expose the original")
          end
          ids = candidate_ids
          unless ids.any? && ids.uniq.length == ids.length
            raise Error.new("invalid_protocol_message", "selection request needs unique candidates")
          end
          assessments.each do |assessment|
            candidate = assessment.fetch("candidate")
            unless candidate.fetch("base_snapshot_digest") == action.base_snapshot_digest &&
                   candidate.fetch("target_path") == action.target_path.to_s &&
                   candidate.fetch("lens") == action.lens.to_s &&
                   candidate.fetch("operator") == action.operator.to_s
              raise Error.new("protocol_mismatch", "selection candidate does not implement the action")
            end
          end
          unknown_observations = candidate_observations.keys - ids
          unless unknown_observations.empty?
            raise Error.new(
              "invalid_protocol_message",
              "selection observations name unknown candidates: #{unknown_observations.join(', ')}"
            )
          end
          candidate_observations.each_value do |observation|
            unless observation.fetch("schema_version") == ScoreObservation::SCHEMA_VERSION &&
                   DIGEST_PATTERN.match?(observation.fetch("observation_digest"))
              raise Error.new(
                "invalid_protocol_message",
                "selection candidate observation is invalid"
              )
            end
          end
          expected = Protocol.request_id(
            kind,
            proposal_request_id: proposal_request_id,
            snapshot: snapshot,
            action: action.to_h,
            original_candidate_id: original_candidate_id,
            assessments: assessments,
            candidate_observations: candidate_observations
          )
          raise Error.new("protocol_mismatch", "selection request_id is invalid") unless request_id == expected
        rescue KeyError => e
          raise Error.new("invalid_protocol_message", "selection assessment lacks #{e.key}")
        end
      end

      class SelectionResponse
        attr_reader :schema_version, :kind, :request_id, :producer,
                    :selected_candidate_id, :reason, :critic_results

        def initialize(schema_version:, kind:, request_id:, producer:, selected_candidate_id:,
                       reason:, critic_results: [])
          @schema_version = Integer(schema_version)
          @kind = kind.to_s.freeze
          @request_id = Validation.text(request_id, "selection response request_id")
          @producer = Validation.text(producer, "selection producer")
          @selected_candidate_id = Validation.text(
            selected_candidate_id, "selected candidate id"
          )
          @reason = Validation.text(reason, "selection reason")
          @critic_results = critic_results.freeze
          Protocol.validate_header(to_h, "selection_response")
          if critic_results.any? { |result| result.scale == :mechanical }
            raise Error.new(
              "invalid_protocol_message",
              "ML responses may not claim Partitura's mechanical critic scale"
            )
          end
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_protocol_message", "selection schema_version must be an integer")
        end

        def self.create(request:, producer:, selected_candidate_id:, reason:, critic_results: [])
          new(
            schema_version: SCHEMA_VERSION,
            kind: "selection_response",
            request_id: request.request_id,
            producer: producer,
            selected_candidate_id: selected_candidate_id,
            reason: reason,
            critic_results: critic_results
          ).tap { |response| response.validate_for(request) }
        end

        def original_selected?
          selected_candidate_id == Protocol::ORIGINAL_CANDIDATE_ID
        end

        def validate_for(request)
          unless request_id == request.request_id
            raise Error.new("protocol_mismatch", "selection response belongs to another request")
          end
          allowed = request.candidate_ids + [request.original_candidate_id]
          unless allowed.include?(selected_candidate_id)
            raise Error.new("invalid_selection", "selection names an unknown candidate")
          end
          unless critic_results.all? { |result| request.candidate_ids.include?(result.candidate_id) }
            raise Error.new("invalid_protocol_message", "critic result names an unknown candidate")
          end
          identities = critic_results.map { |result| [result.candidate_id, result.critic, result.scale] }
          unless identities.uniq.length == identities.length
            raise Error.new("invalid_protocol_message", "selection response has duplicate critic results")
          end
          true
        end

        def to_h
          {
            schema_version: schema_version,
            kind: kind,
            request_id: request_id,
            producer: producer,
            selected_candidate_id: selected_candidate_id,
            reason: reason,
            critic_results: critic_results.map(&:to_h)
          }
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          Protocol.validate_header(data, "selection_response")
          new(
            schema_version: data.fetch(:schema_version),
            kind: data.fetch(:kind),
            request_id: data.fetch(:request_id),
            producer: data.fetch(:producer),
            selected_candidate_id: data.fetch(:selected_candidate_id),
            reason: data.fetch(:reason),
            critic_results: data.fetch(:critic_results, []).map { |item| CriticResult.from_h(item) }
          )
        rescue KeyError => e
          raise Error.new("invalid_protocol_message", "selection response lacks #{e.key}")
        end
      end
    end
  end
end
