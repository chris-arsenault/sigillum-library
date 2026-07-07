# frozen_string_literal: true

module Partitura
  module Production
    class SectionBuilder
      def initialize(section, default_key: nil)
        @section = section
        @default_key = default_key
        @key_explicit = false
      end

      # Section-level key: the default key_context for degree phrases in this section's
      # spans (use after a key_change so inherited degrees resolve in the new key).
      def key(value)
        @default_key = value.to_s
        @key_explicit = true
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def journey(text)
        @section.add_journey(text)
      end

      def destination(text)
        @section.add_destination(text)
      end

      def span(bars:, texture: nil, &block)
        span = Span.new(bars: bars, texture: texture)
        SpanBuilder.new(span, default_key: @default_key, default_key_explicit: @key_explicit).build(&block)
        @section.add_span(span)
      rescue CompileError => e
        raise e.with_context(section: @section.id, span_bars: "#{bars.begin}-#{bars.end}")
      end

      def gesture(id, &block)
        gesture = GestureBuilder.new(id).build(&block)
        @section.add_gesture(gesture)
      end
    end

    class SpanBuilder
      def initialize(span, default_key: nil, default_key_explicit: false)
        @span = span
        @default_key = default_key
        @key_explicit = default_key_explicit
      end

      # Span-level key: the default key_context for this span's degree phrases.
      def key(value)
        @default_key = value.to_s
        @key_explicit = true
      end

      def build(&block)
        instance_eval(&block) if block
      end

      # Per-bar declared chord track: "b17:Am b18:Am b19-20:Dm". Bars must sit inside
      # the span; symbols are letter chords (see Production::Chords). `harmony` routes
      # here automatically when its text is entirely in this microformat, so free prose
      # stays commentary and the chord track stays machine-comparable.
      def chords(text)
        text.to_s.split(/\s+/).reject(&:empty?).each do |token|
          bars_part, symbol = parse_chord_token(token)
          bars_part.each do |bar|
            validate_chord_bar!(bar, token)
            @span.add_chord(bar, symbol)
          end
        end
      end

      def harmony(text)
        tokens = text.to_s.split(/\s+/).reject(&:empty?)
        if tokens.any? && tokens.all? { |token| token.match?(/\Ab\d+(-\d+)?:\S+\z/) }
          chords(text)
        else
          @span.add_harmony(text)
        end
      end

      def process(text)
        @span.add_process(text)
      end

      def phrase(id, surface: nil, pitch: nil, &block)
        builder = PhraseBuilder.new(id, surface || pitch, default_key: @default_key,
                                                          default_key_explicit: @key_explicit)
        @span.add_phrase(builder.build(&block))
      end

      def placement(phrase_id, part:, at:, role: nil, transform: nil, realization: nil, &block)
        bar, beat = Production.parse_location(at)
        placement = PlacementBuilder.new(
          phrase_id: phrase_id,
          part: part,
          role: role,
          bar: bar,
          beat: beat,
          transform: transform,
          realization: realization
        ).build(&block)
        @span.add_placement(placement)
      end

      def staff_bar(number, &block)
        staff_bar = StaffBar.new(number)
        StaffBarBuilder.new(staff_bar).build(&block)
        @span.add_staff_bar(staff_bar)
      end

      def gesture(id, &block)
        gesture = GestureBuilder.new(id).build(&block)
        @span.add_gesture(gesture)
      end

      private

      def parse_chord_token(token)
        match = token.match(/\Ab(\d+)(?:-(\d+))?:(\S+)\z/)
        raise chord_track_error(token, "must look like b17:Am or b19-20:Dm") unless match

        symbol = match[3]
        raise chord_track_error(token, "chord symbol #{symbol.inspect} is not a recognized letter chord") unless
          Chords.valid?(symbol)

        [Integer(match[1])..Integer(match[2] || match[1]), symbol]
      end

      def validate_chord_bar!(bar, token)
        return if @span.bars.cover?(bar)

        raise chord_track_error(token, "bar #{bar} is outside span bars #{@span.bars.begin}-#{@span.bars.end}")
      end

      def chord_track_error(token, detail)
        CompileError.new(
          code: "bad_chord_track",
          message: "Chord track token #{token.inspect}: #{detail}.",
          repair_instruction: "Declare per-bar chords as bN:Symbol inside the span, e.g. " \
                              "chords \"b17:Am b18:E7 b19-20:Dm\". Symbols: letter, optional #/b, optional " \
                              "quality (#{Chords::TEMPLATES.keys.reject(&:empty?).join(' ')}), optional /bass.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"]
        )
      end
    end

    class PlacementBuilder
      def initialize(phrase_id:, part:, role:, bar:, beat:, transform:, realization:)
        @phrase_id = phrase_id
        @part = part
        @role = role
        @bar = bar
        @beat = beat
        @transform = transform
        @realization = realization
      end

      def build(&block)
        instance_eval(&block) if block
        missing_role! unless @role

        Placement.new(
          phrase_id: @phrase_id,
          part: @part,
          role: @role,
          bar: @bar,
          beat: @beat,
          transform: @transform,
          realization: @realization
        )
      end

      def role(value)
        @role = value
      end

      def transform(value)
        @transform = value
      end

      def realization(value)
        @realization = value
      end

      def materialized(value)
        @realization = value
      end

      private

      def missing_role!
        raise CompileError.new(
          code: "missing_placement_role",
          message: "Placement #{@phrase_id} is missing role.",
          repair_instruction: "Add role: :foreground or a role value inside the placement block.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end
    end
  end
end
