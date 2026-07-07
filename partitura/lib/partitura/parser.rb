# frozen_string_literal: true

require_relative "model"

module Partitura
  class NoteParser
    TOKEN = /\A(.+?):([0-9.\/]+)(?:\{([^}]*)\})?\z/

    def self.parse(text)
      new.parse(text)
    end

    def parse(text)
      text.to_s.split(/\s+/).flat_map do |token|
        next [] if token.empty? || token == "|"

        [parse_token(token)]
      end
    end

    private

    def parse_token(token)
      match = token.match(TOKEN)
      raise ParseError, "bad note token #{token.inspect}" unless match

      raw_pitch = match[1]
      duration = Rational(match[2])
      raise ParseError, "duration must be positive in #{token.inspect}" unless duration.positive?

      marks = parse_marks(match[3])
      Note.new(pitch: parse_pitch(raw_pitch), duration: duration, marks: marks)
    rescue ArgumentError => e
      raise ParseError, "bad note token #{token.inspect}: #{e.message}"
    end

    def parse_pitch(raw)
      return nil if %w[r rest R REST].include?(raw)

      if raw.start_with?("[") && raw.end_with?("]")
        inner = raw[1...-1]
        pitches = inner.split(",").map(&:strip).reject(&:empty?)
        raise ParseError, "empty chord #{raw.inspect}" if pitches.empty?

        pitches
      else
        raw
      end
    end

    def parse_marks(raw)
      return [] unless raw

      raw.split(",").map(&:strip).reject(&:empty?)
    end
  end
end
