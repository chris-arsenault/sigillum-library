# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module Values
        # Includes theoretical majors (G#, D#, A#) so modal/minor offsets on sharp tonics
        # land before the -7..7 clamp.
        MAJOR_FIFTHS = {
          "Cb" => -7, "Gb" => -6, "Db" => -5, "Ab" => -4, "Eb" => -3, "Bb" => -2, "F" => -1,
          "C" => 0, "G" => 1, "D" => 2, "A" => 3, "E" => 4, "B" => 5, "F#" => 6, "C#" => 7,
          "G#" => 8, "D#" => 9, "A#" => 10
        }.freeze
        # Fifths offset of each mode's diatonic collection relative to the major scale
        # on the same tonic (D dorian = C major collection = fifths(D major) - 2).
        MODE_FIFTHS_OFFSET = {
          "major" => 0, "ionian" => 0, "mixolydian" => -1, "dorian" => -2, "minor" => -3,
          "aeolian" => -3, "harmonic_minor" => -3, "melodic_minor" => -3, "phrygian" => -4,
          "locrian" => -5, "lydian" => 1
        }.freeze
        # MusicXML <mode> vocabulary; the notated signature for harmonic/melodic minor is minor.
        MUSICXML_MODES = MODE_FIFTHS_OFFSET.keys.to_h { |mode| [mode, mode] }
                                           .merge("harmonic_minor" => "minor", "melodic_minor" => "minor").freeze
        NOTE_TYPE_DURATIONS = {
          Rational(8) => "breve",
          Rational(4) => "whole",
          Rational(2) => "half",
          Rational(1) => "quarter",
          Rational(1, 2) => "eighth",
          Rational(1, 4) => "16th",
          Rational(1, 8) => "32nd",
          Rational(1, 16) => "64th",
          Rational(1, 32) => "128th",
          Rational(1, 64) => "256th",
          Rational(1, 128) => "512th",
          Rational(1, 256) => "1024th"
        }.freeze

        private

        def normalize_pedal_state(value)
          state = value.to_s.strip.downcase.tr("-", "_")
          return "down" if %w[down start on sustain ped half half_pedal].include?(state)
          return "up" if %w[up stop off release clear].include?(state)

          nil
        end

        def title
          @data.fetch("title")
        end

        def total_duration
          @total_duration ||= rational(@data.fetch("total_duration_ql"))
        end

        def parse_meter(value)
          beats, beat_type = value.to_s.split("/", 2)
          [Integer(beats), Integer(beat_type)]
        end

        def meter_length(value)
          beats, beat_type = parse_meter(value)
          Rational(beats * 4, beat_type)
        end

        def key_fifths(value)
          parsed_key(value).fetch(:fifths)
        end

        def key_mode(value)
          parsed_key(value).fetch(:mode)
        end

        def parsed_key(value)
          parsed = Production.parse_key_context(value)
          tonic = parsed.fetch(:tonic_name).sub(/-?\d+\z/, "")
          fifths = MAJOR_FIFTHS.fetch(tonic, 0) + MODE_FIFTHS_OFFSET.fetch(parsed.fetch(:mode), 0)
          { fifths: fifths.clamp(-7, 7), mode: MUSICXML_MODES.fetch(parsed.fetch(:mode), "major") }
        rescue Partitura::Production::CompileError
          legacy_parsed_key(value.to_s)
        end

        # Pre-mode key spellings ("Dm", "F#m") that parse_key_context does not accept.
        def legacy_parsed_key(key)
          minor = key.end_with?("m") && key.length > 1
          tonic = minor ? key.delete_suffix("m") : key
          tonic = tonic[0].upcase + tonic[1..] if tonic.match?(/\A[a-g]/)
          fifths = MAJOR_FIFTHS.fetch(tonic, 0) + (minor ? -3 : 0)
          { fifths: fifths.clamp(-7, 7), mode: minor ? "minor" : "major" }
        end

        def parse_pitch(value)
          match = value.to_s.match(/\A([A-Ga-g])([#b]*)(-?\d+)\z/)
          raise Error, "unsupported pitch #{value.inspect}" unless match

          accidental = match[2]
          {
            step: match[1].upcase,
            alter: accidental_alter(accidental),
            octave: Integer(match[3])
          }
        end

        def written_pitch(value)
          parsed = parse_pitch(value)
          transposition = written_transposition_for_current_part
          return parsed unless transposition

          transpose_written_pitch(parsed, transposition)
        end

        def written_transposition_for_current_part
          return nil unless @current_rendered_index

          written_transposition_for(rendered_parts.fetch(@current_rendered_index))
        end

        def written_transposition_for(part)
          WRITTEN_TRANSPOSITIONS[part.fetch("music21_instrument", "").to_s]
        end

        def transpose_written_pitch(parsed, transposition)
          steps = %w[C D E F G A B]
          source_index = steps.index(parsed.fetch(:step))
          diatonic_total = source_index + transposition.fetch(:written_diatonic)
          target_step = steps.fetch(diatonic_total % steps.length)
          target_octave = parsed.fetch(:octave) + diatonic_total.div(steps.length)
          target_midi = parsed_pitch_midi(parsed) + transposition.fetch(:written_chromatic)
          natural_midi = parsed_pitch_midi({ step: target_step, alter: 0, octave: target_octave })
          { step: target_step, alter: target_midi - natural_midi, octave: target_octave }
        end

        def parsed_pitch_midi(parsed)
          base = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }
          ((parsed.fetch(:octave) + 1) * 12) + base.fetch(parsed.fetch(:step)) + parsed.fetch(:alter)
        end

        def written_key_fifths(part, value)
          transposition = written_transposition_for(part)
          delta = transposition ? transposition.fetch(:key_fifths_delta) : 0
          (key_fifths(value) + delta).clamp(-7, 7)
        end

        def pitch_midi(value)
          parsed = parse_pitch(value)
          base = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.fetch(parsed.fetch(:step))
          ((parsed.fetch(:octave) + 1) * 12) + base + parsed.fetch(:alter)
        end

        def parse_harmony(value)
          match = value.to_s.match(/\A([A-Ga-g])([#b]?)(.*)\z/)
          return nil unless match

          suffix = match[3].to_s
          kind =
            if suffix.match?(/m(?!aj)/)
              "minor"
            elsif suffix.match?(/7/)
              "dominant"
            else
              "major"
            end
          {
            step: match[1].upcase,
            alter: accidental_alter(match[2]),
            kind: kind
          }
        end

        def accidental_alter(value)
          value.to_s.count("#") - value.to_s.count("b")
        end

        def duration_units(duration)
          (duration * DIVISIONS).round
        end

        def clef_for_part(part)
          return ["G", "2"] if part.fetch("render_kind") == "notes"

          instrument = part.fetch("music21_instrument", "").to_s
          return ["percussion", nil] if PERCUSSION_CLEF_INSTRUMENTS.include?(instrument)
          return ["C", "3"] if ALTO_CLEF_INSTRUMENTS.include?(instrument)
          return ["F", "4"] if BASS_CLEF_INSTRUMENTS.include?(instrument)

          ["G", "2"]
        end

        def clef_signature(value)
          CLEF_SIGNATURES.fetch(value.to_s)
        end

        def wedge_number_for_span(rendered_index, start_offset, end_offset, key:)
          musicxml_number_level([:wedge, rendered_index], start_offset, end_offset, key: key)
        end

        def pedal_number_for_span(rendered_index, start_offset, end_offset, key:)
          musicxml_number_level([:pedal, rendered_index], start_offset, end_offset, key: key)
        end

        def musicxml_number_level(scope, start_offset, end_offset, key:)
          start_offset = rational(start_offset)
          end_offset = rational(end_offset)
          cache_key = [scope, key]
          number_level_assignments.fetch(cache_key) do
            number = next_musicxml_number_level(scope, start_offset, end_offset)
            number_level_assignments[cache_key] = number
          end
        end

        def next_musicxml_number_level(scope, start_offset, end_offset)
          spans = number_level_spans[scope]
          used = spans.filter_map do |span|
            span.fetch(:number) if number_level_spans_overlap?(span, start_offset, end_offset)
          end
          number = MUSICXML_NUMBER_LEVELS.find { |candidate| !used.include?(candidate) } ||
            MUSICXML_NUMBER_LEVELS.last
          spans << { start_offset: start_offset, end_offset: end_offset, number: number }
          number
        end

        def number_level_spans_overlap?(span, start_offset, end_offset)
          span.fetch(:start_offset) < end_offset && start_offset < span.fetch(:end_offset)
        end

        def number_level_assignments
          @number_level_assignments ||= {}
        end

        def number_level_spans
          @number_level_spans ||= Hash.new { |hash, key| hash[key] = [] }
        end

        def format_tempo(value)
          value.to_s
        end

        def duration_type(duration)
          tuplet = tuplet_signature(duration)
          return [tuplet.fetch(:normal_type), 0, :tuplet] if tuplet
          return [NOTE_TYPE_DURATIONS.fetch(duration), 0, :exact] if NOTE_TYPE_DURATIONS.key?(duration)

          NOTE_TYPE_DURATIONS.each do |base, name|
            return [name, 1, :exact] if duration == base * Rational(3, 2)
            return [name, 2, :exact] if duration == base * Rational(7, 4)
          end

          ["quarter", 0, :fallback]
        end

        def tuplet_signature(duration)
          NOTE_TYPE_DURATIONS.each do |base, name|
            return { normal_type: name } if duration == base * Rational(2, 3)
          end

          nil
        end

        def part_xml_id(index)
          "P#{index + 1}"
        end

        def instrument_xml_id(index)
          "I#{index + 1}"
        end

        def percussion_instrument_xml_id(index, entry_index)
          "#{instrument_xml_id(index)}-#{entry_index + 1}"
        end

        def percussion_map_entries(part)
          Array(part["percussion_map"])
        end

        def percussion_map_entry(part, pitch)
          percussion_map_entries(part).find { |entry| entry.fetch("source_pitch") == pitch.to_s }
        end

        def abbreviation_for(part)
          return part.fetch("abbreviation") if part["abbreviation"]

          name = part_name_for(part)
          return "Notes" if name == "Notes"

          ABBREVIATIONS.fetch(name, name.split.map { |word| word[0] }.join)
        end

        def instrument_abbreviation_for(part, abbreviation)
          return "Pno" if part_name_for(part) == "Notes"

          abbreviation.delete_suffix(".")
        end

        def part_name_for(part)
          return "Crash Cymbals" if part["family"].to_s == "percussion" && part.fetch("name") == "Cymbals"

          part.fetch("name")
        end

        def midi_program_for(part)
          MIDI_PROGRAMS.fetch(part.fetch("music21_instrument"), 1)
        end

        def rational(value)
          raw =
            case value
            when Rational
              value
            when Integer
              Rational(value)
            else
              Rational(value.to_s)
            end
          Rational((raw * DIVISIONS).round, DIVISIONS)
        end

        def deep_stringify(value)
          case value
          when Hash
            value.each_with_object({}) { |(key, child), out| out[key.to_s] = deep_stringify(child) }
          when Array
            value.map { |child| deep_stringify(child) }
          else
            value
          end
        end

        def centered_comment(text)
          " #{text} ".center(62, "=")
        end
      end
    end
  end
end
