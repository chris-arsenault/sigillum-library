# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module ScorePosition
        private

        def bar_at_offset(offset)
          found = bar_layout.find do |bar|
            offset >= bar.fetch(:start) && offset < bar.fetch(:start) + bar.fetch(:length)
          end
          found || (bar_layout.last if offset == total_duration)
        end

        def bar_layout
          @bar_layout ||= begin
            bars = []
            cursor = Rational(0)
            number = 1
            while cursor < total_duration
              meter = meter_at_bar(number)
              length = meter_length(meter)
              bars << {
                number: number,
                start: cursor,
                length: length,
                meter: meter,
                beat_pattern: beat_pattern_at_bar(number)
              }
              cursor += length
              number += 1
            end
            bars
          end
        end

        def meter_changed?(bar)
          number = bar.fetch(:number)
          number != 1 &&
            [meter_at_bar(number), beat_pattern_at_bar(number)] !=
              [meter_at_bar(number - 1), beat_pattern_at_bar(number - 1)]
        end

        def key_changed?(bar)
          number = bar.fetch(:number)
          number != 1 && key_at_bar(number) != key_at_bar(number - 1)
        end

        def clef_for_part_at_bar(part, bar)
          value = active_clef_value(@current_rendered_index, bar.fetch(:start))
          value ? clef_signature(value) : clef_for_part(part)
        end

        def clef_changed?(part, bar)
          return false if bar.fetch(:number) == 1 || part.fetch("staves") == 2

          previous = bar_layout.fetch(bar.fetch(:number) - 2)
          clef_for_part_at_offset(part, previous.fetch(:start)) != clef_for_part_at_offset(part, bar.fetch(:start))
        end

        def clef_for_part_at_offset(part, offset)
          value = active_clef_value(@current_rendered_index, offset)
          value ? clef_signature(value) : clef_for_part(part)
        end

        def active_clef_value(rendered_index, offset)
          clef_controls_for(rendered_index).select do |control|
            rational(control.fetch("offset_ql")) <= offset
          end.last&.fetch("value")
        end

        def clef_controls_for(rendered_index)
          @clef_controls_by_rendered_index ||= {}
          @clef_controls_by_rendered_index[rendered_index] ||= Array(@data["controls"]).select do |control|
            next false unless control["kind"] == "clef"

            rendered_targets(control["target"]).any? { |target| target.fetch(:index) == rendered_index }
          end.sort_by { |control| rational(control.fetch("offset_ql")) }
        end

        def keyless_part?(part)
          return true if part.fetch("render_kind") == "notes"
          return true if part["family"].to_s == "percussion"

          part.fetch("source_parts").any? { |source| source["family"].to_s == "percussion" }
        end

        def meter_at_bar(number)
          event = meter_event_at_bar(number)
          event ? event.fetch("meter") : @data.fetch("meter")
        end

        def beat_pattern_at_bar(number)
          event = meter_event_at_bar(number)
          Array(event && event["beat_pattern"]).filter_map do |weight|
            value = Rational(weight.to_s)
            value if value.positive?
          end
        end

        def meter_event_at_bar(number)
          meter_events.select { |candidate| Integer(candidate.fetch("bar")) <= number }.last
        end

        def beat_group_lengths(bar)
          pattern = Array(bar[:beat_pattern])
          total = pattern.sum
          return [] unless pattern.any? && total.positive?

          pattern.map { |weight| bar.fetch(:length) * weight / total }
        end

        def time_beats_value(bar)
          beats, = parse_meter(bar.fetch(:meter))
          beats.to_s
        end

        def key_at_bar(number)
          bar = bar_layout.fetch(number - 1)
          event = key_changes.select { |candidate| rational(candidate.fetch("offset_ql")) <= bar.fetch(:start) }.last
          event ? event.fetch("key") : @data["key"] || "C"
        end

        def meter_events
          @meter_events ||= Array(@data["meter_events"]).sort_by { |event| Integer(event.fetch("bar")) }
        end

        def key_changes
          @key_changes ||= Array(@data["key_changes"]).sort_by { |event| rational(event.fetch("offset_ql")) }
        end

        def events_by_part
          @events_by_part ||= Array(@data["timed_events"]).group_by { |event| event.fetch("part") }
                                                     .transform_values { |events| sort_part_events(events) }
        end

        def sort_part_events(events)
          events.sort_by { |event| [rational(event.fetch("offset_ql")), rational(event.fetch("duration_ql"))] }
        end

        def event_pitches(event)
          return [] if event["rest"]

          Array(event["pitches"]).compact
        end

        def notes_controls_by_bar
          @notes_controls_by_bar ||= text_controls.group_by do |control|
            offset = rational(control.fetch("offset_ql"))
            bar_at_offset(offset)&.fetch(:number) || 1
          end
        end

        def text_controls
          Array(@data["controls"]).select { |control| control["kind"] == "text" }
        end
      end
    end
  end
end
