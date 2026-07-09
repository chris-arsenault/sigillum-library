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
            xml.open("score-instrument", "id" => instrument_id)
            xml.element("instrument-name", name)
            xml.element("instrument-abbreviation", instrument_abbreviation_for(part, abbreviation))
            xml.close("score-instrument")
            xml.open("midi-instrument", "id" => instrument_id)
            xml.element("midi-channel", ((index % 16) + 1).to_s)
            xml.element("midi-program", midi_program_for(part).to_s)
            xml.close("midi-instrument")
            xml.close("score-part")
          end
          xml.close("part-list")
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
          rendered_voice_count = 0
          voices.each do |voice|
            items = voice.fetch(:bars).fetch(bar.fetch(:number), [])
            next if items.empty?

            render_backup(xml, bar.fetch(:length)) if rendered_voice_count.positive?
            prepare_measure_beams(items, bar).each { |item| render_item(xml, item) }
            rendered_voice_count += 1
          end
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
          xml.open("attributes")
          xml.element("divisions", DIVISIONS.to_s) if bar.fetch(:number) == 1
          xml.open("key")
          if keyless_part?(part)
            xml.element("fifths", "0")
            xml.element("mode", "none")
          else
            xml.element("fifths", key_fifths(key_at_bar(bar.fetch(:number))).to_s)
            xml.element("mode", key_mode(key_at_bar(bar.fetch(:number))))
          end
          xml.close("key")
          beats, beat_type = parse_meter(bar.fetch(:meter))
          xml.open("time")
          xml.element("beats", beats.to_s)
          xml.element("beat-type", beat_type.to_s)
          xml.close("time")
          if part.fetch("staves") == 2
            xml.element("staves", "2")
            render_clef(xml, "G", "2", number: 1)
            render_clef(xml, "F", "4", number: 2)
          else
            render_clef(xml, "G", "2")
          end
          xml.close("attributes")
        end

        def attributes_needed?(bar, part)
          return true if bar.fetch(:number) == 1
          return true if meter_changed?(bar)
          return true if !keyless_part?(part) && key_changed?(bar)

          false
        end

        def render_clef(xml, sign, line, number: nil)
          attrs = number ? { "number" => number.to_s } : {}
          xml.open("clef", attrs)
          xml.element("sign", sign)
          xml.element("line", line)
          xml.close("clef")
        end
      end
    end
  end
end
