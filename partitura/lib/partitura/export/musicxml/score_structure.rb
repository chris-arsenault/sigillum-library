# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module ScoreStructure
        private

        def render_header(xml)
          xml.open("work")
          xml.element("work-title", title)
          xml.close("work")
          xml.element("movement-title", title)
          xml.open("identification")
          xml.element("creator", "Partitura", "type" => "composer")
          xml.open("encoding")
          xml.element("encoding-date", Date.today.iso8601)
          xml.element("software", "Partitura Ruby exporter")
          xml.empty("supports", "element" => "beam", "type" => "yes")
          xml.empty("supports", "element" => "stem", "type" => "yes")
          xml.empty("supports", "element" => "accidental", "type" => "yes")
          xml.close("encoding")
          xml.close("identification")
          xml.open("defaults")
          xml.open("scaling")
          xml.element("millimeters", "7")
          xml.element("tenths", "40")
          xml.close("scaling")
          xml.close("defaults")
        end

        def render_part_list(xml)
          xml.open("part-list")
          rendered_parts.each_with_index do |part, index|
            part_id = part_xml_id(index)
            instrument_id = instrument_xml_id(index)
            name = part_name_for(part)
            abbreviation = abbreviation_for(part)

            xml.open("score-part", "id" => part_id)
            xml.element("part-name", name)
            xml.element("part-abbreviation", abbreviation)
            render_score_instruments(xml, part, index)
            render_midi_instruments(xml, part, index, instrument_id)
            xml.close("score-part")
          end
          xml.close("part-list")
        end

        def render_score_instruments(xml, part, index)
          entries = percussion_map_entries(part)
          if entries.empty?
            render_score_instrument(
              xml,
              instrument_xml_id(index),
              part_name_for(part),
              instrument_abbreviation_for(part, abbreviation_for(part))
            )
            return
          end

          entries.each_with_index do |entry, entry_index|
            render_score_instrument(
              xml,
              percussion_instrument_xml_id(index, entry_index),
              entry.fetch("name"),
              entry.fetch("abbreviation")
            )
          end
        end

        def render_score_instrument(xml, id, name, abbreviation)
          xml.open("score-instrument", "id" => id)
          xml.element("instrument-name", name)
          xml.element("instrument-abbreviation", abbreviation)
          xml.close("score-instrument")
        end

        def render_midi_instruments(xml, part, index, instrument_id)
          entries = percussion_map_entries(part)
          if entries.empty?
            render_midi_instrument(xml, instrument_id, midi_channel_for(part, index), part: part)
            return
          end

          entries.each_with_index do |entry, entry_index|
            render_midi_instrument(
              xml,
              percussion_instrument_xml_id(index, entry_index),
              10,
              midi_unpitched: Integer(entry.fetch("midi_note")) + 1
            )
          end
        end

        def render_midi_instrument(xml, id, channel, part: nil, midi_unpitched: nil)
          xml.open("midi-instrument", "id" => id)
          xml.element("midi-channel", channel.to_s)
          if midi_unpitched
            xml.element("midi-unpitched", midi_unpitched.to_s)
          else
            xml.element("midi-program", midi_program_for(part).to_s)
          end
          xml.close("midi-instrument")
        end

        def midi_channel_for(part, index)
          return 10 if unpitched_percussion_part?(part)
          return 1 if part.fetch("render_kind") == "notes"

          pitched_ordinal = rendered_parts.first(index).count do |candidate|
            candidate.fetch("render_kind") != "notes" && !unpitched_percussion_part?(candidate)
          end
          channel = (pitched_ordinal % 15) + 1
          channel >= 10 ? channel + 1 : channel
        end

        def unpitched_percussion_part?(part)
          return true if part["family"].to_s == "percussion"

          part.fetch("source_parts", []).any? { |source| source["family"].to_s == "percussion" }
        end

        def render_part(xml, part, index)
          xml.comment(centered_comment("Part #{index + 1}"))
          xml.open("part", "id" => part_xml_id(index))
          previous_index = @current_rendered_index
          @current_rendered_index = index
          begin
            if part.fetch("render_kind") == "grand_staff"
              render_grand_staff_part(xml, part)
            elsif part.fetch("render_kind") == "notes"
              render_notes_part(xml, part)
            else
              voices = single_staff_voices(part)
              bar_layout.each do |bar|
                xml.comment(centered_comment("Measure #{bar.fetch(:number)}"))
                xml.open("measure", "implicit" => "no", "number" => bar.fetch(:number).to_s)
                render_attributes(xml, bar, part) if attributes_needed?(bar, part)
                render_measure_events(xml, index, bar, voices)
                render_voices_in_measure(xml, voices, bar)
                xml.close("measure")
              end
            end
          ensure
            @current_rendered_index = previous_index
          end
          xml.close("part")
        end

        def render_grand_staff_part(xml, part)
          voices = grand_staff_voices(part)
          bar_layout.each do |bar|
            xml.comment(centered_comment("Measure #{bar.fetch(:number)}"))
            xml.open("measure", "implicit" => "no", "number" => bar.fetch(:number).to_s)
            render_attributes(xml, bar, part) if attributes_needed?(bar, part)
            render_measure_events(xml, rendered_part_index(part), bar, voices)

            render_voices_in_measure(xml, voices, bar)
            xml.close("measure")
          end
        end

        def render_voices_in_measure(xml, voices, bar)
          voice_items = renderable_measure_voice_items(voices, bar)
          rendered_voice_count = 0
          voice_items.each do |items|
            render_backup(xml, bar.fetch(:length)) if rendered_voice_count.positive?
            prepare_measure_beams(items, bar).each { |item| render_item(xml, item) }
            rendered_voice_count += 1
          end
        end

        def renderable_measure_voice_items(voices, bar)
          voice_items = voices.filter_map do |voice|
            items = voice.fetch(:bars).fetch(bar.fetch(:number), [])
            items unless items.empty?
          end
          return voice_items unless voice_items.any? { |items| items.any? { |item| item.fetch(:pitches).any? } }

          voice_items.reject { |items| inactive_measure_rest_voice?(items) }
        end

        def inactive_measure_rest_voice?(items)
          items.length == 1 &&
            items.first.fetch(:pitches).empty? &&
            items.first[:measure_rest] &&
            items.first.fetch(:marks).empty?
        end

        def render_notes_part(xml, part)
          controls_by_bar = notes_controls_by_bar
          bar_layout.each do |bar|
            xml.comment(centered_comment("Measure #{bar.fetch(:number)}"))
            xml.open("measure", "implicit" => "no", "number" => bar.fetch(:number).to_s)
            render_attributes(xml, bar, part) if attributes_needed?(bar, part)
            render_measure_events(xml, rendered_part_index(part), bar, [])
            controls_by_bar.fetch(bar.fetch(:number), []).each { |control|
 render_words_direction(xml, control.fetch("value")) }
            render_item(xml, full_bar_rest_item(bar))
            xml.close("measure")
          end
        end

        def render_attributes(xml, bar, part)
          initial_bar = bar.fetch(:number) == 1
          xml.open("attributes")
          xml.element("divisions", DIVISIONS.to_s) if initial_bar
          if initial_bar || (!keyless_part?(part) && key_changed?(bar))
            xml.open("key")
            if keyless_part?(part)
              xml.element("fifths", "0")
              xml.element("mode", "none")
            else
              xml.element("fifths", written_key_fifths(part, key_at_bar(bar.fetch(:number))).to_s)
              xml.element("mode", key_mode(key_at_bar(bar.fetch(:number))))
            end
            xml.close("key")
          end
          if initial_bar || meter_changed?(bar)
            _, beat_type = parse_meter(bar.fetch(:meter))
            xml.open("time")
            xml.element("beats", time_beats_value(bar))
            xml.element("beat-type", beat_type.to_s)
            xml.close("time")
          end
          if initial_bar && part.fetch("staves") == 2
            xml.element("staves", "2")
            render_clef(xml, "G", "2", number: 1)
            render_clef(xml, "F", "4", number: 2)
          elsif initial_bar || clef_changed?(part, bar)
            sign, line = clef_for_part_at_bar(part, bar)
            render_clef(xml, sign, line)
          end
          render_transpose(xml, part) if initial_bar
          xml.close("attributes")
        end

        def render_transpose(xml, part)
          transposition = written_transposition_for(part)
          return unless transposition

          xml.open("transpose")
          xml.element("diatonic", transposition.fetch(:diatonic).to_s)
          xml.element("chromatic", transposition.fetch(:chromatic).to_s)
          octave_change = transposition.fetch(:octave_change)
          xml.element("octave-change", octave_change.to_s) unless octave_change.zero?
          xml.close("transpose")
        end

        def attributes_needed?(bar, part)
          return true if bar.fetch(:number) == 1
          return true if meter_changed?(bar)
          return true if !keyless_part?(part) && key_changed?(bar)
          return true if clef_changed?(part, bar)

          false
        end

        def render_clef(xml, sign, line = nil, number: nil)
          attrs = number ? { "number" => number.to_s } : {}
          xml.open("clef", attrs)
          xml.element("sign", sign)
          xml.element("line", line) if line
          xml.close("clef")
        end
      end
    end
  end
end
