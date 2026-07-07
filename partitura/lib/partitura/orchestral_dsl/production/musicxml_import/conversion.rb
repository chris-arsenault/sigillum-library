# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      module MusicXMLImport
        class Conversion
          attr_reader :path, :first, :last, :beats, :segments, :parts, :harmony, :meta

          def initialize(path:, first:, last:, beats:, segments:, parts:, harmony:, meta:)
            @path = path
            @first = first
            @last = last
            @beats = beats
            @segments = segments
            @parts = parts
            @harmony = harmony
            @meta = meta
          end

          def to_h
            {
              path: path,
              bars: first..last,
              beats: beats,
              segments: segments,
              parts: parts.transform_values do |notes|
                notes.map do |note|
                  { bar: note.bar, onset: note.onset, pitch: note.midi && MusicXMLImport.midi_to_label(note.midi),
                    duration: note.duration, marks: note.marks }
                end
              end,
              harmony: harmony,
              meta: meta.map { |row| { part: row.part, bar: row.bar, kind: row.kind, text: row.text } }
            }
          end

          def render
            lines = []
            lines << "# Converted from: #{path}"
            lines << "# Bars #{first}-#{last}; concert pitch; ties merged; durations quarter=1."
            lines << "# Paste each block into a `phrase ... events %q{ ... }` body."
            parts.each { |part, notes| append_part(lines, part, notes) }
            append_harmony(lines)
            append_keys(lines)
            lines.join("\n")
          end

          private

          def append_part(lines, part, notes)
            lines << ""
            lines << "#### #{part} ####"
            append_part_meta(lines, part)
            segments.each { |segment| append_segment(lines, notes, segment) }
          end

          def append_part_meta(lines, part)
            meta.each do |row|
              next unless row.part == part && (first..last).cover?(row.bar) && row.kind != "key"

              lines << "  # m#{row.bar}: #{row.kind.upcase} #{row.text}"
            end
          end

          def append_segment(lines, notes, segment)
            name, segment_first, segment_last = segment
            body = segment_body(notes, segment_first, segment_last)
            if body.all? { |note| note.midi.nil? }
              lines << "-- #{name}: ALL RESTS (bars #{segment_first}-#{segment_last})"
              return
            end

            lines << "-- #{name} (bars #{segment_first}-#{segment_last}):"
            render_body(lines, body)
          end

          def segment_body(notes, segment_first, segment_last)
            MusicXMLImport.merge_ties(MusicXMLImport.fill_and_slice(notes, segment_first, segment_last, beats))
          end

          def render_body(lines, notes)
            current = nil
            line = []
            notes.each do |note|
              current ||= note.bar
              if note.bar != current
                lines << "          #{line.join(' ')} |"
                line = []
                current = note.bar
              end
              token = note.midi ? MusicXMLImport.midi_to_label(note.midi) : "r"
              token += ":#{MusicXMLImport.format_duration(note.duration)}"
              token += "{#{note.marks.join(',')}}" unless note.marks.empty?
              line << token
            end
            lines << "          #{line.join(' ')}" unless line.empty?
          end

          def append_harmony(lines)
            return if harmony.empty?

            lines << ""
            lines << "#### HARMONY TRACK (chord symbols) ####"
            harmony.keys.sort.each do |bar, offset|
              next unless (first..last).cover?(bar)

              beat = 1 + offset.to_f
              lines << %(    text "#{harmony.fetch([bar, 
offset])}", at: "bar #{bar} beat #{format('%g', beat)}", for: :all)
            end
          end

          def append_keys(lines)
            keys = meta.select { |row| row.kind == "key" && (first..last).cover?(row.bar) }
                       .map { |row| [row.bar, row.text] }.uniq.sort
            return if keys.empty?

            lines << ""
            lines << "#### KEY SIGNATURES (first part shown; transposing parts differ) ####"
            keys.each { |bar, text| lines << "  m#{bar}: #{text}" }
          end
        end
      end
    end
  end
end
