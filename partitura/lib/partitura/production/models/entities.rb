# frozen_string_literal: true

module Partitura
  module Production
    class CompileError < StandardError
      attr_reader :response

      def initialize(code:, message:, repair_instruction:, help_topic:, docs:, minimal_example: nil, extra: nil)
        @response = {
          status: "error",
          code: code,
          message: message,
          repair_instruction: repair_instruction,
          help_topic: help_topic,
          docs: docs,
          minimal_example: minimal_example
        }.compact
        @response.merge!(extra) if extra
        super(message)
      end

      CORE_RESPONSE_KEYS = %i[status code message repair_instruction help_topic docs minimal_example].freeze

      # Returns a copy of the error carrying authoring context (phrase id, span bars,
      # section id). Existing context is never overwritten, so the innermost frame wins.
      def with_context(context)
        extra = @response.reject { |key, _| CORE_RESPONSE_KEYS.include?(key) }
        added = context.reject { |key, value| @response.key?(key) || value.nil? }
        return self if added.empty?

        CompileError.new(
          code: @response[:code],
          message: contextualized_message(added),
          repair_instruction: @response[:repair_instruction],
          help_topic: @response[:help_topic],
          docs: @response[:docs],
          minimal_example: @response[:minimal_example],
          extra: extra.merge(added)
        )
      end

      private

      def contextualized_message(added)
        phrase = added[:phrase]
        message = @response[:message].to_s
        return message if phrase.nil? || message.match?(/\b#{Regexp.escape(phrase.to_s)}\b/)

        "phrase :#{phrase}: #{message}"
      end
    end

    module PitchEvent
      def rest?
        pitch.nil? || pitch == []
      end

      def note?
        !rest? && !chord?
      end

      def chord?
        pitch.is_a?(Array)
      end

      def event_type
        return "rest" if rest?

        chord? ? "chord" : "note"
      end

      def pitches
        return [] if rest?

        chord? ? pitch : [pitch]
      end

      def pitch_label
        return "r" if rest?

        chord? ? "[#{pitch.join(',')}]" : pitch
      end

      def marks
        Array(local_marks)
      end
    end

    Event = Struct.new(:pitch, :duration, :source, :local_marks, keyword_init: true) do
      include PitchEvent

      def to_s
        Production.event_token(self)
      end
    end

    TimedEvent = Struct.new(:part, :role, :phrase_id, :pitch, :duration, :offset, :source,
                            :transform, :realization, :local_marks, keyword_init: true) do
      include PitchEvent

      def end_offset
        offset + duration
      end
    end

    Anchor = Struct.new(:id, :at, keyword_init: true)

    Control = Struct.new(:kind, :value, :at, :from, :to, :target, keyword_init: true)

    KeyChange = Struct.new(:key, :at, keyword_init: true)

    MeterEvent = Struct.new(:meter, :beat_pattern, :bar, keyword_init: true)

    TempoEvent = Struct.new(:kind, :text, :at, :from, :to, :bpm, keyword_init: true)

    class Part
      attr_reader :id, :name, :music21_instrument, :family, :range, :description, :notation_group, :notation_staff

      def initialize(id:, name:, music21_instrument:, family: nil, range: nil, description: nil, notation_group: nil, 
notation_staff: nil)
        @id = id.to_sym
        @name = name
        @music21_instrument = music21_instrument.to_s
        @family = family&.to_sym
        @range = range
        @description = description
        @notation_group = notation_group&.to_sym
        @notation_staff = notation_staff
      end
    end

    class Phrase
      attr_reader :id, :surface, :events, :segment_counts, :assumed_key

      # segment_counts: events per `|`-delimited segment of the authored stream, used to
      # verify that every bar marker lands on a barline once the phrase is placed.
      # assumed_key: set when a degrees phrase silently inherited the piece-level key;
      # validation checks that assumption against any key_change at placement time.
      def initialize(id:, surface:, events:, segment_counts: nil, assumed_key: nil)
        @id = id.to_sym
        @surface = surface.to_sym
        @events = events.freeze
        @segment_counts = segment_counts&.freeze
        @assumed_key = assumed_key
      end

      def duration
        @events.sum { |event| event.duration }
      end
    end

    class Placement
      attr_reader :phrase_id, :part, :role, :bar, :beat, :transform, :realization

      def initialize(phrase_id:, part:, role:, bar:, beat:, transform: nil, realization: nil)
        @phrase_id = phrase_id.to_sym
        @part = part.to_sym
        @role = role.to_sym
        @bar = Integer(bar)
        @beat = Rational(beat)
        @transform = transform
        @realization = realization
      end
    end

    class Gesture
      attr_reader :id, :idea_text, :mechanism_texts, :audible_texts, :line_relations,
                  :orchestration_texts, :silence_texts, :note_texts

      def initialize(id:)
        @id = id.to_sym
        @idea_text = nil
        @mechanism_texts = []
        @audible_texts = []
        @line_relations = []
        @orchestration_texts = []
        @silence_texts = []
        @note_texts = []
      end

      attr_writer :idea_text

      def add_mechanism(text)
        @mechanism_texts << text.to_s
      end

      def add_audible(text)
        @audible_texts << text.to_s
      end

      def add_line_relation(left, right, text)
        @line_relations << { left: left.to_sym, right: right.to_sym, text: text.to_s }
      end

      def add_orchestration(text)
        @orchestration_texts << text.to_s
      end

      def add_silence(text)
        @silence_texts << text.to_s
      end

      def add_note(text)
        @note_texts << text.to_s
      end

      def supported?
        !@mechanism_texts.empty? || !@audible_texts.empty? || !@line_relations.empty? ||
          !@orchestration_texts.empty? || !@silence_texts.empty?
      end
    end

    class StaffLane
      attr_reader :role, :part, :tokens

      def initialize(role:, text:)
        @role = role.to_sym
        part_text, token_text = text.to_s.split(":", 2)
        if token_text.nil?
          @part = nil
          @tokens = tokenize_words(part_text)
        else
          @part = part_text.strip.to_sym
          @tokens = tokenize_words(token_text)
        end
      end

      private

      def tokenize_words(text)
        text.to_s.split(/\s+/).reject(&:empty?)
      end
    end

    class StaffBar
      attr_reader :number, :lanes, :checks

      def initialize(number)
        @number = Integer(number)
        @lanes = []
        @checks = []
      end

      def add_lane(role, text)
        @lanes << StaffLane.new(role: role, text: text)
      end

      def add_check(text)
        @checks << text.to_s
      end
    end

    class Span
      attr_reader :bars, :texture, :harmony_texts, :chord_track, :process_texts, :phrases,
                  :phrase_definitions, :placements, :staff_bars, :gestures

      def initialize(bars:, texture: nil)
        @bars = bars
        @texture = texture&.to_sym
        @harmony_texts = []
        @chord_track = {}
        @process_texts = []
        @phrases = {}
        @phrase_definitions = []
        @placements = []
        @staff_bars = []
        @gestures = []
      end

      def add_harmony(text)
        @harmony_texts << text.to_s
      end

      def add_chord(bar, symbol)
        @chord_track[Integer(bar)] = symbol.to_s
      end

      def add_process(text)
        @process_texts << text.to_s
      end

      def add_phrase(phrase)
        @phrase_definitions << phrase
        @phrases[phrase.id] ||= phrase
      end

      def add_placement(placement)
        @placements << placement
      end

      def add_staff_bar(staff_bar)
        @staff_bars << staff_bar
      end

      def add_gesture(gesture)
        @gestures << gesture
      end
    end

    class Section
      attr_reader :id, :name, :bars, :type, :journey_texts, :destination_texts, :spans,
                  :gestures

      def initialize(id:, name:, bars:, type: nil)
        @id = id.to_sym
        @name = name
        @bars = bars
        @type = type&.to_sym
        @journey_texts = []
        @destination_texts = []
        @spans = []
        @gestures = []
      end

      def add_journey(text)
        @journey_texts << text.to_s
      end

      def add_destination(text)
        @destination_texts << text.to_s
      end

      def add_span(span)
        @spans << span
      end

      def add_gesture(gesture)
        @gestures << gesture
      end
    end
  end
end
