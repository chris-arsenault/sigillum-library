# frozen_string_literal: true

module Partitura
  module Production
    module SoundingReadout
      module HarmonyGrid
        def implied_harmony(bars: nil)
          lines = [
            "# Implied Harmony (sounding; per-bar CHORD CANDIDATES from duration+beat-weighted pitch classes - " \
            "a reading aid, not an analysis)"
          ]
          harmony_weights_by_bar(bars).each { |bar, weights| lines << implied_harmony_line(bar, weights) }
          lines.join("\n")
        end

        def harmony_check(bars: nil)
          chords = @piece.declared_chords
          lines = ["# Harmony Check (declared chord track vs sounding pitch classes - where they disagree, " \
                   "either the notes or the declaration is wrong)"]
          if chords.empty?
            lines << "(no chord track declared; declare per-bar chords in a span: chords \"b1:F b2:Bb\")"
            return lines.join("\n")
          end

          weights_by_bar = harmony_weights_by_bar(bars).to_h
          bars_to_check = (weights_by_bar.keys + chords.keys.select { |bar| in_bar_number?(bar, bars) }).uniq.sort
          bars_to_check.each { |bar| lines << harmony_check_line(bar, chords[bar], weights_by_bar[bar]) }
          lines.join("\n")
        end

        def harmony_check_line(bar, declared, weights)
          return "b#{bar}: declared #{declared}; no sounding notes in this bar - silent bar or missing material?" if
            weights.nil?

          candidates = chord_candidates(weights).first(2)
          implied_text = candidates.map { |candidate| candidate_text(candidate) }.join("  alt: ")
          return "b#{bar}: no chord declared; implied #{implied_text}" unless declared

          coverage = declared_chord_coverage(declared, weights)
          verdict = harmony_check_verdict(declared, candidates, coverage)
          "b#{bar}: declared #{declared}; sounding covers #{(coverage * 100).round}% of its tones; " \
            "implied #{implied_text} - #{verdict}"
        end

        def declared_chord_coverage(declared, weights)
          parsed = Chords.parse(declared)
          total = weights.values.sum
          return 0.0 unless parsed && total.positive?

          parsed.pcs.sum { |pc| weights[pc] } / total
        end

        def harmony_check_verdict(declared, candidates, coverage)
          return "match" if coverage >= 0.75 || top_candidate_matches?(declared, candidates)

          coverage >= 0.5 ? "review" : "MISMATCH"
        end

        def top_candidate_matches?(declared, candidates)
          top = candidates.first
          return false unless top

          top_pcs = Chords.parse(top.first)&.pcs&.sort
          !top_pcs.nil? && top_pcs == Chords.parse(declared)&.pcs&.sort
        end

        def ensemble_grid(bars: nil)
          notes = @piece.timed_events(include_rests: true).reject(&:rest?)
          lines = ["# Ensemble Grid (16th resolution; X=attack -=sustain .=silent; beats separated by |)"]
          ensemble_grid_range(notes, bars).each { |bar| append_ensemble_grid_bar(lines, bar, notes) }
          lines.join("\n")
        end

        def ensemble_grid_row(bar, part, notes)
          bar_start = @piece.offset_for(bar, 1)
          steps = (@piece.bar_length_for(bar) / Rational(1, 4)).to_i
          beat_bounds = beat_starts(bar).map { |beat| ((beat - bar_start) / Rational(1, 4)).to_i }
          steps.times.each_with_object(+"") do |step, row|
            time = bar_start + Rational(step, 4)
            row << "|" if step.positive? && beat_bounds.include?(step)
            row << ensemble_grid_cell(part, time, notes)
          end
        end

        def ensemble_grid_cell(part, time, notes)
          cell = "."
          notes.each do |event|
            next unless event.part == part

            return "X" if (event.offset - time).abs < Rational(1, 100)

            cell = "-" if event.offset < time && event.end_offset > time
          end
          cell
        end

        private

        def harmony_weights_by_bar(bars)
          all_sounding.group_by { |event| bar_of(event.offset) }
                      .sort
                      .filter_map { |bar, events| [bar, weighted_pitch_classes(events)] if in_bar_number?(bar, bars) }
        end

        def weighted_pitch_classes(events)
          events.each_with_object(Hash.new(0.0)) do |event, weights|
            weight = event.duration.to_f
            weight *= 2.0 if beat_start?(event.offset)
            event.pitches.each { |pitch| weights[midi_of(pitch) % 12] += weight }
          end
        end

        def implied_harmony_line(bar, weights)
          best, alt = chord_candidates(weights).first(2)
          "b#{bar}: #{candidate_text(best)}#{alt ? "  alt: #{candidate_text(alt)}" : ''}  " \
            "pcs={#{top_pc_weights(weights)}}"
        end

        def candidate_text(candidate)
          return "(?) (0% weight)" unless candidate

          "#{candidate[0]} (#{(candidate[1] * 100).round}% weight)"
        end

        def top_pc_weights(weights)
          weights.sort_by { |_, weight| -weight }
                 .first(5)
                 .map { |pc, weight| "#{PC_NAMES[pc]}:#{weight.round(1)}" }
                 .join(" ")
        end

        def ensemble_grid_range(notes, bars)
          return bars if bars
          return [] if notes.empty?

          1..bar_of(notes.map(&:end_offset).max - Rational(1, 100))
        end

        def append_ensemble_grid_bar(lines, bar, notes)
          lines << "--- b#{bar}"
          @piece.parts.each_key do |pname|
            lines << "  #{pname.to_s.ljust(10)} #{ensemble_grid_row(bar, pname, notes)}"
          end
        end
      end
    end
  end
end
