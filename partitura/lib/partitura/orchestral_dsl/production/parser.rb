# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      PITCH_CLASS = {
        "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11
      }.freeze
      LETTERS = %w[C D E F G A B].freeze
      PC_TO_SHARP = %w[C C# D D# E F F# G G# A A# B].freeze
      MAJOR_STEPS = [0, 2, 4, 5, 7, 9, 11].freeze

      module_function

      def bpm_from_text(text)
        bpm = text.to_s.scan(/\d+(?:\.\d+)?/).last
        return nil unless bpm

        bpm.include?(".") ? bpm.to_f : bpm.to_i
      end

      def events_from_degrees(degrees, rhythm, key_context)
        degree_tokens, rhythm_tokens = parallel_tokens(degrees, rhythm, "degrees", "rhythm", :degrees)
        tonic_midi = pitch_to_midi(key_context =~ /\d/ ? key_context : "#{key_context}4")
        tonic_name = key_context =~ /\d/ ? key_context : "#{key_context}4"
        degree_tokens.zip(rhythm_tokens).map do |degree_token, duration|
          parsed = parse_marked_token(degree_token)
          Event.new(
            pitch: pitch_from_degree_body(parsed[:body], tonic_name, tonic_midi),
            duration: Rational(duration),
            source: parsed[:body],
            local_marks: parsed[:marks]
          )
        end
      end

      def events_from_intervals(intervals, rhythm, anchor)
        interval_tokens, rhythm_tokens = parallel_tokens(intervals, rhythm, "intervals", "rhythm", :intervals)
        current = pitch_to_midi(anchor)
        interval_tokens.zip(rhythm_tokens).map do |interval_token, duration|
          parsed = parse_marked_token(interval_token)
          pitch, current = pitch_from_interval_body(parsed[:body], current)
          Event.new(
            pitch: pitch,
            duration: Rational(duration),
            source: parsed[:body],
            local_marks: parsed[:marks]
          )
        end
      end

      def events_from_absolute(pitches, rhythm, help_topic: :split_pitch_rhythm)
        pitch_tokens, rhythm_tokens = parallel_tokens(pitches, rhythm, "pitches", "rhythm", help_topic)
        pitch_tokens.zip(rhythm_tokens).map do |pitch_token, duration|
          parsed = parse_marked_token(pitch_token)
          Event.new(
            pitch: pitch_from_absolute_body(parsed[:body], help_topic: help_topic),
            duration: Rational(duration),
            source: parsed[:body],
            local_marks: parsed[:marks]
          )
        end
      end

      def events_from_absolute_events(text, help_topic: :absolute)
        tokens(text).map do |token|
          match = token.match(/\A(.+?):([0-9.\/]+)(?:\{([^}]*)\})?\z/)
          unless match
            raise CompileError.new(
              code: "bad_absolute_event",
              message: "Bad absolute event token #{token.inspect}.",
              repair_instruction: "Use fused tokens like C5:1, [A3,C4,E4]:1{mf}, or r:.5.",
              help_topic: help_topic,
              docs: ["docs/architecture/orchestral_dsl/surfaces/#{help_topic}.md"]
            )
          end
          body, duration, marks = match.captures
          Event.new(
            pitch: pitch_from_absolute_body(body, help_topic: help_topic),
            duration: Rational(duration),
            source: body,
            local_marks: parse_marks(marks)
          )
        end
      end

      def parse_marked_token(token)
        match = token.to_s.match(/\A(.+?)(?:\{([^}]*)\})?\z/)
        {
          body: match[1],
          marks: parse_marks(match[2])
        }
      end

      def parse_marks(text)
        text.to_s.split(",").map(&:strip).reject(&:empty?)
      end

      def pitch_from_absolute_body(body, help_topic: :split_pitch_rhythm)
        return nil if rest_token?(body)

        if chord_body?(body)
          parse_chord_body(body, help_topic: help_topic) do |pitch|
            pitch_to_midi(pitch, help_topic: help_topic)
            pitch
          end
        else
          pitch_to_midi(body, help_topic: help_topic)
          body
        end
      end

      def pitch_from_degree_body(body, tonic_name, tonic_midi)
        return nil if rest_token?(body)

        if chord_body?(body)
          parse_chord_body(body, help_topic: :degrees) do |degree|
            degree_to_pitch(degree, tonic_name, tonic_midi)
          end
        else
          degree_to_pitch(body, tonic_name, tonic_midi)
        end
      end

      def pitch_from_interval_body(body, current)
        return [nil, current] if rest_token?(body)

        if chord_body?(body)
          offsets = chord_elements(body, help_topic: :intervals).map { |interval| Integer(interval) }
          pitches = offsets.map { |interval| midi_to_pitch(current + interval) }
          current += offsets.first || 0
          [pitches, current]
        else
          current += Integer(body)
          [midi_to_pitch(current), current]
        end
      rescue ArgumentError
        raise CompileError.new(
          code: "bad_interval",
          message: "Bad interval token #{body.inspect}.",
          repair_instruction: "Use intervals like 0, -2, +7, or chord stacks like [0,+3,+7].",
          help_topic: "intervals",
          docs: ["docs/architecture/orchestral_dsl/surfaces/intervals.md"]
        )
      end

      def parse_chord_body(body, help_topic:)
        elements = chord_elements(body, help_topic: help_topic)
        elements.map { |element| yield element }
      end

      def chord_elements(body, help_topic:)
        unless chord_body?(body)
          raise CompileError.new(
            code: "bad_chord",
            message: "Bad chord token #{body.inspect}.",
            repair_instruction: "Use bracketed chord tokens without spaces, like [A3,C4,E4].",
            help_topic: help_topic,
            docs: ["docs/architecture/orchestral_dsl/surfaces/#{help_topic}.md"]
          )
        end
        elements = body[1...-1].to_s.split(",").map(&:strip).reject(&:empty?)
        if elements.empty?
          raise CompileError.new(
            code: "empty_chord",
            message: "Chord token #{body.inspect} has no pitches.",
            repair_instruction: "Add one or more chord members inside the brackets.",
            help_topic: help_topic,
            docs: ["docs/architecture/orchestral_dsl/surfaces/#{help_topic}.md"]
          )
        end
        elements
      end

      def chord_body?(body)
        body.to_s.match?(/\A\[.*\]\z/)
      end

      def rest_token?(body)
        body.to_s.casecmp("r").zero?
      end

      def parallel_tokens(left_text, right_text, left_name, right_name, help_topic)
        left_bars = token_bars(left_text)
        right_bars = token_bars(right_text)
        unless left_bars.length == right_bars.length
          raise CompileError.new(
            code: "surface_bar_count_mismatch",
            message: "#{left_name} has #{left_bars.length} bars but #{right_name} has #{right_bars.length}.",
            repair_instruction: "Keep bar separators aligned across paired streams.",
            help_topic: help_topic,
            docs: ["docs/architecture/orchestral_dsl/surfaces/#{help_topic}.md"],
            minimal_example: "phrase :line, surface: :#{help_topic} do ..."
          )
        end

        left_bars.zip(right_bars).each_with_index do |(left, right), index|
          assert_equal_lengths!(left, right, left_name, right_name, help_topic, bar: index + 1)
        end
        [left_bars.flatten, right_bars.flatten]
      end

      def token_bars(text)
        text.to_s.split("|").map { |bar| bar.split(/\s+/).reject(&:empty?) }
      end

      def tokens(text)
        text.to_s.gsub("|", " ").split(/\s+/).reject(&:empty?)
      end

      def assert_equal_lengths!(left, right, left_name, right_name, help_topic, bar: nil)
        return if left.length == right.length

        location = bar ? " in bar #{bar}" : ""
        raise CompileError.new(
          code: "surface_event_count_mismatch",
          message: "#{left_name} has #{left.length} events but #{right_name} has #{right.length}#{location}.",
          repair_instruction: "Make the two streams align event-by-event, splitting the phrase if needed.",
          help_topic: help_topic,
          docs: ["docs/architecture/orchestral_dsl/surfaces/#{help_topic}.md"],
          minimal_example: "phrase :line, surface: :#{help_topic} do ..."
        )
      end

      def parse_location(text)
        match = text.to_s.match(/\Abar\s+(\d+)\s+beat\s+([0-9.\/]+)\z/)
        unless match
          raise CompileError.new(
            code: "bad_location",
            message: "Location must look like 'bar 1 beat 1', got #{text.inspect}.",
            repair_instruction: "Use explicit bar/beat location text.",
            help_topic: "phrase_placement",
            docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
          )
        end
        [Integer(match[1]), Rational(match[2])]
      end

      def parse_bar_boundary(value)
        return positive_bar_boundary(Integer(value), value) if value.is_a?(Integer)

        text = value.to_s
        if (match = text.match(/\Abar\s+(\d+)\z/))
          return positive_bar_boundary(Integer(match[1]), value)
        end

        if (match = text.match(/\Abar\s+(\d+)\s+beat\s+([0-9.\/]+)\z/))
          beat = Rational(match[2])
          unless beat == 1
            raise CompileError.new(
              code: "bad_meter_change_location",
              message: "Meter changes must be declared at beat 1, got #{value.inspect}.",
              repair_instruction: "Move the meter change to a bar boundary such as 'bar 5' or 'bar 5 beat 1'.",
              help_topic: "container",
              docs: ["docs/architecture/orchestral_dsl/01_container.md"]
            )
          end
          return positive_bar_boundary(Integer(match[1]), value)
        end

        raise CompileError.new(
          code: "bad_meter_change_location",
          message: "Meter change location must look like 'bar 5' or 'bar 5 beat 1', got #{value.inspect}.",
          repair_instruction: "Use explicit bar-boundary location text for meter changes.",
          help_topic: "container",
          docs: ["docs/architecture/orchestral_dsl/01_container.md"]
        )
      end

      def positive_bar_boundary(bar, original)
        return bar if bar >= 1

        raise CompileError.new(
          code: "bad_meter_change_location",
          message: "Meter change bar must be at least 1, got #{original.inspect}.",
          repair_instruction: "Use a positive bar-boundary location such as 'bar 5'.",
          help_topic: "container",
          docs: ["docs/architecture/orchestral_dsl/01_container.md"]
        )
      end

      def parse_bar_range(value)
        return value if value.is_a?(Range) || value.nil?

        text = value.to_s
        return parse_bar_list(text) if text.include?(",")

        parse_bar_range_piece(text)
      end

      def parse_bar_list(text)
        text.split(",").flat_map { |piece| parse_bar_range_piece(piece).to_a }.uniq.sort
      rescue ArgumentError
        raise ArgumentError, "bar list must look like 2,4,8-10"
      end

      def parse_bar_range_piece(text)
        match = text.strip.match(/\A(\d+)(?:-(\d+))?\z/)
        raise ArgumentError, "bar range must look like 5, 5-8, or 2,4,8-10" unless match

        Integer(match[1])..Integer(match[2] || match[1])
      end

      def meter_to_bar_length(value)
        match = value.match(%r{\A(\d+)/(\d+)\z})
        raise CompileError.new(
          code: "bad_meter",
          message: "Meter must look like '7/8', got #{value.inspect}.",
          repair_instruction: "Use numerator/denominator meter syntax.",
          help_topic: "container",
          docs: ["docs/architecture/orchestral_dsl/01_container.md"]
        ) unless match

        Rational(match[1].to_i * 4, match[2].to_i)
      end

      def degree_to_midi(token, tonic_midi)
        parsed = parse_degree_token(token)
        tonic_midi +
          MAJOR_STEPS[parsed.fetch(:degree) - 1] +
          degree_accidental_offset(parsed) +
          degree_octave_offset(parsed)
      end

      def degree_to_pitch(token, tonic_name, tonic_midi)
        parsed = parse_degree_token(token)
        midi = degree_to_midi(token, tonic_midi)
        letter, octave = degree_letter_and_octave(parsed, tonic_name)
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
          repair_instruction: "Use degree tokens like 5, #1, b6, or 1'.",
          help_topic: "degrees",
          docs: ["docs/architecture/orchestral_dsl/surfaces/degrees.md"]
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

      def pitch_to_midi(text, help_topic: "split_pitch_rhythm")
        match = text.to_s.match(/\A([A-G])(##|bb|[#b])?(-?\d+)\z/)
        raise CompileError.new(
          code: "bad_pitch",
          message: "Bad pitch token #{text.inspect}.",
          repair_instruction: "Use pitch spelling like C5, F#4, or Bb3.",
          help_topic: help_topic,
          docs: ["docs/architecture/orchestral_dsl/surfaces/#{help_topic}.md"]
        ) unless match

        letter, accidental, octave_text = match.captures
        pc = PITCH_CLASS.fetch(letter) +
             { "#" => 1, "##" => 2, "b" => -1, "bb" => -2 }.fetch(accidental, 0)
        ((octave_text.to_i + 1) * 12) + pc
      end

      def midi_to_pitch(midi)
        octave = (midi / 12) - 1
        "#{PC_TO_SHARP[midi % 12]}#{octave}"
      end
    end
  end
end
