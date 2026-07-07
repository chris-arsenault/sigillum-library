# frozen_string_literal: true

module Partitura
  module Production
    class MelodyAnalysis
      module Texture
        private

        def build_texture
          base = bars ? piece.offset_for(bars.begin, 1) : 0r
          piece.timed_events.flat_map do |event|
            texture_note_events(event, base)
          end.sort_by { |event| [event.onset, event.part.to_s, event.midi] }
        end

        def texture_note_events(event, base)
          return [] unless texture_event?(event)

          event.pitches.map do |pitch|
            NoteEvent.new(
              onset: (event.offset - base).to_f,
              offset: event.offset,
              midi: midi_of(pitch),
              duration: event.duration.to_f,
              part: event.part
            )
          end
        end

        def texture_event?(event)
          return false if event.rest?
          return false if part && event.part != part

          in_bars?(event.offset)
        end

        def analyze_notes
          notes = @melody.map do |event|
            AnalyzedNote.new(
              onset: event.onset,
              offset: event.offset,
              midi: event.midi,
              duration: event.duration,
              part: event.part,
              features: {}
            )
          end
          annotations = melody_annotations
          notes.each_with_index do |note, index|
            assign_note_features(note, annotations, index)
          end
          notes
        end

        def melody_annotations
          {
            tonal: annotate_tonal(@melody),
            harmony: annotate_harmony(@melody),
            figuration: annotate_figuration(@melody),
            motif: annotate_motif(@melody),
            metric: annotate_metric(@melody)
          }
        end

        def assign_note_features(note, annotations, index)
          annotations.each do |name, rows|
            note.features[name] = rows[index]
          end
        end

        def summarize_segment
          return empty_segment_features if notes.empty?

          pitches = notes.map(&:midi)
          total = [notes.map { |note| note.onset + note.duration }.max, 1.0].max
          lo, hi = pitches.minmax
          contour = segment_contour(lo, [hi - lo, 1].max)

          SegmentFeatures.new(
            contour: contour,
            archetype: archetype(contour),
            apex_position: (notes.max_by(&:midi).onset / total).round(3),
            range_semitones: hi - lo,
            style: segment_style(pitches, total)
          )
        end

        def empty_segment_features
          SegmentFeatures.new(contour: [], archetype: "flat", apex_position: 0.0, range_semitones: 0, style: {})
        end

        def segment_contour(low_midi, span)
          grouped = {}
          notes.each { |note| (grouped[note.features.fetch(:metric).fetch(:bar)] ||= []) << note.midi }
          grouped.keys.sort.map { |bar| ((mean(grouped.fetch(bar)) - low_midi) / span.to_f).round(3) }
        end

        def segment_style(pitches, total)
          intervals = pitches.each_cons(2).map { |a, b| (b - a).abs }
          figures = tally(notes.map { |note| note.features.fetch(:figuration).fetch(:figure) })
          {
            figuration_profile: figuration_profile(figures),
            chromatic_rate: note_rate(chromatic_note_count),
            note_density: (notes.length / total).round(3),
            mean_interval: mean_interval(intervals),
            harmonic_color: note_rate(non_diatonic_note_count)
          }
        end

        def figuration_profile(figures)
          figures.transform_values { |value| (value.to_f / notes.length).round(3) }
        end

        def note_rate(count)
          (count.to_f / notes.length).round(3)
        end

        def mean_interval(intervals)
          intervals.empty? ? 0.0 : mean(intervals).round(2)
        end

        def archetype(contour)
          return "flat" if contour.length < 2

          archetype_for_means(*contour_third_means(contour))
        end

        def contour_third_means(contour)
          third = [contour.length / 3, 1].max
          middle_values = contour[third...-third]
          [
            mean(contour.first(third)),
            mean(middle_values && !middle_values.empty? ? middle_values : contour),
            mean(contour.last(third))
          ]
        end

        def archetype_for_means(start, middle, ending)
          return "arch" if middle - [start, ending].max > 0.15
          return "valley" if [start, ending].min - middle > 0.15
          return "rising" if ending - start > 0.15
          return "falling" if start - ending > 0.15

          "flat"
        end

        def chromatic_note_count
          notes.count { |note| note.features.fetch(:tonal).fetch(:chromatic) }
        end

        def non_diatonic_note_count
          notes.count { |note| note.features.fetch(:harmony).fetch(:roman).match?(/[b\/]/) }
        end

        def melody_line(events)
          return [] if events.empty?

          total = events.map { |event| event.onset + event.duration }.max
          best = melody_candidates(events, total).max_by { |candidate| candidate.fetch(:score) }
          best ? best.fetch(:line) : topline(events)
        end

        def melody_candidates(events, total)
          events.group_by(&:part).values.filter_map do |part_events|
            melody_candidate(part_events, total)
          end
        end

        def melody_candidate(part_events, total)
          return nil unless sufficient_part_coverage?(part_events, total)

          line = topline(part_events)
          score = melody_score(line, polyphony(part_events))
          score && { line: line, score: score }
        end

        def sufficient_part_coverage?(events, total)
          span = events.map { |event| event.onset + event.duration }.max - events.map(&:onset).min
          !total.positive? || span / total >= MIN_COVERAGE
        end

        def topline(events)
          best = {}
          events.each do |event|
            key = event.onset.round(4)
            best[key] = event if !best.key?(key) || event.midi > best[key].midi
          end
          best.keys.sort.map { |key| best.fetch(key) }
        end

        def polyphony(events)
          state = { active: 0, last: nil, total: 0.0, poly: 0.0 }
          polyphony_edges(events).each { |time, delta| update_polyphony_state(state, time, delta) }
          state.fetch(:total).positive? ? state.fetch(:poly) / state.fetch(:total) : 0.0
        end

        def polyphony_edges(events)
          events.flat_map do |event|
            [[event.onset.round(4), 1], [(event.onset + event.duration).round(4), -1]]
          end.sort_by { |time, delta| [time, delta] }
        end

        def update_polyphony_state(state, time, delta)
          if state.fetch(:last) && time > state.fetch(:last)
            elapsed = time - state.fetch(:last)
            state[:total] += elapsed
            state[:poly] += elapsed if state.fetch(:active) > 1
          end
          state[:active] += delta
          state[:last] = time
        end

        def melody_score(line, polyphony)
          midis = line.map(&:midi)
          return nil unless melody_scoreable?(midis)

          leaps = midis.each_cons(2).map { |a, b| (b - a).abs }
          return nil if excessive_big_leaps?(leaps)

          mean(midis) + (3.0 * midis.map { |midi| midi % 12 }.uniq.length) - (8.0 * polyphony)
        end

        def melody_scoreable?(midis)
          midis.length >= MIN_MELODY_NOTES &&
            midis.map { |midi| midi % 12 }.uniq.length >= MIN_MELODY_PCS
        end

        def excessive_big_leaps?(leaps)
          leaps.any? && leaps.count { |interval| interval > BIG_LEAP }.to_f / leaps.length > MAX_BIG_LEAP_FRACTION
        end
      end
    end
  end
end
