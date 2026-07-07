# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
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
    end
  end
end
