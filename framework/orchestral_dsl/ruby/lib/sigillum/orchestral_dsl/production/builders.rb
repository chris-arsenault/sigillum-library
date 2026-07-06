# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class PieceBuilder
        def initialize(title)
          @piece = Piece.new(title)
        end

        def build(&block)
          instance_eval(&block) if block
          @piece
        end

        def meter(value = nil, beat_pattern: nil, at: nil, &block)
          if block
            MeterBuilder.new(@piece).build(&block)
          elsif at
            @piece.add_meter_change(value, at: at, beat_pattern: beat_pattern)
          elsif value
            @piece.set_meter(value, beat_pattern: beat_pattern)
          else
            raise ArgumentError, "meter requires text or a block"
          end
        end

        def key(value)
          @piece.set_key(value)
        end

        def tempo(text = nil, &block)
          if block
            TempoBuilder.new(@piece).build(&block)
          elsif text
            @piece.add_tempo(text)
          else
            raise ArgumentError, "tempo requires text or a block"
          end
        end

        def anchor(id, at:)
          @piece.add_anchor(id, at: at)
        end

        def control(&block)
          ControlBuilder.new(@piece).build(&block)
        end

        def roster(&block)
          RosterBuilder.new(@piece).build(&block)
        end

        def section(id, name, bars:, type: nil, &block)
          section = Section.new(id: id, name: name, bars: bars, type: type)
          SectionBuilder.new(section).build(&block)
          @piece.add_section(section)
        end
      end

      class RosterBuilder
        def initialize(piece)
          @piece = piece
        end

        def build(&block)
          instance_eval(&block) if block
        end

        def part(id, name, music21: nil, family: nil, range: nil, description: nil, notation_group: nil, notation_staff: nil)
          unless music21
            raise CompileError.new(
              code: "missing_music21_instrument",
              message: "Roster part #{id.inspect} is missing music21: class name.",
              repair_instruction: "Declare the exact music21.instrument class name, e.g. part :oboe, \"Oboe\", music21: \"Oboe\".",
              help_topic: "container",
              docs: ["docs/architecture/orchestral_dsl/01_container.md"]
            )
          end

          @piece.add_part(Part.new(
            id: id,
            name: name,
            music21_instrument: music21,
            family: family,
            range: range,
            description: description,
            notation_group: notation_group,
            notation_staff: notation_staff
          ))
        end
      end

      class ControlBuilder
        def initialize(piece)
          @piece = piece
        end

        def build(&block)
          instance_eval(&block) if block
        end

        def dynamic(value, at:, **kwargs)
          @piece.add_control(Control.new(
            kind: :dynamic,
            value: value.to_s,
            at: at,
            target: required_target(kwargs)
          ))
        end

        def crescendo(from:, to:, **kwargs)
          @piece.add_control(Control.new(
            kind: :crescendo,
            from: from,
            to: to,
            target: required_target(kwargs)
          ))
        end

        def diminuendo(from:, to:, **kwargs)
          @piece.add_control(Control.new(
            kind: :diminuendo,
            from: from,
            to: to,
            target: required_target(kwargs)
          ))
        end

        def pedal(state, at:, **kwargs)
          @piece.add_control(Control.new(
            kind: :pedal,
            value: state.to_s,
            at: at,
            target: required_target(kwargs)
          ))
        end

        def text(value, at:, **kwargs)
          @piece.add_control(Control.new(
            kind: :text,
            value: value.to_s,
            at: at,
            target: required_target(kwargs)
          ))
        end

        # A harmonic label ("Dm", "Bbmaj7", "Dm/A"), distinct from `text`: renders as a
        # real MusicXML <harmony> chord symbol once, above the top staff — never a
        # per-instrument annotation, so it takes no `for:` target. Use `text` for
        # rehearsal/production prose instead.
        def chord(value, at:)
          @piece.add_control(Control.new(
            kind: :chord_symbol,
            value: value.to_s,
            at: at,
            target: :all
          ))
        end

        def key_change(value, at:)
          @piece.add_key_change(KeyChange.new(key: value.to_s, at: at))
        end

        # A harp pedal diagram: the seven pedals in diagram order D C B | E F G A,
        # each with an optional # or b. Renders as a real MusicXML <harp-pedals>
        # direction above the targeted harp's top staff — never as text.
        def harp_pedals(value, at:, **kwargs)
          @piece.add_control(Control.new(
            kind: :harp_pedals,
            value: normalized_harp_pedals(value),
            at: at,
            target: required_target(kwargs)
          ))
        end

        HARP_PEDAL_ORDER = %w[D C B E F G A].freeze

        private

        def normalized_harp_pedals(value)
          tokens = value.to_s.tr("|", " ").split(/\s+/).reject(&:empty?)
          valid = tokens.length == 7 &&
                  tokens.all? { |token| token.match?(/\A[A-G][#b]?\z/) } &&
                  tokens.map { |token| token[0] } == HARP_PEDAL_ORDER
          unless valid
            raise CompileError.new(
              code: "bad_harp_pedals",
              message: "harp_pedals must name the seven pedals in diagram order D C B | E F G A, got #{value.inspect}.",
              repair_instruction: "Write like harp_pedals \"D# C# B# | E# F# G# A#\", at: \"bar 5 beat 1\", for: :harp — one token per pedal, optional # or b.",
              help_topic: "controls",
              docs: ["docs/architecture/orchestral_dsl/surfaces/controls.md"]
            )
          end
          tokens.join(",")
        end

        def required_target(kwargs)
          kwargs.fetch(:for) do
            raise CompileError.new(
              code: "missing_control_target",
              message: "Control is missing for: target.",
              repair_instruction: "Add for: :all, for: :part_id, for: :family, or for: [:part_a, :part_b].",
              help_topic: "controls",
              docs: ["docs/architecture/orchestral_dsl/surfaces/controls.md"]
            )
          end
        end
      end

      class MeterBuilder
        def initialize(piece)
          @piece = piece
        end

        def build(&block)
          instance_eval(&block) if block
        end

        def change(value, at:, beat_pattern: nil)
          @piece.add_meter_change(value, at: at, beat_pattern: beat_pattern)
        end
      end

      class TempoBuilder
        def initialize(piece)
          @piece = piece
        end

        def build(&block)
          instance_eval(&block) if block
        end

        def mark(text, at: "bar 1 beat 1")
          @piece.add_tempo(text, at: at)
        end

        def change(text, at:)
          mark(text, at: at)
        end

        def ritardando(from:, to:)
          @piece.add_tempo_event(TempoEvent.new(kind: :ritardando, text: "rit.", from: from, to: to))
        end

        def accelerando(from:, to:)
          @piece.add_tempo_event(TempoEvent.new(kind: :accelerando, text: "accel.", from: from, to: to))
        end

        def a_tempo(at:)
          @piece.add_tempo_event(TempoEvent.new(kind: :a_tempo, text: "a tempo", at: at))
        end
      end

      class SectionBuilder
        def initialize(section)
          @section = section
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
          SpanBuilder.new(span).build(&block)
          @section.add_span(span)
        end

        def gesture(id, &block)
          gesture = GestureBuilder.new(id).build(&block)
          @section.add_gesture(gesture)
        end
      end

      class SpanBuilder
        def initialize(span)
          @span = span
        end

        def build(&block)
          instance_eval(&block) if block
        end

        def harmony(text)
          @span.add_harmony(text)
        end

        def process(text)
          @span.add_process(text)
        end

        def phrase(id, surface: nil, pitch: nil, &block)
          builder = PhraseBuilder.new(id, surface || pitch)
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
            docs: ["docs/architecture/orchestral_dsl/surfaces/phrase_placement.md"]
          )
        end
      end

      class PhraseBuilder
        def initialize(id, surface)
          @id = id
          @surface = surface&.to_sym
          @fields = {}
        end

        def build(&block)
          instance_eval(&block) if block
          @surface ||= infer_surface
          Phrase.new(id: @id, surface: @surface, events: build_events)
        end

        def key_context(value)
          @fields[:key_context] = value.to_s
        end

        def anchor(value)
          @fields[:anchor] = value.to_s
        end

        def degrees(text)
          @fields[:degrees] = text.to_s
        end

        def intervals(text)
          @fields[:intervals] = text.to_s
        end

        def rhythm(text)
          @fields[:rhythm] = text.to_s
        end

        def events(text)
          @fields[:events] = text.to_s
        end

        def pitches(text)
          @fields[:pitch_bars] = text.to_s
        end

        def pitch_bars(text)
          @fields[:pitch_bars] = text.to_s
        end

        def rhythm_bars(text)
          @fields[:rhythm_bars] = text.to_s
        end

        private

        def infer_surface
          return :degrees if @fields.key?(:degrees)
          return :intervals if @fields.key?(:intervals)
          return :absolute if @fields.key?(:events)
          return :split_pitch_rhythm if @fields.key?(:pitch_bars) || @fields.key?(:rhythm_bars)

          raise CompileError.new(
            code: "missing_surface",
            message: "Phrase #{@id} does not declare a surface and no surface can be inferred.",
            repair_instruction: "Add surface: :degrees, pitch: :degrees, or a typed phrase stream.",
            help_topic: "decision",
            docs: ["docs/architecture/orchestral_dsl/02_surface_decision.md"],
            minimal_example: "phrase :call, pitch: :degrees do ..."
          )
        end

        def build_events
          return Production.events_from_absolute_events(required(:events)) if @fields.key?(:events)

          case @surface
          when :degrees
            Production.events_from_degrees(required(:degrees), required(:rhythm), @fields[:key_context] || "C4")
          when :intervals
            Production.events_from_intervals(required(:intervals), required(:rhythm), required(:anchor))
          when :split_pitch_rhythm
            Production.events_from_absolute(required(:pitch_bars), required_rhythm_bars)
          when :absolute
            Production.events_from_absolute(required(:pitch_bars), required_rhythm_bars, help_topic: :absolute)
          else
            raise CompileError.new(
              code: "unknown_surface",
              message: "Unknown phrase surface #{@surface}.",
              repair_instruction: "Use one of: degrees, intervals, split_pitch_rhythm, absolute.",
              help_topic: "decision",
              docs: ["docs/architecture/orchestral_dsl/02_surface_decision.md"]
            )
          end
        end

        def required(name)
          @fields.fetch(name) do
            raise CompileError.new(
              code: "missing_phrase_field",
              message: "Phrase #{@id} surface #{@surface} is missing #{name}.",
              repair_instruction: "Add #{name} to the typed phrase block.",
              help_topic: @surface,
              docs: ["docs/architecture/orchestral_dsl/surfaces/#{@surface}.md"]
            )
          end
        end

        def required_rhythm_bars
          @fields[:rhythm_bars] || required(:rhythm)
        end
      end

      class GestureBuilder
        def initialize(id)
          @gesture = Gesture.new(id: id)
        end

        def build(&block)
          instance_eval(&block) if block
          @gesture
        end

        def idea(text)
          @gesture.idea_text = text
        end

        def mechanism(text)
          @gesture.add_mechanism(text)
        end

        def audible(text)
          @gesture.add_audible(text)
        end

        def line_relation(left, right, text)
          @gesture.add_line_relation(left, right, text)
        end

        def orchestration(text)
          @gesture.add_orchestration(text)
        end

        def silence(text)
          @gesture.add_silence(text)
        end

        def note(text)
          @gesture.add_note(text)
        end
      end

      class StaffBarBuilder
        def initialize(staff_bar)
          @staff_bar = staff_bar
        end

        def build(&block)
          instance_eval(&block) if block
        end

        def check(text)
          @staff_bar.add_check(text)
        end

        def lane(role, text)
          @staff_bar.add_lane(role, text)
        end

        def method_missing(name, *args, &block)
          return super if block || args.length != 1

          lane(name, args.first)
        end

        def respond_to_missing?(_name, _include_private = false)
          true
        end
      end
    end
  end
end
