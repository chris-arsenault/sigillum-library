# frozen_string_literal: true

module Partitura
  module Production
    module Validation
      private

      def validate_meter_events!
        seen = {}
        @meter_changes.each do |event|
          Production.meter_to_bar_length(event.meter)
          validate_unique_meter_bar!(seen, event)
          seen[event.bar] = true
        end
      end

      def validate_unique_meter_bar!(seen, event)
        return unless seen.key?(event.bar)

        raise compile_error(
          code: "duplicate_meter_change",
          message: "More than one meter change is declared at bar #{event.bar}.",
          repair_instruction: "Keep at most one meter event per bar.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"]
        )
      end

      def validate_spans_and_placements!
        @sections.each do |section|
          section.spans.each { |span| validate_span!(section, span) }
        end
      end

      def validate_span!(section, span)
        validate_span_inside_section!(section, span)
        span.placements.each { |placement| validate_placement_inside_span!(span, placement) }
      end

      def validate_span_inside_section!(section, span)
        return if section.bars.cover?(span.bars.begin) && section.bars.cover?(span.bars.end)

        raise compile_error(
          code: "span_outside_section",
          message: span_outside_section_message(section, span),
          repair_instruction: "Keep span bars inside the containing section.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"]
        )
      end

      def span_outside_section_message(section, span)
        "Span bars #{span.bars.begin}-#{span.bars.end} are outside section #{section.id} " \
          "bars #{section.bars.begin}-#{section.bars.end}."
      end

      def validate_placement_inside_span!(span, placement)
        return if span.bars.cover?(placement.bar)

        raise compile_error(
          code: "placement_outside_span",
          message: placement_outside_span_message(span, placement),
          repair_instruction: "Move the placement into the containing span or place it in a span that covers that " \
                              "bar.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end

      def placement_outside_span_message(span, placement)
        "Placement #{placement.phrase_id} at bar #{placement.bar} is outside span bars " \
          "#{span.bars.begin}-#{span.bars.end}."
      end

      def validate_tempo_events!
        @tempo_events.each { |event| validate_ranged_reference!(event) }
      end

      def validate_key_changes!
        @key_changes.each { |key_change| offset_for_reference(key_change.at) }
      end

      def validate_controls!(events)
        @controls.each do |control|
          validate_ranged_reference!(control)
          validate_control_target!(control, events)
        end
      end

      def validate_ranged_reference!(event)
        if event.at
          offset_for_reference(event.at)
        else
          offset_for_reference(event.from)
          offset_for_reference(event.to)
        end
      end

      def validate_control_target!(control, events)
        unmatched = unmatched_control_selectors(control.target, events)
        return if unmatched.empty?

        raise compile_error(
          code: "unknown_control_target",
          message: "Control target #{unmatched.join(', ')} does not match any part, family, or role.",
          repair_instruction: "Use an existing part id, family, role, :all, or a list of those selectors.",
          help_topic: "controls",
          docs: ["docs/architecture/partitura/surfaces/controls.md"]
        )
      end

      def unmatched_control_selectors(target, events)
        return @parts.empty? ? ["all"] : [] if target == :all || target.to_s == "all"

        target_selectors(target).select { |selector| parts_matching_selector(selector, events).empty? }.map(&:to_s)
      end

      def target_selectors(target)
        target.is_a?(Array) ? target : [target]
      end

      def parts_matching_selector(selector, events)
        selector_text = selector.to_s
        direct_matches = direct_part_matches(selector_text)
        return direct_matches unless direct_matches.empty?

        role_part_matches(selector_text, events)
      end

      def direct_part_matches(selector_text)
        @parts.values.filter_map do |part|
          part.id if part_selector_values(part).include?(selector_text)
        end
      end

      def part_selector_values(part)
        [part.id, part.family, part.name].compact.map(&:to_s)
      end

      def role_part_matches(selector_text, events)
        events.filter_map do |event|
          event.part if event.role.to_s == selector_text && @parts.key?(event.part)
        end
      end
    end
  end
end
