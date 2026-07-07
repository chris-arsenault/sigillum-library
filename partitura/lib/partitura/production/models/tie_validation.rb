# frozen_string_literal: true

module Partitura
  module Production
    # Authored ties are event-level spanners (`tie(` / `tie)`) for cases where
    # the source must place a bar marker between tied noteheads. They are
    # validated against the sounding timeline so a tie cannot silently connect
    # the wrong pitch, part, or offset.
    module TieValidation
      TIE_DOCS = ["docs/architecture/partitura/surfaces/absolute.md"].freeze

      private

      def validate_authored_ties!(events)
        events.reject(&:rest?).group_by(&:part).each_value do |part_events|
          validate_authored_ties_for_part!(part_events.sort_by { |event| [event.offset, event.duration] })
        end
      end

      def validate_authored_ties_for_part!(events)
        active = nil
        events.each do |event|
          active = close_authored_tie!(active, event) if event.marks.include?("tie)")
          active = open_authored_tie!(active, event) if event.marks.include?("tie(")
        end
        raise_unclosed_authored_tie!(active) if active
      end

      def close_authored_tie!(active, event)
        raise_authored_tie_error(event, "has tie) with no preceding tie(") unless active
        unless event.offset == active.fetch(:end_offset) && tie_pitches(event) == active.fetch(:pitches)
          raise_authored_tie_error(event, 
"does not continue #{active.fetch(:label)} exactly at #{format_offset(active.fetch(:end_offset))}")
        end

        nil
      end

      def open_authored_tie!(active, event)
        raise_authored_tie_error(event, "opens tie( before the previous tie is closed") if active

        { pitches: tie_pitches(event), end_offset: event.offset + event.duration, event: event, 
label: event.pitch_label }
      end

      def raise_unclosed_authored_tie!(active)
        raise_authored_tie_error(active.fetch(:event), "opens tie( but no matching adjacent tie) follows")
      end

      def raise_authored_tie_error(event, detail)
        raise compile_error(
          code: "bad_authored_tie",
          message: "Authored tie on #{event.part} #{event.pitch_label} at #{format_offset(event.offset)} #{detail}.",
          repair_instruction: "Pair `tie(` and `tie)` on adjacent same-pitch events in the same part, " \
                              "typically around a bar marker: `G3:1{tie(} | G3:.5{tie)}`.",
          help_topic: "absolute",
          docs: TIE_DOCS,
          extra: { part: event.part, phrase: event.phrase_id, offset: format_offset(event.offset) }
        )
      end

      def tie_pitches(event)
        event.pitches.map { |pitch| Production.pitch_to_midi(pitch) }
      end
    end
  end
end
