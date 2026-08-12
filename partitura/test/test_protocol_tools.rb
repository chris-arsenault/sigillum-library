# frozen_string_literal: true

require "json"
require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/composition_workflow_helper"

class ProtocolToolsTest < Minitest::Test
  include CompositionWorkflowTestSupport
  Workflow = CompositionWorkflowTestSupport::Workflow

  def test_constructs_and_validates_request_bound_responses
    with_protocol_records do |source, request, _proposal, selection_request|
      patch = bass_patch(File.basename(source))
      proposal_data = proposal_template(request, patch)
      selection_data = selection_template(selection_request)
      proposal = Workflow::ProposalResponse.from_h(proposal_data)

      assert proposal.validate_for(request)
      assert_equal Workflow::Validation.source_digest(patch), proposal.candidates.first.patch_digest
      assert Workflow::SelectionResponse.from_h(selection_data).validate_for(selection_request)
      assert Workflow::ProtocolTools.validate(
        proposal_data, against_data: request.to_h
      ).fetch(:binding_validated)
    end
  end

  def test_response_validation_requires_the_exact_request
    with_protocol_records do |_source, request, proposal, _selection_request|
      error = assert_raises(Workflow::Error) do
        Workflow::ProtocolTools.validate(proposal.to_h)
      end

      assert_equal "missing_protocol_request", error.code
      assert_includes error.message, "--against proposal_request.json"
      assert Workflow::ProtocolTools.validate(
        proposal.to_h, against_data: request.to_h
      ).fetch(:binding_validated)
    end
  end

  def test_cli_templates_and_validates_protocol_responses
    with_protocol_records do |source, request, _proposal, selection_request, directory|
      proposal_request_path = write_json(directory, "proposal-request.json", request.to_h)
      selection_request_path = write_json(directory, "selection-request.json", selection_request.to_h)
      patch_path = write_patch(directory, source)

      proposal_path = cli_proposal(directory, proposal_request_path, patch_path)
      validate_protocol_cli(proposal_path, proposal_request_path)
      selection_path = cli_selection(directory, selection_request_path)
      validate_protocol_cli(selection_path, selection_request_path)
    end
  end

  private

  def with_protocol_records
    with_source do |source, directory|
      executor = Workflow::CandidateExecutor.new
      snapshot = executor.load_snapshot(source)
      request = proposal_request(source, snapshot)
      candidate = inline_candidate(request.action)
      proposal = Workflow::ProposalResponse.create(
        request:, producer: "test-proposer", candidates: [candidate]
      )
      selection = selection_request(executor, source, snapshot, request, candidate)
      yield source, request, proposal, selection, directory
    end
  end

  def proposal_request(source, snapshot)
    Workflow::ProposalRequest.create(
      snapshot:,
      action: scheduled_action(snapshot),
      source_name: File.basename(source),
      source_digest: Workflow::Validation.source_digest(File.binread(source))
    )
  end

  def selection_request(executor, source, snapshot, request, candidate)
    execution = executor.execute(
      source_path: source, snapshot:, action: request.action,
      candidate:, export: false
    )
    assessment = Workflow::Assessment.new(
      candidate:,
      critic_results: [execution.mechanical_result(request.action)],
      candidate_snapshot: execution.after_snapshot.to_h
    )
    Workflow::SelectionRequest.create(proposal_request: request, assessments: [assessment])
  end

  def proposal_template(request, patch)
    Workflow::ProtocolTools.template(
      "proposal-response", request.to_h, producer: "tool-test", patch:,
      description: "Complete the scheduled bass span."
    )
  end

  def selection_template(request)
    Workflow::ProtocolTools.template(
      "selection-response", request.to_h, producer: "tool-selector",
      selected_candidate_id: "original", reason: "Retain the current score."
    )
  end

  def write_json(directory, name, payload)
    path = File.join(directory, name)
    File.write(path, JSON.generate(payload))
    path
  end

  def write_patch(directory, source)
    path = File.join(directory, "candidate.diff")
    File.write(path, bass_patch(File.basename(source)))
    path
  end

  def cli_proposal(directory, request_path, patch_path)
    stdout, stderr, status = run_cli(
      "protocol", "template", "proposal-response", request_path,
      "--producer", "cli-template", "--patch", patch_path,
      "--description", "Complete the scheduled span."
    )
    assert status.success?, stderr
    write_json(directory, "proposal-response.json", JSON.parse(stdout))
  end

  def cli_selection(directory, request_path)
    stdout, stderr, status = run_cli(
      "protocol", "template", "selection-response", request_path,
      "--producer", "cli-selector", "--select", "original",
      "--reason", "Retain the current score."
    )
    assert status.success?, stderr
    write_json(directory, "selection-response.json", JSON.parse(stdout))
  end

  def validate_protocol_cli(message_path, request_path)
    stdout, stderr, status = run_cli(
      "protocol", "validate", message_path, "--against", request_path
    )
    assert status.success?, stderr
    assert JSON.parse(stdout).fetch("binding_validated")
  end
end
