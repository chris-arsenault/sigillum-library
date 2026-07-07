# frozen_string_literal: true

module Partitura
  module Production
    module SoundingReadout
      module RhythmProfile
        private

        def rhythm_profile(part: nil, bars: nil)
          lines = ["# Rhythm Profile (sounding; durations are true/tie-merged event lengths)"]
          sounding_parts(part).each do |pname, evs|
            lines.concat(rhythm_part_lines(pname, evs.select { |e| in_bars?(e.offset, bars) }))
          end
          lines.join("\n")
        end

        def rhythm_part_lines(pname, events)
          return ["#{pname}: (no notes)"] if events.empty?

          ["#{pname}: duration histogram: #{duration_histogram(events)}"] + rhythm_section_lines(events)
        end

        def duration_histogram(events)
          events.map(&:duration).tally.sort_by { |duration, _| duration }
                .map { |duration, count| "#{Production.format_duration(duration)}:#{count}" }
                .join(" ")
        end

        def rhythm_section_lines(events)
          @piece.sections.filter_map do |section|
            section_events = events.select { |event| section.bars.cover?(bar_of(event.offset)) }
            rhythm_section_line(section, section_events) unless section_events.empty?
          end
        end

        def rhythm_section_line(section, events)
          counts = rhythm_duration_counts(events)
          total = events.size.to_f
          "  #{section.id} (#{section.bars.begin}-#{section.bars.end}): " \
            "<8th #{pct(counts.fetch(:fast), total)}  8th #{pct(counts.fetch(:eighth), total)}  " \
            ">8th-to-quarter #{pct(counts.fetch(:mid), total)}  longer #{pct(counts.fetch(:long), total)}"
        end

        def rhythm_duration_counts(events)
          {
            fast: events.count { |event| event.duration < Rational(1, 2) },
            eighth: events.count { |event| event.duration == Rational(1, 2) },
            mid: events.count { |event| event.duration > Rational(1, 2) && event.duration <= 1 },
            long: events.count { |event| event.duration > 1 }
          }
        end
      end
    end
  end
end
