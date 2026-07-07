# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module NoteRendering
        EMPTY_NOTATION_KEYS = %i[tie_types articulations technicals arpeggios ornaments spanners].freeze
        TEXT_MARK_EXCLUSIONS = %w[
          lv harm trem trill trill( trill) slur( slur) tie( tie) gliss( gliss) cresc( cresc) dim( dim)
          pizz arco rimshot xstick
        ].freeze

        private

        def render_item(xml, item)
          previous_item = @current_item
          @current_item = item
          begin
            pitches = item.fetch(:pitches)
            pitches.empty? ? render_rest_note(xml, item) : render_pitched_notes(xml, item, pitches)
          ensure
            @current_item = previous_item
          end
        end

        def render_rest_note(xml, item)
          xml.open("note")
          item[:measure_rest] ? xml.empty("rest", "measure" => "yes") : xml.empty("rest")
          render_note_details(xml, item)
          xml.close("note")
        end

        def render_pitched_notes(xml, item, pitches)
          pitches.each_with_index do |pitch_name, index|
            xml.open("note")
            xml.empty("chord") if index.positive?
            render_pitch(xml, pitch_name)
            render_note_details(xml, item)
            xml.close("note")
          end
        end

        def render_note_details(xml, item)
          render_duration(xml, item)
          render_voice_staff(xml, item)
          render_stem_and_beams(xml, item)
          render_notations(xml, item)
        end

        def render_pitch(xml, pitch_name)
          parsed = parse_pitch(pitch_name)
          xml.open("pitch")
          xml.element("step", parsed.fetch(:step))
          xml.element("alter", parsed.fetch(:alter).to_s) unless parsed.fetch(:alter).zero?
          xml.element("octave", parsed.fetch(:octave).to_s)
          xml.close("pitch")
        end

        def render_duration(xml, item)
          duration = item.fetch(:duration)
          xml.element("duration", duration_units(duration).to_s)
          return if item[:measure_rest]

          tie_types_for(item).each { |type| xml.element("tie", nil, "type" => type) }
          duration_name, dots = duration_type(duration)
          xml.element("type", duration_name)
          dots.times { xml.empty("dot") }
          render_time_modification(xml, duration)
        end

        def render_time_modification(xml, duration)
          tuplet = tuplet_signature(duration)
          return unless tuplet

          xml.open("time-modification")
          xml.element("actual-notes", "3")
          xml.element("normal-notes", "2")
          xml.element("normal-type", tuplet.fetch(:normal_type))
          xml.close("time-modification")
        end

        def render_voice_staff(xml, item)
          xml.element("voice", item.fetch(:voice).to_s) if item[:voice]
          xml.element("staff", item.fetch(:staff).to_s) if item[:staff]
        end

        def render_stem_and_beams(xml, item)
          return if item[:measure_rest]
          return if item.fetch(:pitches).empty?

          beams = Array(item[:beams])
          return if beams.empty?

          xml.element("stem", stem_direction(item))
          beams.each do |number, value|
            xml.element("beam", value, "number" => number.to_s)
          end
        end

        def stem_direction(item)
          return "down" if item[:staff] == 2
          return "down" if item.fetch(:pitches).any? { |pitch| pitch_midi(pitch) >= 71 }

          "up"
        end

        def beam_count(duration)
          duration_name, = duration_type(duration)
          {
            "eighth" => 1,
            "16th" => 2,
            "32nd" => 3,
            "64th" => 4
          }.fetch(duration_name, 0)
        end

        def render_notations(xml, item)
          notation = notation_components(item)
          return if notation_empty?(notation, item)

          xml.open("notations")
          render_tie_notations(xml, notation.fetch(:tie_types), item)
          render_articulation_notations(xml, notation.fetch(:articulations))
          render_technical_notations(xml, notation.fetch(:technicals))
          render_ornament_notations(xml, notation.fetch(:ornaments))
          notation.fetch(:arpeggios).each { |mark| render_arpeggio_notation(xml, mark) }
          notation.fetch(:spanners).each { |mark| render_spanner_notation(xml, mark) }
          render_tuplet_notation(xml, item) if item[:tuplet]
          xml.element("notehead", notation.fetch(:notehead)) if notation.fetch(:notehead)
          xml.close("notations")
        end

        def notation_components(item)
          marks = item.fetch(:marks)
          {
            tie_types: tie_types_for(item),
            marks: marks,
            articulations: marks.filter_map { |mark| ARTICULATIONS[mark] },
            technicals: marks.select { |mark| %w[harm lv choke].include?(mark) },
            arpeggios: marks.select { |mark| mark.start_with?("arp") },
            ornaments: marks.select { |mark| %w[trill trem].include?(mark) },
            spanners: marks.select { |mark| spanner_mark?(mark) },
            notehead: notehead_for_marks(marks)
          }
        end

        def notation_empty?(notation, item)
          notation_component_empty?(notation) && notation.fetch(:notehead).nil? && item[:tuplet].nil?
        end

        def notation_component_empty?(notation)
          EMPTY_NOTATION_KEYS.all? { |key| notation.fetch(key).empty? }
        end

        def render_tie_notations(xml, tie_types, item)
          tie_types.each { |type| xml.empty("tied", "type" => type) }
          marks = item.fetch(:marks)
          xml.empty("tied", "type" => "let-ring") if marks.include?("lv") && !item[:structural_tie]
        end

        def render_articulation_notations(xml, articulations)
          return if articulations.empty?

          xml.open("articulations")
          articulations.uniq.each { |name| render_articulation_notation(xml, name) }
          xml.close("articulations")
        end

        def render_articulation_notation(xml, name)
          name == "strong-accent" ? xml.empty(name, "type" => "up") : xml.empty(name)
        end

        def render_technical_notations(xml, technicals)
          return if technicals.empty?

          xml.open("technical")
          xml.empty("harmonic") if technicals.include?("harm")
          xml.empty("stopped") if technicals.include?("choke")
          xml.close("technical")
        end

        def render_ornament_notations(xml, ornaments)
          return if ornaments.empty?

          xml.open("ornaments")
          xml.empty("trill-mark") if ornaments.include?("trill")
          xml.element("tremolo", "3", "type" => "single") if ornaments.include?("trem")
          xml.close("ornaments")
        end

        def render_tuplet_notation(xml, item)
          tuplet = tuplet_signature(item.fetch(:duration))
          return unless tuplet

          if item[:tuplet] == :start
            xml.open("tuplet", "bracket" => "yes", "number" => "1", "placement" => "above", "type" => "start")
            xml.open("tuplet-actual")
            xml.element("tuplet-number", "3")
            xml.element("tuplet-type", tuplet.fetch(:normal_type))
            xml.close("tuplet-actual")
            xml.open("tuplet-normal")
            xml.element("tuplet-number", "2")
            xml.element("tuplet-type", tuplet.fetch(:normal_type))
            xml.close("tuplet-normal")
            xml.close("tuplet")
          else
            xml.empty("tuplet", "number" => "1", "type" => "stop")
          end
        end

        def render_arpeggio_notation(xml, mark)
          case mark
          when "arp", "arp:up"
            xml.empty("arpeggiate", "direction" => "up")
          when "arp:down"
            xml.empty("arpeggiate", "direction" => "down")
          when "arp:non"
            xml.empty("non-arpeggiate", "type" => "top")
          end
        end

        def render_spanner_notation(xml, mark)
          case mark
          when "slur("
            xml.empty("slur", "type" => "start")
          when "slur)"
            xml.empty("slur", "type" => "stop")
          when "gliss("
            xml.empty("glissando", "type" => "start", "line-type" => "wavy")
          when "gliss)"
            xml.empty("glissando", "type" => "stop", "line-type" => "wavy")
          when "trill("
            xml.empty("wavy-line", "type" => "start")
          when "trill)"
            xml.empty("wavy-line", "type" => "stop")
          end
        end

        def spanner_mark?(mark)
          %w[slur( slur) gliss( gliss) trill( trill)].include?(mark)
        end

        def notehead_for_marks(marks)
          return "circle-x" if marks.include?("rimshot")
          return "x" if marks.include?("xstick")

          nil
        end

        def dynamic_text_mark?(mark)
          %w[< > <>].include?(mark)
        end

        def dynamic_text_label(mark)
          { "<" => "cresc.", ">" => "dim.", "<>" => "cresc-dim" }.fetch(mark)
        end

        def text_mark?(mark)
          return false unless mark.is_a?(String) && !mark.empty?
          return false if reserved_text_mark?(mark)
          return false if mark.start_with?("arp")
          return false if mark.start_with?("stick:")

          true
        end

        def reserved_text_mark?(mark)
          DYNAMICS.include?(mark) || ARTICULATIONS.key?(mark) || TEXT_MARK_EXCLUSIONS.include?(mark)
        end

        def tie_types_for(item)
          Array(item[:ties] || item[:tie]).compact
        end

        def marks_for_segment(marks, index, count)
          return marks if count == 1
          return marks.reject { |mark| mark == "ten" } if index.zero?
          return marks.select { |mark| mark == "ten" } if index == count - 1

          []
        end
      end
    end
  end
end
