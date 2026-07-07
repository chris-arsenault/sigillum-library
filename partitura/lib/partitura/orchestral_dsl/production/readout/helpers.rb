# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class Readout
        module Helpers
          private

        def last_bar_number
          bar = 1
          bar += 1 while @piece.offset_for(bar + 1, 1) < @piece.total_duration
          bar
        end

        def each_span(bars: nil)
          @piece.sections.each do |section|
            section.spans.each do |span|
              next unless range_intersects?(span.bars, bars)

              yield section, span
            end
          end
        end

        def matching_events(bars:, roles:)
          @piece.timed_events.select do |event|
            !event.rest? && in_bars?(event.offset, bars) && role_named?(event.role, *roles)
          end
        end

        def harmony_at(offset)
          contexts = []
          each_span do |_section, span|
            next if span.harmony_texts.empty?

            start_offset = @piece.offset_for(span.bars.begin, 1)
            end_offset = @piece.offset_for(span.bars.end + 1, 1)
            contexts.concat(span.harmony_texts) if offset >= start_offset && offset < end_offset
          end
          contexts.empty? ? "(none)" : contexts.join(" / ")
        end

        def append_gesture(lines, gesture, location)
          lines << ""
          lines << "#{location} | #{gesture.id}"
          lines << "  idea: #{gesture.idea_text}" if gesture.idea_text
          append_gesture_texts(lines, gesture)
          append_gesture_relations(lines, gesture)
          lines << "  mechanism: not written yet" unless gesture.supported?
        end

        def append_gesture_texts(lines, gesture)
          {
            mechanism: gesture.mechanism_texts,
            audible: gesture.audible_texts,
            orchestration: gesture.orchestration_texts,
            silence: gesture.silence_texts,
            note: gesture.note_texts
          }.each do |label, texts|
            texts.each { |text| lines << "  #{label}: #{text}" }
          end
        end

        def append_gesture_relations(lines, gesture)
          gesture.line_relations.each do |relation|
            lines << "  relation #{relation[:left]} <-> #{relation[:right]}: #{relation[:text]}"
          end
        end

        def role_named?(role, *names)
          role_text = role.to_s
          tokens = role_text.split(/[_-]/)
          names.any? do |name|
            name_text = name.to_s
            role_text == name_text || tokens.include?(name_text)
          end
        end

        def in_bars?(offset, bars)
          return true unless bars

          bar = (offset / @piece.bar_length).floor + 1
          bars.include?(bar)
        end

        def in_bars_number?(number, bars)
          !bars || bars.include?(number)
        end

        def range_intersects?(left, right)
          return true unless right
          return right.any? { |n| left.cover?(n) } if right.is_a?(Array)

          left.begin <= right.end && right.begin <= left.end
        end
        end
      end
    end
  end
end
