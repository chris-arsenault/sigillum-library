# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module Items
        private

        def single_staff_voices(part)
          voices = voice_items_for_part(part.fetch("id"), staff: nil, voice_base: 0, tag_single_voice: false)
          return voices unless needs_harmony_shadow_voice?(part)

          retag_shadowed_single_staff_voices!(voices)
          voices << { part_id: part.fetch("id"), staff: nil, voice: 1, bars: shadow_rest_bars(1) }
        end

        def retag_shadowed_single_staff_voices!(voices)
          voices.each do |voice|
            voice.fetch(:bars).each_value do |items|
              items.each { |item| item[:voice] = 0 }
            end
          end
        end

        def needs_harmony_shadow_voice?(_part)
          @current_rendered_index.to_i.zero? &&
            Array(@data["controls"]).any? { |control| control["kind"] == "chord_symbol" }
        end

        def shadow_rest_bars(voice)
          bar_layout.to_h do |bar|
            item = full_bar_rest_item(bar)
            item[:voice] = voice
            [bar.fetch(:number), [item]]
          end
        end

        def voice_items_for_part(part_id, staff:, voice_base:, tag_single_voice:)
          voice_items_from_events(
            part_id,
            events_by_part.fetch(part_id, []),
            staff: staff,
            voice_base: voice_base,
            tag_single_voice: tag_single_voice
          )
        end

        def voice_items_from_events(part_id, events, staff:, voice_base:, tag_single_voice:, fill_gaps_override: nil)
          lanes = split_event_lanes(events)
          lanes = [[]] if lanes.empty?
          multiple_lanes = lanes.length > 1
          lanes.map.with_index do |lane_events, index|
            voice = voice_number(voice_base, index, multiple_lanes, tag_single_voice)
            fill_gaps = voice_fill_gaps(index, multiple_lanes, tag_single_voice, fill_gaps_override)
            {
              part_id: part_id,
              staff: staff,
              voice: voice,
              bars: items_by_bar_from_events(part_id, lane_events, staff: staff, voice: voice, fill_gaps: fill_gaps)
            }
          end
        end

        def voice_number(voice_base, index, multiple_lanes, tag_single_voice)
          return nil unless tag_single_voice || multiple_lanes

          voice_base + index
        end

        def voice_fill_gaps(index, multiple_lanes, tag_single_voice, override)
          return override unless override.nil?
          return true if !tag_single_voice && multiple_lanes

          index.zero?
        end

        def items_by_bar_from_events(part_id, events, staff:, voice:, fill_gaps:)
          if fill_gaps == :active_measures
            return active_measure_items_by_bar_from_events(part_id, events, staff: staff, voice: voice)
          end

          items = []
          current = Rational(0)
          events.each do |event|
            current = append_timed_event_items(
              items, part_id, event, current, staff: staff, voice: voice, fill_gaps: fill_gaps
            )
          end
          append_trailing_gap(items, current, staff, voice) if fill_gaps && total_duration > current
          items.group_by { |item| item.fetch(:bar_number) }
        end

        def append_timed_event_items(items, part_id, event, current, staff:, voice:, fill_gaps:)
          offset = rational(event.fetch("offset_ql"))
          duration = rational(event.fetch("duration_ql"))
          raise Error, "overlapping events in part #{part_id}" if offset < current

          append_segments(items, current, offset - current, [], [], staff: staff, voice: voice) if fill_gaps &&
                                                                                                   offset > current
          append_segments(
            items, offset, duration, event_pitches(event), Array(event["local_marks"]), staff: staff, voice: voice
          )
          offset + duration
        end

        def append_trailing_gap(items, current, staff, voice)
          append_segments(items, current, total_duration - current, [], [], staff: staff, voice: voice)
        end

        def active_measure_items_by_bar_from_events(part_id, events, staff:, voice:)
          current = Rational(0)
          items = []
          events.each do |event|
            current = append_active_measure_event_items(items, part_id, event, current, staff: staff, voice: voice)
          end
          fill_active_measure_gaps(items, staff: staff, voice: voice).group_by { |item| item.fetch(:bar_number) }
        end

        def append_active_measure_event_items(items, part_id, event, current, staff:, voice:)
          offset = rational(event.fetch("offset_ql"))
          duration = rational(event.fetch("duration_ql"))
          raise Error, "overlapping events in part #{part_id}" if offset < current

          append_segments(
            items, offset, duration, event_pitches(event), Array(event["local_marks"]), staff: staff, voice: voice
          )
          offset + duration
        end

        def fill_active_measure_gaps(items, staff:, voice:)
          context = { staff: staff, voice: voice }
          items.group_by { |item| item.fetch(:bar_number) }
               .sort
               .each_with_object([]) do |(bar_number, bar_items), filled|
                 append_filled_bar_items(filled, bar_number, bar_items, context)
               end
        end

        def append_filled_bar_items(filled, bar_number, bar_items, context)
          bar = bar_layout.fetch(bar_number - 1)
          cursor = Rational(0)
          bar_items.sort_by { |item| item.fetch(:local_offset) }.each do |item|
            cursor = append_filled_item(filled, bar, item, cursor, context)
          end
          append_bar_gap(filled, bar, cursor, bar.fetch(:length), context)
        end

        def append_filled_item(filled, bar, item, cursor, context)
          append_bar_gap(filled, bar, cursor, item.fetch(:local_offset), context)
          filled << item
          [cursor, item.fetch(:local_offset) + item.fetch(:duration)].max
        end

        def append_bar_gap(items, bar, from, to, context)
          return unless to > from

          append_segments(
            items,
            bar.fetch(:start) + from,
            to - from,
            [],
            [],
            staff: context.fetch(:staff),
            voice: context.fetch(:voice)
          )
        end

        def split_event_lanes(events)
          lanes = []
          events.each { |event| place_event_in_lane!(lanes, event) }
          lanes.map { |lane| lane.fetch(:events) }
        end

        def place_event_in_lane!(lanes, event)
          offset = rational(event.fetch("offset_ql"))
          duration = rational(event.fetch("duration_ql"))
          index = lanes.index { |lane| offset >= lane.fetch(:current) }
          return lanes << { current: offset + duration, events: [event] } if index.nil?

          lanes[index].fetch(:events) << event
          lanes[index][:current] = offset + duration
        end
      end
    end
  end
end
