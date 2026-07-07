# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Export
      module MusicXML
        module RenderedParts
          private

          def rendered_parts
            @rendered_parts ||= begin
              rendered = []
              state = rendered_part_group_state
              Array(@data["parts"]).each { |part| append_rendered_part(rendered, state, part) }
              rendered << notes_part if needs_notes_part?
              rendered
            end
          end

          def rendered_part_group_state
            groups = explicit_notation_groups
            {
              groups: groups,
              group_by_part: group_name_by_part(groups),
              rendered_groups: {}
            }
          end

          def append_rendered_part(rendered, state, part)
            group_name = state.fetch(:group_by_part)[part.fetch("id")]
            if group_name
              append_grand_staff_part(rendered, state, group_name)
            else
              rendered << single_staff_part(part)
            end
          end

          def append_grand_staff_part(rendered, state, group_name)
            return if state.fetch(:rendered_groups)[group_name]

            rendered << grand_staff_part(group_name, state.fetch(:groups).fetch(group_name))
            state.fetch(:rendered_groups)[group_name] = true
          end

          def group_name_by_part(groups)
            groups.each_with_object({}) do |(group_name, parts), out|
              parts.each { |part| out[part.fetch("id")] = group_name }
            end
          end

          def single_staff_part(part)
            part.merge("render_kind" => "single_staff", "staves" => 1, "source_parts" => [part])
          end

          def grand_staff_part(group_name, parts)
            first = parts.first
            first.merge(
              "id" => "__group__#{group_name}",
              "name" => grand_staff_display_name(group_name, parts),
              "music21_instrument" => "Piano",
              "render_kind" => "grand_staff",
              "staves" => 2,
              "source_parts" => parts
            )
          end

          def notes_part
            {
              "id" => NOTES_PART_ID,
              "name" => "Notes",
              "music21_instrument" => "Piano",
              "family" => "notes",
              "render_kind" => "notes",
              "staves" => 1,
              "source_parts" => []
            }
          end

          def explicit_notation_groups
            notation_groups.select { |_group_name, parts| two_staff_notation_group?(parts) }
          end

          def notation_groups
            Array(@data["parts"]).each_with_object({}) do |part, out|
              group_name = part["notation_group"]
              next unless group_name

              (out[group_name] ||= []) << part
            end
          end

          def two_staff_notation_group?(parts)
            staffs = parts.map { |part| normalize_notation_staff(part["notation_staff"]) }
            parts.length >= 2 && staffs.include?(1) && staffs.include?(2)
          end

          def grand_staff_voices(part)
            part.fetch("source_parts").flat_map do |source_part|
              source_part_voices(source_part)
            end
          end

          def source_part_voices(source_part)
            staff = normalize_notation_staff(source_part["notation_staff"])
            return auto_staff_voices(source_part) if staff == "auto"

            voice_base = staff == 1 ? 1 : 4
            voice_items_for_part(source_part.fetch("id"), staff: staff, voice_base: voice_base, tag_single_voice: true)
          end

          def auto_staff_voices(source_part)
            high, low = events_by_part.fetch(source_part.fetch("id"), []).partition do |event|
              auto_staff_for_event(event) == 1
            end
            [
              voice_items_from_events(
                source_part.fetch("id"), high, staff: 1, voice_base: 2,
                tag_single_voice: true, fill_gaps_override: :active_measures
              ),
              voice_items_from_events(
                source_part.fetch("id"), low, staff: 2, voice_base: 3,
                tag_single_voice: true, fill_gaps_override: :active_measures
              )
            ].flatten
          end

          def auto_staff_for_event(event)
            pitches = event_pitches(event)
            return 1 if pitches.empty?

            pitches.map { |value| pitch_midi(value) }.min < 60 ? 2 : 1
          end

          def normalize_notation_staff(value)
            normalized = value.to_s.strip.downcase
            return 2 if %w[2 lower bass left lh].include?(normalized)
            return "auto" if %w[auto split].include?(normalized)

            1
          end

          def grand_staff_display_name(group_name, parts)
            return "Piano" if parts.any? { |part| part.fetch("name").downcase.include?("piano") }

            group_name.to_s.split("_").map(&:capitalize).join(" ")
          end

          def needs_notes_part?
            text_controls.any?
          end

          def rendered_part_index(part)
            rendered_parts.index(part) || 0
          end

          def measure_directions(rendered_index, bar)
            directions_by_rendered_part_index.fetch(rendered_index).select do |event|
              event.fetch(:bar_number) == bar.fetch(:number)
            end
          end

          def note_candidates(rendered_index, staff: nil, sounding_only: false)
            rendered_part_voices(rendered_index).flat_map { |voice| voice.fetch(:bars).values.flatten }
              .select { |item| staff.nil? || item[:staff] == staff }
              .select { |item| !sounding_only || item.fetch(:pitches).any? }
              .sort_by { |item| [item_absolute_offset(item), item[:voice].to_i, item[:staff].to_i] }
          end

          def rendered_part_voices(rendered_index)
            @rendered_part_voice_cache ||= {}
            @rendered_part_voice_cache[rendered_index] ||=
              voices_for_rendered_part(rendered_parts.fetch(rendered_index))
          end

          def voices_for_rendered_part(part)
            case part.fetch("render_kind")
            when "grand_staff"
              grand_staff_voices(part)
            when "notes"
              []
            else
              single_staff_voices(part)
            end
          end

          def rendered_targets(target)
            selectors = rendered_target_selectors(target || { "type" => "all" })
            targets = selectors.flat_map { |selector| targets_for_selector(selector) }
            targets.uniq { |target| [target[:index], target[:staff]] }
          end

          def rendered_target_selectors(target)
            case target["type"]
            when "all"
              [:all]
            when "list"
              Array(target["selectors"])
            else
              [target["selector"]]
            end
          end

          def targets_for_selector(selector)
            return all_rendered_targets if selector == :all || selector.to_s == "all"

            rendered_parts.each_with_index.flat_map do |part, index|
              targets_for_rendered_part(part, index, selector.to_s)
            end
          end

          def all_rendered_targets
            rendered_parts.each_with_index.map { |_part, index| { index: index } }
          end

          def targets_for_rendered_part(part, index, selector)
            return [] if part.fetch("render_kind") == "notes"
            return [{ index: index }] if rendered_part_matches_selector?(part, selector)

            part.fetch("source_parts").filter_map do |source|
              source_target(source, part, index, selector)
            end
          end

          def rendered_part_matches_selector?(part, selector)
            [part["id"], part["name"], part["family"]].compact.map(&:to_s).include?(selector)
          end

          def source_target(source, part, index, selector)
            return nil unless source_matches_selector?(source, selector)

            staff = part.fetch("staves") == 2 ? normalize_notation_staff(source["notation_staff"]) : nil
            { index: index, staff: staff == "auto" ? nil : staff }
          end

          def source_matches_selector?(source, selector)
            values = [source["id"], source["name"], source["family"], source["notation_group"]].compact.map(&:to_s)
            values.include?(selector) || roles_by_part.fetch(source.fetch("id"), []).include?(selector)
          end

          def roles_by_part
            @roles_by_part ||= Array(@data["timed_events"]).each_with_object(Hash.new { |h, key|
 h[key] = [] }) do |event,
              out|
              out[event.fetch("part")] << event["role"].to_s if event["role"]
            end.transform_values(&:uniq)
          end
        end
      end
    end
  end
end
