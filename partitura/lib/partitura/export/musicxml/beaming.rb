# frozen_string_literal: true

module Partitura
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
          tuplet_index_groups(items).each { |group| apply_tuplet_group!(items, group) }
        end

        def beam_index_groups(items, bar)
          consecutive_index_groups(items) do |item|
            beammable_item?(item) ? beam_group_for(item, bar) : nil
          end
        end

        def tuplet_index_groups(items)
          consecutive_index_groups(items) { |item| tuplet_signature(item.fetch(:duration)) ? :tuplet : nil }
            .flat_map { |indexes| split_tuplet_index_group(items, indexes) }
        end

        def split_tuplet_index_group(items, indexes)
          beat_groups = beat_tuplet_index_groups(items, indexes)
          return beat_groups if beat_groups

          same_duration_tuplet_index_groups(items, indexes)
        end

        def beat_tuplet_index_groups(items, indexes)
          groups = []
          current = []
          total = Rational(0)
          indexes.each do |index|
            current << index
            total += items.fetch(index).fetch(:duration)
            return nil if total > 1
            next unless total == 1

            groups << { indexes: current, normal_type: "eighth" }
            current = []
            total = Rational(0)
          end
          current.empty? ? groups : nil
        end

        def same_duration_tuplet_index_groups(items, indexes)
          same_duration_index_runs(items, indexes)
            .flat_map do |same_duration_indexes|
              same_duration_indexes.each_slice(3).filter_map do |slice|
                next unless slice.length == 3

                { indexes: slice, normal_type: tuplet_signature(items.fetch(slice.first).fetch(:duration))
                  .fetch(:normal_type) }
              end
            end
        end

        def same_duration_index_runs(items, indexes)
          runs = []
          current = []
          current_signature = nil
          indexes.each do |index|
            signature = tuplet_signature(items.fetch(index).fetch(:duration))
            runs << current if current.any? && signature != current_signature
            current = signature == current_signature ? current + [index] : [index]
            current_signature = signature
          end
          runs << current if current.any?
          runs
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

        def apply_tuplet_group!(items, group)
          indexes = group.fetch(:indexes)
          indexes.each { |index| items.fetch(index)[:tuplet_normal_type] = group.fetch(:normal_type) }
          if indexes.length == 1
            items.fetch(indexes.first)[:tuplet] = :start_stop
          else
            items.fetch(indexes.first)[:tuplet] = :start
            items.fetch(indexes.last)[:tuplet] = :stop
          end
        end

        def beammable_item?(item)
          return false if item[:tie]

          item.fetch(:pitches).any? && beam_count(item.fetch(:duration)).positive?
        end

        def beam_group_for(item, bar)
          group_lengths = beat_group_lengths(bar)
          return proportional_beam_group(item, group_lengths) if group_lengths.any?

          group_length = beam_group_length(bar.fetch(:meter))
          (item.fetch(:local_offset) / group_length).floor
        end

        def proportional_beam_group(item, group_lengths)
          cursor = Rational(0)
          group_lengths.each_with_index do |length, index|
            cursor += length
            return index if item.fetch(:local_offset) < cursor
          end
          group_lengths.length - 1
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
