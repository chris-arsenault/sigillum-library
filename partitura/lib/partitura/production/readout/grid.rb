# frozen_string_literal: true

module Partitura
  module Production
    class Readout
      module Grid
        def grid(bars: nil)
          all_events = @piece.timed_events(include_rests: true)
          attack_offsets = grid_attack_offsets(all_events, bars)
          return "# Score Grid\n(no events in range)" if attack_offsets.empty?

          lines = ["# Score Grid#{bars ? " | bars #{bars.begin}-#{bars.end}" : ""}"]
          attack_offsets.each_slice(16) do |chunk|
            append_grid_chunk(lines, chunk, @piece.parts.keys, all_events)
          end
          lines.join("\n")
        end

        private

        def grid_attack_offsets(all_events, bars)
          all_events.reject(&:rest?)
                    .select { |event| in_bars?(event.offset, bars) }
                    .map(&:offset).uniq.sort
        end

        def append_grid_chunk(lines, chunk, parts, all_events)
          label_width = parts.map { |part| part.to_s.length }.max + 1
          column_width = 7
          header = grid_header(chunk, label_width, column_width)
          lines << ""
          lines << header
          lines << ("-" * header.length)
          parts.each do |part|
            row = grid_row(part, chunk, all_events, label_width, column_width)
            lines << row if row
          end
        end

        def grid_header(chunk, label_width, column_width)
          chunk.each_with_object((" " * label_width) + "|") do |offset, out|
            out << @piece.format_offset(offset).delete_prefix("b").ljust(column_width) << "|"
          end
        end

        def grid_row(part, chunk, all_events, label_width, column_width)
          cells = chunk.map { |offset| grid_cell(part, offset, all_events) }
          return nil if cells.all? { |cell| cell == "." }

          cells.each_with_object(part.to_s.ljust(label_width) + "|") do |cell, out|
            out << cell.ljust(column_width) << "|"
          end
        end

        def grid_cell(part, offset, all_events)
          event = all_events.find { |candidate| grid_event_matches?(candidate, part, offset) }
          return "." unless event
          return "." if event.rest?

          event.offset == offset ? event.pitch_label : "~"
        end

        def grid_event_matches?(event, part, offset)
          event.part == part && event.offset <= offset && event.end_offset > offset
        end
      end
    end
  end
end
