# frozen_string_literal: true

require_relative "models"

module Partitura
  module Production
    module CompositionWorkflow
      class RefinementNeed
        attr_reader :need_id, :target_path, :lens, :operator, :reason, :priority,
                    :context_paths, :depends_on

        def initialize(need_id:, target_path:, lens:, operator:, reason:, priority: 0.0,
                       context_paths: [], depends_on: [])
          @need_id = Validation.text(need_id, "need_id")
          @target_path = Validation.path(target_path, "need target_path")
          @lens = Validation.enum(lens, LENSES, "need lens")
          @operator = Validation.enum(operator, OPERATORS, "need operator")
          @reason = Validation.text(reason, "need reason")
          @priority = Float(priority)
          @context_paths = paths(context_paths, "need context path")
          @depends_on = paths(depends_on, "need dependency")
          freeze
        rescue ArgumentError, TypeError
          raise Error.new("invalid_workflow_record", "need priority must be numeric")
        end

        private

        def paths(values, label)
          values.map { |path| Validation.path(path, label) }.freeze
        end
      end

      class Transition
        attr_reader :schema_version, :transition_id, :before_graph_digest,
                    :before_snapshot_digest, :before_snapshot, :source_name,
                    :before_source, :before_source_digest, :trajectory_context,
                    :action, :candidates, :decision,
                    :after_graph_digest, :after_snapshot_digest, :selected_candidate_id,
                    :unresolved_paths, :selection

        def initialize(schema_version:, transition_id:, before_graph_digest:, before_snapshot_digest:,
                       before_snapshot:, source_name:, before_source:, before_source_digest:,
                       trajectory_context:,
                       action:, candidates:, decision:, after_graph_digest:, after_snapshot_digest:,
                       selected_candidate_id: nil, unresolved_paths: [], selection: nil)
          @schema_version = Integer(schema_version)
          @transition_id = Validation.text(transition_id, "transition_id")
          @before_graph_digest = Validation.digest(before_graph_digest, "before graph digest")
          @before_snapshot_digest = Validation.digest(before_snapshot_digest, "before snapshot digest")
          @before_snapshot = immutable_snapshot(before_snapshot)
          @source_name = source_filename(source_name)
          @before_source = Validation.source_text(before_source, "before_source")
          @before_source_digest = Validation.digest(before_source_digest, "before source digest")
          @trajectory_context = trajectory_context
          @action = action
          @candidates = candidates.freeze
          @decision = Validation.enum(decision, DECISIONS, "transition decision")
          @after_graph_digest = Validation.digest(after_graph_digest, "after graph digest")
          @after_snapshot_digest = Validation.digest(after_snapshot_digest, "after snapshot digest")
          @selected_candidate_id = selected_candidate_id&.to_s
          @unresolved_paths = unresolved_paths.map { |path| Validation.path(path, "unresolved path") }.freeze
          @selection = immutable_selection(selection)
          validate_transition
          freeze
        end

        def self.create(before_snapshot:, source_name:, before_source:, trajectory_context:,
                        action:, candidates:, decision:, after_snapshot: nil,
                        selected_candidate_id: nil, unresolved_paths: [], selection: nil)
          after = after_snapshot || before_snapshot
          source_digest = Validation.source_digest(before_source)
          identity = transition_identity(
            before_snapshot, source_digest, trajectory_context, action, candidates,
            decision, selected_candidate_id, after
          )
          new(
            schema_version: TRAJECTORY_SCHEMA_VERSION,
            transition_id: transition_id(identity),
            before_graph_digest: before_snapshot.graph_digest,
            before_snapshot_digest: before_snapshot.snapshot_digest,
            before_snapshot: before_snapshot.to_h,
            source_name: source_name,
            before_source: before_source,
            before_source_digest: source_digest,
            trajectory_context: trajectory_context,
            action: action,
            candidates: candidates,
            decision: decision,
            selected_candidate_id: selected_candidate_id,
            after_graph_digest: after.graph_digest,
            after_snapshot_digest: after.snapshot_digest,
            unresolved_paths: unresolved_paths,
            selection: selection
          )
        end

        def self.from_h(value)
          data = value.transform_keys(&:to_sym)
          unless data[:schema_version] == TRAJECTORY_SCHEMA_VERSION
            raise Error.new(
              "unsupported_schema",
              "trajectory schema #{data[:schema_version].inspect} cannot supply replay evidence"
            )
          end
          new(
            schema_version: data.fetch(:schema_version),
            transition_id: data.fetch(:transition_id),
            before_graph_digest: data.fetch(:before_graph_digest),
            before_snapshot_digest: data.fetch(:before_snapshot_digest),
            before_snapshot: data.fetch(:before_snapshot),
            source_name: data.fetch(:source_name),
            before_source: data.fetch(:before_source),
            before_source_digest: data.fetch(:before_source_digest),
            trajectory_context: TrajectoryContext.from_h(data.fetch(:trajectory_context)),
            action: Action.from_h(data.fetch(:action)),
            candidates: data.fetch(:candidates).map { |item| Assessment.from_h(item) },
            decision: data.fetch(:decision),
            selected_candidate_id: data[:selected_candidate_id],
            after_graph_digest: data.fetch(:after_graph_digest),
            after_snapshot_digest: data.fetch(:after_snapshot_digest),
            unresolved_paths: data.fetch(:unresolved_paths, []),
            selection: data[:selection]
          )
        rescue KeyError => e
          raise Error.new("invalid_workflow_record", "transition lacks #{e.key}")
        end

        def to_h(include_source: true)
          {
            schema_version: schema_version,
            transition_id: transition_id,
            before_graph_digest: before_graph_digest,
            before_snapshot_digest: before_snapshot_digest,
            before_snapshot: include_source ? before_snapshot : nil,
            source_name: source_name,
            before_source: include_source ? before_source : nil,
            before_source_digest: before_source_digest,
            trajectory_context: trajectory_context.to_h,
            action: action.to_h,
            candidates: candidates.map { |item| item.to_h(include_source: include_source) },
            decision: decision,
            selected_candidate_id: selected_candidate_id,
            after_graph_digest: after_graph_digest,
            after_snapshot_digest: after_snapshot_digest,
            unresolved_paths: unresolved_paths.map(&:to_s),
            selection: selection
          }.compact
        end

        class << self
          private

          def transition_identity(before, source_digest, context, action, candidates,
                                  decision, selected, after)
            {
              run_id: context.run_id,
              before_snapshot_digest: before.snapshot_digest,
              before_source_digest: source_digest,
              action_id: action.action_id,
              candidate_ids: candidates.map { |item| item.candidate.candidate_id },
              decision: decision,
              selected_candidate_id: selected,
              after_snapshot_digest: after.snapshot_digest
            }
          end

          def transition_id(identity)
            digest = CompositionGraph::Canonical.digest(identity).split(":", 2).last
            "transition:#{digest[0, 20]}"
          end
        end

        private

        def immutable_selection(value)
          return unless value

          CompositionGraph::Canonical.immutable(CompositionGraph::Canonical.value(value))
        end

        def immutable_snapshot(value)
          snapshot = CompositionGraph::Canonical.value(value)
          unless snapshot.is_a?(Hash)
            raise Error.new("invalid_workflow_record", "before_snapshot must be an object")
          end

          CompositionGraph::Canonical.immutable(snapshot)
        end

        def source_filename(value)
          filename = Validation.text(value, "source_name")
          return filename if filename == File.basename(filename)

          raise Error.new("invalid_workflow_record", "source_name must be a filename")
        end

        def validate_transition
          validate_schema_and_action
          validate_source_evidence
          validate_candidates
          validate_decision
          return if decision == :accept || unchanged?

          raise Error.new("transition_mismatch", "#{decision} must preserve the before snapshot")
        end

        def validate_schema_and_action
          unless schema_version == TRAJECTORY_SCHEMA_VERSION
            raise Error.new("unsupported_schema", "trajectory schema version is unsupported")
          end
          unless before_snapshot.fetch("graph_digest", nil) == before_graph_digest &&
                 before_snapshot.fetch("snapshot_digest", nil) == before_snapshot_digest
            raise Error.new("transition_mismatch", "before snapshot evidence has mismatched digests")
          end
          return if action.base_graph_digest == before_graph_digest &&
                    action.base_snapshot_digest == before_snapshot_digest

          raise Error.new("transition_mismatch", "transition action does not match before snapshot")
        end

        def validate_source_evidence
          return if Validation.source_digest(before_source) == before_source_digest

          raise Error.new("transition_mismatch", "before source evidence has a mismatched digest")
        end

        def validate_candidates
          ids = candidates.map { |item| item.candidate.candidate_id }
          unless ids.uniq.length == ids.length
            raise Error.new("invalid_workflow_record", "candidate ids must be unique")
          end
          candidates.each { |item| item.candidate.validate_for(action) }
        end

        def validate_decision
          return validate_acceptance if decision == :accept
          if decision == :keep_original && candidates.empty?
            raise Error.new("invalid_workflow_record", "keep_original must record proposed candidates")
          end
          return unless selected_candidate_id

          raise Error.new("invalid_workflow_record", "#{decision} may not select a candidate")
        end

        def validate_acceptance
          selected = candidates.find { |item| item.candidate.candidate_id == selected_candidate_id }
          return if selected&.mechanically_valid? && after_snapshot_digest != before_snapshot_digest

          raise Error.new("invalid_acceptance", "acceptance requires a changed, mechanically valid candidate")
        end

        def unchanged?
          [after_graph_digest, after_snapshot_digest] ==
            [before_graph_digest, before_snapshot_digest]
        end
      end

      class State
        attr_reader :snapshot, :trajectory, :refinement_needs

        def initialize(snapshot:, trajectory: [], refinement_needs: [])
          @snapshot = snapshot
          @trajectory = trajectory.freeze
          @refinement_needs = refinement_needs.freeze
          validate_state
          freeze
        end

        def need_closed?(need_id)
          trajectory.any? do |transition|
            transition.action.need_id == need_id &&
              %i[accept keep_original].include?(transition.decision)
          end
        end

        def with_transition(transition, after_snapshot: nil)
          validate_before(transition)
          next_snapshot = transition.decision == :accept ? after_snapshot : snapshot
          validate_after(transition, next_snapshot)
          State.new(
            snapshot: next_snapshot,
            trajectory: trajectory + [transition],
            refinement_needs: refinement_needs
          )
        end

        private

        def validate_before(transition)
          return if [transition.before_graph_digest, transition.before_snapshot_digest] ==
                    [snapshot.graph_digest, snapshot.snapshot_digest]

          raise Error.new("transition_mismatch", "new transition does not begin at current state")
        end

        def validate_after(transition, next_snapshot)
          return if next_snapshot &&
                    [transition.after_graph_digest, transition.after_snapshot_digest] ==
                    [next_snapshot.graph_digest, next_snapshot.snapshot_digest]

          raise Error.new("transition_mismatch", "transition after snapshot does not match state")
        end

        def validate_state
          validate_unique_ids
          validate_continuity
          validate_needs
        rescue ArgumentError => e
          raise Error.new("invalid_workflow_record", e.message)
        end

        def validate_unique_ids
          ids = trajectory.map(&:transition_id)
          unless ids.uniq.length == ids.length
            raise Error.new("invalid_workflow_record", "trajectory ids must be unique")
          end
          needs = refinement_needs.map(&:need_id)
          return if needs.uniq.length == needs.length

          raise Error.new("invalid_workflow_record", "need ids must be unique")
        end

        def validate_continuity
          trajectory.each_cons(2) do |before, after|
            next if [before.after_graph_digest, before.after_snapshot_digest] ==
                    [after.before_graph_digest, after.before_snapshot_digest]

            raise Error.new("trajectory_not_contiguous", "workflow trajectory is not contiguous")
          end
          return if trajectory.empty? || trajectory_tail_matches?

          raise Error.new("trajectory_not_contiguous", "state snapshot does not match trajectory tail")
        end

        def trajectory_tail_matches?
          [trajectory.last.after_graph_digest, trajectory.last.after_snapshot_digest] ==
            [snapshot.graph_digest, snapshot.snapshot_digest]
        end

        def validate_needs
          refinement_needs.each do |need|
            snapshot.graph.require_stable(need.target_path)
            (need.context_paths + need.depends_on).each do |path|
              snapshot.graph.require_stable(path)
            end
          end
        end
      end

      class ScheduleResult
        attr_reader :action, :done, :blocked_reasons

        def initialize(action: nil, done: false, blocked_reasons: [])
          @action = action
          @done = done
          @blocked_reasons = blocked_reasons.freeze
          count = [!action.nil?, done, !blocked_reasons.empty?].count(true)
          unless count == 1
            raise Error.new("invalid_schedule", "schedule result must have exactly one outcome")
          end

          freeze
        end
      end
    end
  end
end
