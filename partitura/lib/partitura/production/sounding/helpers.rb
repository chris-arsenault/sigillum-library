# frozen_string_literal: true

module Partitura
  module Production
    module SoundingReadout
      module Helpers
        CHORD_TEMPLATES = {
          "" => [0, 4, 7], "m" => [0, 3, 7], "dim" => [0, 3, 6], "aug" => [0, 4, 8],
          "7" => [0, 4, 7, 10], "m7" => [0, 3, 7, 10], "maj7" => [0, 4, 7, 11],
          "dim7" => [0, 3, 6, 9], "m7b5" => [0, 3, 6, 10]
        }.freeze

      private

        def contour_of(ms)
          intervals = ms.each_cons(2).map { |a, b| b - a }
          return "." if intervals.empty?

          counts = contour_counts(intervals)
          return "R" if counts.fetch(:repeat_rate) > 0.5
          return "~" if mixed_contour?(counts, intervals.length)

          counts.fetch(:ups) > counts.fetch(:downs) ? "/" : "\\"
        end

        def contour_counts(intervals)
          {
            repeat_rate: intervals.count(0) / intervals.size.to_f,
            ups: intervals.count(&:positive?),
            downs: intervals.count(&:negative?)
          }
        end

        def mixed_contour?(counts, interval_count)
          counts.fetch(:ups).positive? &&
            counts.fetch(:downs).positive? &&
            (counts.fetch(:ups) - counts.fetch(:downs)).abs <= interval_count * 0.25
        end

        def longest_run(seq)
          best = cur = 1
          seq.each_cons(2) { |a, b| cur = a == b ? cur + 1 : 1; best = [best, cur].max }
          best
        end

        def sounding_parts(part)
          groups = all_sounding.group_by(&:part)
          keys = part ? [part.to_sym] : @piece.parts.keys
          keys.filter_map { |k| groups[k] && [k, groups[k].sort_by(&:offset)] }
        end

        def all_sounding
          @all_sounding ||= @piece.timed_events.reject(&:rest?)
        end

        def event_midi(event)
          event.pitches.map { |pitch| midi_of(pitch) }.min
        end

        def previous_sounding_event(part, offset)
          all_sounding.select { |event| event.part == part && event.offset < offset }
                      .max_by(&:offset)
        end

        def next_sounding_event(part, offset)
          all_sounding.select { |event| event.part == part && event.offset > offset }
                      .min_by(&:offset)
        end

        def clash_context(a, b, offset)
          [a, b].flat_map { |event| event_context(event, offset) }.uniq
        end

        def event_context(event, offset)
          midi = event_midi(event)
          arrival = event_arrival_context(event, offset, midi)
          departure = event_departure_context(event, offset, midi)
          [arrival, departure].compact
        end

        def event_arrival_context(event, offset, midi)
          return nil unless event.offset == offset

          prev = previous_sounding_event(event.part, offset)
          return nil unless prev

          prev_midi = event_midi(prev)
          return "#{event.part} arrives by step" if prev.end_offset == offset && (prev_midi - midi).abs <= 2
          return "#{event.part} prepared (same pitch)" if prev_midi == midi

          nil
        end

        def event_departure_context(event, offset, midi)
          nxt = next_sounding_event(event.part, offset)
          return nil unless nxt && (event_midi(nxt) - midi).abs <= 2

          "#{event.part} leaves by step@#{@piece.format_offset(nxt.offset).split(':').last}"
        end

        def midi_of(label)
          m = label.to_s.match(/\A([A-G])([#b-]*)(-?\d+)\z/)
          raise ArgumentError, "bad pitch label #{label.inspect}" unless m

          semis = PC.fetch(m[1])
          m[2].each_char { |c| semis += c == "#" ? 1 : -1 }
          semis + (12 * (m[3].to_i + 1))
        end

        def label_of(midi)
          "#{PC_NAMES[midi % 12]}#{(midi / 12) - 1}"
        end

        def pct(count, total)
          "#{(100.0 * count / total).round}%"
        end

        def bar_of(offset)
          bar = 1
          bar_start = Rational(0)
          loop do
            length = @piece.bar_length_for(bar)
            break if Rational(offset) < bar_start + length

            bar_start += length
            bar += 1
          end
          bar
        end

        def in_bar_number?(number, bars)
          !bars || bars.include?(number)
        end

        def beat_starts(bar)
          blen = @piece.bar_length_for(bar)
          pattern = @piece.meter_for(bar).beat_pattern || ([1] * blen.to_i)
          total = pattern.sum
          start = @piece.offset_for(bar, 1)
          acc = Rational(0)
          pattern.map do |p|
            s = start + acc
            acc += blen * Rational(p, total)
            s
          end
        end

        def beat_start?(offset)
          bar = bar_of(offset)
          beat_starts(bar).any? { |b| (b - Rational(offset)).abs < Rational(1, 100) }
        end

        def dynamic_timeline
          (control_dynamic_points + event_dynamic_points).sort_by(&:first)
        end

        def control_dynamic_points
          @piece.controls.filter_map do |control|
            next unless control.kind.to_s == "dynamic"

            level = DYN_ORDER.index(control.value.to_s)
            [@piece.offset_for_reference(control.at), level] if level
          end
        end

        def event_dynamic_points
          all_sounding.flat_map do |event|
            event.marks.filter_map do |mark|
              level = DYN_ORDER.index(mark.to_s)
              [event.offset, level] if level
            end
          end
        end

        def slur_length_distribution(evs)
          state = { dist: Hash.new(0), depth: 0, count: 0 }
          evs.sort_by(&:offset).each do |event|
            update_slur_distribution!(state, event.marks.map(&:to_s))
          end
          state.fetch(:dist)
        end

        def update_slur_distribution!(state, marks)
          state[:count] += 1 if state.fetch(:depth).positive? || marks.include?("slur(")
          state[:depth] += marks.count("slur(")
          closes = marks.count("slur)")
          return unless closes.positive? && state.fetch(:depth).positive?

          close_slur_distribution!(state, closes)
        end

        def close_slur_distribution!(state, closes)
          state[:depth] -= closes
          return if state.fetch(:depth).positive?

          state.fetch(:dist)[state.fetch(:count)] += 1 if state.fetch(:count) > 1
          state[:depth] = 0
          state[:count] = 0
        end

        def breathless_spans(evs)
          # A breath is an explicit rest >= a half-beat OR a silent GAP between
          # events (unplaced stretches have no rest events at all).
          state = { spans: [], run_start: nil, run_end: nil }
          evs.reject(&:rest?).sort_by(&:offset).each do |event|
            update_breathless_span!(state, event)
          end
          finish_breathless_spans(state)
        end

        def update_breathless_span!(state, event)
          close_breathless_run!(state) if breath_gap?(event, state.fetch(:run_end))
          state[:run_start] ||= event.offset
          state[:run_end] = [state.fetch(:run_end), event.end_offset].compact.max
        end

        def close_breathless_run!(state)
          state.fetch(:spans) << breathless_span(state.fetch(:run_start), state.fetch(:run_end))
          state[:run_start] = nil
        end

        def finish_breathless_spans(state)
          state.fetch(:spans) << breathless_span(state.fetch(:run_start), 
  state.fetch(:run_end)) if state.fetch(:run_start)
          state.fetch(:spans)
        end

        def breath_gap?(event, run_end)
          run_end && event.offset - run_end >= Rational(1, 2)
        end

        def breathless_span(run_start, run_end)
          [bar_of(run_start), bar_of(run_end - Rational(1, 100)), run_end - run_start]
        end

        def chord_candidates(weights)
          total = weights.values.sum
          return [] if total <= 0

          scored = []
          12.times do |root|
            CHORD_TEMPLATES.each do |suffix, degrees|
              pcs = degrees.map { |d| (root + d) % 12 }
              covered = pcs.sum { |pc| weights[pc] }
              # penalize big templates lightly so triads win ties
              scored << ["#{PC_NAMES[root]}#{suffix}", (covered / total) - (degrees.size * 0.005)]
            end
          end
          scored.sort_by { |_, s| -s }
        end

        def compress_ranges(nums)
          nums.slice_when { |a, b| b > a + 1 }.map { |g| g.size > 1 ? "#{g.first}-#{g.last}" : g.first.to_s }.join(", ")
        end
      end
    end
  end
end
