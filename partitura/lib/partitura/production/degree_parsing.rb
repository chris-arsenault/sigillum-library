# frozen_string_literal: true

module Partitura
  module Production
    module_function

    # key_context grammar: tonic letter (lowercase letter = minor), optional accidental
    # and octave, optional explicit mode word: "F4", "c3", "Bb", "D4 dorian", "C minor".
    def parse_key_context(text)
      match = text.to_s.strip.match(/\A([A-Ga-g])(##|bb|[#b])?(-?\d+)?(?:\s+([a-z_]+))?\z/)
      raise_bad_key_context!(text) unless match

      letter, accidental, octave, mode_word = match.captures
      mode = mode_word || (letter == letter.downcase ? "minor" : "major")
      steps = MODE_STEPS[mode]
      raise_bad_key_context!(text) unless steps

      tonic_name = "#{letter.upcase}#{accidental}#{octave || 4}"
      { tonic_name: tonic_name, tonic_midi: pitch_to_midi(tonic_name, help_topic: "degrees"),
        steps: steps, mode: mode }
    end

    def raise_bad_key_context!(text)
      raise CompileError.new(
        code: "bad_key_context",
        message: "Bad key context #{text.inspect}.",
        repair_instruction: "Use tonic plus octave and optional mode: \"F4\", \"c3\" (lowercase = minor), " \
                            "\"D4 dorian\". Modes: #{MODE_STEPS.keys.join(', ')}.",
        help_topic: "degrees",
        docs: ["docs/architecture/partitura/surfaces/degrees.md"]
      )
    end

    def degree_to_midi(token, key)
      parsed = parse_degree_token(token)
      key.fetch(:tonic_midi) +
        key.fetch(:steps)[parsed.fetch(:degree) - 1] +
        degree_accidental_offset(parsed) +
        degree_octave_offset(parsed)
    end

    def degree_to_pitch(token, key)
      parsed = parse_degree_token(token)
      midi = degree_to_midi(token, key)
      letter, octave = degree_letter_and_octave(parsed, key.fetch(:tonic_name))
      accidental = midi - pitch_to_midi("#{letter}#{octave}")
      accidental_text = accidental_text_for(accidental)
      return midi_to_pitch(midi) unless accidental_text

      "#{letter}#{accidental_text}#{octave}"
    end

    def parse_degree_token(token)
      match = token.match(/\A([#b]*)([1-7])('*)(,*)\z/)
      raise_bad_degree!(token) unless match

      accidentals, degree_text, ups, downs = match.captures
      { accidentals: accidentals, degree: degree_text.to_i, ups: ups, downs: downs }
    end

    def raise_bad_degree!(token)
      raise CompileError.new(
        code: "bad_degree",
        message: "Bad degree token #{token.inspect}.",
        repair_instruction: "Use degree tokens such as `5`, `#1`, `b6`, an octave up as `1'`, or an octave " \
                            "down as `1,` (accidental first, then degree, then octave marks).",
        help_topic: "degrees",
        docs: ["docs/architecture/partitura/surfaces/degrees.md"]
      )
    end

    def degree_accidental_offset(parsed)
      parsed.fetch(:accidentals).chars.sum { |char| char == "#" ? 1 : -1 }
    end

    def degree_octave_offset(parsed)
      (parsed.fetch(:ups).length - parsed.fetch(:downs).length) * 12
    end

    def degree_letter_and_octave(parsed, tonic_name)
      tonic_match = tonic_name.match(/\A([A-G])([#b]?)(-?\d+)\z/)
      tonic_letter = tonic_match[1]
      tonic_octave = tonic_match[3].to_i
      tonic_letter_index = LETTERS.index(tonic_letter)
      target_index = tonic_letter_index + parsed.fetch(:degree) - 1
      letter = LETTERS[target_index % 7]
      octave = tonic_octave + (target_index / 7) + parsed.fetch(:ups).length - parsed.fetch(:downs).length
      [letter, octave]
    end

    def accidental_text_for(accidental)
      { -2 => "bb", -1 => "b", 0 => "", 1 => "#", 2 => "##" }[accidental]
    end
  end
end
