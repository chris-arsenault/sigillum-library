# frozen_string_literal: true

module Partitura
  module Production
    # Turns placements into the piece's timed-event stream. Anacrusis events win
    # over earlier same-part sounding material in their pickup window: overlapped
    # notes are clipped (a lint warns) and overlapped rests vanish silently.
    module EventResolution
      def timed_events(include_rests: false)
        resolve_anacrusis_overwrites(timed_events_unresolved(include_rests: include_rests))
          .sort_by { |event| [event.offset, event.part.to_s, event.pitch.to_s] }
      end

      def timed_events_unresolved(include_rests: false)
        phrase_map = phrases
        placements.flat_map do |placement|
          timed_events_for_placement(placement, phrase_map, include_rests: include_rests)
        end.sort_by { |event| [event.offset, event.part.to_s, event.pitch.to_s] }
      end

      def resolve_anacrusis_overwrites(events)
        regions_by_part = anacrusis_sounding_regions(events)
        events.flat_map do |event|
          next [event] if event.anacrusis? || regions_by_part[event.part].nil?

          subtract_regions(event, regions_by_part.fetch(event.part))
        end
      end

      def anacrusis_sounding_regions(events)
        events.reject(&:rest?).select(&:anacrusis?).group_by(&:part).transform_values do |part_events|
          part_events.map { |event| [event.offset, event.end_offset] }
        end
      end

      def subtract_regions(event, regions)
        spans = [[event.offset, event.end_offset]]
        regions.each { |from, to| spans = spans.flat_map { |span| subtract_region(span, from, to) } }
        spans.filter_map { |from, to| clipped_event(event, from, to) }
      end

      def subtract_region(span, from, to)
        span_from, span_to = span
        return [span] if to <= span_from || from >= span_to

        [[span_from, [from, span_to].min], [[to, span_from].max, span_to]].select { |a, b| b > a }
      end

      def clipped_event(event, from, to)
        duration = to - from
        return nil unless duration.positive?

        TimedEvent.new(
          part: event.part, role: event.role, phrase_id: event.phrase_id, pitch: event.pitch,
          duration: duration, offset: from, source: event.source, transform: event.transform,
          realization: event.realization, local_marks: event.local_marks, anacrusis: event.anacrusis
        )
      end
    end
  end
end
