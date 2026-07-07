# frozen_string_literal: true

require_relative "model"
require_relative "projections/helpers"
require_relative "projections/views"

module Sigillum
  module OrchestralDSL
    class Projections
      include ProjectionHelpers
      include ProjectionViews

      RENDERERS = {
        summary: ->(projections, **) { projections.summary },
        roles: ->(projections, bars:, **) { projections.roles(bars: bars) },
        foreground: ->(projections, bars:, **) { projections.foreground(bars: bars) },
        verticals: ->(projections, bars:, **) { projections.verticals(bars: bars) },
        bass_path: ->(projections, bars:, **) { projections.bass_path(bars: bars) },
        material_map: ->(projections, **) { projections.material_map },
        gesture_map: ->(projections, **) { projections.gesture_map },
        line: ->(projections, part:, bars:) { projections.render_line_view(part, bars: bars) },
        all: ->(projections, bars:, **) { projections.render_all(bars: bars) }
      }.freeze

      def initialize(piece)
        @piece = piece
      end

      def render(name, part: nil, bars: nil)
        renderer = RENDERERS[name.to_sym]
        raise ArgumentError, "unknown projection #{name.inspect}" unless renderer

        renderer.call(self, part: part, bars: bars)
      end

      def render_line_view(part, bars:)
        raise ArgumentError, "line projection requires part:" unless part

        line(part, bars: bars)
      end

      def render_all(bars: nil)
        [
          summary,
          roles(bars: bars),
          foreground(bars: bars),
          bass_path(bars: bars),
          material_map,
          gesture_map
        ].join("\n\n")
      end
    end
  end
end
