# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module Timing
        private

        def timed_events_for_placement(placement, phrase_map, include_rests:)
          validate_placement_part!(placement)
          phrase = phrase_for_placement(placement, phrase_map)
          offset = offset_for(placement.bar, placement.beat)
          phrase.events.filter_map do |event|
            current = timed_event_for(placement, phrase, event, offset)
            offset += event.duration
            include_rests || !current.rest? ? current : nil
          end
        end

        def validate_placement_part!(placement)
          return if @parts.key?(placement.part)

          raise compile_error(
            code: "unknown_part",
            message: "Placement references unknown part #{placement.part}.",
            repair_instruction: "Add the part to the roster or fix the placement part id.",
            help_topic: "container",
            docs: ["docs/architecture/orchestral_dsl/01_container.md"]
          )
        end

        def phrase_for_placement(placement, phrase_map)
          phrase_map.fetch(placement.phrase_id) do
            raise compile_error(
              code: "unknown_phrase",
              message: "Placement references unknown phrase #{placement.phrase_id}.",
              repair_instruction: "Define the phrase before placing it, or fix the phrase id.",
              help_topic: "phrase_placement",
              docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
            )
          end
        end

        def timed_event_for(placement, phrase, event, offset)
          TimedEvent.new(
            part: placement.part,
            role: placement.role,
            phrase_id: phrase.id,
            pitch: event.pitch,
            duration: event.duration,
            offset: offset,
            source: event.source,
            transform: placement.transform,
            realization: placement.realization,
            local_marks: event.marks
          )
        end
      end
    end
  end
end
