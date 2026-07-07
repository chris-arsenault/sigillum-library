# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class MelodyAnalysis
        module ReportHarmony
          private

          def harmonic_exposure(harmony, metric, bars_by_number)
            counts = harmonic_bar_counts(harmony, metric, bars_by_number)
            ncts = non_chord_tone_roles(harmony)
            nbars = [bars_by_number.length, 1].max
            {
              implied: counts.fetch(:implied),
              root_rate: counts.fetch(:root_hits).to_f / nbars,
              strong_ct_rate: counts.fetch(:strong_ct).to_f / [counts.fetch(:strong), 1].max,
              nct_rate: ncts.length.to_f / notes.length,
              summary: harmonic_summary(counts, nbars, accented_non_chord_tone_count(harmony, metric)),
              nct_summary: nct_summary(ncts)
            }
          end

          def harmonic_bar_counts(harmony, metric, bars_by_number)
            counts = { implied: [], root_hits: 0, strong: 0, strong_ct: 0 }
            bars_by_number.keys.sort.each do |bar|
              count_harmonic_bar!(counts, harmony, metric, bars_by_number.fetch(bar))
            end
            counts
          end

          def count_harmonic_bar!(counts, harmony, metric, indexes)
            downbeat_index = indexes.min_by { |index| metric[index].fetch(:bar_position) }
            counts.fetch(:implied) << implied_harmony_label(harmony[downbeat_index])
            counts[:root_hits] += 1 if harmony[downbeat_index].fetch(:role) == "ct:R"
            count_strong_harmony!(counts, harmony, metric, indexes)
          end

          def implied_harmony_label(harmony)
            "#{harmony.fetch(:roman)}#{harmony.fetch(:inversion)}"
          end

          def count_strong_harmony!(counts, harmony, metric, indexes)
            indexes.each do |index|
              next unless strong_metric_position?(metric[index])

              counts[:strong] += 1
              counts[:strong_ct] += 1 if harmony[index].fetch(:role).start_with?("ct")
            end
          end

          def non_chord_tone_roles(harmony)
            harmony.map { |row| row.fetch(:role) }.select { |role| role.start_with?("nct") }
          end

          def accented_non_chord_tone_count(harmony, metric)
            harmony.each_index.count do |index|
              harmony[index].fetch(:role).start_with?("nct") && strong_metric_position?(metric[index])
            end
          end

          def strong_metric_position?(row)
            %w[downbeat halfbar].include?(row.fetch(:strength))
          end

          def harmonic_summary(counts, nbars, accented_nct)
            "#{percent(counts.fetch(:strong_ct), [counts.fetch(:strong), 1].max)} of strong beats are chord tones, " \
              "downbeat=root in #{counts.fetch(:root_hits)}/#{nbars} bars; #{accented_nct} accented NCTs"
          end

          def nct_summary(ncts)
            counts = tally(ncts.map { |role| role.split(":", 2).last })
            "#{percent(ncts.length, notes.length)} NCTs (#{hash_preview(counts, 4)})"
          end
        end
      end
    end
  end
end
