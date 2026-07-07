# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
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
    end
  end
end
