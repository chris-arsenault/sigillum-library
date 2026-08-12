# frozen_string_literal: true

require_relative "executor"
require_relative "promoter"
require_relative "protocol"
require_relative "scheduler"
require_relative "store"

module Partitura
  module Production
    module CompositionWorkflow
      class Evaluation
        attr_reader :proposal_request, :proposal_response, :executions,
                    :assessments, :selection_request

        def initialize(proposal_request:, proposal_response:, executions: [],
                       assessments: [], selection_request: nil)
          @proposal_request = proposal_request
          @proposal_response = proposal_response
          @executions = executions.freeze
          @assessments = assessments.freeze
          @selection_request = selection_request
          if assessments.empty? != selection_request.nil?
            raise Error.new("invalid_evaluation", "selection request must match evaluated candidates")
          end
          freeze
        end
      end

      class LoopStep
        attr_reader :state, :schedule, :proposal_request, :evaluation,
                    :selection_response, :transition

        def initialize(state:, schedule:, proposal_request: nil, evaluation: nil,
                       selection_response: nil, transition: nil)
          @state = state
          @schedule = schedule
          @proposal_request = proposal_request
          @evaluation = evaluation
          @selection_response = selection_response
          @transition = transition
          freeze
        end

        def to_h
          {
            status: schedule.done ? "done" : (schedule.blocked_reasons.empty? ? "advanced" : "blocked"),
            blocked_reasons: schedule.blocked_reasons,
            proposal_request: proposal_request&.to_h,
            selection_request: evaluation&.selection_request&.to_h,
            selection_response: selection_response&.to_h,
            transition: transition&.to_h(include_source: false),
            graph_digest: state.snapshot.graph_digest,
            snapshot_digest: state.snapshot.snapshot_digest
          }.compact
        end
      end

      class LoopRun
        attr_reader :state, :status, :steps, :blocked_reasons

        def initialize(state:, status:, steps:, blocked_reasons: [])
          @state = state
          @status = status.to_sym
          @steps = steps.freeze
          @blocked_reasons = blocked_reasons.freeze
          freeze
        end
      end

      class CompositionLoop
        def initialize(executor: CandidateExecutor.new, promoter: nil,
                       scheduler: DeterministicScheduler.new, trajectory_store: nil,
                       trajectory_context: nil, export_candidates: true)
          @executor = executor
          @promoter = promoter || CandidatePromoter.new(executor: executor)
          @scheduler = scheduler
          @trajectory_store = trajectory_store
          @trajectory_context = trajectory_context || trajectory_store&.context ||
                                TrajectoryContext.new(
                                  run_id: "run:unpersisted",
                                  origin: :deterministic,
                                  quality_label: :unrated
                                )
          @export_candidates = export_candidates
        end

        def load_state(source_path:, refinement_needs: [])
          snapshot = @executor.load_snapshot(source_path)
          trajectory = @trajectory_store ? @trajectory_store.load : []
          @trajectory_context = @trajectory_store.context if @trajectory_store
          State.new(
            snapshot: snapshot,
            trajectory: trajectory,
            refinement_needs: refinement_needs
          )
        end

        def observe(state, source_path:)
          schedule = @scheduler.next_action(state)
          return LoopStep.new(state: state, schedule: schedule) unless schedule.action

          source = File.expand_path(source_path)
          request = ProposalRequest.create(
            snapshot: state.snapshot,
            action: schedule.action,
            source_name: File.basename(source),
            source_digest: Validation.source_digest(File.binread(source))
          )
          LoopStep.new(state: state, schedule: schedule, proposal_request: request)
        end

        def evaluate(state, source_path:, proposal_request:, proposal_response:)
          validate_live_request(state, source_path, proposal_request)
          proposal_response.validate_for(proposal_request)
          executions = execute_candidates(
            state, source_path, proposal_request, proposal_response
          )
          assessments = assess_candidates(
            executions, proposal_response.candidates, proposal_request.action
          )
          Evaluation.new(
            proposal_request: proposal_request,
            proposal_response: proposal_response,
            executions: executions,
            assessments: assessments,
            selection_request: selection_request(
              proposal_request, assessments, executions
            )
          )
        end

        def commit(state, source_path:, evaluation:, selection_response: nil)
          if evaluation.assessments.empty?
            return commit_deferred(state, source_path, evaluation, selection_response)
          end

          raise Error.new(
            "missing_selection", "evaluated candidates require a selection response"
          ) unless selection_response
          selection_response.validate_for(evaluation.selection_request)
          assessments = merge_external_results(
            evaluation.assessments, selection_response.critic_results
          )
          if selection_response.original_selected?
            return commit_original(
              state, source_path, evaluation, assessments, selection_response
            )
          end

          commit_accepting(
            state, source_path, evaluation, assessments, selection_response
          )
        end

        def advance(state, source_path:, provider:)
          observation = observe(state, source_path: source_path)
          return observation unless observation.proposal_request

          proposal = provider.propose(observation.proposal_request)
          evaluation = evaluate(
            state,
            source_path: source_path,
            proposal_request: observation.proposal_request,
            proposal_response: proposal
          )
          selection = evaluation.selection_request && provider.select(evaluation.selection_request)
          commit(
            state,
            source_path: source_path,
            evaluation: evaluation,
            selection_response: selection
          )
        end

        def run(state, source_path:, provider:, max_steps:)
          limit = Validation.positive_integer(max_steps, "max_steps")
          steps = []
          limit.times do
            step = advance(state, source_path: source_path, provider: provider)
            steps << step
            state = step.state
            return LoopRun.new(state: state, status: :done, steps: steps) if step.schedule.done
            unless step.schedule.blocked_reasons.empty?
              return LoopRun.new(
                state: state,
                status: :blocked,
                steps: steps,
                blocked_reasons: step.schedule.blocked_reasons
              )
            end
          end
          LoopRun.new(state: state, status: :step_limit, steps: steps)
        end

        private

        def execute_candidates(state, source_path, request, response)
          response.candidates.map do |candidate|
            @executor.execute(
              source_path: source_path,
              snapshot: state.snapshot,
              action: request.action,
              candidate: candidate,
              export: @export_candidates
            )
          end
        end

        def assess_candidates(executions, candidates, action)
          executions.zip(candidates).map do |execution, candidate|
            Assessment.new(
              candidate: candidate,
              critic_results: [execution.mechanical_result(action)],
              candidate_snapshot: execution.after_snapshot&.to_h,
              artifact_digests: execution.artifacts.to_h do |artifact|
                [artifact.kind, artifact.digest]
              end
            )
          end
        end

        def selection_request(proposal_request, assessments, executions)
          return if assessments.empty?

          SelectionRequest.create(
            proposal_request: proposal_request,
            assessments: assessments,
            candidate_observations: executions.filter_map do |execution|
              if execution.score_observation
                [execution.candidate_id, execution.score_observation]
              end
            end.to_h
          )
        end

        def commit_deferred(state, source_path, evaluation, selection_response)
          unless selection_response.nil?
            raise Error.new("invalid_selection", "an empty proposal set has no selection request")
          end
          source_name, before_source = transition_source(source_path, evaluation)
          transition = Transition.create(
            before_snapshot: state.snapshot,
            source_name: source_name,
            before_source: before_source,
            trajectory_context: @trajectory_context,
            action: evaluation.proposal_request.action,
            candidates: [],
            decision: :defer,
            unresolved_paths: unresolved_paths(state)
          )
          commit_nonaccepting(state, transition, evaluation: evaluation)
        end

        def commit_original(state, source_path, evaluation, assessments, response)
          source_name, before_source = transition_source(source_path, evaluation)
          transition = Transition.create(
            before_snapshot: state.snapshot,
            source_name: source_name,
            before_source: before_source,
            trajectory_context: @trajectory_context,
            action: evaluation.proposal_request.action,
            candidates: assessments,
            decision: :keep_original,
            unresolved_paths: unresolved_paths(state),
            selection: selection_record(response)
          )
          commit_nonaccepting(
            state, transition, evaluation: evaluation, selection_response: response
          )
        end

        def commit_accepting(state, source_path, evaluation, assessments, response)
          assessment, execution = selected_pair(assessments, evaluation.executions, response)
          validate_selected_execution(assessment, execution)
          source_name, before_source = transition_source(source_path, evaluation)
          next_state = nil
          transition = nil
          @promoter.promote(
            source_path: source_path,
            before_snapshot: state.snapshot,
            action: evaluation.proposal_request.action,
            candidate: assessment.candidate,
            execution: execution
          ) do |promoted|
            transition = accepted_transition(
              state, evaluation, assessments, assessment, response, promoted,
              source_name, before_source
            )
            next_state = state.with_transition(transition, after_snapshot: promoted)
            @trajectory_store&.append(transition)
          end
          workflow_step(next_state, evaluation, response, transition)
        end

        def selected_pair(assessments, executions, response)
          index = assessments.index do |assessment|
            assessment.candidate.candidate_id == response.selected_candidate_id
          end
          raise Error.new("invalid_selection", "selected candidate is absent") unless index

          [assessments.fetch(index), executions.fetch(index)]
        end

        def validate_selected_execution(assessment, execution)
          unless assessment.mechanically_valid?
            raise Error.new("invalid_selection", "cannot promote a mechanically invalid candidate")
          end
          return if execution.score_changed?

          raise Error.new("invalid_selection", "cannot promote a candidate that leaves the score unchanged")
        end

        def accepted_transition(state, evaluation, assessments, assessment, response, promoted,
                                source_name, before_source)
          Transition.create(
            before_snapshot: state.snapshot,
            source_name: source_name,
            before_source: before_source,
            trajectory_context: @trajectory_context,
            action: evaluation.proposal_request.action,
            candidates: assessments,
            decision: :accept,
            after_snapshot: promoted,
            selected_candidate_id: assessment.candidate.candidate_id,
            unresolved_paths: unresolved_paths_for(promoted),
            selection: selection_record(response)
          )
        end

        def selection_record(response)
          {
            request_id: response.request_id,
            producer: response.producer,
            selected_candidate_id: response.selected_candidate_id,
            reason: response.reason
          }
        end

        def validate_live_request(state, source_path, request)
          unless [request.action.base_graph_digest, request.action.base_snapshot_digest] ==
                 [state.snapshot.graph_digest, state.snapshot.snapshot_digest]
            raise Error.new("protocol_mismatch", "proposal request is stale for workflow state")
          end
          source_digest = Validation.source_digest(File.binread(File.expand_path(source_path)))
          unless request.source_digest == source_digest
            raise Error.new("protocol_mismatch", "proposal request is stale for source bytes")
          end
        end

        def transition_source(source_path, evaluation)
          source = File.expand_path(source_path)
          content = File.binread(source)
          digest = Validation.source_digest(content)
          unless digest == evaluation.proposal_request.source_digest
            raise Error.new("protocol_mismatch", "accepted source changed after evaluation")
          end

          [File.basename(source), content]
        end

        def merge_external_results(assessments, external_results)
          grouped = external_results.group_by(&:candidate_id)
          assessments.map do |assessment|
            Assessment.new(
              candidate: assessment.candidate,
              critic_results: assessment.critic_results + grouped.fetch(
                assessment.candidate.candidate_id, []
              ),
              candidate_snapshot: assessment.candidate_snapshot,
              artifact_digests: assessment.artifact_digests
            )
          end
        end

        def commit_nonaccepting(state, transition, evaluation:, selection_response: nil)
          next_state = state.with_transition(transition)
          @trajectory_store&.append(transition)
          workflow_step(next_state, evaluation, selection_response, transition)
        end

        def workflow_step(state, evaluation, selection_response, transition)
          LoopStep.new(
            state: state,
            schedule: ScheduleResult.new(action: transition.action),
            proposal_request: evaluation.proposal_request,
            evaluation: evaluation,
            selection_response: selection_response,
            transition: transition
          )
        end

        def unresolved_paths(state)
          unresolved_paths_for(state.snapshot)
        end

        def unresolved_paths_for(snapshot)
          snapshot.graph.requirements.filter_map do |requirement|
            requirement.owner if %i[open partial].include?(requirement.state)
          end.uniq.sort_by(&:to_s)
        end
      end
    end
  end
end
