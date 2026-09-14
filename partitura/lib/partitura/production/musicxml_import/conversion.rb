# frozen_string_literal: true

module Partitura
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
                { bar: note.bar, onset: note.onset, pitch: note.pitch || (note.midi && MusicXMLImport.midi_to_label(note.midi)),
                  duration: note.duration, marks: note.marks, ties: note.ties, staff: note.staff, voice: note.voice }
              end
            end,
            harmony: harmony,
            meta: meta.map(&:to_h)
          }
        end

        def json_h
          {
            schema_version: 1,
            status: "ok",
            path:,
            bars: { first:, last: },
            beats: beats.to_s,
            segments: segments.map do |name, segment_first, segment_last|
              { name:, bars: { first: segment_first, last: segment_last } }
            end,
            parts: json_parts,
            harmony: harmony.map do |(bar, onset), chord|
              { bar:, onset: onset.to_s, chord: }
            end,
            meta: meta.map { |row| row.to_h.merge(onset: row.onset&.to_s) }
          }
        end

        def render
          lines = []
          lines << "# Converted from: #{path}"
          lines << "# Bars #{first}-#{last}; concert pitch; explicit ties; durations quarter=1."
          lines << "# Paste each block into a `phrase ... events %q{ ... }` body."
          parts.each { |part, notes| append_part(lines, part, notes) }
          append_harmony(lines)
          append_keys(lines)
          lines.join("\n")
        end

        private

        def json_parts
          parts.transform_values do |notes|
            notes.map do |note|
              {
                bar: note.bar,
                onset: note.onset.to_s,
                pitch: note.pitch || (note.midi && MusicXMLImport.midi_to_label(note.midi)),
                duration: note.duration.to_s,
                marks: note.marks,
                ties: note.ties,
                staff: note.staff,
                voice: note.voice
              }
            end
          end
        end

        def append_part(lines, part, notes)
          lines << ""
          lines << "#### #{part} ####"
          append_part_meta(lines, part)
          segments.each { |segment| append_segment(lines, notes, segment) }
        end

        def append_part_meta(lines, part)
          meta.each do |row|
            next unless row.part == part && (first..last).cover?(row.bar) && row.kind != "key"

            lines << "  # m#{row.bar} offset=#{row.onset || 0} staff=#{row.staff || 1}: #{row.kind.upcase} #{row.text}"
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
          MusicXMLImport.fill_and_slice(notes, segment_first, segment_last, beats)
        end

        def render_body(lines, notes)
          current = nil
          line = []
          notes.group_by { |note| [note.bar, note.onset] }.each_value do |simultaneous|
            sounding = simultaneous.reject { |note| note.midi.nil? }
            simultaneous = sounding unless sounding.empty?
            note = simultaneous.first
            unless simultaneous.map { |item| [item.duration, item.ties.sort] }.uniq.length == 1
              raise ArgumentError, "independent voices at bar #{note.bar}; import separate voices before rendering DSL"
            end
            current ||= note.bar
            if note.bar != current
              lines << "          #{line.join(' ')} |"
              line = []
              current = note.bar
            end
            pitches = simultaneous.filter_map { |item| item.pitch || (item.midi && MusicXMLImport.midi_to_label(item.midi)) }
            token = pitches.empty? ? "r" : (pitches.length == 1 ? pitches.first : "[#{pitches.join(',')}]")
            token += ":#{MusicXMLImport.format_duration(note.duration)}"
            marks = simultaneous.flat_map(&:marks).uniq
            marks << "tie)" if note.ties.include?("stop")
            marks << "tie(" if note.ties.include?("start")
            token += "{#{marks.join(',')}}" unless marks.empty?
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
