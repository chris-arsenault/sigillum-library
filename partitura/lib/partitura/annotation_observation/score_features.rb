# frozen_string_literal: true

module Partitura
  module AnnotationObservation
    module ScoreFeatures
      FEATURE_SCALE = 1_000_000
      GLOBAL_FEATURE_NAMES = [
        "duration_ql",
        "pitched_event_density",
        "rest_event_density",
        "active_part_fraction",
        "mean_midi",
        "midi_range",
        *12.times.map { |pitch_class| "pitch_class_#{pitch_class}" }
      ].freeze

      def global_features(start_q, end_q)
        feature_payload(start_q, end_q)
      end

      def part_features(start_q, end_q, part_id:, staff: nil)
        part = feature_payload(start_q, end_q, part_id:, staff:)
        ensemble = feature_payload(start_q, end_q)
        {
          names: [
            *part.fetch(:names).map { |name| "part_#{name}" },
            *ensemble.fetch(:names).map { |name| "ensemble_#{name}" }
          ],
          values: [*part.fetch(:values), *ensemble.fetch(:values)]
        }
      end

      def pair_features(start_q, end_q, left:, right:)
        left_features = part_features(
          start_q,
          end_q,
          part_id: left.fetch(:part_id),
          staff: left[:staff]
        )
        right_features = part_features(
          start_q,
          end_q,
          part_id: right.fetch(:part_id),
          staff: right[:staff]
        )
        difference = left_features.fetch(:values).zip(right_features.fetch(:values)).map do |a, b|
          (a - b).abs
        end
        {
          names: [
            *left_features.fetch(:names).map { |name| "left_#{name}" },
            *right_features.fetch(:names).map { |name| "right_#{name}" },
            *left_features.fetch(:names).map { |name| "delta_#{name}" }
          ],
          values: [*left_features.fetch(:values), *right_features.fetch(:values), *difference]
        }
      end

      def boundary_features(offset, window: 8r)
        point = rational(offset)
        left_start = [0r, point - window].max
        right_end = [@duration, point + window].min
        left = global_features(left_start, point)
        right = global_features(point, right_end)
        difference = left.fetch(:values).zip(right.fetch(:values)).map { |a, b| (a - b).abs }
        {
          names: [
            *left.fetch(:names).map { |name| "left_#{name}" },
            *right.fetch(:names).map { |name| "right_#{name}" },
            *left.fetch(:names).map { |name| "delta_#{name}" }
          ],
          values: [*left.fetch(:values), *right.fetch(:values), *difference]
        }
      end

      def difference_features(left_span, right_span)
        left = global_features(*left_span)
        right = global_features(*right_span)
        {
          names: left.fetch(:names).map { |name| "delta_#{name}" },
          values: left.fetch(:values).zip(right.fetch(:values)).map { |a, b| (a - b).abs }
        }
      end

      private

      def feature_payload(start_q, end_q, part_id: nil, staff: nil)
        start_value, end_value = validate_span(start_q, end_q)
        key = [start_value, end_value, part_id, staff]
        @feature_cache[key] ||= calculate_features(
          start_value,
          end_value,
          part_id:,
          staff:
        )
      end

      def calculate_features(start_value, end_value, part_id:, staff:)
        duration = (end_value - start_value).to_f
        events = events_in(start_value, end_value, part_id:, staff:)
        pitched = events.filter_map { |event| event["midi"]&.to_f }
        rests = events.count { |event| event.fetch("kind") == "rest" }
        active_parts = events.filter_map { |event| event["midi"] && event.fetch("part_id") }.uniq.length
        values = [
          duration,
          density(pitched.length, duration),
          density(rests, duration),
          active_parts.to_f / @parts.length,
          *pitch_statistics(pitched)
        ]
        {
          names: GLOBAL_FEATURE_NAMES,
          values: values.map { |value| (value * FEATURE_SCALE).round }.freeze
        }.freeze
      end

      def pitch_statistics(pitched)
        return [0.0, 0.0, *Array.new(12, 0.0)] if pitched.empty?

        histogram = Array.new(12, 0.0)
        pitched.each { |midi| histogram[midi.to_i % 12] += 1.0 }
        histogram.map! { |count| count / pitched.length }
        [pitched.sum / pitched.length, pitched.max - pitched.min, *histogram]
      end

      def density(count, duration)
        duration.zero? ? 0.0 : count.to_f / duration
      end
    end
  end
end
