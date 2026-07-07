# frozen_string_literal: true

module Partitura
  module Export
    module MIDI
      module Values
        PITCH_BASE = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze
        MAJOR_KEYS = {
          "Cb" => -7, "Gb" => -6, "Db" => -5, "Ab" => -4, "Eb" => -3, "Bb" => -2, "F" => -1,
          "C" => 0, "G" => 1, "D" => 2, "A" => 3, "E" => 4, "B" => 5, "F#" => 6, "C#" => 7
        }.freeze
        MINOR_KEYS = {
          "Ab" => -7, "Eb" => -6, "Bb" => -5, "F" => -4, "C" => -3, "G" => -2, "D" => -1,
          "A" => 0, "E" => 1, "B" => 2, "F#" => 3, "C#" => 4, "G#" => 5, "D#" => 6, "A#" => 7
        }.freeze

        private

        def midi_pitch(value)
          match = value.to_s.match(/\A([A-Ga-g])([#b]*)(-?\d+)\z/)
          raise Error, "unsupported pitch #{value.inspect}" unless match

          ((Integer(match[3]) + 1) * 12) + PITCH_BASE.fetch(match[1].upcase) + accidental_offset(match[2])
        end

        def accidental_offset(text)
          text.count("#") - text.count("b")
        end

        def ticks(quarter_length)
          Integer(quarter_length * DIVISIONS)
        end

        def time_signature_bytes(value)
          numerator, denominator = value.to_s.split("/", 2).map(&:to_i)
          [numerator, Math.log2(denominator).to_i, 24, 8].pack("C*")
        end

        def key_signature_bytes(value)
          key = normalize_key_signature(value)
          [key.fetch(:minor) ? MINOR_KEYS.fetch(key.fetch(:tonic), 0) : MAJOR_KEYS.fetch(key.fetch(:tonic), 0),
           key.fetch(:minor) ? 1 : 0].pack("cC")
        end

        def normalize_key_signature(value)
          key = value.to_s
          minor = (key.end_with?("m") && key.length > 1) || key.match?(/\A[a-g]/)
          tonic = key.end_with?("m") && key.length > 1 ? key.delete_suffix("m") : key
          tonic = tonic[0].upcase + tonic[1..] if tonic.match?(/\A[a-g]/)
          { tonic: tonic, minor: minor }
        end

        def rational(value)
          return value if value.is_a?(Rational)
          return Rational(value) if value.is_a?(Integer)

          Rational(value.to_s)
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
      end
    end
  end
end
