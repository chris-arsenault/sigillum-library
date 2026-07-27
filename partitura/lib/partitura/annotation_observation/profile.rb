# frozen_string_literal: true

module Partitura
  module AnnotationObservation
    class Profile
      def initialize(index, sources)
        @index = index
        @sources = sources
        @examples = []
        @audits = []
        @warnings = []
      end

      def project
        build
        {
          examples: @examples.sort_by { |example| example.fetch(:example_id) },
          audits: @audits,
          warnings: @warnings.sort_by do |warning|
            [
              warning.fetch(:source_path),
              warning.fetch(:source_row),
              warning.fetch(:code),
              warning.fetch(:detail)
            ]
          end
        }
      end

      private

      def add_example(target:, label:, scope:, features:, provenance:, metadata: {})
        payload = {
          target: target.to_s,
          label: label.to_s,
          scope: scope,
          feature_names: features.fetch(:names),
          features: features.fetch(:values),
          provenance: provenance,
          metadata: metadata
        }
        digest = ScoreObservation::Canonical.digest(payload)
        @examples << payload.merge(example_id: "example:#{digest.delete_prefix('sha256:')[0, 24]}")
      end

      def provenance(row)
        {
          source_path: row.fetch(:source_path),
          source_row: row.fetch(:source_row)
        }
      end

      def decimal(row, key)
        Rational(row.fetch(:values).fetch(key).to_s)
      end

      def shifted_decimal(row, key)
        decimal(row, key) + @time_shift
      end

      def text(row, key)
        value = row.fetch(:values).fetch(key).to_s.strip
        raise Error.new("missing_annotation_value", "#{key} is empty at #{row.fetch(:source_path)}") if value.empty?

        value
      end

      def text_any(row, *keys)
        key = keys.find { |candidate| !row.fetch(:values)[candidate].to_s.strip.empty? }
        return text(row, key) if key

        raise Error.new(
          "missing_annotation_value",
          "#{keys.join(' or ')} is empty at #{row.fetch(:source_path)}"
        )
      end

      def annotation_rows(kind, numeric_keys:)
        @sources.csv_rows(kind).filter_map do |row|
          exclusion = annotation_row_exclusion(row, numeric_keys)
          if exclusion
            add_warning(exclusion.fetch(:code), row, exclusion.fetch(:detail))
            next
          end
          row
        end
      end

      def annotation_row_exclusion(row, numeric_keys)
        values = row.fetch(:values)
        return {
          code: "blank_annotation_row",
          detail: "row contains no annotation values"
        } if values.values.all? { |value| value.to_s.strip.empty? }
        return {
          code: "repeated_csv_header",
          detail: "concatenated CSV header was excluded"
        } if numeric_keys.any? { |key| values[key].to_s.strip.casecmp?(key) }

        numeric_keys.each { |key| Rational(values.fetch(key).to_s) }
        nil
      rescue ArgumentError, KeyError, ZeroDivisionError
        {
          code: "invalid_numeric_annotation",
          detail: "row has an invalid required numeric field: #{numeric_keys.join(', ')}"
        }
      end

      def safe_span(row, start_q, end_q)
        start_value = Rational(start_q.to_s)
        end_value = Rational(end_q.to_s)
        if end_value <= 0r || start_value >= @index.duration
          add_warning(
            "annotation_span_outside_score",
            row,
            "span #{start_value}-#{end_value} does not intersect 0-#{@index.duration}"
          )
          return
        end
        if end_value <= start_value
          add_warning(
            "invalid_annotation_span",
            row,
            "span end #{end_value} is not after start #{start_value}"
          )
          return
        end

        bounded = [[start_value, 0r].max, [end_value, @index.duration].min]
        return bounded if bounded == [start_value, end_value]

        add_warning(
          "annotation_span_clamped",
          row,
          "span #{start_value}-#{end_value} was clamped to #{bounded[0]}-#{bounded[1]}"
        )
        bounded
      end

      def add_warning(code, row, detail)
        @warnings << {
          code: code.to_s,
          source_path: row.fetch(:source_path),
          source_row: row.fetch(:source_row),
          detail: detail.to_s
        }
      end

      def canonical_label(value)
        value.to_s.strip.downcase.gsub(/\s+/, "_")
      end

      def add_material_recurrence(segments)
        segments.each_cons(2) do |left, right|
          next unless left[:label] && right[:label]

          features = @index.difference_features(left.fetch(:span), right.fetch(:span))
          scope = {
            left: @index.scope(*left.fetch(:span)),
            right: @index.scope(*right.fetch(:span))
          }
          add_example(
            target: "material_recurrence",
            label: left.fetch(:label) == right.fetch(:label) ? "same" : "different",
            scope:,
            features:,
            provenance: right.fetch(:provenance),
            metadata: {
              left_material: left.fetch(:label),
              right_material: right.fetch(:label)
            }
          )
        end
      end

      def add_seam_examples(boundaries)
        positive_records = boundaries.group_by { |boundary| Rational(boundary.fetch(:offset).to_s) }
                                     .transform_values(&:first)
        positives = positive_records.keys.sort
        candidates = @index.measure_offsets.drop(1).reject { |offset| positives.include?(offset) }
        positives.each do |offset|
          add_seam_example(offset, "boundary", positive_records.fetch(offset).fetch(:provenance))
        end
        candidates.each do |offset|
          add_seam_example(
            offset,
            "continuation",
            { source_path: "derived:score_measure_timeline", source_row: 0 }
          )
        end
      end

      def add_seam_example(offset, label, source)
        return if offset <= 0r || offset >= @index.duration

        add_example(
          target: "seam_boundary",
          label:,
          scope: {
            offset_ql: offset,
            measure_index: @index.scope(offset, [offset + Rational(1, 1_000_000), @index.duration].min)
                                         .fetch(:start_measure_index)
          },
          features: @index.boundary_features(offset),
          provenance: source
        )
      end
    end
  end
end
