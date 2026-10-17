# frozen_string_literal: true

module Partitura
  module Export
    module MIDI
      module Rolls
        # Three tremolo strokes are auditioned as 32nds. This interprets an
        # authored percussion roll; the notation and canonical events stay held.
        ROLL_STEP = Rational(1, 8)
        ONSET_ONLY = %w[accent marc fp sfz].freeze

        private

        def performed_note_events(event, channel, part)
          return percussion_roll_events(event, channel, part) if percussion_roll?(event, part)

          part_note_events(event, channel, event_velocity(event, part), part)
        end

        def percussion_roll?(event, part)
          percussion = %w[percussion pitched_percussion].include?(part["family"].to_s) ||
                       part["music21_instrument"] == "Timpani"
          percussion && Array(event["local_marks"]).include?("trem")
        end

        def percussion_roll_events(event, channel, part)
          first = rational(event.fetch("offset_ql"))
          finish = first + rational(event.fetch("duration_ql"))
          offset = first
          notes = []
          while offset < finish
            marks = Array(event["local_marks"])
            marks -= ONSET_ONLY unless offset == first
            stroke = event.merge("offset_ql" => offset, "duration_ql" => [ROLL_STEP, finish - offset].min,
                                 "local_marks" => marks)
            notes.concat(part_note_events(stroke, channel, event_velocity(stroke, part), part))
            offset += ROLL_STEP
          end
          notes
        end
      end
    end
  end
end
