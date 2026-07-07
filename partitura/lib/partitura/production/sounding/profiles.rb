# frozen_string_literal: true

require_relative "profiles/rhythm"

module Partitura
  module Production
    module SoundingReadout
      module Profiles
        include RhythmProfile

        def adjacency_profile(part: nil, bars: nil)
          lines = ["# Adjacency Profile (sounding)"]
          sounding_parts(part).each do |pname, evs|
            lines.concat(adjacency_part_lines(pname, evs.select { |e| in_bars?(e.offset, bars) }))
          end
          lines.join("\n")
        end

        def adjacency_part_lines(pname, events)
          midis = events.flat_map { |event| event.pitches.map { |pitch| midi_of(pitch) } }
          return ["#{pname}: (no notes)"] if midis.size < 2

          intervals = midis.each_cons(2).map { |a, b| (b - a).abs }
          [
            adjacency_summary_line(pname, midis, intervals),
            top_pitch_class_line(midis),
            interval_histogram_line(intervals)
          ]
        end

        def adjacency_summary_line(pname, midis, intervals)
          total = intervals.size.to_f
          "#{pname}: notes=#{midis.size} repeated=#{pct(intervals.count(0), total)} " \
            "step=#{pct(intervals.count { |i| (1..2).cover?(i) }, total)} " \
            "skip=#{pct(intervals.count { |i| (3..4).cover?(i) }, total)} " \
            "leap5-11=#{pct(intervals.count { |i| (5..11).cover?(i) }, total)} " \
            "leap8ve+=#{intervals.count { |i| i >= 12 }}"
        end

        def top_pitch_class_line(midis)
          top_pc = pitch_class_counts(midis).max_by { |_, count| count }
          "  top pitch-class: #{PC_NAMES[top_pc[0]]} (#{top_pc[1]} of #{midis.size}); " \
            "range #{label_of(midis.min)}-#{label_of(midis.max)}"
        end

        def pitch_class_counts(midis)
          midis.each_with_object(Hash.new(0)) { |midi, out| out[midi % 12] += 1 }
        end

        def interval_histogram_line(intervals)
          hist = intervals.tally.sort_by { |interval, _| interval }.map { |interval, count| "#{interval}:#{count}" }
          "  interval histogram (semitones:count): #{hist.join(' ')}"
        end

        def recurrence_map_sounding(part: nil, bars: nil)
          lines = [
            "# Recurrence Map (sounding; bars keyed by attack bar; events crossing barlines count in their attack bar)"
          ]
          sounding_parts(part).each do |pname, evs|
            by_bar = evs.group_by { |e| bar_of(e.offset) }
            signatures = recurrence_signatures(by_bar, bars)
            lines << "#{pname}:"
            lines.concat(recurrence_summary_lines(signatures, by_bar))
          end
          lines.join("\n")
        end

        def recurrence_signatures(by_bar, bars)
          signatures = {
            exact: Hash.new { |hash, key| hash[key] = [] },
            transposed: Hash.new { |hash, key| hash[key] = [] },
            rhythm: Hash.new { |hash, key| hash[key] = [] }
          }
          by_bar.each { |bar, events| add_recurrence_bar(signatures, bar, events, bars) }
          signatures
        end

        def add_recurrence_bar(signatures, bar, events, bars)
          return unless in_bar_number?(bar, bars)

          seq = events.sort_by(&:offset)
          midis = seq.map { |event| midi_of(event.pitches.first) }
          durations = seq.map(&:duration)
          return if midis.empty?

          signatures.fetch(:exact)[[midis, durations]] << bar
          signatures.fetch(:transposed)[[midis.map { |midi| midi - midis.first }, durations]] << bar
          signatures.fetch(:rhythm)[durations] << bar
        end

        def recurrence_summary_lines(signatures, by_bar)
          exact = repeated_groups(signatures.fetch(:exact))
          [
            "  exact repeats (pitch+rhythm): #{exact.empty? ? '(none)' : exact.map(&:inspect).join(' ')}",
            "  transposed matches (same contour+rhythm, new level): #{transposed_recurrences(signatures, by_bar)}",
            "  rhythm-only families (>2 bars): #{rhythm_family_summary(signatures.fetch(:rhythm))}"
          ]
        end

        def repeated_groups(groups)
          groups.values.select { |value| value.size > 1 }.sort_by(&:first)
        end

        def transposed_recurrences(signatures, by_bar)
          transposed = signatures.fetch(:transposed).each_value.filter_map { |group| transposed_group(group, by_bar) }
          transposed.empty? ? "(none)" : transposed.join(" | ")
        end

        def transposed_group(group, by_bar)
          return nil if group.size < 2

          offsets = group.map { |bar| midi_of(by_bar[bar].min_by(&:offset).pitches.first) }
          return nil if offsets.uniq.size == 1

          group.zip(offsets).map { |bar, midi| "#{bar}@#{label_of(midi)}" }.join(" ")
        end

        def rhythm_family_summary(groups)
          groups.values.select { |value| value.size > 2 }
                .sort_by { |value| -value.size }
                .first(6)
                .map { |value| "#{value.size} bars #{value.first(12).inspect}" }
                .join(" | ")
        end

        def peak_axes(bars: nil)
          evs = all_sounding.select { |e| in_bars?(e.offset, bars) }
          return "# Peak Axes\n(no notes)" if evs.empty?

          data = peak_axis_data(evs)
          peak_axis_lines(data, bars).join("\n")
        end

        def peak_axis_data(evs)
          notes = evs.flat_map { |e| e.pitches.map { |p| [midi_of(p), e] } }
          hi = notes.max_by(&:first)
          lo = notes.min_by(&:first)
          {
            evs: evs,
            hi: hi,
            lo: lo,
            hi_bars: peak_bars(notes, hi),
            lo_bars: peak_bars(notes, lo),
            longest: evs.max_by(&:duration),
            dense_bar: density_peak(evs),
            mass_bar: active_part_peak(evs),
            dyn: dynamic_timeline,
            last_bar: evs.map { |e| bar_of(e.offset) }.max
          }
        end

        def peak_axis_lines(data, bars)
          dmax = data.fetch(:dyn).max_by { |(_, level)| level }
          lines = ["# Peak Axes (sounding)"]
          lines.concat(registral_axis_lines(data))
          lines << dynamic_axis_line(data.fetch(:dyn), dmax)
          lines << "melodic high point per part: #{per_part_high_points(bars).join('  ')}"
          axes = axis_bars(data, dmax)
          lines << "axis placement (piece spans bars 1-#{data.fetch(:last_bar)}):"
          axes.sort_by { |_, bar|
   bar }.each { |name, bar| lines << "  bar #{bar} (#{(100.0 * bar / data.fetch(:last_bar)).round}%): #{name}" }
          lines << axis_convergence_line(axes)
          lines
        end

        def peak_bars(notes, peak)
          notes.select { |midi, _event| midi == peak[0] }.map { |_midi, event| bar_of(event.offset) }.uniq
        end

        def density_peak(evs)
          evs.group_by { |event| bar_of(event.offset) }.transform_values(&:size).max_by { |_bar, count| count }
        end

        def active_part_peak(evs)
          evs.group_by { |event| bar_of(event.offset) }
             .transform_values { |events| events.map(&:part).uniq.size }
             .max_by { |_bar, count| count }
        end

        def registral_axis_lines(data)
          hi = data.fetch(:hi)
          lo = data.fetch(:lo)
          [
            registral_axis_line("max", hi, data.fetch(:hi_bars)),
            registral_axis_line("min", lo, data.fetch(:lo_bars)),
            longest_note_axis_line(data.fetch(:longest)),
            "attack-density max: bar #{data.fetch(:dense_bar)[0]} (#{data.fetch(:dense_bar)[1]} attacks)",
            active_part_axis_line(data.fetch(:mass_bar))
          ].compact
        end

        def registral_axis_line(name, peak, bars)
          suffix = bars.size == 1 ? "  <- one-shot" : ""
          "registral #{name}: #{label_of(peak[0])} (#{peak[1].part}) at " \
            "bar#{bars.size > 1 ? 's' : ''} #{bars.join(', ')}#{suffix}"
        end

        def longest_note_axis_line(longest)
          "longest note: #{longest.pitch_label}:#{Production.format_duration(longest.duration)} " \
            "(#{longest.part}) at bar #{bar_of(longest.offset)}"
        end

        def active_part_axis_line(mass_bar)
          "active-part max: bar #{mass_bar[0]} (#{mass_bar[1]} parts)" if @piece.parts.size > 1
        end

        def dynamic_axis_line(dyn, dmax)
          return "dynamic max: (no dynamics found)" unless dmax

          "dynamic max: #{DYN_ORDER[dmax[1]]} first at bar #{dynamic_axis_bar(dyn, dmax)}"
        end

        def dynamic_axis_bar(dyn, dmax)
          dyn.select { |(_offset, level)| level == dmax[1] }.map(&:first).map { |offset| bar_of(offset) }.min
        end

        def per_part_high_points(bars)
          sounding_parts(nil).filter_map do |pname, pevs|
            notes = pevs.select { |event| in_bars?(event.offset, bars) }
                        .flat_map { |event| event.pitches.map { |pitch| [midi_of(pitch), bar_of(event.offset)] } }
            next if notes.empty?

            high = notes.max_by(&:first)
            "#{pname}=#{label_of(high[0])}@b#{high[1]}"
          end
        end

        def axis_bars(data, dmax)
          axes = {
            "registral max" => data.fetch(:hi_bars).min,
            "registral min" => data.fetch(:lo_bars).min,
            "longest note" => bar_of(data.fetch(:longest).offset),
            "attack density" => data.fetch(:dense_bar)[0]
          }
          axes["dynamic max"] = dynamic_axis_bar(data.fetch(:dyn), dmax) if dmax
          axes
        end

        def axis_convergence_line(axes)
          clusters = axes.group_by { |_name, bar| bar }.select { |_bar, values| values.size > 1 }
          text = clusters.empty? ? "(none - axes separated)" : clusters.map { |bar, values|
   "bar #{bar}: #{values.map(&:first).join(' + ')}" }.join("; ")
          "convergences (same bar): #{text}"
        end
      end
    end
  end
end
