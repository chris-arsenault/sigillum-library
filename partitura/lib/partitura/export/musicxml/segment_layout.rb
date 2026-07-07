# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module SegmentLayout
        private

        def append_segments(items, offset, duration, pitches, marks, staff: nil, voice: nil)
          return unless duration.positive?

          segments = segment_fragments(offset, duration, rest: pitches.empty?)
          base = { duration: duration, pitches: pitches, marks: marks, staff: staff, voice: voice }
          segments.each_with_index do |segment, index|
            append_segment_item(items, base.merge(segment: segment, index: index, segment_count: segments.length))
          end
        end

        def segment_fragments(offset, duration, rest:)
          source_segments = bar_segments(offset, duration)
          source_segments.each_with_index.flat_map do |segment, bar_segment_index|
            split_bar_segment(segment, bar_segment_index, source_segments.length, rest: rest)
          end
        end

        def split_bar_segment(segment, bar_segment_index, bar_segment_count, rest:)
          measure_rest = measure_rest_segment?(segment, rest)
          prior = Rational(0)
          duration_splits(segment.fetch(:duration), measure_rest: measure_rest).map do |split_duration|
            local_offset = segment.fetch(:local_offset) + prior
            prior += split_duration
            segment.merge(
              local_offset: local_offset,
              duration: split_duration,
              measure_rest: measure_rest,
              bar_segment_index: bar_segment_index,
              bar_segment_count: bar_segment_count
            )
          end
        end

        def measure_rest_segment?(segment, rest)
          rest &&
            segment.fetch(:local_offset).zero? &&
            segment.fetch(:duration) == bar_layout.fetch(segment.fetch(:bar_number) - 1).fetch(:length)
        end

        def append_segment_item(items, context)
          structural_tie = structural_tie?(context)
          tie_types = segment_tie_types(context, structural_tie)
          items << segment_item(context, tie_types, structural_tie)
        end

        def structural_tie?(context)
          context.fetch(:pitches).any? && context.fetch(:segment).fetch(:bar_segment_count) > 1
        end

        def segment_tie_types(context, structural_tie)
          tie_types = automatic_tie_types(context, structural_tie)
          tie_types.concat(authored_tie_types(context))
          tie_types.uniq
        end

        def automatic_tie_types(context, structural_tie)
          return [] unless structural_tie || tied_decomposition?(context)

          tie_types = []
          tie_types << "stop" if context.fetch(:index).positive?
          tie_types << "start" if segment_start_tie?(context, structural_tie)
          tie_types
        end

        def authored_tie_types(context)
          marks = context.fetch(:marks)
          index = context.fetch(:index)
          count = context.fetch(:segment_count)
          tie_types = []
          if marks.include?("tie)")
            tie_types << "stop"
            tie_types << "start" if index < count - 1
          end
          if marks.include?("tie(")
            tie_types << "stop" if index.positive?
            tie_types << "start"
          end
          tie_types
        end

        def tied_decomposition?(context)
          context.fetch(:pitches).any? &&
            !duration_type_exact?(context.fetch(:duration)) &&
            context.fetch(:duration) >= Rational(2)
        end

        def segment_start_tie?(context, structural_tie)
          context.fetch(:index) < context.fetch(:segment_count) - 1 &&
            (structural_tie || !context.fetch(:marks).include?("lv"))
        end

        def segment_item(context, tie_types, structural_tie)
          segment = context.fetch(:segment)
          {
            bar_number: segment.fetch(:bar_number),
            local_offset: segment.fetch(:local_offset),
            duration: segment.fetch(:duration),
            pitches: context.fetch(:pitches),
            marks: marks_for_segment(context.fetch(:marks), context.fetch(:index), context.fetch(:segment_count)),
            tie: tie_types.first,
            ties: tie_types,
            structural_tie: structural_tie,
            staff: context.fetch(:staff),
            voice: context.fetch(:voice),
            measure_rest: segment.fetch(:measure_rest)
          }
        end

        def duration_splits(duration, measure_rest:)
          return [duration] if measure_rest
          return [duration] if duration_type_exact?(duration)

          remaining = duration
          values = [
            Rational(4),
            Rational(2),
            Rational(3, 2),
            Rational(1),
            Rational(3, 4),
            Rational(1, 2),
            Rational(1, 4),
            Rational(1, 8),
            Rational(1, 16)
          ]
          out = []
          while remaining.positive?
            value = values.find { |candidate| candidate <= remaining } || remaining
            out << value
            remaining -= value
          end
          out
        end

        def duration_type_exact?(duration)
          duration_type(duration).last != :fallback
        end

        def full_bar_rest_item(bar)
          {
            bar_number: bar.fetch(:number),
            local_offset: Rational(0),
            duration: bar.fetch(:length),
            pitches: [],
            marks: [],
            tie: nil,
            measure_rest: true
          }
        end

        def render_backup(xml, duration)
          xml.open("backup")
          xml.element("duration", duration_units(duration).to_s)
          xml.close("backup")
        end

        def bar_segments(offset, duration)
          segments = []
          remaining = duration
          cursor = offset
          while remaining.positive?
            bar = bar_at_offset(cursor)
            raise Error, "event offset #{cursor.to_f} falls outside score duration" unless bar

            local_offset = cursor - bar.fetch(:start)
            length = [remaining, bar.fetch(:length) - local_offset].min
            segments << {
              bar_number: bar.fetch(:number),
              local_offset: local_offset,
              duration: length
            }
            cursor += length
            remaining -= length
          end
          segments
        end
      end
    end
  end
end
