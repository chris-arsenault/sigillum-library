# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module SoundingReadout
        module ArticulationBreath
          ARTICULATION_MARKS = %w[
            stacc accent ten marc slur( slur) arp arp:up arp:down gliss( gliss) lv trill pizz
          ].freeze
          PRESENCE_MARKS = %w[stacc ten slur( accent marc arp arp:down gliss( lv].freeze

          def articulation_map(part: nil, bars: nil)
            lines = ["# Articulation Map (sounding)"]
            sounding_parts(part).each do |pname, events|
              selected = events.select { |event| in_bars?(event.offset, bars) }
              lines.concat(articulation_part_lines(pname, selected))
            end
            lines.join("\n")
          end

          def breath_map(part: nil, bars: nil)
            lines = ["# Breath Map (rests and breathless spans per part)"]
            breath_parts(part).each do |pname|
              lines.concat(breath_part_lines(pname, bars))
            end
            lines.join("\n")
          end

          private

          def articulation_part_lines(pname, events)
            census = articulation_census(events)
            lines = ["#{pname}: #{articulation_summary(census)}"]
            lines << "  slur lengths (notes:count): #{formatted_slur_lengths(events)}"
            lines.concat(articulation_presence_lines(events))
          end

          def articulation_census(events)
            marks = events.flat_map { |event| event.marks.map(&:to_s) }
            ARTICULATION_MARKS.to_h { |mark| [mark, marks.count(mark)] }
          end

          def articulation_summary(census)
            rolls = census.fetch("arp") + census.fetch("arp:up") + census.fetch("arp:down")
            [
              "stacc=#{census.fetch('stacc')}",
              "ten=#{census.fetch('ten')}",
              "accent=#{census.fetch('accent')}",
              "marc=#{census.fetch('marc')}",
              "slurs=#{balanced_mark_count(census, 'slur(', 'slur)')}",
              "arp=#{rolls}",
              "gliss=#{balanced_mark_count(census, 'gliss(', 'gliss)')}",
              "lv=#{census.fetch('lv')}",
              "trill=#{census.fetch('trill')}",
              "pizz=#{census.fetch('pizz')}"
            ].join(" ")
          end

          def balanced_mark_count(census, open_mark, close_mark)
            opens = census.fetch(open_mark)
            closes = census.fetch(close_mark)
            closes == opens ? opens.to_s : "#{opens} (UNBALANCED: #{closes} closes)"
          end

          def formatted_slur_lengths(events)
            lengths = slur_length_distribution(events)
            return "(none)" if lengths.empty?

            lengths.sort.map { |count, tally| "#{count}:#{tally}" }.join(" ")
          end

          def articulation_presence_lines(events)
            PRESENCE_MARKS.filter_map do |mark|
              bars = mark_presence_bars(events, mark)
              "  #{mark} presence: bars #{compress_ranges(bars)}" unless bars.empty?
            end
          end

          def mark_presence_bars(events, mark)
            events.select { |event| event.marks.map(&:to_s).include?(mark) }
                  .map { |event| bar_of(event.offset) }.uniq.sort
          end

          def breath_parts(part)
            part ? [part.to_sym] : @piece.parts.keys
          end

          def breath_part_lines(pname, bars)
            events = breath_events_for_part(pname, bars)
            lines = ["#{pname}: rest windows >= half-beat: #{rest_windows_text(events)}"]
            span_line = breathless_span_line(events)
            lines << span_line if span_line
            lines
          end

          def breath_events_for_part(pname, bars)
            @piece.timed_events(include_rests: true).select do |event|
              event.part == pname && in_bars?(event.offset, bars)
            end
          end

          def rest_windows_text(events)
            rests = events.select { |event| event.rest? && event.duration >= Rational(1, 2) }
            return "(NONE - every breath must be stolen)" if rests.empty?

            rests.map { |rest| "#{@piece.format_offset(rest.offset)} len #{Production.format_duration(rest.duration)}" }
                 .join("  ")
          end

          def breathless_span_line(events)
            top = breathless_spans(events).sort_by { |span| -span[2] }.first(3)
            return nil if top.empty?

            "  longest breathless spans: #{top.map { |start_bar, end_bar, duration|
              "bars #{start_bar}-#{end_bar} (#{Production.format_duration(duration)} ql)"
            }.join('  ')}"
          end
        end
      end
    end
  end
end
