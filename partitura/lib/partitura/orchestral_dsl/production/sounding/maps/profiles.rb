# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module SoundingReadout
        module Profiles
          def bar_profile(part: nil, bars: nil)
            lines = ["# Bar Profile (sounding; per-bar pitches, rhythm, contour, band, pitch classes)"]
            sounding_parts(part).each do |pname, events|
              lines.concat(bar_profile_part_lines(pname, events, bars))
            end
            lines.join("\n")
          end

          def figure_timeline(part: nil, bars: nil)
            lines = [
              "# Figure Timeline (per-bar: rhythm-class letter + contour + register width; the anti-block scanner)"
            ]
            sounding_parts(part).each do |pname, events|
              lines.concat(figure_timeline_part_lines(pname, events, bars))
            end
            lines.join("\n")
          end

          private

          def bar_profile_part_lines(pname, events, bars)
            events.group_by { |event| bar_of(event.offset) }
                  .sort
                  .filter_map { |bar, seq| bar_profile_lines(pname, bar, seq, bars) }
                  .flatten
          end

          def bar_profile_lines(pname, bar, events, bars)
            return nil unless in_bar_number?(bar, bars)

            seq = events.sort_by(&:offset)
            midis = seq.flat_map { |event| event.pitches.map { |pitch| midi_of(pitch) } }
            [
              "b#{bar} [#{pname}] #{seq.map(&:pitch_label).join(' ')}",
              "  rhythm: #{rhythm_text(seq)} | #{bar_profile_stats(seq, midis)}"
            ]
          end

          def rhythm_text(events)
            events.map { |event| Production.format_duration(event.duration) }.join(" ")
          end

          def bar_profile_stats(seq, midis)
            pcs = midis.map { |midi| PC_NAMES[midi % 12] }.uniq.join(",")
            "contour: #{contour_of(midis)} | band: #{label_of(midis.min)}-#{label_of(midis.max)} " \
              "(#{midis.max - midis.min} semis) | pcs {#{pcs}} | attacks #{seq.size}"
          end

          def figure_timeline_part_lines(pname, events, bars)
            labels, classes = figure_labels_by_bar(events, bars)
            return [] if labels.empty?

            [
              "#{pname}: #{labels.keys.sort.map { |bar| "#{bar}:#{labels[bar]}" }.join(' ')}",
              figure_timeline_summary(labels, classes),
              "  rhythm-class legend: #{rhythm_class_legend(classes)}"
            ]
          end

          def figure_labels_by_bar(events, bars)
            classes = {}
            labels = {}
            events.group_by { |event| bar_of(event.offset) }.sort.each do |bar, seq|
              next unless in_bar_number?(bar, bars)

              labels[bar] = figure_label(seq.sort_by(&:offset), classes)
            end
            [labels, classes]
          end

          def figure_label(seq, classes)
            durations = seq.map(&:duration)
            classes[durations] ||= ((classes.size % 26) + 97).chr
            "#{classes[durations]}#{contour_of(figure_midis(seq))}#{register_width(seq)}"
          end

          def figure_midis(seq)
            seq.flat_map { |event| event.pitches.map { |pitch| midi_of(pitch) } }
          end

          def register_width(seq)
            midis = figure_midis(seq)
            span = midis.max - midis.min
            return "W" if span >= 19
            return "w" if span >= 12

            ""
          end

          def figure_timeline_summary(labels, classes)
            ordered = labels.keys.sort.map { |bar| labels[bar] }
            rhythm_only = ordered.map { |label| label[0] }
            "  longest identical-figure run: #{longest_run(ordered)} | " \
              "longest same-rhythm run: #{longest_run(rhythm_only)} | rhythm classes: #{classes.size}"
          end

          def rhythm_class_legend(classes)
            classes.map do |durations, letter|
              "#{letter}=[#{durations.map { |duration| Production.format_duration(duration) }.join(' ')}]"
            end.join("  ")
          end
        end
      end
    end
  end
end
