# frozen_string_literal: true

module Partitura
  module Export
    module MusicXML
      module Values
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
          key = value.to_s
          minor_mode = minor_key?(key)
          tonic = key.end_with?("m") && key.length > 1 ? key.delete_suffix("m") : key
          tonic = tonic[0].upcase + tonic[1..] if tonic.match?(/\A[a-g]/)
          major_keys = {
            "Cb" => -7, "Gb" => -6, "Db" => -5, "Ab" => -4, "Eb" => -3, "Bb" => -2, "F" => -1,
            "C" => 0, "G" => 1, "D" => 2, "A" => 3, "E" => 4, "B" => 5, "F#" => 6, "C#" => 7
          }
          minor_keys = {
            "Ab" => -7, "Eb" => -6, "Bb" => -5, "F" => -4, "C" => -3, "G" => -2, "D" => -1,
            "A" => 0, "E" => 1, "B" => 2, "F#" => 3, "C#" => 4, "G#" => 5, "D#" => 6, "A#" => 7
          }
          (minor_mode ? minor_keys : major_keys).fetch(tonic, 0)
        end

        def key_mode(value)
          minor_key?(value.to_s) ? "minor" : "major"
        end

        def minor_key?(key)
          (key.end_with?("m") && key.length > 1) || key.match?(/\A[a-g]/)
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

        def format_tempo(value)
          value.to_s
        end

        def duration_type(duration)
          return ["quarter", 0, :tuplet] if duration == Rational(2, 3)
          return ["eighth", 0, :tuplet] if duration == Rational(1, 3)

          base_types = {
            Rational(4) => "whole",
            Rational(2) => "half",
            Rational(1) => "quarter",
            Rational(1, 2) => "eighth",
            Rational(1, 4) => "16th",
            Rational(1, 8) => "32nd",
            Rational(1, 16) => "64th"
          }
          return [base_types.fetch(duration), 0, :exact] if base_types.key?(duration)

          base_types.each do |base, name|
            return [name, 1, :exact] if duration == base * Rational(3, 2)
            return [name, 2, :exact] if duration == base * Rational(7, 4)
          end

          ["quarter", 0, :fallback]
        end

        def tuplet_signature(duration)
          return { normal_type: "quarter" } if duration == Rational(2, 3)
          return { normal_type: "eighth" } if duration == Rational(1, 3)

          nil
        end

        def part_xml_id(index)
          "P#{index + 1}"
        end

        def instrument_xml_id(index)
          "I#{index + 1}"
        end

        def abbreviation_for(part)
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
