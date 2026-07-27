# frozen_string_literal: true

module Partitura
  module AnnotationObservation
    class OpenScoreHauptstimme < Profile
      RELATION = /\A(U|P[2-8])\((.*)\)\z/

      private

      def build
        segments = prominent_segments
        add_prominent_examples(segments)
        add_material_recurrence(segments)
        add_seam_examples(
          segments.drop(1).map do |segment|
            {
              offset: segment.fetch(:span).first,
              provenance: segment.fetch(:provenance)
            }
          end
        )
        add_relation_examples
        @audits << {
          name: "openscore_hauptstimme_segment_count",
          actual: segments.length,
          passed: segments.any?
        }
      end

      def prominent_segments
        rows = annotation_rows(
          "hauptstimme_annotations",
          numeric_keys: %w[qstamp measure measure_fraction]
        )
        raise Error.new("empty_annotation_source", "Hauptstimme annotations are empty") if rows.empty?

        bound = rows.map { |row| bind_prominent_row(row) }
                    .sort_by { |item| item.fetch(:start_q) }
        starts = bound.map { |item| item.fetch(:start_q) }.uniq.sort
        bound.filter_map { |item| segment_from_bound_row(item, starts) }
      end

      def segment_from_bound_row(item, starts)
        following = starts.find { |start_q| start_q > item.fetch(:start_q) }
        span = safe_span(item.fetch(:row), item.fetch(:start_q), following || @index.duration)
        prominent_segment(item, span) if span
      end

      def bind_prominent_row(row)
        start_q = @index.measure_offset(
          text(row, "measure"),
          fraction: text(row, "measure_fraction")
        )
        part_name = row.fetch(:values).fetch("part", "").to_s.strip
        part = if part_name.empty?
                 @index.part_by_index(Integer(text(row, "part_num")))
               else
                 resolve_prominent_part(part_name, row, start_q)
               end
        warn_ambiguous_part(part, row, part_name) unless part_name.empty?
        events = @index.note_events_near(start_q, part_id: part.fetch(:part_id))
        if events.empty?
          raise Error.new(
            "unbound_hauptstimme_event",
            "no note for part #{part.fetch(:part_id)} at #{start_q}"
          )
        end
        {
          row:,
          start_q:,
          part:,
          events:
        }
      end

      def resolve_prominent_part(part_name, row, start_q)
        @index.resolve_part(
          part_name,
          start_q:,
          end_q: [start_q + 1r, @index.duration].min
        )
      rescue Error => error
        raise unless error.code == "unknown_annotation_part"

        @index.part_by_index(Integer(text(row, "part_num")))
      end

      def prominent_segment(item, span)
        row = item.fetch(:row)
        {
          span:,
          label: canonical_label(text(row, "label")),
          part: item.fetch(:part),
          event_ids: item.fetch(:events).map { |event| event.fetch("event_id") },
          provenance: provenance(row)
        }
      end

      def add_prominent_examples(segments)
        segments.each do |segment|
          start_q, end_q = segment.fetch(:span)
          part = segment.fetch(:part)
          scope = @index.scope(start_q, end_q, part_id: part.fetch(:part_id))
          scope[:annotation_event_ids] = segment.fetch(:event_ids)
          add_example(
            target: "prominent_part",
            label: part.fetch(:label),
            scope:,
            features: @index.part_features(start_q, end_q, part_id: part.fetch(:part_id)),
            provenance: segment.fetch(:provenance),
            metadata: { material_label: segment.fetch(:label) }
          )
        end
      end

      def add_relation_examples
        seen = {}
        annotation_rows(
          "part_relations",
          numeric_keys: %w[qstamp_start qstamp_end]
        ).each { |row| add_relation_row(row, seen) }
        @audits << {
          name: "openscore_unique_part_relations",
          actual: seen.length,
          passed: seen.any?
        }
      end

      def add_relation_row(row, seen)
        values = row.fetch(:values)
        span = safe_span(
          row,
          decimal(row, "qstamp_start"),
          decimal(row, "qstamp_end")
        )
        return unless span

        main_name = values.find { |_, value| value.to_s.strip == "Main Part" }&.first
        raise Error.new("missing_main_part", "part-relation row has no Main Part") unless main_name

        values.each do |part_name, cell|
          next if %w[qstamp_start qstamp_end].include?(part_name)

          add_cell_relations(
            row,
            { part_name:, cell:, main_name:, start_q: span.first, end_q: span.last },
            seen
          )
        end
      end

      def add_cell_relations(row, context, seen)
        part_name = context.fetch(:part_name)
        cell = context.fetch(:cell)
        return if cell.to_s.strip.empty? || cell.to_s.strip == "Main Part"

        start_q = context.fetch(:start_q)
        end_q = context.fetch(:end_q)
        left = @index.resolve_part(part_name, start_q:, end_q:)
        warn_ambiguous_part(left, row, part_name)
        cell.to_s.split("&").each do |token|
          match = RELATION.match(token.strip)
          raise Error.new("invalid_part_relation", "invalid relation token: #{token}") unless match

          other_name = match[2] == "Main" ? context.fetch(:main_name) : match[2]
          right = @index.resolve_part(other_name, start_q:, end_q:)
          warn_ambiguous_part(right, row, other_name)
          label = relation_label(match[1])
          key = relation_key(context, left, right, label)
          next if seen[key]

          seen[key] = true
          add_relation_example(row, context, left:, right:, label:)
        end
      end

      def warn_ambiguous_part(part, row, source_name)
        return unless part.fetch(:candidate_count, 1) > 1

        add_warning(
          "ambiguous_part_resolved_by_activity",
          row,
          "#{source_name} selected #{part.fetch(:part_id)} from " \
          "#{part.fetch(:candidate_count)} candidates (#{part.fetch(:tied_candidate_count)} tied)"
        )
      end

      def relation_key(context, left, right, label)
        [
          context.fetch(:start_q),
          context.fetch(:end_q),
          *[left.fetch(:part_id), right.fetch(:part_id)].sort,
          label
        ]
      end

      def add_relation_example(row, context, left:, right:, label:)
        start_q = context.fetch(:start_q)
        end_q = context.fetch(:end_q)
        add_example(
          target: "structural_part_relation",
          label:,
          scope: {
            span: @index.scope(start_q, end_q),
            left_part_id: left.fetch(:part_id),
            right_part_id: right.fetch(:part_id)
          },
          features: @index.pair_features(start_q, end_q, left:, right:),
          provenance: provenance(row)
        )
      end

      def relation_label(code)
        return "unison" if code == "U"
        return "parallel_octave" if code == "P8"

        "parallel_#{code.delete_prefix('P')}"
      end
    end
  end
end
