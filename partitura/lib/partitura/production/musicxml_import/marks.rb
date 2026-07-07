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
        marks
      end

      def read_articulation_marks(element, marks)
        each_at(element, ".//articulations/*") { |art| marks << ART.fetch(art.name) if ART.key?(art.name) }
      end

      def read_slur_marks(element, marks)
        each_at(element, ".//slur") { |slur| marks << typed_span_mark(slur, "slur") }
      end

      def read_arpeggio_marks(element, marks)
        arpeggiate = first_at(element, ".//notations/arpeggiate")
        return unless arpeggiate

        direction = arpeggiate.attributes["direction"]
        marks << (direction ? "arp:#{direction}" : "arp")
      end

      def read_glissando_marks(element, marks)
        each_at(element, ".//glissando") { |gliss| marks << typed_span_mark(gliss, "gliss") }
        each_at(element, ".//slide") { |slide| marks << typed_span_mark(slide, "gliss") }
      end

      def read_let_ring_marks(element, marks)
        each_at(element, ".//notations/tied") { |tied| marks << "lv" if tied.attributes["type"] == "let-ring" }
      end

      def typed_span_mark(element, name)
        element.attributes["type"] == "start" ? "#{name}(" : "#{name})"
      end
    end
  end
end
