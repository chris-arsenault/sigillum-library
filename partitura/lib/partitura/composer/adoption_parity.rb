# frozen_string_literal: true

module Partitura
  module Composer
    module AdoptionParity
      def signature(piece)
        controls = piece.controls.map { |control| normalized_locations(piece, control.to_h) }.sort_by(&:to_s)
        tempi = piece.tempo_events.reject { |event| event.kind == :mark }
                     .map { |event| normalized_locations(piece, event.to_h) }
        [event_signature(piece), controls, tempi, tempo_signature(piece), context_signature(piece),
         piece.declared_chords, piece.parts.values.map { |part| Production.export_part(part) }, piece.total_duration]
      end

      def event_signature(piece)
        piece.timed_events(include_rests: true).map do |event|
          [event.part.to_s, event.role.to_s, event.pitch, event.offset, event.duration, event.marks]
        end.sort_by(&:to_s)
      end

      def context_signature(piece)
        last = piece.sections.last&.bars&.end || 0
        (1..last).map do |bar|
          [piece.meter_for(bar).meter, piece.meter_for(bar).beat_pattern, piece.key_for_bar(bar)]
        end
      end

      def tempo_signature(piece)
        marks = piece.tempo_events.select { |event| event.kind == :mark }
                     .map { |event| [piece.offset_for_reference(event.at), event.text] }.sort_by(&:first)
        marks.each_with_object([]) { |mark, list| list << mark unless list.last&.last == mark.last }
      end

      def normalized_locations(piece, values)
        values.dup.tap do |result|
          %i[at from to].each { |field| result[field] = piece.offset_for_reference(result[field]) if result[field] }
        end
      end
    end
  end
end
