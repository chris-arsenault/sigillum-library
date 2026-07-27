# frozen_string_literal: true

module Partitura
  module AnnotationObservation
    class S3 < Profile
      private

      def build
        downbeats = annotation_rows("s3_downbeats", numeric_keys: %w[onset])
        raise Error.new("empty_annotation_source", "S3 downbeat annotations are empty") if downbeats.empty?

        time_signatures = annotation_rows(
          "s3_time_signature",
          numeric_keys: %w[
            onset
            measure
            time_signature_numerator
            time_signature_denominator
          ]
        )
        raise Error.new("empty_annotation_source", "S3 time-signature annotations are empty") if time_signatures.empty?

        @time_shift = @index.measure_offsets.first - decimal(downbeats.first, "onset")
        segments = add_form_examples
        add_material_recurrence(segments)
        add_seam_examples(
          segments.drop(1).map do |segment|
            {
              offset: segment.fetch(:span).first,
              provenance: segment.fetch(:provenance)
            }
          end
        )
        add_cadence_examples
        add_harmony_examples
        add_orchestral_role_examples
        add_temporal_audits(downbeats, time_signatures)
      end

      def add_form_examples
        rows = annotation_rows(
          "s3_form",
          numeric_keys: ["phrase onset", "phrase offset"]
        )
        raise Error.new("empty_annotation_source", "S3 form annotations are empty") if rows.empty?

        rows.filter_map do |row|
          span = safe_span(
            row,
            shifted_decimal(row, "phrase onset"),
            shifted_decimal(row, "phrase offset")
          )
          next unless span

          features = @index.global_features(*span)
          section = canonical_label(text(row, "section"))
          theme = material_label(row)
          add_example(
            target: "form_section",
            label: section,
            scope: @index.scope(*span),
            features:,
            provenance: provenance(row),
            metadata: { material_label: theme }
          )
          {
            span:,
            label: theme,
            provenance: provenance(row)
          }
        end
      end

      def material_label(row)
        value = %w[theme part].filter_map do |key|
          candidate = row.fetch(:values)[key].to_s.strip
          candidate unless candidate.empty?
        end.first
        return canonical_label(value) if value

        add_warning(
          "missing_material_label",
          row,
          "form section retained without material-recurrence supervision"
        )
        nil
      end

      def add_cadence_examples
        annotation_rows(
          "s3_cadence",
          numeric_keys: %w[onset offset]
        ).each do |row|
          span = safe_span(row, shifted_decimal(row, "onset"), shifted_decimal(row, "offset"))
          next unless span

          start_q, end_q = span
          add_example(
            target: "cadence_type",
            label: canonical_label(text(row, "cadence type")),
            scope: @index.scope(start_q, end_q),
            features: @index.global_features(start_q, end_q),
            provenance: provenance(row),
            metadata: { resolve_ql: shifted_decimal(row, "resolve time") }
          )
        end
      end

      def add_harmony_examples
        annotation_rows(
          "s3_harmony",
          numeric_keys: %w[onset offset]
        ).each do |row|
          span = safe_span(row, shifted_decimal(row, "onset"), shifted_decimal(row, "offset"))
          next unless span

          start_q, end_q = span
          label = [
            canonical_label(text(row, "degree")),
            canonical_label(text(row, "quality")),
            canonical_label(text(row, "inversion"))
          ].join("|")
          add_example(
            target: "harmonic_function",
            label:,
            scope: @index.scope(start_q, end_q),
            features: @index.global_features(start_q, end_q),
            provenance: provenance(row),
            metadata: {
              key: text(row, "key"),
              roman_number: text(row, "roman number")
            }
          )
        end
      end

      def add_orchestral_role_examples
        annotation_rows(
          "s3_orchestral_texture",
          numeric_keys: %w[onset offset]
        ).each { |row| add_orchestral_role(row) }
      end

      def add_orchestral_role(row)
        span = safe_span(row, shifted_decimal(row, "onset"), shifted_decimal(row, "offset"))
        return unless span

        start_q, end_q = span
        instrument = File.basename(row.fetch(:source_path), ".csv")
        part = @index.resolve_part(instrument, start_q:, end_q:)
        add_part_resolution_warnings(row, instrument, part)
        add_example(
          target: "orchestral_role",
          label: canonical_role(text(row, "role")),
          scope: @index.scope(
            start_q,
            end_q,
            part_id: part.fetch(:part_id),
            staff: part.fetch(:staff)
          ),
          features: @index.part_features(
            start_q,
            end_q,
            part_id: part.fetch(:part_id),
            staff: part.fetch(:staff)
          ),
          provenance: provenance(row),
          metadata: {
            instrument:,
            candidate_count: part.fetch(:candidate_count, 1),
            tied_candidate_count: part.fetch(:tied_candidate_count, 1)
          }
        )
      end

      def add_part_resolution_warnings(row, instrument, part)
        if part.fetch(:collapsed_numbered_part, false)
          add_warning(
            "numbered_annotation_bound_to_combined_part",
            row,
            "#{instrument} was bound to combined score part #{part.fetch(:part_id)}"
          )
        end
        return unless part.fetch(:candidate_count, 1) > 1

        add_warning(
          "combined_part_resolved_by_activity",
          row,
          "#{instrument} selected #{part.fetch(:part_id)} staff #{part.fetch(:staff)} " \
          "from #{part.fetch(:candidate_count)} candidates " \
          "(#{part.fetch(:tied_candidate_count)} tied)"
        )
      end

      def add_temporal_audits(downbeats, time_signatures)
        @audits << downbeat_audit(downbeats)
        @audits << measure_count_audit
        @audits << time_signature_audit(time_signatures)
        @audits.reject { |audit| audit.fetch(:passed) }.each do |audit|
          add_warning(
            "s3_temporal_audit_failed",
            downbeats.first,
            "#{audit.fetch(:name)} expected #{audit.fetch(:expected)}, got #{audit.fetch(:actual)}; " \
            "first mismatch #{audit[:first_mismatch].inspect}"
          )
        end
      end

      def downbeat_audit(downbeats)
        expected = @index.measure_offsets
        actual = downbeats.map { |row| shifted_decimal(row, "onset") }
        {
          name: "s3_downbeats_match_score_measures",
          expected: expected.length,
          actual: actual.length,
          first_mismatch: first_mismatch(expected, actual),
          passed: actual == expected
        }
      end

      def measure_count_audit
        expected = @index.measure_offsets.length
        measure_count = Integer(File.read(@sources.one("s3_measure_count"), encoding: Encoding::UTF_8).strip)
        {
          name: "s3_measure_count_matches_score",
          expected:,
          actual: measure_count,
          passed: measure_count == expected
        }
      end

      def time_signature_audit(time_signatures)
        expected_meters = @index.meter_events
        actual_meters = time_signatures.map { |row| meter_from_annotation(row) }
        {
          name: "s3_time_signatures_match_score",
          expected: expected_meters.length,
          actual: actual_meters.length,
          first_mismatch: first_mismatch(expected_meters, actual_meters),
          passed: actual_meters == expected_meters
        }
      end

      def meter_from_annotation(row)
        {
          measure_index: Integer(text(row, "measure")),
          beats: Integer(text(row, "time_signature_numerator")).to_s,
          beat_type: Integer(text(row, "time_signature_denominator"))
        }
      end

      def first_mismatch(expected, actual)
        length = [expected.length, actual.length].max
        index = length.times.find { |candidate| expected[candidate] != actual[candidate] }
        return unless index

        {
          index:,
          expected: expected[index],
          actual: actual[index]
        }
      end

      def canonical_role(value)
        value.split("+").map { |role| canonical_label(role) }.sort.join("+")
      end
    end
  end
end
