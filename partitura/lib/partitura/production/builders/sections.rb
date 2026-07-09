# frozen_string_literal: true

module Partitura
  module Production
    class SectionBuilder
      def initialize(piece, section, default_key: nil)
        @piece = piece
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
        SpanBuilder.new(@piece, span, default_key: @default_key,
                                      default_key_explicit: @key_explicit).build(&block)
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
      def initialize(piece, span, default_key: nil, default_key_explicit: false)
        @piece = piece
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
        phrase = builder.build(&block)
        @span.add_phrase(phrase)
        @span.set_phrase_anacrusis(phrase.id, builder.anacrusis_value) if builder.anacrusis_value
        phrase
      end

      def placement(phrase_id, part:, at:, role: nil, transform: nil, realization: nil, anacrusis: nil, &block)
        bar, beat = Production.parse_location(at)
        placement = PlacementBuilder.new(
          phrase_id: phrase_id,
          part: part,
          role: role,
          bar: bar,
          beat: beat,
          transform: transform,
          realization: realization,
          anacrusis: anacrusis
        ).build(&block)
        @span.add_placement(placement)
      end

      def fill(id, part:, at:, from: nil, surface: nil, pitch: nil, role: :fill, **kwargs, &block)
        if from
          add_material_fill(id, from, block, **kwargs)
        else
          validate_realized_fill_duration!(phrase(id, surface: surface, pitch: pitch, &block), :inline)
        end
        @span.mark_fill(id)
        placement(id, part: part, at: at, role: role, realization: kwargs[:realization],
                      anacrusis: kwargs[:anacrusis])
      end

      def staff_bar(number, &block)
        staff_bar = StaffBar.new(number)
        StaffBarBuilder.new(staff_bar).build(&block)
        @span.add_staff_bar(staff_bar)
      end

      def texture(id, bars: @span.bars, type: nil, &block)
        TextureBuilder.new(
          @piece, @span, id, bars: bars, type: type, default_key: @default_key,
                            default_key_explicit: @key_explicit
        ).build(&block)
      end

      def gesture(id, &block)
        gesture = GestureBuilder.new(id).build(&block)
        @span.add_gesture(gesture)
      end

      private

      def add_material_fill(id, material_id, block, **kwargs)
        options = {
          transpose_to: kwargs[:transpose_to],
          transpose_by: kwargs[:transpose_by],
          key_match: kwargs[:key_match]
        }.compact
        options = FillTransformBuilder.new(options).build(&block)
        phrase = FillMaterialRealizer.new(@piece.fill_material(material_id), options).realize(id: id)
        validate_realized_fill_duration!(phrase, material_id)
        @span.add_phrase(phrase)
      end

      def validate_realized_fill_duration!(phrase, material_id)
        return if phrase.duration < @piece.bar_length_for(@span.bars.begin)

        raise CompileError.new(
          code: "fill_too_long",
          message: "Fill #{phrase.id} from #{material_id} lasts #{Production.format_duration(phrase.duration)} " \
                   "beats; fills must be shorter than one bar.",
          repair_instruction: "Use a shorter fill material, diminish it, or write a normal phrase/texture line.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end

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
      def initialize(phrase_id:, part:, role:, bar:, beat:, transform:, realization:, anacrusis:)
        @phrase_id = phrase_id
        @part = part
        @role = role
        @bar = bar
        @beat = beat
        @transform = transform
        @realization = realization
        @anacrusis = anacrusis.nil? ? nil : Rational(anacrusis)
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
          realization: @realization,
          anacrusis: @anacrusis
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

      def anacrusis(value)
        @anacrusis = Rational(value)
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
