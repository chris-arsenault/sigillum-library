# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Export
      module MusicXML
        module Beaming
          private

          def prepare_measure_beams(items, bar)
            prepared = items.map(&:dup)
            prepare_measure_tuplets(prepared)
            beam_index_groups(prepared, bar).each { |indexes| apply_beam_group!(prepared, indexes) }
            prepared
          end

          def prepare_measure_tuplets(items)
            tuplet_index_groups(items).each { |indexes| apply_tuplet_group!(items, indexes) }
          end

          def beam_index_groups(items, bar)
            consecutive_index_groups(items) do |item|
              beammable_item?(item) ? beam_group_for(item, bar) : nil
            end
          end

          def tuplet_index_groups(items)
            consecutive_index_groups(items) { |item| tuplet_signature(item.fetch(:duration)) }
          end

          def consecutive_index_groups(items)
            groups = []
            current = []
            current_signature = nil
            items.each_with_index do |item, index|
              signature = yield(item)
              groups << current if current.any? && signature != current_signature
              current = signature ? next_group_indexes(current, index, signature == current_signature) : []
              current_signature = signature
            end
            groups << current if current.any?
            groups
          end

          def next_group_indexes(current, index, same_signature)
            same_signature ? current + [index] : [index]
          end

          def apply_beam_group!(items, indexes)
            return if indexes.length < 2

            indexes.each_with_index do |item_index, group_index|
              items.fetch(item_index)[:beams] = beam_values_for_group(items, indexes, group_index)
            end
          end

          def apply_tuplet_group!(items, indexes)
            indexes.each_slice(3) do |slice|
              next unless slice.length == 3

              items.fetch(slice.first)[:tuplet] = :start
              items.fetch(slice.last)[:tuplet] = :stop
            end
          end

          def beammable_item?(item)
            return false if item[:tie]

            item.fetch(:pitches).any? && beam_count(item.fetch(:duration)).positive?
          end

          def beam_group_for(item, bar)
            group_length = beam_group_length(bar.fetch(:meter))
            (item.fetch(:local_offset) / group_length).floor
          end

          def beam_group_length(meter)
            beats, beat_type = parse_meter(meter)
            return Rational(3, 2) if beat_type == 8 && (beats % 3).zero?

            Rational(1)
          end

          def beam_values_for_group(items, indexes, group_index)
            item = items.fetch(indexes.fetch(group_index))
            max_count = beam_count(item.fetch(:duration))
            (1..max_count).filter_map do |level|
              value = beam_value_for_level(items, indexes, group_index, level)
              [level, value] if value
            end
          end

          def beam_value_for_level(items, indexes, group_index, level)
            previous_has, next_has = beam_neighbors(items, indexes, group_index, level)
            connected = connected_beam_value(previous_has, next_has)
            return connected if connected
            return hook_value(group_index, indexes.length) if level > 1

            nil
          end

          def beam_neighbors(items, indexes, group_index, level)
            [
              group_index.positive? && adjacent_beam?(items, indexes, group_index - 1, level),
              group_index < indexes.length - 1 && adjacent_beam?(items, indexes, group_index + 1, level)
            ]
          end

          def connected_beam_value(previous_has, next_has)
            return "continue" if previous_has && next_has
            return "begin" if next_has
            return "end" if previous_has

            nil
          end

          def adjacent_beam?(items, indexes, group_index, level)
            beam_count(items.fetch(indexes.fetch(group_index)).fetch(:duration)) >= level
          end

          def hook_value(group_index, group_length)
            group_index < group_length - 1 ? "forward hook" : "backward hook"
          end
        end
      end
    end
  end
end
