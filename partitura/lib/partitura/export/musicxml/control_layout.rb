# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module ControlLayout
        private

        def directions_by_rendered_part_index
          @directions_by_rendered_part_index ||= begin
            @direction_sequence = 0
            directions = Array.new(rendered_parts.length) { [] }
            add_tempo_directions(directions)
            add_control_directions(directions)
            directions.each { |events| events.sort_by! { |event|
 [event.fetch(:bar_number), event.fetch(:local_offset), event.fetch(:sequence)] } }
            directions
          end
        end

        def add_tempo_directions(directions)
          marks = tempo_mark_events
          Array(@data["tempo_events"]).each { |event| add_tempo_event_direction(directions, marks, event) }
        end

        def add_tempo_event_direction(directions, marks, event)
          kind = event["kind"]
          return add_tempo_mark_direction(directions, event) if tempo_mark_kind?(kind)
          return unless %w[ritardando accelerando a_tempo].include?(kind)

          add_tempo_text_direction(directions, marks, kind, event)
        end

        def tempo_mark_kind?(kind)
          kind.nil? || kind == "mark"
        end

        def add_tempo_mark_direction(directions, event)
          bpm = event["bpm"]
          return unless bpm

          add_direction(
            directions,
            0,
            rational(event["offset_ql"] || 0),
            :tempo,
            bpm: bpm,
            text: event["text"],
            beat_unit: event["beat_unit"] || "quarter",
            beat_unit_dots: event["beat_unit_dots"] || 0,
            per_minute: event["per_minute"] || bpm
          )
        end

        def add_tempo_text_direction(directions, marks, kind, event)
          offset = rational(event["offset_ql"] || event["from_offset_ql"] || 0)
          add_tempo_ramp_directions(directions, marks, kind, event) if %w[ritardando accelerando].include?(kind)
          add_direction(directions, 0, offset, :words, value: tempo_text_label(kind, event))
        end

        def tempo_text_label(kind, event)
          event["text"] || { "ritardando" => "rit.", "accelerando" => "accel.", "a_tempo" => "a tempo" }.fetch(kind)
        end

        def add_tempo_ramp_directions(directions, marks, kind, event)
          from_offset = rational(event["from_offset_ql"] || 0)
          to_offset = rational(event["to_offset_ql"] || from_offset)
          span = to_offset - from_offset
          return unless span.positive?

          base_bpm = bpm_at_or_before(marks, from_offset)
          target_bpm = bpm_at_or_after(marks, to_offset)
          target_bpm ||= base_bpm * DEFAULT_TEMPO_RAMP_PERCENT.fetch(kind) / 100.0
          steps = [(span / TEMPO_RAMP_STEP_QL).round, 1].max
          steps.times do |index|
            step = index + 1
            offset = from_offset + (span * step / steps)
            bpm = base_bpm + ((target_bpm - base_bpm) * step / steps)
            add_direction(directions, 0, offset, :hidden_tempo, bpm: bpm.round(2))
          end
        end

        def tempo_mark_events
          events = Array(@data["tempo_events"]).filter_map do |event|
            kind = event["kind"]
            next unless kind.nil? || kind == "mark"
            next unless event["bpm"]

            [rational(event["offset_ql"] || 0), Float(event["bpm"])]
          end
          events.sort_by(&:first)
        end

        def bpm_at_or_before(marks, offset)
          result = marks.first&.last || 120.0
          marks.each do |mark_offset, bpm|
            break if mark_offset > offset

            result = bpm
          end
          result
        end

        def bpm_at_or_after(marks, offset)
          marks.find { |mark_offset, _bpm| mark_offset >= offset }&.last
        end

        def add_control_directions(directions)
          controls = Array(@data["controls"])
          controls.each { |control| add_control_direction(directions, control) }
          add_pedal_control_directions(directions, controls)
        end

        def add_control_direction(directions, control)
          case control["kind"]
          when "dynamic"
            add_dynamic_control_direction(directions, control)
          when "crescendo", "diminuendo"
            add_hairpin_control_direction(directions, control)
          when "harp_pedals"
            add_harp_pedals_control_direction(directions, control)
          when "text"
            add_text_control_direction(directions, control)
          when "chord_symbol"
            add_direction(directions, 0, rational(control.fetch("offset_ql")), :harmony, 
value: control.fetch("value"))
          end
        end

        def add_text_control_direction(directions, control)
          rendered_notation_targets(control["target"]).each do |target|
            add_direction(
              directions,
              target.fetch(:index),
              rational(control.fetch("offset_ql")),
              :words,
              value: control.fetch("value"),
              staff: target[:staff]
            )
          end
        end

        def add_dynamic_control_direction(directions, control)
          rendered_targets(control["target"]).each do |target|
            add_direction(
              directions,
              target.fetch(:index),
              rational(control.fetch("offset_ql")),
              :dynamic,
              value: control.fetch("value"),
              staff: target[:staff]
            )
          end
        end

        def add_hairpin_control_direction(directions, control)
          rendered_notation_targets(control["target"]).each do |target|
            add_hairpin_direction(
              directions,
              target.fetch(:index),
              control.fetch("kind"),
              rational(control.fetch("from_offset_ql")),
              rational(control.fetch("to_offset_ql")),
              staff: target[:staff]
            )
          end
        end

        def rendered_notation_targets(target)
          rendered_targets(target).reject do |rendered_target|
            rendered_parts.fetch(rendered_target.fetch(:index)).fetch("render_kind") == "notes"
          end
        end

        def add_harp_pedals_control_direction(directions, control)
          rendered_targets(control["target"]).each do |target|
            add_direction(
              directions,
              target.fetch(:index),
              rational(control.fetch("offset_ql")),
              :harp_pedals,
              value: control.fetch("value"),
              staff: target[:staff]
            )
          end
        end

        def add_direction(
          directions,
          rendered_index,
          offset,
          kind,
          value: nil,
          staff: nil,
          bpm: nil,
          text: nil,
          beat_unit: nil,
          beat_unit_dots: nil,
          per_minute: nil,
          other: nil,
          number: nil,
          spread: nil
        )
          bar = bar_at_offset(offset) || bar_layout.first
          @direction_sequence = (@direction_sequence || 0) + 1
          directions.fetch(rendered_index) << {
            bar_number: bar.fetch(:number),
            local_offset: offset - bar.fetch(:start),
            kind: kind,
            value: value,
            staff: staff,
            bpm: bpm,
            text: text,
            beat_unit: beat_unit,
            beat_unit_dots: beat_unit_dots,
            per_minute: per_minute,
            other: other,
            number: number,
            spread: spread,
            sequence: @direction_sequence
          }
        end

        def add_hairpin_direction(directions, rendered_index, wedge_type, from_offset, to_offset, staff: nil)
          anchors = hairpin_anchor_items(rendered_index, from_offset, to_offset, staff)
          return add_hairpin_text_direction(directions, rendered_index, wedge_type, from_offset, 
staff: staff) unless anchors

          start_item, end_item = anchors
          start_offset = item_absolute_offset(start_item)
          end_offset = item_absolute_offset(end_item)
          return add_hairpin_text_direction(directions, rendered_index, wedge_type, from_offset, 
staff: staff) if end_offset <= start_offset

          if long_hairpin?(start_offset, end_offset)
            add_hairpin_text_direction(directions, rendered_index, wedge_type, start_offset, 
staff: staff || start_item[:staff], long: true)
            return
          end

          add_hairpin_wedge_directions(
            directions,
            rendered_index,
            hairpin_wedge_context(
              wedge_type,
              start_item,
              end_item,
              start_offset: start_offset,
              end_offset: end_offset,
              staff: staff
            )
          )
        end

        def hairpin_anchor_items(rendered_index, from_offset, to_offset, staff)
          start_item = element_at_or_after(rendered_index, from_offset, staff: staff)
          end_item = element_at_or_before(rendered_index, to_offset, staff: staff)
          return nil if start_item.nil? || end_item.nil? || start_item.equal?(end_item)

          [start_item, end_item]
        end

        def add_hairpin_text_direction(directions, rendered_index, wedge_type, offset, staff:, long: false)
          add_direction(
            directions,
            rendered_index,
            offset,
            :dynamic,
            value: hairpin_text(wedge_type, long: long),
            staff: staff,
            other: true
          )
        end

        def hairpin_wedge_context(wedge_type, start_item, end_item, start_offset:, end_offset:, staff:)
          {
            type: wedge_type,
            start_item: start_item,
            end_item: end_item,
            start_offset: start_offset,
            end_offset: end_offset,
            staff: staff
          }
        end

        def add_hairpin_wedge_directions(directions, rendered_index, context)
          number = hairpin_wedge_number(rendered_index, context)
          add_hairpin_wedge_direction(
            directions,
            rendered_index,
            hairpin_wedge_direction_context(
              context, number,
              {
                offset: :start_offset, item: :start_item, value: context.fetch(:type),
                spread: wedge_hairpin_start_spread(context.fetch(:type))
              }
            )
          )
          add_hairpin_wedge_direction(
            directions,
            rendered_index,
            hairpin_wedge_direction_context(
              context, number,
              {
                offset: :end_offset, item: :end_item, value: "stop",
                spread: wedge_hairpin_stop_spread(context.fetch(:type))
              }
            )
          )
        end

        def hairpin_wedge_direction_context(context, number, selectors)
          {
            offset: context.fetch(selectors.fetch(:offset)),
            value: selectors.fetch(:value),
            item: context.fetch(selectors.fetch(:item)),
            number: number,
            staff: context[:staff],
            spread: selectors.fetch(:spread)
          }
        end

        def hairpin_wedge_number(rendered_index, context)
          wedge_number_for_span(
            rendered_index,
            context.fetch(:start_offset),
            context.fetch(:end_offset),
            key: [
              :control,
              rendered_index,
              context[:staff],
              context.fetch(:type),
              context.fetch(:start_offset),
              context.fetch(:end_offset)
            ]
          )
        end

        def add_hairpin_wedge_direction(directions, rendered_index, event)
          add_direction(
            directions,
            rendered_index,
            event.fetch(:offset),
            :wedge,
            value: event.fetch(:value),
            staff: event[:staff] || event.fetch(:item)[:staff],
            number: event.fetch(:number),
            spread: event.fetch(:spread)
          )
        end

        def add_pedal_control_directions(directions, controls)
          grouped_pedal_controls(controls).each do |(rendered_index, staff), target_controls|
            add_pedal_target_directions(directions, rendered_index, staff, target_controls)
          end
        end

        def grouped_pedal_controls(controls)
          per_target = Hash.new { |hash, key| hash[key] = [] }
          controls.each do |control|
            next unless control["kind"] == "pedal"

            group_pedal_control(per_target, control)
          end
          per_target
        end

        def group_pedal_control(per_target, control)
          rendered_targets(control["target"]).each do |target|
            normalized = pedal_target(target)
            per_target[[normalized.fetch(:index), normalized[:staff]]] << control
          end
        end

        def add_pedal_target_directions(directions, rendered_index, staff, target_controls)
          active_start = nil
          sorted_pedal_controls(target_controls).each do |control|
            active_start = next_pedal_active_start(directions, rendered_index, staff, active_start, control)
          end
          return unless active_start

          add_pedal_span_direction(directions, rendered_index, active_start, total_duration, staff: staff)
        end

        def sorted_pedal_controls(target_controls)
          target_controls.sort_by { |control| rational(control.fetch("offset_ql")) }
        end

        def next_pedal_active_start(directions, rendered_index, staff, active_start, control)
          state = normalize_pedal_state(control["value"])
          offset = rational(control.fetch("offset_ql"))
          return offset if state == "down" && active_start.nil?
          return active_start unless state == "up" && active_start

          add_pedal_span_direction(directions, rendered_index, active_start, offset, staff: staff)
          nil
        end

        def pedal_target(target)
          part = rendered_parts.fetch(target.fetch(:index))
          if part.fetch("staves") == 2 && target[:staff].nil?
            return target.merge(staff: 2)
          end

          target
        end

        def add_pedal_span_direction(directions, rendered_index, from_offset, to_offset, staff: nil)
          start_item, end_item = pedal_span_items(rendered_index, from_offset, to_offset, staff)
          return unless pedal_span_renderable?(start_item, end_item, to_offset)

          number = pedal_span_number(rendered_index, from_offset, to_offset, staff)
          add_pedal_direction(directions, rendered_index, pedal_direction_context(start_item, "start", staff, number))
          add_pedal_direction(directions, rendered_index, pedal_direction_context(end_item, "stop", staff, number))
        end

        def pedal_span_items(rendered_index, from_offset, to_offset, staff)
          start_item = element_at_or_after(rendered_index, from_offset, staff: staff, sounding_only: true)
          end_item = element_before(rendered_index, to_offset, staff: staff, sounding_only: true) ||
            element_at_or_before(rendered_index, to_offset, staff: staff, sounding_only: true)
          [start_item, end_item]
        end

        def pedal_span_renderable?(start_item, end_item, to_offset)
          return false if start_item.nil? || end_item.nil?

          item_absolute_offset(start_item) < to_offset
        end

        def pedal_span_number(rendered_index, from_offset, to_offset, staff)
          pedal_number_for_span(rendered_index, from_offset, to_offset,
                                key: [:control, rendered_index, staff, from_offset, to_offset])
        end

        def pedal_direction_context(item, value, staff, number)
          { item: item, value: value, staff: staff || item[:staff], number: number }
        end

        def add_pedal_direction(directions, rendered_index, event)
          add_direction(
            directions,
            rendered_index,
            item_absolute_offset(event.fetch(:item)),
            :pedal,
            value: event.fetch(:value),
            staff: event.fetch(:staff),
            number: event.fetch(:number)
          )
        end

        def element_at_or_after(rendered_index, offset, staff: nil, sounding_only: false)
          candidates = note_candidates(rendered_index, staff: staff, sounding_only: sounding_only)
          candidates.find { |item| item_absolute_offset(item) >= offset } || candidates.last
        end

        def element_at_or_before(rendered_index, offset, staff: nil, sounding_only: false)
          previous = nil
          note_candidates(rendered_index, staff: staff, sounding_only: sounding_only).each do |item|
            return previous if item_absolute_offset(item) > offset

            previous = item
          end
          previous
        end

        def element_before(rendered_index, offset, staff: nil, sounding_only: false)
          previous = nil
          note_candidates(rendered_index, staff: staff, sounding_only: sounding_only).each do |item|
            return previous if item_absolute_offset(item) >= offset

            previous = item
          end
          previous
        end
      end
    end
  end
end
