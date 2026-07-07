# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class MelodyAnalysis
        module Figuration
          private

        def annotate_figuration(events)
          pitches = events.map(&:midi)
          durations = events.map(&:duration)
          chord_tones = events.map { |event| chord_at(event.onset)[1].include?(event.midi % 12) }
          figures = figuration(pitches, durations, chord_tones)
          seq = sequences(pitches)
          figures.each_index.map { |index| { figure: figures[index], in_sequence: seq[index] } }
        end

        def annotate_motif(events)
          pitches = events.map(&:midi)
          durations = events.map(&:duration)
          labels = motif_detect(pitches, durations)
          labels.each_index.map { |index| { transform: labels[index] } }
        end

        def figuration(pitches, durations, chord_tones)
          return [] if pitches.empty?

          context = figure_context(pitches, durations, chord_tones)
          pitches.each_index.map do |index|
            figure_label(context, index)
          end
        end

        def figure_context(pitches, durations, chord_tones)
          {
            pitches: pitches,
            durations: durations,
            median_duration: median(durations),
            runs: run_members(pitches),
            arps: arpeggio_members(pitches, chord_tones)
          }
        end

        def run_members(pitches)
          chain(pitches) do |start, index|
            interval = pitches[index + 1] - pitches[index]
            first = pitches[start + 1] - pitches[start]
            interval.abs.between?(1, STEP_MAX) && interval * first > 0
          end
        end

        def arpeggio_members(pitches, chord_tones)
          chain(pitches) do |_start, index|
            (pitches[index + 1] - pitches[index]).abs >= LEAP_MIN && chord_tones[index] && chord_tones[index + 1]
          end
        end

        def figure_label(context, index)
          pitches = context.fetch(:pitches)
          din, dout = figure_motion(pitches, index)
          priority_figure(context, index, din, dout) ||
            melodic_figure(context, index, din) ||
            duration_figure(context, index) ||
            "step"
        end

        def priority_figure(context, index, din, dout)
          return "repeat" if din == 0 || dout == 0
          return directional_figure("run", dout, din, STEP_MAX) if context.fetch(:runs)[index]
          return directional_figure("arp", dout, din, nil) if context.fetch(:arps)[index]

          nil
        end

        def melodic_figure(context, index, din)
          return alternation_figure(context, din, index) if alternating_neighbor?(context.fetch(:pitches), din, index)
          return "leap" if din && din.abs >= LEAP_MIN

          nil
        end

        def duration_figure(context, index)
          "sustained" if sustained_figure?(context, index)
        end

        def figure_motion(pitches, index)
          [
            index.positive? ? pitches[index] - pitches[index - 1] : nil,
            index + 1 < pitches.length ? pitches[index + 1] - pitches[index] : nil
          ]
        end

        def sustained_figure?(context, index)
          context.fetch(:durations)[index] >= SUSTAIN_X * context.fetch(:median_duration)
        end

        def directional_figure(prefix, dout, din, max_step)
          direction = if prefix == "arp"
                        dout && dout.abs >= LEAP_MIN ? dout : din
                      elsif dout && dout.abs.between?(1, max_step)
                        dout
                      else
                        din
                      end
          "#{prefix}-#{direction.to_i.positive? ? 'up' : 'dn'}"
        end

        def alternating_neighbor?(pitches, din, index)
          index.positive? && index + 1 < pitches.length &&
            pitches[index - 1] == pitches[index + 1] &&
            din.abs.between?(1, STEP_MAX)
        end

        def alternation_figure(context, din, index)
          pitches = context.fetch(:pitches)
          sustained = (index >= 2 && pitches[index - 2] == pitches[index]) ||
                      (index + 2 < pitches.length && pitches[index + 2] == pitches[index])
          sustained && context.fetch(:durations)[index] <= TRILL_MAX_DUR ? "trill" : neighbor_label(din)
        end

        def neighbor_label(interval)
          interval.positive? ? "neighbor-up" : "neighbor-dn"
        end

        def chain(pitches)
          member = Array.new(pitches.length, false)
          index = 0
          while index < pitches.length - 1
            cursor = index
            cursor += 1 while cursor < pitches.length - 1 && yield(index, cursor)
            if cursor - index >= 2
              (index..cursor).each { |i| member[i] = true }
              index = cursor
            else
              index += 1
            end
          end
          member
        end

        def sequences(pitches, min_cell: 2, max_cell: 4)
          intervals = pitches.each_cons(2).map { |a, b| b - a }
          seq = Array.new(pitches.length, false)
          max_cell.downto(min_cell) do |length|
            0.upto(intervals.length - (2 * length)) do |index|
              next unless intervals[index, length] == intervals[index + length, length]

              (index..(index + (2 * length))).each { |i| seq[i] = true }
            end
          end
          seq
        end

        def motif_detect(pitches, durations)
          rounded_durations = durations.map { |duration| duration.round(4) }
          labels = Array.new(pitches.length, "-")
          CELL_LENGTHS.each do |length|
            signatures = motif_signatures(pitches, rounded_durations, length)
            apply_motif_length!(labels, signatures, length)
          end
          labels
        end

        def motif_signatures(pitches, durations, length)
          0.upto(pitches.length - length).map do |index|
            motif_signature(pitches[index, length], durations[index, length])
          end
        end

        def motif_signature(pitches, durations)
          [pitches, durations, pitches.each_cons(2).map { |a, b| b - a }, tonal_intervals(pitches)]
        end

        def apply_motif_length!(labels, signatures, length)
          length.upto(labels.length - length) do |index|
            next unless motif_cell_unlabeled?(labels, index, length)

            apply_motif_reference!(labels, signatures, index, length)
          end
        end

        def motif_cell_unlabeled?(labels, index, length)
          (0...length).none? { |k| labels[index + k] != "-" }
        end

        def apply_motif_reference!(labels, signatures, index, length)
          (index - length).downto(0) do |reference|
            next if reference + length > index - MOTIF_MIN_GAP

            transform = motif_classify(signatures[reference], signatures[index])
            next unless transform

            (0...length).each { |k| labels[index + k] = transform }
            break
          end
        end

        def motif_classify(reference, cell)
          motif_exact_or_transposed(reference, cell) ||
            motif_interval_transform(reference, cell) ||
            motif_retrograde(reference, cell) ||
            motif_scaled(reference, cell)
        end

        def motif_exact_or_transposed(reference, cell)
          ref_pitches, ref_durations, ref_real = reference
          pitches, durations, real = cell
          return nil unless durations == ref_durations && real == ref_real

          pitches == ref_pitches ? "exact" : format("transpose%+d", pitches.first - ref_pitches.first)
        end

        def motif_interval_transform(reference, cell)
          _ref_pitches, ref_durations, ref_real, ref_tonal = reference
          _pitches, durations, real, tonal = cell
          return nil unless durations == ref_durations
          return "inversion" if real == negated(ref_real)

          motif_tonal_transform(ref_real, ref_tonal, real, tonal)
        end

        def motif_tonal_transform(ref_real, ref_tonal, real, tonal)
          return nil unless tonal && ref_tonal
          return "tonal-transpose" if tonal == ref_tonal && real != ref_real
          return "tonal-inversion" if tonal == negated(ref_tonal)

          nil
        end

        def motif_retrograde(reference, cell)
          _ref_pitches, ref_durations, ref_real = reference
          _pitches, durations, real = cell
          return nil unless durations == ref_durations.reverse && real == negated(ref_real.reverse)

          "retrograde"
        end

        def motif_scaled(reference, cell)
          _ref_pitches, ref_durations, ref_real = reference
          _pitches, durations, real = cell
          return nil unless real == ref_real && ref_durations.all?(&:positive?)

          factor = durations.first / ref_durations.first
          return nil unless motif_scale_factor?(durations, ref_durations, factor)

          factor > 1 ? "augmentation" : "diminution"
        end

        def motif_scale_factor?(durations, ref_durations, factor)
          (factor - 1).abs > 0.000001 &&
            durations.each_index.all? { |index| ((durations[index] / ref_durations[index]) - factor).abs < 0.000001 }
        end

        def negated(values)
          values.map { |value| -value }
        end

        def tonal_intervals(pitches)
          return nil unless pitches.all? { |pitch| @ordinals.key?(pitch) }

          ords = pitches.map { |pitch| @ordinals.fetch(pitch) }
          ords.each_cons(2).map { |a, b| b - a }
        end

        end
      end
    end
  end
end
