# frozen_string_literal: true

require "rexml/document"
require_relative "musicxml_import/conversion"
require_relative "musicxml_import/marks"
require_relative "musicxml_import/verification"

module Partitura
  module Production
    module MusicXMLImport
      CHORD_WORD = /\A[A-G][#b]?(m|dim7?|maj7|m7b5|m7|sus[24]|aug|7|9)*\z/
      STEPS = %w[C C# D Eb E F F# G Ab A Bb B].freeze
      STEP_PC = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze
      ART = {
        "staccato" => "stacc",
        "accent" => "accent",
        "strong-accent" => "marc",
        "tenuto" => "ten",
        "detached-legato" => "ten"
      }.freeze
      KIND = {
        "major" => "",
        "minor" => "m",
        "dominant" => "7",
        "diminished" => "dim",
        "diminished-seventh" => "dim7",
        "half-diminished" => "m7b5",
        "minor-seventh" => "m7",
        "major-seventh" => "maj7",
        "dominant-seventh" => "7",
        "suspended-fourth" => "sus4",
        "augmented" => "aug"
      }.freeze
      PART_KEYS = %w[flute trumpet trombone violin violoncello cello contrabass bass percussion].freeze

      Note = Struct.new(:bar, :onset, :midi, :duration, :marks, :ties, keyword_init: true)
      Meta = Struct.new(:part, :bar, :kind, :text, keyword_init: true)

      module_function

      def convert(path, bars: 1..10_000, segments: nil, perc_map: {}, beats: 2)
        first, last = normalize_bars(bars)
        percussion = normalize_map(perc_map)
        parts, harmony, meta = load_parts(path, last, percussion)
        last = [last, max_content_bar(parts)].min
        Conversion.new(
          path: path,
          first: first,
          last: last,
          beats: beats,
          segments: normalize_segments(segments) || [["all", first, last]],
          parts: parts,
          harmony: harmony,
          meta: meta
        )
      end

      def verify(hand_path, export_path, bars: 1..10_000, perc_map: {}, beats: 2)
        first, last = normalize_bars(bars)
        percussion = normalize_map(perc_map)
        sides = [hand_path, export_path].map do |path|
          parts, = load_parts(path, last, percussion)
          last = [last, max_content_bar(parts)].min
          parts.transform_values do |notes|
            rebars = {}
            merge_ties(fill_and_slice(notes, first, last, beats)).each do |note|
              (rebars[note.bar] ||= []) << [note.midi, note.duration]
            end
            rebars
          end
        end
        Verification.new(first: first, last: last, hand: sides[0], export: sides[1])
      end

      def parse_bars(text)
        first, last = text.to_s.split("-", 2).map(&:to_i)
        first..last
      end

      def parse_segments(text)
        text.to_s.split(",").map do |item|
          name, range = item.split(":", 2)
          first, last = range.split("-", 2).map(&:to_i)
          [name.strip, first, last]
        end
      end

      def load_parts(path, last_bar, perc_map)
        document = REXML::Document.new(File.read(path))
        names = score_part_names(document)
        tracks = { parts: {}, harmony: {}, meta: [] }
        REXML::XPath.each(document, "//part") do |part_element|
          load_part_element(part_element, names, last_bar, perc_map, tracks)
        end

        [tracks.fetch(:parts), tracks.fetch(:harmony), tracks.fetch(:meta)]
      end

      def score_part_names(document)
        names = {}
        REXML::XPath.each(document, "//score-part") do |score_part|
          names[score_part.attributes["id"]] = text_at(score_part, "part-name") || score_part.attributes["id"]
        end
        names
      end

      def load_part_element(part_element, names, last_bar, perc_map, tracks)
        state = part_state(part_element, names, perc_map, tracks)
        each_child(part_element, "measure") do |measure|
          number = measure_number(measure)
          next unless number
          break if number > last_bar

          load_measure(measure, number, state)
        end
        tracks.fetch(:parts)[state.fetch(:name)] = state.fetch(:notes)
      end

      def part_state(part_element, names, perc_map, tracks)
        transpose = first_at(part_element, ".//transpose")
        {
          name: norm_part(names[part_element.attributes["id"]].to_s.strip),
          chromatic: transpose ? Integer(text_at(transpose, "chromatic", "0")) : 0,
          octave_change: transpose ? Integer(text_at(transpose, "octave-change", "0")) : 0,
          divisions: 1,
          notes: [],
          bar_fill: {},
          perc_map: perc_map,
          tracks: tracks
        }
      end

      def measure_number(measure)
        match = measure.attributes["number"].to_s.match(/\AX?(\d+)\z/)
        match && Integer(match[1])
      end

      def load_measure(measure, number, state)
        update_divisions!(measure, state)
        record_key_signature(measure, number, state)
        cursor = state.fetch(:bar_fill).fetch(number, 0r)
        pending = []
        measure.elements.each do |child|
          cursor = load_measure_child(child, number, cursor, pending, state)
        end
        attach_pending!(state.fetch(:notes), number, pending)
        state.fetch(:bar_fill)[number] = cursor
      end

      def update_divisions!(measure, state)
        division_text = text_at(measure, "attributes/divisions")
        state[:divisions] = Integer(division_text) if division_text
      end

      def record_key_signature(measure, number, state)
        key_text = text_at(measure, "attributes/key/fifths")
        return unless key_text

        state.fetch(:tracks).fetch(:meta) << Meta.new(
          part: state.fetch(:name),
          bar: number,
          kind: "key",
          text: "fifths=#{key_text} mode=#{text_at(measure, 'attributes/key/mode')}"
        )
      end

      def load_measure_child(child, number, cursor, pending, state)
        case child.name
        when "backup"
          cursor - child_duration(child, state)
        when "forward"
          cursor + child_duration(child, state)
        when "harmony"
          read_harmony(child, number, cursor, state.fetch(:tracks).fetch(:harmony))
          cursor
        when "direction"
          append_pending_direction(child, number, cursor, pending, state)
          cursor
        when "note"
          load_note(child, number, cursor, state)
        else
          cursor
        end
      end

      def child_duration(child, state)
        Rational(Integer(text_at(child, "duration", "0")), state.fetch(:divisions))
      end

      def append_pending_direction(child, number, cursor, pending, state)
        payload = read_direction(child, state.fetch(:name), number, state.fetch(:tracks).fetch(:meta))
        pending << [cursor, payload] unless payload.empty?
      end

      def load_note(child, number, cursor, state)
        if first_at(child, "chord") || first_at(child, "grace")
          state.fetch(:tracks).fetch(:meta) << Meta.new(part: state.fetch(:name), bar: number, kind: "warning", 
text: "chord or grace note skipped")
          return cursor
        end

        duration = child_duration(child, state)
        state.fetch(:notes) << imported_note(child, number, cursor, duration, state)
        cursor + duration
      end

      def imported_note(child, number, onset, duration, state)
        marks = read_marks(child)
        ties = each_at(child, "tie").map { |tie| tie.attributes["type"] }.compact
        midi = if first_at(child, "rest")
                 nil
               else
                 read_pitch(child, state.fetch(:chromatic), state.fetch(:octave_change), state.fetch(:perc_map))
               end
        Note.new(bar: number, onset: onset, midi: midi, duration: duration, marks: marks, ties: ties)
      end

      def read_harmony(element, bar, cursor, harmony_track)
        root_step = text_at(element, "root/root-step")
        return unless root_step

        alter = Integer(text_at(element, "root/root-alter", "0"))
        kind = first_at(element, "kind")
        label = root_step + { 1 => "#", -1 => "b" }.fetch(alter, "")
        if kind && kind.attributes["text"]
          label += kind.attributes["text"]
        elsif kind
          label += KIND.fetch(kind.text.to_s, kind.text.to_s)
        end
        harmony_track[[bar, cursor]] ||= label
      end

      def read_direction(element, part, bar, meta)
        payload = []
        dynamics = first_at(element, ".//dynamics")
        payload << dynamics.elements[1].name if dynamics && dynamics.elements[1]
        each_at(element, "direction-type/words") do |words|
          text = words.text.to_s.strip
          payload << "txt:#{slug(text)}" if !text.empty? && !CHORD_WORD.match?(text)
        end
        metronome = first_at(element, ".//metronome")
        if metronome
          meta << Meta.new(
            part: part,
            bar: bar,
            kind: "tempo",
            text: "#{metronome_beat_unit(metronome)}=#{text_at(metronome, 'per-minute')}"
          )
        end
        wedge = first_at(element, ".//wedge")
        meta << Meta.new(part: part, bar: bar, kind: "wedge", text: wedge.attributes["type"]) if wedge
        payload
      end

      def read_pitch(element, chromatic, octave_change, perc_map)
        pitch = first_at(element, "pitch")
        if pitch
          ((Integer(text_at(pitch, "octave")) + 1) * 12) +
            STEP_PC.fetch(text_at(pitch, "step")) +
            Integer(text_at(pitch, "alter", "0")) +
            chromatic +
            (12 * octave_change)
        else
          unpitched = first_at(element, "unpitched")
          label = "#{text_at(unpitched, 'display-step', 'C')}#{text_at(unpitched, 'display-octave', '4')}"
          label_to_midi(perc_map.fetch(label, label))
        end
      end

      def attach_pending!(notes, bar, pending)
        pending.each do |offset, payload|
          target = pending_target(notes, bar, offset)
          target.marks = payload + target.marks if target
        end
      end

      def pending_target(notes, bar, offset)
        pending_note_at_or_after(notes, bar, offset) || pending_anything_at_or_after(notes, bar, offset) || notes.last
      end

      def pending_note_at_or_after(notes, bar, offset)
        notes.find { |note| note.bar == bar && note.onset >= offset && !note.midi.nil? }
      end

      def pending_anything_at_or_after(notes, bar, offset)
        notes.find { |note| [note.bar, note.onset] >= [bar, offset] }
      end

      def merge_ties(notes)
        merged = []
        index = 0
        while index < notes.length
          note = notes[index]
          if mergeable_tie_start?(note)
            merged_note, index = merged_tie_note(notes, index)
            merged << merged_note
          else
            merged << clone_note(note)
            index += 1
          end
        end
        merged
      end

      def mergeable_tie_start?(note)
        note.midi && note.ties.include?("start")
      end

      def merged_tie_note(notes, index)
        note = notes.fetch(index)
        duration = note.duration
        marks = note.marks.dup
        cursor = index + 1
        while cursor < notes.length
          candidate = notes[cursor]
          break unless tied_continuation?(candidate, note)

          duration += candidate.duration
          candidate.marks.each { |mark| marks << mark unless marks.include?(mark) }
          cursor += 1
          break unless candidate.ties.include?("start")
        end
        [Note.new(bar: note.bar, onset: note.onset, midi: note.midi, duration: duration, marks: marks, ties: []), 
cursor]
      end

      def tied_continuation?(candidate, note)
        candidate.midi == note.midi && candidate.ties.include?("stop")
      end

      def clone_note(note)
        Note.new(
          bar: note.bar,
          onset: note.onset,
          midi: note.midi,
          duration: note.duration,
          marks: note.marks,
          ties: note.ties
        )
      end

      def fill_and_slice(notes, first, last, beats_per_bar)
        present = notes.map(&:bar).uniq
        out = notes.select { |note| (first..last).cover?(note.bar) }
        first.upto(last) do |bar|
          next if present.include?(bar)

          out << Note.new(bar: bar, onset: 0r, midi: nil, duration: Rational(beats_per_bar), marks: [], ties: [])
        end
        out.sort_by { |note| [note.bar, note.onset] }
      end

      def max_content_bar(parts)
        parts.values.flatten.select { |note| note.midi }.map(&:bar).max || 1
      end

      def norm_part(name)
        normalized = name.downcase
        special = special_part_name(normalized)
        return special if special

        found = PART_KEYS.find { |key| normalized.include?(key) }
        return { "violoncello" => "cello", "contrabass" => "bass" }.fetch(found, found) if found

        normalized.empty? ? "?" : normalized
      end

      def special_part_name(normalized)
        return "percussion" if normalized.include?("snare") || normalized == "percussion"
        return "bass_drum" if normalized.include?("bass drum")
        return "cymbal" if normalized.include?("cymbal")

        nil
      end

      def midi_to_label(midi)
        "#{STEPS[midi % 12]}#{(midi / 12) - 1}"
      end

      def label_to_midi(label)
        match = label.to_s.match(/\A([A-G])([#b]*)(-?\d+)\z/)
        raise ArgumentError, "bad pitch label #{label.inspect}" unless match

        ((match[3].to_i + 1) * 12) + STEP_PC.fetch(match[1]) + match[2].count("#") - match[2].count("b")
      end

      def format_duration(value)
        fraction = Rational(value)
        return fraction.numerator.to_s if fraction.denominator == 1
        return fraction.to_f.to_s.sub(/0+\z/, "").sub(/\.\z/, "").sub(/\A0\./, ".") if [2, 
4].include?(fraction.denominator)

        "#{fraction.numerator}/#{fraction.denominator}"
      end

      def slug(text)
        text.strip.tr(" ", "_").tr("éè", "ee")
      end

      def normalize_bars(value)
        range = value.is_a?(String) ? parse_bars(value) : value
        [Integer(range.begin), Integer(range.end)]
      end

      def normalize_segments(value)
        return nil if value.nil?
        return parse_segments(value) if value.is_a?(String)

        value.map do |segment|
          if segment.is_a?(Hash)
            first, last = normalize_bars(segment.fetch(:bars))
            [segment.fetch(:name).to_s, first, last]
          else
            [segment[0].to_s, Integer(segment[1]), Integer(segment[2])]
          end
        end
      end

      def normalize_map(value)
        return value.transform_keys(&:to_s).transform_values(&:to_s) if value.is_a?(Hash)

        Array(value).each_with_object({}) do |entry, out|
          left, right = entry.to_s.split("=", 2)
          out[left] = right
        end
      end

      def first_at(element, path)
        REXML::XPath.first(element, path)
      end

      def each_at(element, path, &block)
        REXML::XPath.each(element, path, &block)
      end

      def each_child(element, name, &block)
        element.each_element(name, &block)
      end

      def text_at(element, path, default = nil)
        found = first_at(element, path)
        text = found&.text
        text.nil? ? default : text
      end

    end
  end
end
