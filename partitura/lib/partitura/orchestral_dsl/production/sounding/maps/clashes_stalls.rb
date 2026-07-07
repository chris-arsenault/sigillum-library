# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module SoundingReadout
        module ClashesStalls
          def exposed_clashes(bars: nil)
            rows = all_sounding.map(&:offset).uniq.sort.flat_map do |offset|
              exposed_clash_rows(all_sounding, offset, bars)
            end
            clash_header(rows).join("\n")
          end

          def exposed_clash_rows(events, offset, bars)
            return [] unless in_bars?(offset, bars)

            sounding = events.select { |event| event.offset <= offset && event.end_offset > offset }
            return [] if sounding.size < 2

            sounding.combination(2).filter_map do |left, right|
              exposed_clash_row(left, right, sounding, offset)
            end
          end

          def exposed_clash_row(left, right, sounding, offset)
            return nil unless left.offset == offset || right.offset == offset

            interval = dissonant_interval(left, right)
            return nil unless interval

            severity = clash_severity(left, right, sounding, offset)
            return nil if severity < 2

            format_clash_row(
              left: left,
              right: right,
              offset: offset,
              interval: interval,
              severity: severity,
              naked: sounding.size == 2
            )
          end

          def dissonant_interval(left, right)
            intervals = left.pitches.product(right.pitches).map { |a, b| (midi_of(a) - midi_of(b)).abs % 12 }
            intervals.find { |interval| DISSONANT.include?(interval) }
          end

          def clash_severity(left, right, sounding, offset)
            (beat_start?(offset) ? 2 : 0) +
              (sounding.size == 2 ? 2 : 0) +
              (left.offset == offset && right.offset == offset ? 1 : 0)
          end

          def composite_stalls(bars: nil)
            rows = composite_stall_rows(all_sounding, bars)
            lines = ["# Composite Stalls (sounding; attack gaps >= 1.25 ql across the whole ensemble)"]
            lines.concat(rows.empty? ? ["(no attack gaps >= 1.25 ql)"] : rows)
            lines.join("\n")
          end

          private

          def clash_header(rows)
            lines = [
              "# Exposed Clashes (sounding; dissonant interval-classes at attack points, " \
              "severity = on-beat + naked + both-attacking)",
              "# adjudicate before fixing: prepared suspensions, cadential V7s, pedal stacks, " \
              "and resolving passing tones are correct music"
            ]
            lines.concat(rows.empty? ? ["(no findings at severity >= 2)"] : rows)
          end

          def format_clash_row(left:, right:, offset:, interval:, severity:, naked:)
            "#{clash_location(offset)} #{clash_pair(left, right)} " \
              "iv#{interval}#{clash_flags(left, right, offset, naked)} sev#{severity} | " \
              "#{clash_context_text(left, right, offset)}"
          end

          def clash_location(offset)
            beat = @piece.format_offset(offset).split(":").last
            "b#{bar_of(offset)}@#{beat}#{beat_start?(offset) ? '*' : ''}"
          end

          def clash_pair(left, right)
            "#{left.part}:#{left.pitch_label}-#{right.part}:#{right.pitch_label}"
          end

          def clash_flags(left, right, offset, naked)
            "#{naked ? ' NAKED' : ''}#{left.offset == offset && right.offset == offset ? ' both-atk' : ''}"
          end

          def clash_context_text(left, right, offset)
            context = clash_context(left, right, offset)
            context.empty? ? "NO stepwise context" : context.join("; ")
          end

          def composite_stall_rows(events, bars)
            events.map(&:offset).uniq.sort.each_cons(2).filter_map do |left, right|
              composite_stall_row(events, left, right, bars)
            end
          end

          def composite_stall_row(events, left, right, bars)
            gap = right - left
            return nil unless in_bars?(left, bars) && gap >= Rational(5, 4)

            "#{composite_stall_location(left)} gap #{Production.format_duration(gap)} | " \
              "#{composite_stall_state(events, left, right)}"
          end

          def composite_stall_location(offset)
            "b#{bar_of(offset)}@#{@piece.format_offset(offset).split(':').last}"
          end

          def composite_stall_state(events, left, right)
            return "FULL SILENCE" if composite_stall_silent?(events, left, right)

            holding = composite_stall_holding_parts(events, left, right)
            holding.empty? ? "decay only" : "held: #{holding.join(',')}"
          end

          def composite_stall_silent?(events, left, right)
            mid = left + ((right - left) / 2)
            events.none? { |event| event.offset <= mid && event.end_offset > mid }
          end

          def composite_stall_holding_parts(events, left, right)
            events.select { |event| event.offset <= left && event.end_offset >= right }
                  .map(&:part).uniq
          end
        end
      end
    end
  end
end
