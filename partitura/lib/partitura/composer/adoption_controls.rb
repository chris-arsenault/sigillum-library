# frozen_string_literal: true

module Partitura
  module Composer
    module AdoptionControls
      def controls(section)
        values = meter_controls(section) + key_controls(section) +
                 tempo_controls(section) + expressive_controls(section)
        values.map.with_index { |value, index| { "id" => "control_#{index + 1}", **value } }
      end

      def meter_controls(section)
        @piece.meter_timeline.filter_map do |event|
          next unless section.bars.cover?(event.bar) && event.bar != section.bars.begin

          { "kind" => "meter", "value" => event.meter,
            "at" => "bar #{event.bar - section.bars.begin + 1} beat 1", "beat_pattern" => event.beat_pattern }.compact
        end
      end

      def key_controls(section)
        @piece.key_changes.filter_map do |event|
          next unless belongs?(event.at, section) && @piece.bar_of_reference(event.at) != section.bars.begin

          { "kind" => "key", "value" => event.key, "at" => local(event.at, section) }
        end
      end

      def tempo_controls(section)
        @piece.tempo_events.filter_map do |event|
          next unless belongs?(event.at || event.from, section)
          next if opening_mark?(event, section)

          value = { "kind" => event.kind == :mark ? "tempo" : event.kind.to_s }
          value["value"] = event.text if event.kind == :mark
          value.merge(local_locations(event, section))
        end
      end

      def opening_mark?(event, section)
        event.kind == :mark && @piece.offset_for_reference(event.at) == @piece.offset_for(section.bars.begin, 1)
      end

      def expressive_controls(section)
        @piece.controls.filter_map do |control|
          next unless belongs?(control.at || control.from, section)

          expressive_fields(control).merge(local_locations(control, section))
        end
      end

      def expressive_fields(control)
        value = { "kind" => control.kind == :chord_symbol ? "chord" : control.kind.to_s,
                  "value" => control.value&.to_s, "exact" => control.exact }.compact
        value["for"] = target_text(control.target) unless control.kind == :chord_symbol
        value
      end

      def target_text(target)
        target.is_a?(Array) ? target.map(&:to_s) : target.to_s
      end

      def local_locations(value, section)
        %i[at from to].each_with_object({}) do |field, result|
          reference = value.public_send(field)
          result[field.to_s] = local(reference, section) if reference
        end
      end

      def belongs?(reference, section)
        reference && section.bars.cover?(@piece.bar_of_reference(reference))
      end

      def local(reference, section)
        bar, beat = Production.parse_location(reference)
        "bar #{bar - section.bars.begin + 1} beat #{beat}"
      end
    end
  end
end
