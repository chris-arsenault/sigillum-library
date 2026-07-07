# frozen_string_literal: true

module Partitura
  module Production
    class MelodyAnalysis
      module Harmony
        private

        def pc_histogram(events, lo: 0.0, hi: nil, taper: false, center: nil, width: nil)
          hist = Array.new(12, 0.0)
          events.each do |event|
            left = [event.onset, lo].max
            right = hi ? [event.onset + event.duration, hi].min : event.onset + event.duration
            next if right <= left

            weight = right - left
            if taper && width && center
              mid = (left + right) / 2.0
              weight *= 0.5 * (1 + Math.cos(Math::PI * [((mid - center).abs / (width / 2.0)), 1.0].min))
            end
            hist[event.midi % 12] += weight
          end
          hist
        end

        def estimate_key(hist)
          best = [0, :major]
          score = -2.0
          12.times do |tonic|
            rotated = hist.rotate(tonic)
            { major: KS_MAJOR, minor: KS_MINOR }.each do |mode, profile|
              candidate = correlation(profile, rotated)
              next unless candidate > score

              best = [tonic, mode]
              score = candidate
            end
          end
          best
        end

        def correlation(profile, hist)
          pmean = mean(profile)
          hmean = mean(hist)
          numerator = profile.each_index.sum { |i| (profile[i] - pmean) * (hist[i] - hmean) }
          denominator = Math.sqrt(
            profile.sum { |value| (value - pmean)**2 } *
            hist.sum { |value| (value - hmean)**2 }
          )
          denominator.zero? ? -1.0 : numerator / denominator
        end

        def windowed_harmony(events)
          out = []
          center = HARM_WINDOW / 2.0
          while center - (HARM_WINDOW / 2.0) < @total
            lo = center - (HARM_WINDOW / 2.0)
            hi = center + (HARM_WINDOW / 2.0)
            hist = pc_histogram(events, lo: lo, hi: hi, taper: true, center: center, width: HARM_WINDOW)
            if hist.sum > 0.000001
              label, pcs, root = best_chord(hist)
              bass = bass_pc(events, lo, hi)
              inversion = bass && !pcs.empty? && bass != root ? "/#{CHORD_TONE.fetch((bass - root) % 12, 'x')}" : ""
              out << [center, label, pcs, root, inversion]
            end
            center += HARM_HOP
          end
          out
        end

        def chord_vocab
          tonic, mode = @key
          spec =
            if mode == :major
              {
                "I" => [0, [0, 4, 7]], "ii" => [2, [2, 5, 9]], "iii" => [4, [4, 7, 11]],
                "IV" => [5, [5, 9, 0]], "V" => [7, [7, 11, 2]], "vi" => [9, [9, 0, 4]],
                "viio" => [11, [11, 2, 5]], "V7" => [7, [7, 11, 2, 5]], "ii7" => [2, [2, 5, 9, 0]],
                "IM7" => [0, [0, 4, 7, 11]], "viio7" => [11, [11, 2, 5, 8]], "iv" => [5, [5, 8, 0]],
                "bVI" => [8, [8, 0, 3]], "bVII" => [10, [10, 2, 5]], "bIII" => [3, [3, 7, 10]],
                "iio" => [2, [2, 5, 8]], "bII" => [1, [1, 5, 8]], "V/V" => [2, [2, 6, 9]],
                "V7/V" => [2, [2, 6, 9, 0]], "V/vi" => [4, [4, 8, 11]], "V/ii" => [9, [9, 1, 4]],
                "viio7/V" => [1, [1, 4, 7, 10]]
              }
            else
              {
                "i" => [0, [0, 3, 7]], "iio" => [2, [2, 5, 8]], "III" => [3, [3, 7, 10]],
                "iv" => [5, [5, 8, 0]], "v" => [7, [7, 10, 2]], "V" => [7, [7, 11, 2]],
                "VI" => [8, [8, 0, 3]], "bVII" => [10, [10, 2, 5]], "viio" => [11, [11, 2, 5]],
                "V7" => [7, [7, 11, 2, 5]], "viio7" => [11, [11, 2, 5, 8]], "iv7" => [5, [5, 8, 0, 3]],
                "III+" => [3, [3, 7, 11]], "bII" => [1, [1, 4, 8]], "V/III" => [10, [10, 2, 5]],
                "V/iv" => [0, [0, 4, 7]], "V/VI" => [3, [3, 7, 10]]
              }
            end
          spec.map do |label, (root, pcs)|
            [label, pcs.map { |pc| (tonic + pc) % 12 }, (tonic + root) % 12]
          end
        end

        def best_chord(hist)
          total = hist.sum
          return ["-", [], 0] if total.zero?

          norm = hist.map { |weight| weight / total }
          chord_vocab.max_by do |_label, pcs, _root|
            12.times.sum { |pc| norm[pc] * (pcs.include?(pc) ? 1.0 : -HARM_OFF_PENALTY) }
          end
        end

        def bass_pc(events, lo, hi)
          sounding = events.select { |event| event.onset < hi && event.onset + event.duration > lo }
          bass = sounding.min_by(&:midi)
          bass && (bass.midi % 12)
        end

        def accompaniment(texture, melody)
          melody_keys = melody.map { |event| [event.onset.round(4), event.midi] }.to_h { |key| [key, true] }
          rest = texture.reject { |event| melody_keys.key?([event.onset.round(4), event.midi]) }
          rest.empty? ? texture : rest
        end

        def annotate_tonal(events)
          tonic, mode = @key
          events.map do |event|
            degree = scale_degree(event.midi, tonic, mode)
            { degree: degree, chromatic: degree.nil?, octave: (event.midi / 12) - 1 }
          end
        end

        def annotate_metric(events)
          events.map do |event|
            bar = bar_of(event.offset)
            bar_position = event.offset - piece.offset_for(bar, 1)
            {
              bar: bar,
              bar_position: bar_position.to_f.round(4),
              strength: metric_strength(bar_position, piece.bar_length_for(bar)),
              duration: event.duration
            }
          end
        end

        def annotate_harmony(events)
          events.each_with_index.map do |event, index|
            label, pcs, root, inversion = chord_at(event.onset)
            prev_midi = index.positive? ? events[index - 1].midi : nil
            next_midi = index + 1 < events.length ? events[index + 1].midi : nil
            { roman: label, inversion: inversion, role: note_role(prev_midi, event.midi, next_midi, pcs, root) }
          end
        end

        def note_role(prev_midi, midi, next_midi, pcs, root)
          chord_tone = chord_tone_role(midi, pcs, root)
          return chord_tone if chord_tone
          return "nct:?" unless prev_midi && next_midi

          classify_non_chord_tone(prev_midi, midi, next_midi)
        end

        def chord_tone_role(midi, pcs, root)
          return nil unless pcs.include?(midi % 12)

          "ct:#{CHORD_TONE.fetch(((midi % 12) - root) % 12, '?')}"
        end

        def classify_non_chord_tone(prev_midi, midi, next_midi)
          into = midi - prev_midi
          out = next_midi - midi
          tied = tied_non_chord_tone(prev_midi, midi, next_midi, out)
          return tied if tied

          motion = motion_non_chord_tone(into, out)
          return motion if motion

          "nct:chromatic"
        end

        def tied_non_chord_tone(prev_midi, midi, next_midi, out)
          return "nct:susp" if prev_midi == midi && step_motion?(out)
          return "nct:antic" if midi == next_midi

          nil
        end

        def motion_non_chord_tone(into, out)
          return stepwise_non_chord_tone(into, out) if step_motion?(into) && step_motion?(out)
          return "nct:appog" if into.abs > 2 && step_motion?(out)
          return "nct:escape" if step_motion?(into) && out.abs > 2

          nil
        end

        def step_motion?(value)
          value.abs.between?(1, 2)
        end

        def stepwise_non_chord_tone(into, out)
          into.positive? == out.positive? ? "nct:passing" : "nct:neighbor"
        end

        def chord_at(onset)
          return ["-", [], 0, ""] if @windows.empty?

          window = @windows.min_by { |candidate| (candidate[0] - onset).abs }
          [window[1], window[2], window[3], window[4]]
        end

        def scale_degree(midi, tonic, mode)
          offsets = SCALE_OFFSETS.fetch(mode)
          pc = (midi - tonic) % 12
          found = offsets.index(pc)
          found && (found + 1)
        end

        def diatonic_ordinals(tonic, mode)
          pcs = SCALE_OFFSETS.fetch(mode).map { |offset| (tonic + offset) % 12 }
          ordinal = 0
          (0...128).each_with_object({}) do |midi, out|
            next unless pcs.include?(midi % 12)

            out[midi] = ordinal
            ordinal += 1
          end
        end

        def metric_strength(position, bar_length)
          pos = Rational(position)
          return "downbeat" if pos.zero? || (pos - bar_length).abs < Rational(1, 1_000_000)
          return "halfbar" if (pos - (bar_length / 2)).abs < Rational(1, 1_000_000)
          return "beat" if (pos - pos.round).abs < Rational(1, 1_000_000)

          "offbeat"
        end

      end
    end
  end
end
