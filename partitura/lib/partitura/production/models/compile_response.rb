# frozen_string_literal: true

module Partitura
  module Production
    module CompileResponse
      def compile_response
        validate!
        lints = Lint.run(self)
        return lint_error_response(lints) if lints.any? { |lint| lint[:level] == "error" }

        {
          status: "ok",
          source_model: "production_hybrid",
          surface_summary: phrases.values.map(&:surface).uniq.map(&:to_s),
          lints: lints,
          available_projections: available_projection_names,
          secondary_declared_intent_projections: secondary_projection_names,
          projection_note: "available_projections are SOUNDING (note-derived) and primary; " \
                           "secondary views read authored assertions and only verify them against the music",
          available_exports: %w[transport_json musicxml midi],
          next_help_topics: %w[projections hybrid controls transport_export],
          docs: ["docs/architecture/partitura/INDEX.md"]
        }
      rescue CompileError => e
        e.response.merge(
          error_scope: "first blocking error only - fix it and recompile to surface any further errors"
        )
      end

      private

      def lint_error_response(lints)
        errors = lints.select { |lint| lint[:level] == "error" }
        {
          status: "error",
          code: "lint_error",
          message: "#{errors.length} lint rule(s) at error level: " \
                   "#{errors.map { |lint| "#{lint[:rule]}(#{lint[:phrase]})" }.uniq.join(', ')}.",
          repair_instruction: "Fix the error-level lints (see lints); thresholds are configurable per piece " \
                              "with a `lint do rule :name, warn: N, error: N end` block.",
          help_topic: "production",
          docs: ["docs/architecture/partitura/01_container.md"],
          lints: lints
        }
      end

      def available_projection_names
        %w[
          adjacency_profile recurrence_map peak_axes rhythm_profile articulation_map
          breath_map implied_harmony harmony_check ensemble_grid exposed_clashes composite_stalls
          bar_profile figure_timeline range_check bar_probe line verticals grid timed_events controls
          lint transport transport_metrics melody_analysis melody_report
        ]
      end

      def secondary_projection_names
        %w[
          structure roles phrases placements staff_bars foreground bass_path
          harmony harmony_with_melody material_map gesture_map
        ]
      end
    end
  end
end
