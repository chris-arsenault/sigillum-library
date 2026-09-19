# frozen_string_literal: true

module Partitura
  module Production
    module MusicXMLImport
      module_function

      def read_marks(element)
        marks = []
        read_articulation_marks(element, marks)
        read_slur_marks(element, marks)
        read_arpeggio_marks(element, marks)
        read_glissando_marks(element, marks)
        read_let_ring_marks(element, marks)
        notehead = first_at(element, "notehead")
        marks << "ghost" if notehead && notehead.attributes["parentheses"] == "yes"
        marks << "fermata" if first_at(element, ".//notations/fermata")
        waves = each_at(element, ".//ornaments/wavy-line").to_a
        if waves.empty?
          marks << "trill" if first_at(element, ".//ornaments/trill-mark")
        else
          waves.each do |wave|
            marks << typed_span_mark(wave, "trill") if %w[start stop].include?(wave.attributes["type"])
          end
        end
        marks
      end

      def read_articulation_marks(element, marks)
        each_at(element, ".//articulations/*") { |art| marks << ART.fetch(art.name) if ART.key?(art.name) }
      end

      def read_slur_marks(element, marks)
        each_at(element, ".//slur") do |slur|
          number = slur.attributes["number"]
          name = number && number != "1" ? "slur:#{number}" : "slur"
          marks << typed_span_mark(slur, name) if %w[start stop].include?(slur.attributes["type"])
        end
      end

      def read_arpeggio_marks(element, marks)
        arpeggiate = first_at(element, ".//notations/arpeggiate")
        return unless arpeggiate

        direction = arpeggiate.attributes["direction"]
        marks << (direction ? "arp:#{direction}" : "arp")
      end

      def read_glissando_marks(element, marks)
        each_at(element, ".//glissando") { |gliss| marks << typed_span_mark(gliss, "gliss") }
        each_at(element, ".//slide") { |slide| marks << typed_span_mark(slide, "slide") }
      end

      def read_let_ring_marks(element, marks)
        each_at(element, ".//notations/tied") { |tied| marks << "lv" if tied.attributes["type"] == "let-ring" }
      end

      def typed_span_mark(element, name)
        element.attributes["type"] == "start" ? "#{name}(" : "#{name})"
      end

      def metronome_beat_unit(metronome)
        beat_unit = text_at(metronome, "beat-unit")
        dots = each_at(metronome, "beat-unit-dot").count
        return beat_unit if dots.zero?

        prefix = { 1 => "dotted", 2 => "double-dotted", 3 => "triple-dotted" }.fetch(dots, "#{dots}-dotted")
        "#{prefix}-#{beat_unit}"
      end
    end
  end
end
