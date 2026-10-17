# frozen_string_literal: true

module Partitura
  module Production
    module SoundingReadout
      module DissonanceIntent
        # Intent annotates evidence; it never changes the measured result or severity.
        def dissonance_intents
          @dissonance_intents ||= @piece.controls.filter_map do |control|
            next unless control.kind.to_s == "intentional_dissonance"

            [@piece.realized_offset_for_reference(control.from),
             @piece.realized_offset_for_reference(control.to),
             @piece.control_target_parts(control), control.value]
          end
        end

        def dissonance_intent_at(offset, parts)
          reasons = dissonance_intents.filter_map do |first, last, targets, reason|
            reason if first <= offset && offset < last && (parts - targets).empty?
          end
          reasons.empty? ? "" : " | INTENTIONAL: #{reasons.uniq.join('; ')}"
        end

        def dissonance_intent_in_bar(bar)
          first = @piece.offset_for(bar, 1)
          last = first + @piece.bar_length_for(bar)
          reasons = dissonance_intents.filter_map do |start, finish, targets, reason|
            "#{targets.join(',')}: #{reason}" if start < last && finish > first
          end
          reasons.empty? ? "" : " | declared dissonance intent (scoped; not a verdict): #{reasons.uniq.join('; ')}"
        end
      end
    end
  end
end
