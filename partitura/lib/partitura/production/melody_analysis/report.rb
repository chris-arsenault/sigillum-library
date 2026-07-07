# frozen_string_literal: true

require_relative "report/harmony"

module Partitura
  module Production
    class MelodyAnalysis
      module Report
        include ReportHarmony

        def render_analysis(limit: 24)
          fig = tally(notes.map { |note| note.features.fetch(:figuration).fetch(:figure) })
          transforms = motif_transforms
          transform_counts = tally(transforms)

          lines = [analysis_header]
          return (lines + ["(no melody notes)"]).join("\n") if notes.empty?

          lines << "figuration: #{hash_preview(fig, 6)}"
          lines << "motif restatements: #{transforms.length} #{hash_preview(transform_counts, 5)}"
          lines << "per-note (offset | part | pitch | degree | roman role | figure | motif):"
          notes.first(limit).each { |note| lines << analysis_note_row(note) }
          lines.join("\n")
        end

        def render_report
          return "# Melody Report #{piece.title}#{scope_suffix}: too short to analyse" if notes.length < 4

          data = report_data
          lines = [report_title]
          lines.concat(report_verdict_lines(data))
          lines << "implies:      #{data.fetch(:harmonic).fetch(:implied).join(' ')}"
          lines.join("\n")
        end

        private

        def report_title
          "# Melody Report #{piece.title}#{scope_suffix} " \
            "(#{notes.length} notes, #{bar_count} bars; estimated key #{key_label})"
        end

        def report_data
          midis = notes.map(&:midi)
          durations = notes.map(&:duration)
          harmony = feature_rows(:harmony)
          metric = feature_rows(:metric)
          figuration = feature_rows(:figuration)
          restated = motif_transforms
          bars_by_number = metric_bars_by_number(metric)
          {
            midis: midis,
            durations: durations,
            metric: metric,
            figuration: figuration,
            restated: restated,
            harmonic: harmonic_exposure(harmony, metric, bars_by_number)
          }
        end

        def report_verdict_lines(data)
          [
            motif_verdict_line(data.fetch(:restated), data.fetch(:figuration)),
            "contour/apex  #{verdict(apex_ok?(data.fetch(:midis)), contour_summary(data.fetch(:midis)))}",
            range_verdict_line(data.fetch(:midis)),
            interval_verdict_line(data.fetch(:midis)),
            rhythm_verdict_line(data.fetch(:durations), data.fetch(:metric)),
            harmonic_verdict_line(data.fetch(:harmonic)),
            nct_verdict_line(data.fetch(:harmonic)),
            "phrase/cad    #{verdict(cadence?, cadence_summary)}"
          ]
        end

        def feature_rows(name)
          notes.map { |note| note.features.fetch(name) }
        end

        def metric_bars_by_number(metric)
          metric.each_with_index.each_with_object({}) do |(row, index), out|
            (out[row.fetch(:bar)] ||= []) << index
          end
        end

        def motif_verdict_line(restated, figuration)
          ok = restated.length.to_f / notes.length >= MIN_RESTATEMENT
          "motif/hook    #{verdict(ok, motif_summary(restated, figuration))}"
        end

        def range_verdict_line(midis)
          ok = (MIN_RANGE..MAX_RANGE).cover?(segment.range_semitones)
          "range         #{verdict(ok, range_summary(midis))}"
        end

        def interval_verdict_line(midis)
          ok = unrecovered_leaps(midis).zero?
          "intervals/VL  #{verdict(ok, interval_summary(midis))}"
        end

        def rhythm_verdict_line(durations, metric)
          "rhythm        #{verdict(rhythm_ok?(durations, metric), rhythm_summary(durations, metric))}"
        end

        def harmonic_verdict_line(harmonic)
          ok = harmonic.fetch(:strong_ct_rate) >= MIN_STRONGBEAT_CT &&
               harmonic.fetch(:root_rate) >= MIN_DOWNBEAT_ROOT
          "harmony       #{verdict(ok, harmonic.fetch(:summary))}"
        end

        def nct_verdict_line(harmonic)
          ok = (NCT_LO..NCT_HI).cover?(harmonic.fetch(:nct_rate))
          "NCT/tension   #{verdict(ok, harmonic.fetch(:nct_summary))}"
        end

        def analysis_header
          "# Melody Analysis #{piece.title}#{scope_suffix} (#{notes.length} melody notes; estimated key #{key_label})"
        end

        def motif_transforms
          notes.map { |note| note.features.fetch(:motif).fetch(:transform) }.reject { |value| value == "-" }
        end

        def analysis_note_row(note)
          tonal = note.features.fetch(:tonal)
          harmony = note.features.fetch(:harmony)
          format(
            "  %-7s %-12s %-4s ^%-3s %-9s %-12s %-11s %s",
            piece.format_offset(note.offset),
            note.part,
            label_of(note.midi),
            tonal.fetch(:chromatic) ? "chr" : tonal.fetch(:degree).to_s,
            "#{harmony.fetch(:roman)}#{harmony.fetch(:inversion)}",
            harmony.fetch(:role),
            note.features.fetch(:figuration).fetch(:figure),
            note.features.fetch(:motif).fetch(:transform)
          )
        end

        def motif_summary(restated, figuration)
          kinds = tally(restated)
          developing = kinds.keys.any? { |kind| kind != "exact" }
          seqrate = figuration.count { |row| row.fetch(:in_sequence) }.to_f / notes.length
          "#{percent(restated.length, notes.length)} of notes recur as a motif (#{hash_preview(kinds, 4)}); " \
            "#{motif_development_label(kinds, developing)}; seq #{(seqrate * 100).round}%"
        end

        def motif_development_label(kinds, developing)
          return "developing" if developing
          return "no recurring cell" if kinds.empty?

          "only literal repeats"
        end

        def contour_summary(midis)
          apex_hits = midis.count(midis.max)
          "archetype=#{segment.archetype}, apex at #{(segment.apex_position * 100).round}% of the line, " \
            "high note hit #{apex_hits}x, range #{segment.range_semitones}st"
        end

        def range_summary(midis)
          "#{segment.range_semitones} semitones (#{label_of(midis.min)}-#{label_of(midis.max)})"
        end

        def interval_summary(midis)
          intervals = midis.each_cons(2).map { |a, b| b - a }
          leaps = intervals.select { |value| value.abs >= 5 }
          forbidden = intervals.select { |value| [6, 11].include?(value.abs) || value.abs > 12 }
          "mean |iv| #{segment.style.fetch(:mean_interval)}st, #{leaps.length} leaps>=P4, " \
            "#{unrecovered_leaps(midis)} unrecovered, #{forbidden.length} tritone/M7/>8ve"
        end

        def rhythm_summary(durations, metric)
          distinct = durations.map { |duration| duration.round(3) }.uniq.length
          offbeat = metric.count { |row| row.fetch(:strength) == "offbeat" }
          syncopated = metric.each_index.count { |index|
            metric[index].fetch(:strength) == "offbeat" && durations[index] >= 1.0
          }
          "#{distinct} distinct values, density #{segment.style.fetch(:note_density)}/beat, " \
            "#{offbeat} off-beat onsets (#{syncopated} agogic-syncopated)"
        end

        def cadence_summary
          degrees = notes.map { |note| note.features.fetch(:tonal).fetch(:degree) }
          ending = degrees.last(3).compact
          "ends on scale-degrees #{ending.empty? ? '?' : ending.inspect}"
        end

        def apex_ok?(midis)
          apex_hits = midis.count(midis.max)
          segment.archetype != "flat" && segment.apex_position >= APEX_EDGE &&
            segment.apex_position <= 1 - APEX_EDGE && apex_hits <= MAX_APEX_HITS
        end

        def unrecovered_leaps(midis)
          intervals = midis.each_cons(2).map { |a, b| b - a }
          count = 0
          0.upto(intervals.length - 2) do |index|
            count += 1 if intervals[index].abs >= 5 &&
                          !(intervals[index + 1].abs.between?(1, 2) && intervals[index] * intervals[index + 1] < 0)
          end
          count
        end

        def rhythm_ok?(durations, metric)
          distinct = durations.map { |duration| duration.round(3) }.uniq.length
          offbeat = metric.count { |row| row.fetch(:strength) == "offbeat" }
          distinct >= MIN_DISTINCT_DUR && (offbeat.positive? || distinct >= 4)
        end

        def cadence?
          ending = notes.map { |note| note.features.fetch(:tonal).fetch(:degree) }.last(3).compact
          ending.any? && ending.last == 1 && (ending.length < 2 || [2, 7, 5, 4].include?(ending[-2]))
        end

        def verdict(ok, message)
          "#{ok ? 'OK   ' : 'CHECK'} #{message}"
        end

      end
    end
  end
end
