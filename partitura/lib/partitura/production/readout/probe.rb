# frozen_string_literal: true

module Partitura
  module Production
    class Readout
      module Probe
        def bar_probe(bars: nil)
          events = @piece.timed_events.reject(&:rest?)
          bar_numbers(bars).each_with_object([]) do |bar, lines|
            append_bar_probe(lines, bar, events)
          end.join("\n")
        end

        private

        def bar_numbers(bars)
          bars ? bars.to_a : (1..last_bar_number).to_a
        end

        def append_bar_probe(lines, bar, events)
          bar_start = @piece.offset_for(bar, 1)
          bar_end = bar_start + @piece.bar_length_for(bar)
          lines << "--- #{@piece.title} bar #{bar} ---"
          @piece.parts.each_key do |part|
            segments = bar_probe_segments(events, part, bar_start, bar_end)
            lines << format("  %-14s %s", part, segments.join("  ")) unless segments.empty?
          end
        end

        def bar_probe_segments(events, part, bar_start, bar_end)
          active = events.select { |event| bar_probe_event?(event, part, bar_start, bar_end) }
          active.sort_by(&:offset).map do |event|
            "[#{bar_probe_range(event, bar_start, bar_end)}]#{event.pitch_label}"
          end
        end

        def bar_probe_event?(event, part, bar_start, bar_end)
          event.part == part && event.offset < bar_end && event.end_offset > bar_start
        end

        def bar_probe_range(event, bar_start, bar_end)
          start_offset = [event.offset, bar_start].max - bar_start
          end_offset = [event.end_offset, bar_end].min - bar_start
          "#{Production.format_duration(start_offset)}-#{Production.format_duration(end_offset)}"
        end
      end
    end
  end
end
