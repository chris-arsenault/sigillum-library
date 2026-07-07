# frozen_string_literal: true

module Partitura
  module Production
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
        # Keys change at barlines: accept a bare "bar N" and pin it to beat 1.
        at = "#{at} beat 1" if at.is_a?(String) && at.match?(/\Abar\s+\d+\z/)
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
            repair_instruction: "Write like harp_pedals \"D# C# B# | E# F# G# A#\", at: \"bar 5 beat 1\", " \
                                "for: :harp — one token per pedal, optional # or b.",
            help_topic: "controls",
            docs: ["docs/architecture/partitura/surfaces/controls.md"]
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
            docs: ["docs/architecture/partitura/surfaces/controls.md"]
          )
        end
      end
    end
  end
end
