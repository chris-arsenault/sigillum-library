# frozen_string_literal: true

module Partitura
  module Production
    module CompositionWorkflow
      module ProtocolTools
        RESPONSE_REQUEST_KINDS = {
          "proposal_response" => "proposal_request",
          "selection_response" => "selection_request"
        }.freeze

        module_function

        def template(kind, request_data, producer:, patch: nil, description: nil,
                     candidate_id: nil, selected_candidate_id: nil, reason: nil)
          case normalize_kind(kind)
          when "proposal_response"
            proposal_template(
              request_data, producer:, patch:, description:, candidate_id:
            )
          when "selection_response"
            selection_template(
              request_data, producer:, selected_candidate_id:, reason:
            )
          else
            raise Error.new(
              "unknown_protocol_template",
              "template kind must be proposal-response or selection-response"
            )
          end
        end

        def validate(message_data, against_data: nil)
          kind = message_data.fetch("kind", message_data[:kind]).to_s
          record = parse_record(kind, message_data)
          binding = binding_validated?(kind, record, against_data)
          {
            status: "ok",
            schema_version: SCHEMA_VERSION,
            kind:,
            request_id: record.request_id,
            binding_validated: binding
          }
        rescue KeyError => error
          raise Error.new("invalid_protocol_message", "protocol message lacks #{error.key}")
        end

        def proposal_template(request_data, producer:, patch:, description:, candidate_id:)
          request = ProposalRequest.from_h(request_data)
          candidates = if patch
                         [Candidate.inline(
                           request.action,
                           source_patch: patch,
                           description: description || "Candidate supplied by #{producer}.",
                           candidate_id:
                         )]
                       else
                         []
                       end
          ProposalResponse.create(request:, producer:, candidates:).to_h
        end

        def selection_template(request_data, producer:, selected_candidate_id:, reason:)
          request = SelectionRequest.from_h(request_data)
          selected = selected_candidate_id || Protocol::ORIGINAL_CANDIDATE_ID
          explanation = reason || "Retain the original unless this reason is replaced."
          SelectionResponse.create(
            request:,
            producer:,
            selected_candidate_id: selected,
            reason: explanation
          ).to_h
        end

        def parse_record(kind, data)
          case kind
          when "proposal_request" then ProposalRequest.from_h(data)
          when "proposal_response" then ProposalResponse.from_h(data)
          when "selection_request" then SelectionRequest.from_h(data)
          when "selection_response" then SelectionResponse.from_h(data)
          else
            raise Error.new(
              "unknown_protocol_kind",
              "unknown protocol kind #{kind.inspect}; available: #{Protocol::MESSAGE_KINDS.join(', ')}"
            )
          end
        end

        def binding_validated?(kind, record, against_data)
          request_kind = RESPONSE_REQUEST_KINDS[kind]
          return false unless request_kind

          unless against_data
            raise Error.new(
              "missing_protocol_request",
              "validating #{kind} requires --against #{request_kind}.json"
            )
          end
          request = parse_record(request_kind, against_data)
          record.validate_for(request)
          true
        end

        def normalize_kind(kind)
          kind.to_s.tr("-", "_")
        end
      end
    end
  end
end
