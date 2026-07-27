# frozen_string_literal: true

require_relative "state_models"

module Partitura
  module Production
    module CompositionWorkflow
      class DeterministicScheduler
        PERIODIC_REVIEWS = [
          %i[seam interleave_seam],
          %i[pacing review],
          %i[return_identity transform_return],
          %i[orchestration review]
        ].freeze

        FINAL_REVIEWS = [
          [:final_seams, :global_review, :seam, :interleave_seam,
           "Read every boundary with its neighboring material and compose or reject seam changes."],
          [:final_form, :global_review, :form, :review,
           "Judge the whole-score journey, destination, pacing, and material identity."],
          [:final_verticals, :global_review, :harmony, :revise_verticals,
           "Read verticals and single-voice continuity across the complete score."],
          [:final_orchestration, :global_review, :orchestration, :review,
           "Judge role clarity, register, reserve, idiom, and orchestral accumulation."],
          [:final_audition, :export_review, :audition, :audition,
           "Judge an exported result and compare proposed changes with the original."]
        ].freeze

        FACET_PRIORITY = {
          material: 0, harmony: 1, "role:foreground": 2, "role:bass_line": 3,
          texture: 4, part: 5, role: 6, control: 7, checkpoint: 8
        }.freeze

        def initialize(global_review_interval: 3)
          @global_review_interval = Validation.positive_integer(
            global_review_interval, "global review interval"
          )
        end

        def next_action(state)
          need_action, need_blockers = next_need(state)
          return ScheduleResult.new(action: need_action) if need_action

          periodic = periodic_review(state)
          return ScheduleResult.new(action: periodic) if periodic

          unresolved = state.snapshot.graph.requirements.select do |requirement|
            %i[open partial].include?(requirement.state)
          end
          requirement_action, requirement_blockers = next_requirement(state, unresolved)
          return ScheduleResult.new(action: requirement_action) if requirement_action

          pending_needs = state.refinement_needs.reject { |need| state.need_closed?(need.need_id) }
          if unresolved.any? || pending_needs.any?
            reasons = (need_blockers + requirement_blockers).uniq.sort
            reasons = ["unresolved composition work has no schedulable stable target"] if reasons.empty?
            return ScheduleResult.new(blocked_reasons: reasons)
          end

          final = next_final_review(state)
          return ScheduleResult.new(action: final) if final

          ScheduleResult.new(done: true)
        end

        private

        def next_need(state)
          ready, blockers = ready_needs(state)
          return [nil, blockers] if ready.empty?

          need = ready.sort_by { |item| [-item.priority, item.need_id] }.first
          [need_action(state, need), blockers]
        end

        def ready_needs(state)
          pending = state.refinement_needs.reject { |need| state.need_closed?(need.need_id) }
          blockers = []
          ready = pending.reject do |need|
            dependencies = (
              need.depends_on + state.snapshot.graph.dependencies_for(need.target_path)
            ).uniq.sort_by(&:to_s)
            blocked = unready_dependencies(state.snapshot.graph, dependencies)
            blockers << "need #{need.need_id} waits for #{blocked.map(&:to_s).join(', ')}" if blocked.any?
            blocked.any?
          end
          [ready, blockers]
        end

        def need_action(state, need)
          context = (
            need.context_paths + need.depends_on +
            state.snapshot.graph.dependencies_for(need.target_path)
          ).uniq
          Action.create(
            snapshot: state.snapshot,
            kind: :refine,
            target_path: need.target_path,
            lens: need.lens,
            operator: need.operator,
            reason: need.reason,
            attempt: attempt_for(state, :need_id, need.need_id),
            context_paths: context,
            need_id: need.need_id
          )
        end

        def next_requirement(state, unresolved)
          graph = state.snapshot.graph
          ready, blockers = ready_requirements(graph, unresolved)
          return [nil, blockers] if ready.empty?

          requirement = ready.sort_by { |item| requirement_sort_key(item) }.first
          [requirement_action(state, requirement), blockers]
        end

        def ready_requirements(graph, unresolved)
          blockers = []
          ready = unresolved.reject do |requirement|
            node = graph.node(requirement.owner)
            unless node&.stable
              blockers << "requirement #{requirement.key} targets an unstable or missing graph path"
              next true
            end
            blocked = unready_dependencies(graph, graph.dependencies_for(requirement.owner))
            if blocked.any?
              blockers << "requirement #{requirement.key} waits for #{blocked.map(&:to_s).join(', ')}"
            end
            blocked.any?
          end
          [ready, blockers]
        end

        def requirement_action(state, requirement)
          graph = state.snapshot.graph
          lens, operator = requirement_policy(requirement)
          dependencies = graph.dependencies_for(requirement.owner)
          Action.create(
            snapshot: state.snapshot,
            kind: :bind_requirement,
            target_path: requirement.owner,
            lens: lens,
            operator: operator,
            reason: requirement_reason(requirement),
            attempt: attempt_for(state, :requirement_key, requirement.key),
            context_paths: (dependencies + stable_bindings(graph, requirement)).uniq,
            requirement_key: requirement.key
          )
        end

        def stable_bindings(graph, requirement)
          requirement.bindings.select { |path| graph.node(path)&.stable }
        end

        def requirement_reason(requirement)
          selector = requirement.selector ? " #{requirement.selector}" : ""
          relation = requirement.relation ? " as #{requirement.relation}" : ""
          "#{requirement.state} #{requirement.facet}#{selector}#{relation} requirement " \
            "at #{requirement.owner}; bind it with explicit Partitura source material."
        end

        def periodic_review(state)
          since_review = 0
          periodic_count = 0
          state.trajectory.each do |transition|
            if transition.action.kind == :global_review &&
               transition.action.review_key&.start_with?("periodic:") &&
               closed?(transition)
              since_review = 0
              periodic_count += 1
            elsif transition.decision == :accept
              since_review += 1
            end
          end
          return if since_review < @global_review_interval

          lens, operator = PERIODIC_REVIEWS.fetch(periodic_count % PERIODIC_REVIEWS.length)
          key = format("periodic:%03d:%s", periodic_count + 1, lens)
          Action.create(
            snapshot: state.snapshot,
            kind: :global_review,
            target_path: state.snapshot.graph.piece_path,
            lens: lens,
            operator: operator,
            reason: "Periodic #{lens} review after #{since_review} accepted refinements; " \
                    "compare every proposal with keeping the current score.",
            review_key: key
          )
        end

        def next_final_review(state)
          closed = state.trajectory.filter_map do |transition|
            transition.action.review_key if transition.action.review_key && closed?(transition)
          end
          review = FINAL_REVIEWS.find { |key, *_rest| !closed.include?(key.to_s.tr("_", ":")) }
          return unless review

          key, kind, lens, operator, reason = review
          Action.create(
            snapshot: state.snapshot,
            kind: kind,
            target_path: state.snapshot.graph.piece_path,
            lens: lens,
            operator: operator,
            reason: reason,
            review_key: key.to_s.tr("_", ":")
          )
        end

        def attempt_for(state, field, value)
          state.trajectory.count do |transition|
            selected = field == :need_id ? transition.action.need_id : transition.action.requirement_key
            selected == value
          end + 1
        end

        def requirement_sort_key(requirement)
          state_priority = requirement.state == :partial ? 0 : 1
          facet = if requirement.facet == :role &&
                     %i[foreground bass_line].include?(requirement.selector)
                    "role:#{requirement.selector}".to_sym
                  else
                    requirement.facet
                  end
          [state_priority, FACET_PRIORITY.fetch(facet, 99), requirement.owner.to_s, requirement.key]
        end

        def requirement_policy(requirement)
          case requirement.facet
          when :material
            return %i[return_identity transform_return] if %i[return variation fragment].include?(requirement.relation)

            %i[primary_material establish_material]
          when :harmony then %i[harmony realize_harmony]
          when :role
            return %i[primary_material realize_span] if requirement.selector == :foreground
            return %i[voice_leading realize_span] if requirement.selector == :bass_line

            %i[role_texture realize_span]
          when :part, :texture then %i[orchestration realize_span]
          when :control then %i[detail detail]
          else %i[mechanical review]
          end
        end

        def unready_dependencies(graph, dependencies)
          dependencies.select do |dependency|
            unresolved = graph.requirements_at(
              dependency, states: %i[open partial], include_descendants: true
            )
            unrealized_material = dependency.type == :material &&
                                  graph.relations(kind: :realizes).none? do |relation|
                                    relation.to == dependency
                                  end
            unresolved.any? || unrealized_material
          end
        end

        def closed?(transition)
          %i[accept keep_original].include?(transition.decision)
        end
      end
    end
  end
end
