# frozen_string_literal: true

require_relative "direction_rendering/renderers"

module Sigillum
  module OrchestralDSL
    module Export
      module MusicXML
        module DirectionRendering
          include Renderers

          LOCAL_WORD_MARKS = { "pizz" => "pizz.", "arco" => "arco" }.freeze

          private

          def render_measure_events(xml, rendered_index, bar, voices)
            events = measure_directions(rendered_index, bar) + local_direction_events(rendered_index, bar, voices)
            events = dedupe_measure_dynamics(events)
            events.sort_by! { |event|
 [event.fetch(:local_offset), event.fetch(:sequence), direction_kind_order(event.fetch(:kind))] }

            events.reject { |event| event.fetch(:kind) == :harmony }.each { |event| render_measure_event(xml, event) }
            events.select { |event| event.fetch(:kind) == :harmony }.each { |event| render_measure_event(xml, event) }
          end

          def local_direction_events(rendered_index, bar, voices)
            sequence = 10_000
            point_events = voices.flat_map do |voice|
              voice.fetch(:bars).fetch(bar.fetch(:number), []).flat_map do |item|
                item.fetch(:marks).filter_map do |mark|
                  sequence += 1
                  next if control_duplicate_dynamic?(rendered_index, item, mark)

                  local_direction_event(mark, item, sequence)
                end
              end
            end
            point_events + local_hairpin_events(voices).fetch(bar.fetch(:number), [])
          end

          def local_direction_event(mark, item, sequence)
            common = {
              local_offset: item.fetch(:local_offset),
              staff: item[:staff],
              sequence: sequence,
              source: :local
            }
            payload = local_direction_payload(mark, item)
            common.merge(payload) if payload
          end

          def local_direction_payload(mark, item)
            return { kind: :dynamic, value: mark } if DYNAMICS.include?(mark)
            return { kind: :words, value: LOCAL_WORD_MARKS.fetch(mark) } if LOCAL_WORD_MARKS.key?(mark)
            return { kind: :words, value: "l.v." } if mark == "lv" && item[:structural_tie]

            local_text_direction_payload(mark)
          end

          def local_text_direction_payload(mark)
            return { kind: :words, value: mark.delete_prefix("txt:").tr("_", " ") } if mark.start_with?("txt:")
            return { kind: :dynamic, value: dynamic_text_label(mark), other: true } if dynamic_text_mark?(mark)
            return { kind: :words, value: mark.tr("_", " ") } if text_mark?(mark)

            nil
          end

          def local_hairpin_events(voices)
            voices.each_with_index.each_with_object(Hash.new { |hash, key|
 hash[key] = [] }) do |(voice, voice_index), out|
              append_voice_hairpin_events(out, voice, voice_index)
            end
          end

          def append_voice_hairpin_events(out, voice, voice_index)
            active = nil
            ordered_voice_items(voice).each do |item|
              active = opening_hairpin(item, voice_index) || active
              close_kind = closing_hairpin_kind(item.fetch(:marks))
              next unless active && close_kind == active.fetch(:kind)

              append_hairpin_events(out, active.fetch(:kind), active.fetch(:item), item, voice_index)
              active = nil
            end
          end

          def opening_hairpin(item, voice_index)
            kind = opening_hairpin_kind(item.fetch(:marks))
            { kind: kind, item: item, voice_index: voice_index } if kind
          end

          def opening_hairpin_kind(marks)
            return "crescendo" if marks.include?("cresc(")
            return "diminuendo" if marks.include?("dim(")

            nil
          end

          def closing_hairpin_kind(marks)
            return "crescendo" if marks.include?("cresc)")
            return "diminuendo" if marks.include?("dim)")

            nil
          end

          def ordered_voice_items(voice)
            voice.fetch(:bars).values.flatten.sort_by { |item| [item.fetch(:bar_number), item.fetch(:local_offset)] }
          end

          def append_hairpin_events(out, kind, start_item, end_item, sequence_seed)
            start_offset = item_absolute_offset(start_item)
            end_offset = item_absolute_offset(end_item)
            return if end_offset <= start_offset

            if long_hairpin?(start_offset, end_offset)
              append_long_hairpin_event(out, kind, start_item, start_offset, sequence_seed)
              return
            end

            append_wedge_hairpin_events(
              out,
              wedge_event_context(
                kind,
                start_item,
                end_item,
                start_offset: start_offset,
                end_offset: end_offset,
                sequence_seed: sequence_seed
              )
            )
          end

          def append_long_hairpin_event(out, kind, start_item, start_offset, sequence_seed)
            event = event_at_absolute_offset(start_offset).merge(
              kind: :dynamic,
              value: hairpin_text(kind, long: true),
              other: true,
              staff: start_item[:staff],
              sequence: 20_000 + sequence_seed
            )
            out[event.fetch(:bar_number)] << event
          end

          def wedge_event_context(kind, start_item, end_item, start_offset:, end_offset:, sequence_seed:)
            {
              kind: kind,
              start_item: start_item,
              end_item: end_item,
              start_offset: start_offset,
              end_offset: end_offset,
              sequence_seed: sequence_seed
            }
          end

          def append_wedge_hairpin_events(out, context)
            number = next_wedge_number
            start_event = wedge_hairpin_event(
              context.fetch(:kind),
              context.fetch(:start_item),
              context.fetch(:start_offset),
              number,
              20_000 + context.fetch(:sequence_seed),
              spread: wedge_hairpin_start_spread(context.fetch(:kind))
            )
            stop_event = wedge_hairpin_event(
              "stop",
              context.fetch(:end_item),
              context.fetch(:end_offset),
              number,
              20_001 + context.fetch(:sequence_seed),
              spread: wedge_hairpin_stop_spread(context.fetch(:kind))
            )
            out[start_event.fetch(:bar_number)] << start_event
            out[stop_event.fetch(:bar_number)] << stop_event
          end

          def wedge_hairpin_event(kind, item, offset, number, sequence, spread:)
            event_at_absolute_offset(offset).merge(
              kind: :wedge,
              value: kind,
              spread: spread,
              staff: item[:staff],
              number: number,
              sequence: sequence
            )
          end

          def wedge_hairpin_start_spread(kind)
            kind == "crescendo" ? 0 : 15
          end

          def wedge_hairpin_stop_spread(kind)
            kind == "crescendo" ? 15 : 0
          end

          def hairpin_text(kind, long:)
            suffix = long ? ". poco a poco" : "."
            "#{kind == "crescendo" ? "cresc" : "dim"}#{suffix}"
          end

          def item_absolute_offset(item)
            bar_layout.fetch(item.fetch(:bar_number) - 1).fetch(:start) + item.fetch(:local_offset)
          end

          def event_at_absolute_offset(offset)
            bar = bar_at_offset(offset) || bar_layout.last
            {
              bar_number: bar.fetch(:number),
              local_offset: offset - bar.fetch(:start)
            }
          end

          def long_hairpin?(start_offset, end_offset)
            bar = bar_at_offset(start_offset) || bar_layout.first
            end_offset - start_offset > MAX_HAIRPIN_BARS * bar.fetch(:length)
          end

          def next_wedge_number
            @wedge_number = (@wedge_number || 0) + 1
          end

          def dedupe_measure_dynamics(events)
            selected = {}
            out = []
            events.each do |event|
              unless event.fetch(:kind) == :dynamic
                out << event
                next
              end

              if event[:other]
                out << event
                next
              end

              key = [event.fetch(:local_offset), event[:staff]]
              previous_index = selected[key]
              if previous_index.nil?
                selected[key] = out.length
                out << event
                next
              end

              previous = out.fetch(previous_index)
              out[previous_index] = dominant_dynamic_event(previous, event)
            end
            out
          end

          def dominant_dynamic_event(left, right)
            left_rank = dynamic_priority(left.fetch(:value))
            right_rank = dynamic_priority(right.fetch(:value))
            right_rank >= left_rank ? right : left
          end

          def dynamic_priority(value)
            DYNAMICS.index(value) || DYNAMICS.length
          end

          def direction_kind_order(kind)
            {
              tempo: 0,
              words: 1,
              hidden_tempo: 2,
              dynamic: 3,
              wedge: 4,
              pedal: 5,
              harp_pedals: 6,
              harmony: 9
            }.fetch(kind, 8)
          end

          def render_offset(xml, offset, sound: false)
            return if offset.nil? || offset.zero?

            attrs = sound ? { "sound" => "yes" } : {}
            xml.element("offset", duration_units(offset).to_s, attrs)
          end

          def render_dynamic_direction(xml, value, staff: nil, other: false, offset: nil)
            xml.open("direction")
            xml.open("direction-type")
            xml.open("dynamics", "default-x" => "-36", "default-y" => "-80")
            if other
              xml.element("other-dynamics", value)
            else
              xml.empty(value)
            end
            xml.close("dynamics")
            xml.close("direction-type")
            render_offset(xml, offset, sound: true)
            xml.element("staff", staff.to_s) if staff
            xml.empty("sound", "dynamics" => (DYNAMIC_SOUND[value] || 63).to_s)
            xml.close("direction")
          end

          def render_words_direction(xml, text, staff: nil, offset: nil)
            xml.open("direction")
            xml.open("direction-type")
            xml.element("words", text, "font-style" => "italic")
            xml.close("direction-type")
            render_offset(xml, offset)
            xml.element("staff", staff.to_s) if staff
            xml.close("direction")
          end

          def render_tempo_direction(xml, bpm, _text, offset: nil)
            xml.open("direction")
            xml.open("direction-type")
            xml.open("metronome", "parentheses" => "no")
            xml.element("beat-unit", "quarter")
            xml.element("per-minute", bpm.to_s)
            xml.close("metronome")
            xml.close("direction-type")
            render_offset(xml, offset, sound: true)
            xml.empty("sound", "tempo" => bpm.to_s)
            xml.close("direction")
          end

          def render_hidden_tempo_direction(xml, bpm, offset: nil)
            xml.open("direction")
            xml.open("direction-type")
            xml.empty("words")
            xml.close("direction-type")
            render_offset(xml, offset, sound: true)
            xml.empty("sound", "tempo" => format_tempo(bpm))
            xml.close("direction")
          end

          def render_wedge_direction(xml, type, staff: nil, offset: nil, number: nil, spread: nil)
            xml.open("direction", "placement" => "below")
            xml.open("direction-type")
            attrs = { "type" => type }
            attrs["number"] = number.to_s if number
            attrs["spread"] = (spread || wedge_spread(type)).to_s
            xml.empty("wedge", attrs)
            xml.close("direction-type")
            render_offset(xml, offset, sound: true)
            xml.element("staff", staff.to_s) if staff
            xml.close("direction")
          end

          def wedge_spread(type)
            return 15 if type == "stop"
            return 15 if type == "diminuendo"

            0
          end

          def render_pedal_direction(xml, type, staff: nil, offset: nil, number: nil)
            xml.open("direction", "placement" => "below")
            xml.open("direction-type")
            attrs = { "type" => type, "line" => "yes" }
            attrs["number"] = number.to_s if number
            xml.empty("pedal", attrs)
            xml.close("direction-type")
            render_offset(xml, offset, sound: true)
            xml.element("staff", staff.to_s) if staff
            xml.close("direction")
          end

          def render_harp_pedals_direction(xml, value, staff: nil, offset: nil)
            xml.open("direction")
            xml.open("direction-type")
            xml.open("harp-pedals")
            value.to_s.split(",").each do |token|
              token = token.strip
              next if token.empty?

              match = token.match(/\A([A-G])([#b]?)\z/)
              next unless match

              xml.open("pedal-tuning")
              xml.element("pedal-step", match[1])
              xml.element("pedal-alter", accidental_alter(match[2]).to_s)
              xml.close("pedal-tuning")
            end
            xml.close("harp-pedals")
            xml.close("direction-type")
            render_offset(xml, offset)
            xml.element("staff", staff.to_s) if staff
            xml.close("direction")
          end

          def render_harmony(xml, value, offset: nil)
            parsed = parse_harmony(value)
            unless parsed
              render_words_direction(xml, value)
              return
            end

            xml.open("harmony")
            render_offset(xml, offset)
            xml.open("root")
            xml.element("root-step", parsed.fetch(:step))
            xml.element("root-alter", parsed.fetch(:alter).to_s) unless parsed.fetch(:alter).zero?
            xml.close("root")
            xml.element("kind", parsed.fetch(:kind))
            xml.close("harmony")
          end

          def control_duplicate_dynamic?(rendered_index, item, mark)
            return false unless DYNAMICS.include?(mark)

            directions_by_rendered_part_index.fetch(rendered_index).any? do |event|
              event.fetch(:kind) == :dynamic &&
                event.fetch(:bar_number) == item.fetch(:bar_number) &&
                event.fetch(:local_offset) == item.fetch(:local_offset) &&
                event.fetch(:value) == mark &&
                event[:staff] == item[:staff]
            end
          end
        end
      end
    end
  end
end
