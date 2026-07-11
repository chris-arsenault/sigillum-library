# frozen_string_literal: true

module Partitura
  module Production
    module_function

    # Authored tie chains (`tie(` ... `tie)`) notate one sustained sound as several
    # noteheads. Sounding analysis must hear one event - a continuation is not an
    # attack - so the sounding projections and checkpoint verification read through
    # this merge, mirroring the MIDI export's coalescing.
    def merge_authored_ties(events)
      events.group_by(&:part)
            .values
            .flat_map { |part_events| merge_part_tie_chains(part_events.sort_by(&:offset)) }
            .sort_by { |event| [event.offset, event.part.to_s, event.pitch_label.to_s] }
    end

    def merge_part_tie_chains(events)
      consumed = {}
      events.each_with_index.filter_map do |event, index|
        next if consumed[index]
        next event unless event.marks.include?("tie(")

        merge_tie_chain(events, index, consumed)
      end
    end

    def merge_tie_chain(events, index, consumed)
      head = events[index]
      total = head.duration
      marks = head.marks - ["tie("]
      current = head
      cursor = index
      while current.marks.include?("tie(")
        cursor = tie_continuation_index(events, cursor, current)
        break unless cursor

        consumed[cursor] = true
        current = events[cursor]
        total += current.duration
        marks |= (current.marks - ["tie)", "tie("])
      end
      TimedEvent.new(**head.to_h.merge(duration: total, local_marks: marks))
    end

    def tie_continuation_index(events, index, current)
      target = current.offset + current.duration
      ((index + 1)...events.length).find do |candidate|
        event = events[candidate]
        event.marks.include?("tie)") && event.pitches == current.pitches && event.offset == target
      end
    end
  end
end
