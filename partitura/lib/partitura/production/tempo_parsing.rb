# frozen_string_literal: true

require_relative "models/entities"

module Partitura
  module Production
    TEMPO_UNIT_ALIASES = {
      "whole" => "whole",
      "half" => "half",
      "quarter" => "quarter",
      "q" => "quarter",
      "eighth" => "eighth",
      "16th" => "16th",
      "sixteenth" => "16th",
      "32nd" => "32nd",
      "thirtysecond" => "32nd",
      "thirty-second" => "32nd"
    }.freeze
    TEMPO_UNIT_QUARTER_LENGTHS = {
      "whole" => Rational(4),
      "half" => Rational(2),
      "quarter" => Rational(1),
      "eighth" => Rational(1, 2),
      "16th" => Rational(1, 4),
      "32nd" => Rational(1, 8)
    }.freeze
    TEMPO_MARK_PATTERN = %r{
      \A\s*
      (?<dot_prefix>triple[\s_-]*dotted|double[\s_-]*dotted|dotted)?
      [\s_-]*
      (?<unit>thirty[\s_-]*second|sixteenth|32nd|16th|eighth|quarter|half|whole|q)
      \s*=\s*
      (?<per_minute>
        (?:(?<approximation>c(?:a)?\.?|circa)\s*)?
        (?<lower>\d+(?:\.\d+)?)
        (?:\s*-\s*(?<upper>\d+(?:\.\d+)?))?
      )
      (?:\s*(?:,.*|[[:alpha:]].*))?\s*\z
    }ix
    TEMPO_SHORTHAND_PATTERN = /\bq\s*=\s*(?<per_minute>\d+(?:\.\d+)?)/i
    MIDI_TEMPO_MICROSECONDS = (1..0xFF_FF_FF)

    module_function

    def tempo_from_text(text)
      source = text.to_s
      match = source.match(TEMPO_MARK_PATTERN)
      return shorthand_tempo(source) if !match && source.match?(TEMPO_SHORTHAND_PATTERN)
      return malformed_tempo!(source) if !match && source.include?("=")
      return fallback_tempo(source) unless match

      beat_unit = canonical_tempo_unit(match[:unit])
      beat_unit_dots = tempo_dot_count(match[:dot_prefix])
      per_minute, playback_value = tempo_values(match, source)
      normalized = normalized_quarter_bpm(beat_unit, beat_unit_dots, playback_value)
      validate_playback_tempo!(normalized, source)

      {
        bpm: normalized_tempo_number(normalized, float: per_minute.is_a?(Float)),
        beat_unit: beat_unit,
        beat_unit_dots: beat_unit_dots,
        per_minute: per_minute
      }
    end

    def bpm_from_text(text)
      tempo_from_text(text)&.fetch(:bpm)
    rescue CompileError => e
      raise unless e.response.fetch(:code) == "bad_tempo_mark"

      fallback_tempo(text.to_s)&.fetch(:bpm)
    end

    def fallback_tempo(source)
      per_minute_text = source.scan(/\d+(?:\.\d+)?/).last
      return nil unless per_minute_text

      per_minute = tempo_number(per_minute_text)
      validate_playback_tempo!(Rational(per_minute.to_s), source)
      { bpm: per_minute, beat_unit: "quarter", beat_unit_dots: 0, per_minute: per_minute }
    end

    def shorthand_tempo(source)
      per_minute = tempo_number(source.match(TEMPO_SHORTHAND_PATTERN)[:per_minute])
      validate_playback_tempo!(Rational(per_minute.to_s), source)
      { bpm: per_minute, beat_unit: "quarter", beat_unit_dots: 0, per_minute: per_minute }
    end

    def tempo_values(match, source)
      lower = Rational(match[:lower])
      upper = match[:upper] && Rational(match[:upper])
      return malformed_tempo!(source) if upper && upper < lower

      playback_value = upper ? (lower + upper) / 2 : lower
      display_value = if match[:approximation] || upper
                        match[:per_minute].strip
                      else
                        tempo_number(match[:lower])
                      end
      [display_value, playback_value]
    end

    def canonical_tempo_unit(unit)
      token = unit.downcase.tr("_ ", "-").gsub(/-+/, "-")
      TEMPO_UNIT_ALIASES.fetch(token)
    end

    def normalized_quarter_bpm(beat_unit, dots, per_minute)
      quarter_length = TEMPO_UNIT_QUARTER_LENGTHS.fetch(beat_unit)
      dotted_multiplier = Rational((2**(dots + 1)) - 1, 2**dots)
      Rational(per_minute) * quarter_length * dotted_multiplier
    end

    def tempo_number(text)
      text.include?(".") ? text.to_f : text.to_i
    end

    def tempo_dot_count(prefix)
      return 3 if prefix.to_s.match?(/triple/i)
      return 2 if prefix.to_s.match?(/double/i)
      return 1 if prefix.to_s.match?(/dotted/i)

      0
    end

    def normalized_tempo_number(value, float: false)
      return value.to_f if float || value.denominator != 1

      value.numerator
    end

    def validate_playback_tempo!(bpm, source)
      micros = bpm.positive? ? (Rational(60_000_000) / bpm).round : 0
      return if MIDI_TEMPO_MICROSECONDS.cover?(micros)

      raise_tempo_error(
        "tempo_out_of_midi_range",
        "Tempo #{source.inspect} normalizes outside the MIDI playback range.",
        "Choose a beat-unit value whose normalized quarter tempo produces 1..16777215 microseconds per quarter."
      )
    end

    def malformed_tempo!(source)
      raise_tempo_error(
        "bad_tempo_mark",
        "Bad typed tempo mark #{source.inspect}.",
        "Use a mark like `quarter = 72`, `dotted-quarter = 52`, or `eighth = 132-144`."
      )
    end

    def raise_tempo_error(code, message, repair_instruction)
      raise CompileError.new(
        code: code,
        message: message,
        repair_instruction: repair_instruction,
        help_topic: "controls",
        docs: ["docs/architecture/partitura/surfaces/controls.md"]
      )
    end
  end
end
