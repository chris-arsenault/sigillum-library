# frozen_string_literal: true

module Partitura
  module Production
    class TextureBuilder
      def initialize(piece, span, id, bars:, type:, default_key:, default_key_explicit:)
        @piece = piece
        @span = span
        @id = id.to_sym
        @bars = bars
        @type = type&.to_sym
        @default_key = default_key
        @default_key_explicit = default_key_explicit
        @parts = []
        @controls = []
      end

      def build(&block)
        instance_eval(&block) if block
        flush_controls
      end

      def intent(text)
        @span.add_process("texture #{@id}: #{text}")
      end

      def harmony(text)
        @span.add_harmony("texture #{@id}: #{text}")
      end

      def control(&block)
        TextureControlBuilder.new(@controls).build(&block)
      end

      def line(id, part:, role: id, surface: nil, pitch: nil, realization: nil, anacrusis: nil, &block)
        phrase_id = texture_phrase_id(id)
        phrase_builder = PhraseBuilder.new(phrase_id, surface || pitch, default_key: @default_key,
                                                                     default_key_explicit: @default_key_explicit)
        @span.add_phrase(phrase_builder.build(&block))
        add_texture_placement(
          phrase_id, part, role, anacrusis: anacrusis || phrase_builder.anacrusis_value,
                                realization: realization
        )
      end

      def score(grid:, surface: :absolute, role: :texture, &block)
        raise unsupported_score_surface!(surface) unless surface.to_sym == :absolute
        return unless grid_known?(grid)

        sink = ->(error) { @piece.add_deferred_error(error) }
        builder = ScoreGridBuilder.new(@id, grid, role, expected_slots: expected_slots_for(grid), on_error: sink)
        builder.build(&block).each do |lane|
          @span.add_phrase(lane.fetch(:phrase))
          add_texture_placement(lane.fetch(:phrase).id, lane.fetch(:part), lane.fetch(:role))
        end
      end

      private

      def texture_phrase_id(id)
        :"#{@id}_#{id}"
      end

      def add_texture_placement(phrase_id, part, role, anacrusis: nil, realization: nil)
        @parts << part.to_sym
        @span.add_placement(Placement.new(
          phrase_id: phrase_id, part: part, role: role, bar: @bars.begin, beat: 1,
          realization: realization || "texture #{@id}", anacrusis: anacrusis
        ))
      end

      def flush_controls
        targets = @parts.uniq
        @controls.each { |control| @piece.add_control(control.to_control(@bars, targets)) }
      end

      def unsupported_score_surface!(surface)
        CompileError.new(
          code: "unsupported_texture_score_surface",
          message: "texture #{@id} score surface #{surface.inspect} is not supported.",
          repair_instruction: "Use score grid: ..., surface: :absolute for vertical source grids.",
          help_topic: "texture",
          docs: ["docs/architecture/partitura/surfaces/texture.md"]
        )
      end

      # Unknown grids abort the score block; a grid that does not divide a bar evenly
      # is recorded as a deferred compile error (views still render best-effort) and
      # per-bar counting is skipped for that bar.
      def grid_known?(grid)
        return true if ScoreGridBuilder::GRID_DURATIONS.key?(grid.to_sym)

        @piece.add_deferred_error(CompileError.new(
          code: "bad_score_grid",
          message: "texture #{@id}: unknown grid #{grid.inspect}.",
          repair_instruction: "Use one of: #{ScoreGridBuilder::GRID_DURATIONS.keys.join(', ')}.",
          help_topic: "texture", docs: ["docs/architecture/partitura/surfaces/texture.md"]
        ))
        false
      end

      def expected_slots_for(grid)
        slot = ScoreGridBuilder::GRID_DURATIONS.fetch(grid.to_sym)
        @bars.map do |bar|
          slots = @piece.bar_length_for(bar) / slot
          next slots.to_i if (slots % 1).zero?

          @piece.add_deferred_error(CompileError.new(
            code: "bad_score_grid",
            message: "texture #{@id}: grid :#{grid} does not divide bar #{bar} " \
                     "(#{@piece.meter_for(bar).meter}) evenly.",
            repair_instruction: "Use a finer grid (e.g. :eighth or :sixteenth) that divides every bar of the " \
                                "texture's meter.",
            help_topic: "texture", docs: ["docs/architecture/partitura/surfaces/texture.md"]
          ))
          nil
        end
      end
    end

    class TextureControlBuilder
      def initialize(out)
        @out = out
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def dynamic(value, at:, **kwargs)
        @out << TextureControl.new(:dynamic, value: value.to_s, at: at, target: kwargs[:for])
      end

      def crescendo(from:, to:, **kwargs)
        @out << TextureControl.new(:crescendo, from: from, to: to, target: kwargs[:for])
      end

      def diminuendo(from:, to:, **kwargs)
        @out << TextureControl.new(:diminuendo, from: from, to: to, target: kwargs[:for])
      end

      def text(value, at:, **kwargs)
        @out << TextureControl.new(:text, value: value.to_s, at: at, target: kwargs[:for])
      end
    end

    class TextureControl
      def initialize(kind, value: nil, at: nil, from: nil, to: nil, target: nil)
        @kind = kind
        @value = value
        @at = at
        @from = from
        @to = to
        @target = target
      end

      def to_control(bars, parts)
        Control.new(kind: @kind, value: @value, at: location(@at, bars), from: location(@from, bars),
                    to: location(@to, bars), target: @target || parts)
      end

      private

      def location(value, bars)
        return nil if value.nil?
        return "bar #{bars.begin} beat 1" if value == :start
        return "bar #{bars.end + 1} beat 1" if value == :end

        value
      end
    end

    class ScoreGridBuilder
      GRID_DURATIONS = {
        whole: Rational(4), half: Rational(2), quarter: Rational(1),
        quarter_triplet: Rational(2, 3), eighth: Rational(1, 2), eighth_triplet: Rational(1, 3),
        sixteenth: Rational(1, 4), thirty_second: Rational(1, 8)
      }.freeze

      def initialize(texture_id, grid, role, expected_slots: nil, on_error: nil)
        @texture_id = texture_id
        @grid = grid.to_sym
        @slot = GRID_DURATIONS.fetch(@grid)
        @role = role
        @expected_slots = expected_slots
        @on_error = on_error
        @lanes = []
      end

      def build(&block)
        instance_eval(&block) if block
        @lanes.map { |lane| compiled_lane(lane) }
      end

      def lane(part, text, role: @role)
        @lanes << { part: part.to_sym, text: text.to_s, role: role.to_sym }
      end

      def method_missing(name, *args, **kwargs, &block)
        return super if block || args.length != 1

        lane(name, args.first, **kwargs)
      end

      def respond_to_missing?(_name, _include_private = false)
        true
      end

      private

      def compiled_lane(lane)
        slot_counts = validated_slot_counts(lane)
        events, counts = ScoreGridParser.new(lane.fetch(:text), @slot).parse
        phrase = Phrase.new(id: lane_phrase_id(lane), surface: :score_grid,
                            events: events, segment_counts: counts)
        { phrase: phrase, part: lane.fetch(:part), role: lane.fetch(:role), slots: slot_counts }
      rescue CompileError => e
        raise e.with_context(phrase: lane_phrase_id(lane), texture: @texture_id, lane: lane.fetch(:part))
      end

      def lane_phrase_id(lane)
        :"#{@texture_id}_#{lane.fetch(:part)}_score"
      end

      # Every bar of a lane must carry exactly the meter's slot count for this grid.
      # A miscount is a deferred compile error, named by lane and bar: the piece still
      # loads so projections can render best-effort evidence, but validate! (compile,
      # export) fails on it.
      def validated_slot_counts(lane)
        counts = Production.token_bars(lane.fetch(:text)).map(&:length)
        return counts unless @expected_slots

        if counts.length != @expected_slots.length
          report(slot_mismatch!(lane, "has #{counts.length} bars; the texture spans #{@expected_slots.length}"))
          return counts
        end

        counts.each_with_index do |count, index|
          expected = @expected_slots.fetch(index)
          next if expected.nil? || count == expected

          report(slot_mismatch!(lane, "bar #{index + 1} of the lane has #{count} slots; the meter needs " \
                                      "#{expected} at grid :#{@grid}"))
        end
        counts
      end

      def report(error)
        raise error unless @on_error

        @on_error.call(error)
      end

      def slot_mismatch!(lane, detail)
        CompileError.new(
          code: "score_grid_slot_mismatch",
          message: "texture #{@texture_id} lane #{lane.fetch(:part)}: #{detail}.",
          repair_instruction: "Write one token per :#{@grid} slot (pitch/chord = attack, `_` = sustain, " \
                              "`.` = silence) and one `|` per barline, so every bar carries exactly the " \
                              "meter's slot count.",
          help_topic: "texture",
          docs: ["docs/architecture/partitura/surfaces/texture.md"]
        )
      end
    end

    class ScoreGridParser
      def initialize(text, slot)
        @bars = Production.token_bars(text)
        @slot = slot
      end

      def parse
        events = []
        counts = []
        active = nil
        @bars.each_with_index do |tokens, index|
          bar_events, active = parse_bar(tokens, active, continues_after?(index))
          events.concat(bar_events)
          counts << bar_events.length
        end
        [events, counts]
      end

      private

      def parse_bar(tokens, active, continues_after)
        events = []
        index = 0
        while index < tokens.length
          event, index, active = next_event(tokens, index, active, continues_after)
          events << event if event
        end
        [events, active]
      end

      def next_event(tokens, index, active, continues_after)
        token = tokens.fetch(index)
        return rest_event(tokens, index) if token == "."
        return sustain_event(tokens, index, active, continues_after) if token == "_"

        attack_event(tokens, index, continues_after)
      end

      def rest_event(tokens, index)
        count = run_length(tokens, index) { |token| token == "." }
        [Event.new(pitch: nil, duration: @slot * count, source: "r", local_marks: []), index + count, nil]
      end

      def sustain_event(tokens, index, active, continues_after)
        raise bad_grid_token!("_ cannot start without an active note") unless active

        count = run_length(tokens, index) { |token| token == "_" }
        marks = ["tie)"]
        marks << "tie(" if index + count == tokens.length && continues_after
        [Event.new(pitch: active, duration: @slot * count, source: pitch_source(active),
                   local_marks: marks), index + count, active]
      end

      def attack_event(tokens, index, continues_after)
        parsed = Production.parse_marked_token(tokens.fetch(index))
        pitch = Production.pitch_from_absolute_body(parsed.fetch(:body), help_topic: :absolute)
        count = run_length(tokens, index + 1) { |token| token == "_" }
        marks = parsed.fetch(:marks)
        marks << "tie(" if index + count + 1 == tokens.length && continues_after
        event = Event.new(pitch: pitch, duration: @slot * (count + 1), source: parsed.fetch(:body),
                          local_marks: marks)
        [event, index + count + 1, pitch]
      end

      def continues_after?(bar_index)
        @bars[bar_index + 1]&.first == "_"
      end

      def run_length(tokens, start)
        index = start
        index += 1 while index < tokens.length && yield(tokens.fetch(index))
        index - start
      end

      def pitch_source(pitch)
        pitch.is_a?(Array) ? "[#{pitch.join(',')}]" : pitch
      end

      def bad_grid_token!(detail)
        CompileError.new(code: "bad_score_grid", message: "Bad score grid: #{detail}.",
                         repair_instruction: "Use pitches/chords for attacks, `_` for sustain, and `.` for silence.",
                         help_topic: "texture", docs: ["docs/architecture/partitura/surfaces/texture.md"])
      end
    end
  end
end
