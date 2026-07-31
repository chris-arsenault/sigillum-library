# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "fileutils"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/composition_workflow_helper"

class CompositionWorkflowProtocolTest < Minitest::Test
  include CompositionWorkflowTestSupport
  Workflow = CompositionWorkflowTestSupport::Workflow

  def test_protocol_records_round_trip_and_keep_source_out_of_selection
    with_source do |source|
      records = protocol_records(source)
      round_trips = records.map do |record|
        record.class.from_h(JSON.parse(JSON.generate(record.to_h)))
      end

      assert_equal records.map(&:to_h), round_trips.map(&:to_h)
      assert round_trips.last.original_selected?
      refute records[2].to_h.dig(:assessments, 0, "candidate").key?("source_patch")
      assert_equal "partitura-candidate-executor",
                   records[2].to_h.dig(:assessments, 0, "critic_results", 0, "critic")
    end
  end

  def test_cli_exchanges_versioned_messages_and_records_step
    with_source do |source, directory|
      paths = cli_paths(directory)
      request = observe_request(source, paths.fetch(:trajectory))
      write_cli_proposal(source, paths.fetch(:proposal), request)
      selection_request = evaluate_request(source, paths)
      write_cli_selection(paths.fetch(:selection), selection_request)
      payload = run_cli_step(source, paths)

      assert_equal "keep_original", payload.dig("transition", "decision")
      stored = JSON.parse(File.read(paths.fetch(:trajectory)))
      assert_equal "keep_original", stored.fetch("decision")
      assert_equal(
        {
          "run_id" => "run:cli-agent",
          "origin" => "agent",
          "quality_label" => "medium"
        },
        stored.fetch("trajectory_context")
      )
    end
  end

  def test_selection_request_carries_ephemeral_candidate_observations
    with_source do |source|
      executor = Workflow::CandidateExecutor.new
      snapshot = executor.load_snapshot(source)
      request = proposal_request(source, snapshot)
      candidate = inline_candidate(request.action)
      execution = executor.execute(
        source_path: source,
        snapshot: snapshot,
        action: request.action,
        candidate: candidate,
        export: true
      )
      assessment = Workflow::Assessment.new(
        candidate: candidate,
        critic_results: [execution.mechanical_result(request.action)],
        candidate_snapshot: execution.after_snapshot.to_h,
        artifact_digests: execution.artifacts.to_h do |artifact|
          [artifact.kind, artifact.digest]
        end
      )

      selection = Workflow::SelectionRequest.create(
        proposal_request: request,
        assessments: [assessment],
        candidate_observations: {
          candidate.candidate_id => execution.score_observation
        }
      )
      round_trip = Workflow::SelectionRequest.from_h(
        JSON.parse(JSON.generate(selection.to_h))
      )

      assert_equal selection.to_h, round_trip.to_h
      assert_equal(
        execution.score_observation.fetch("observation_digest"),
        selection.candidate_observations
          .fetch(candidate.candidate_id)
          .fetch("observation_digest")
      )
      refute selection.assessments.first.key?("candidate_observation")
    end
  end

  private

  def protocol_records(source)
    executor = Workflow::CandidateExecutor.new
    snapshot = executor.load_snapshot(source)
    request = proposal_request(source, snapshot)
    candidate = inline_candidate(request.action)
    proposal = Workflow::ProposalResponse.create(
      request: request, producer: "test-proposer", candidates: [candidate]
    )
    assessment = mechanical_assessment(executor, source, snapshot, request, candidate)
    selection = Workflow::SelectionRequest.create(
      proposal_request: request, assessments: [assessment]
    )
    response = original_selection(selection)
    [request, proposal, selection, response]
  end

  def proposal_request(source, snapshot)
    Workflow::ProposalRequest.create(
      snapshot: snapshot,
      action: scheduled_action(snapshot),
      source_name: File.basename(source),
      source_digest: Workflow::Validation.source_digest(File.binread(source))
    )
  end

  def mechanical_assessment(executor, source, snapshot, request, candidate)
    execution = executor.execute(
      source_path: source, snapshot: snapshot, action: request.action,
      candidate: candidate, export: false
    )
    Workflow::Assessment.new(
      candidate: candidate,
      critic_results: [execution.mechanical_result(request.action)],
      candidate_snapshot: execution.after_snapshot.to_h
    )
  end

  def original_selection(request)
    Workflow::SelectionResponse.create(
      request: request,
      producer: "test-policy",
      selected_candidate_id: Workflow::Protocol::ORIGINAL_CANDIDATE_ID,
      reason: "The unchanged score remains an explicit candidate."
    )
  end

  def cli_paths(directory)
    {
      trajectory: File.join(directory, "trajectory.jsonl"),
      proposal: File.join(directory, "proposal.json"),
      selection: File.join(directory, "selection.json")
    }
  end

  def observe_request(source, trajectory)
    stdout, stderr, status = run_cli(
      "observe", source,
      "--trajectory", trajectory,
      "--trajectory-origin", "agent",
      "--run-id", "run:cli-agent",
      "--no-export"
    )
    assert status.success?, stderr
    Workflow::ProposalRequest.from_h(JSON.parse(stdout))
  end

  def write_cli_proposal(source, path, request)
    candidate = inline_candidate(
      request.action,
      patch: invalid_patch(File.basename(source)),
      description: "A candidate for CLI protocol coverage."
    )
    response = Workflow::ProposalResponse.create(
      request: request, producer: "cli-test-proposer", candidates: [candidate]
    )
    File.write(path, JSON.generate(response.to_h))
  end

  def evaluate_request(source, paths)
    stdout, stderr, status = run_cli(
      "evaluate", source,
      "--trajectory", paths.fetch(:trajectory),
      "--proposals", paths.fetch(:proposal),
      "--trajectory-origin", "agent",
      "--run-id", "run:cli-agent",
      "--no-export"
    )
    assert status.success?, stderr
    request = Workflow::SelectionRequest.from_h(JSON.parse(stdout))
    refute request.to_h.dig(:assessments, 0, "critic_results", 0, "passed")
    request
  end

  def write_cli_selection(path, request)
    response = Workflow::SelectionResponse.create(
      request: request,
      producer: "cli-test-policy",
      selected_candidate_id: Workflow::Protocol::ORIGINAL_CANDIDATE_ID,
      reason: "Reject the mechanically invalid CLI test candidate."
    )
    File.write(path, JSON.generate(response.to_h))
  end

  def run_cli_step(source, paths)
    stdout, stderr, status = run_cli(
      "step", source,
      "--trajectory", paths.fetch(:trajectory),
      "--proposals", paths.fetch(:proposal),
      "--selection", paths.fetch(:selection),
      "--trajectory-origin", "agent",
      "--run-id", "run:cli-agent",
      "--no-export"
    )
    assert status.success?, stderr
    JSON.parse(stdout)
  end
end
