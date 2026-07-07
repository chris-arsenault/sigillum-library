# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Export
      module MIDI
        module Notation
          private

          def parts
            Array(@data["parts"])
          end

          def desired_track_count
            [parts.length, rendered_musicxml_part_count].max + 1
          end

          def rendered_musicxml_part_count
            rendered_part_count + (needs_notes_part? ? 1 : 0)
          end

          def rendered_part_count
            grouped_parts = explicit_notation_groups.values.flatten.map { |part| part.fetch("id") }
            rendered_groups = {}
            parts.count do |part|
              render_part_track?(part, grouped_parts, rendered_groups)
            end
          end

          def render_part_track?(part, grouped_parts, rendered_groups)
            group = part["notation_group"]
            return true unless group && grouped_parts.include?(part.fetch("id"))
            return false if rendered_groups[group]

            rendered_groups[group] = true
          end

          def explicit_notation_groups
            notation_groups.select do |_group_name, group_parts|
              two_staff_notation_group?(group_parts)
            end
          end

          def notation_groups
            parts.each_with_object({}) do |part, out|
              group_name = part["notation_group"]
              next unless group_name

              (out[group_name] ||= []) << part
            end
          end

          def two_staff_notation_group?(group_parts)
            staffs = group_parts.map { |part| normalize_notation_staff(part["notation_staff"]) }
            group_parts.length >= 2 && staffs.include?(1) && staffs.include?(2)
          end

          def normalize_notation_staff(value)
            normalized = value.to_s.strip.downcase
            return 2 if %w[2 lower bass left lh].include?(normalized)
            return "auto" if %w[auto split].include?(normalized)

            1
          end

          def needs_notes_part?
            Array(@data["controls"]).any? { |control| control["kind"] == "text" }
          end
        end
      end
    end
  end
end
