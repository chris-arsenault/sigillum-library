# frozen_string_literal: true

module Partitura
  module Production
    module CompileResponse
      def compile_response
        validate!
        {
          status: "ok",
          source_model: "production_hybrid",
          surface_summary: phrases.values.map(&:surface).uniq.map(&:to_s),
          available_projections: available_projection_names,
          secondary_declared_intent_projections: secondary_projection_names,
          projection_note: "available_projections are SOUNDING (note-derived) and primary; " \
                           "secondary views read authored assertions and only verify them against the music",
          available_exports: %w[transport_json musicxml midi],
          next_help_topics: %w[projections hybrid controls transport_export],
          docs: ["docs/architecture/partitura/INDEX.md"]
        }
      rescue CompileError => e
        e.response
      end

      private

      def available_projection_names
        %w[
          adjacency_profile recurrence_map peak_axes rhythm_profile articulation_map
          breath_map implied_harmony ensemble_grid exposed_clashes composite_stalls
          bar_profile figure_timeline bar_probe line verticals grid timed_events controls
          transport transport_metrics melody_analysis melody_report
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
