# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module MusicXMLImport
        class Verification
          attr_reader :first, :last, :hand, :export

          def initialize(first:, last:, hand:, export:)
            @first = first
            @last = last
            @hand = hand
            @export = export
          end

          def ok?
            total_differing_bars.zero?
          end

          def total_differing_bars
            rows.sum { |row| row.fetch(:diffs).length + (row.fetch(:only_on_one_side_with_notes) ? 1 : 0) }
          end

          def rows
            @rows ||= build_rows
          end

          def to_h
            { bars: first..last, total_differing_bars: total_differing_bars, rows: rows }
          end

          def render
            lines = ["comparing bars #{first}-#{last}"]
            rows.each do |row|
              part = row.fetch(:part)
              if row.fetch(:side)
                suffix = if row.fetch(:only_on_one_side_with_notes)
                           "only on one side WITH notes in range"
                         else
                           "only on one side (all rests in range - OK)"
                         end
                lines << "#{part}: #{suffix}"
              else
                diffs = row.fetch(:diffs)
                lines << "#{part}: #{diffs.empty? ? 'OK' : "DIFF at bars #{diffs.first(24).inspect}"}"
              end
            end
            lines << "TOTAL differing bars: #{total_differing_bars}"
            lines.join("\n")
          end

          private

          def build_rows
            shared = (hand.keys & export.keys).sort
            rows = shared.map do |part|
              diffs = first.upto(last).select do |bar|
                norm_events(hand.fetch(part).fetch(bar, [])) != norm_events(export.fetch(part).fetch(bar, []))
              end
              { part: part, diffs: diffs, side: nil, only_on_one_side_with_notes: false }
            end

            ((hand.keys | export.keys) - shared).sort.each do |part|
              side = hand[part] || export[part]
              has_notes = side.values.flatten(1).any? { |midi, _duration| !midi.nil? }
              rows << { part: part, diffs: [], side: hand.key?(part) ? :hand : :export, 
only_on_one_side_with_notes: has_notes }
            end
            rows
          end

          def norm_events(events)
            out = []
            events.each do |midi, duration|
              next if duration.zero?

              if !out.empty? && midi.nil? && out.last[0].nil?
                out[-1] = [nil, out.last[1] + duration]
              else
                out << [midi, duration]
              end
            end
            out
          end
        end
      end
    end
  end
end
