# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class Readout
        module DataViews
          def line(part, bars: nil)
            lines = ["# Line: #{part}"]
            @piece.timed_events(include_rests: true).each do |event|
              next unless event.part == part.to_sym
              next unless in_bars?(event.offset, bars)

              lines << Production.timed_event_line(@piece, event)
            end
            lines.join("\n")
          end

          def transport_metrics
            TransportMetrics.for_piece(@piece).render
          end

          def melody_analysis(part: nil, bars: nil)
            MelodyAnalysis.for_piece(@piece, part: part, bars: bars).render_analysis
          end

          def melody_report(part: nil, bars: nil)
            MelodyAnalysis.for_piece(@piece, part: part, bars: bars).render_report
          end
        end
      end
    end
  end
end
