# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
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
    end
  end
end
