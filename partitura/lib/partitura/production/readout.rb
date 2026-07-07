# frozen_string_literal: true

require_relative "readout/data_views"
require_relative "readout/declared_views"
require_relative "readout/grid"
require_relative "readout/helpers"
require_relative "readout/probe"

module Partitura
  module Production
    class Readout
      include SoundingReadout
      include Helpers
      include DeclaredViews
      include DataViews
      include Grid
      include Probe

      SECONDARY_VIEWS = %i[structure roles phrases placements staff_bars foreground
                           bass_path harmony harmony_with_melody material_map gesture_map].freeze
      SECONDARY_BANNER = "# [secondary/declared-intent view: reads authored assertions, not the sounding result. " \
                         "Prefer sounding projections: adjacency_profile recurrence_map peak_axes rhythm_profile " \
                         "articulation_map breath_map implied_harmony ensemble_grid exposed_clashes " \
                         "composite_stalls verticals line grid]"

      DECLARED_RENDERERS = {
        structure: ->(readout, **) { readout.structure },
        roles: ->(readout, bars:, **) { readout.roles(bars: bars) },
        phrases: ->(readout, **) { readout.phrases },
        placements: ->(readout, **) { readout.placements },
        timed_events: ->(readout, bars:, **) { readout.timed_events(bars: bars) },
        verticals: ->(readout, bars:, **) { readout.verticals(bars: bars) },
        staff_bars: ->(readout, bars:, **) { readout.staff_bars(bars: bars) },
        foreground: ->(readout, bars:, **) { readout.foreground(bars: bars) },
        bass_path: ->(readout, bars:, **) { readout.bass_path(bars: bars) },
        harmony: ->(readout, bars:, **) { readout.harmony(bars: bars) },
        harmony_with_melody: ->(readout, bars:, **) { readout.harmony_with_melody(bars: bars) },
        material_map: ->(readout, **) { readout.material_map },
        gesture_map: ->(readout, **) { readout.gesture_map }
      }.freeze

      DATA_RENDERERS = {
        line: ->(readout, bars:, part:) { readout.render_line_view(part, bars: bars) },
        grid: ->(readout, bars:, **) { readout.grid(bars: bars) },
        bar_probe: ->(readout, bars:, **) { readout.bar_probe(bars: bars) },
        probe: ->(readout, bars:, **) { readout.bar_probe(bars: bars) },
        controls: ->(readout, **) { readout.controls },
        transport: ->(readout, **) { JSON.pretty_generate(Production.transport_hash(readout.piece)) },
        transport_metrics: ->(readout, **) { readout.transport_metrics },
        card_metrics: ->(readout, **) { readout.transport_metrics },
        melody_analysis: ->(readout, bars:, part:) { readout.melody_analysis(part: part, bars: bars) },
        analyze_score: ->(readout, bars:, part:) { readout.melody_analysis(part: part, bars: bars) },
        melody_report: ->(readout, bars:, part:) { readout.melody_report(part: part, bars: bars) },
        compile: ->(readout, **) { JSON.pretty_generate(readout.piece.compile_response) }
      }.freeze

      SOUNDING_RENDERERS = {
        adjacency_profile: ->(readout, bars:, part:) { readout.adjacency_profile(part: part, bars: bars) },
        recurrence_map: ->(readout, bars:, part:) { readout.recurrence_map_sounding(part: part, bars: bars) },
        peak_axes: ->(readout, bars:, **) { readout.peak_axes(bars: bars) },
        rhythm_profile: ->(readout, bars:, part:) { readout.rhythm_profile(part: part, bars: bars) },
        articulation_map: ->(readout, bars:, part:) { readout.articulation_map(part: part, bars: bars) },
        breath_map: ->(readout, bars:, part:) { readout.breath_map(part: part, bars: bars) },
        implied_harmony: ->(readout, bars:, **) { readout.implied_harmony(bars: bars) },
        ensemble_grid: ->(readout, bars:, **) { readout.ensemble_grid(bars: bars) },
        exposed_clashes: ->(readout, bars:, **) { readout.exposed_clashes(bars: bars) },
        composite_stalls: ->(readout, bars:, **) { readout.composite_stalls(bars: bars) },
        bar_profile: ->(readout, bars:, part:) { readout.bar_profile(part: part, bars: bars) },
        figure_timeline: ->(readout, bars:, part:) { readout.figure_timeline(part: part, bars: bars) }
      }.freeze

      attr_reader :piece

      def initialize(piece)
        @piece = piece
      end

      def render(view, part: nil, bars: nil)
        bars = Production.parse_bar_range(bars) if bars.is_a?(String)
        body = render_view(view, part: part, bars: bars)
        return "#{SECONDARY_BANNER}\n#{body}" if SECONDARY_VIEWS.include?(view.to_sym)

        body
      end

      def render_view(view, part: nil, bars: nil)
        key = view.to_sym
        renderer = DECLARED_RENDERERS[key] || DATA_RENDERERS[key] || SOUNDING_RENDERERS[key]
        raise ArgumentError, "unknown production view #{view.inspect}" unless renderer

        renderer.call(self, part: part, bars: bars)
      end

      def render_line_view(part, bars:)
        raise ArgumentError, "production line view requires part:" unless part

        line(part, bars: bars)
      end
    end
  end
end
