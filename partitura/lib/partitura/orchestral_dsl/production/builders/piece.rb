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

        def part(id, name, music21: nil, family: nil, range: nil, description: nil, notation_group: nil, 
notation_staff: nil)
          unless music21
            raise CompileError.new(
              code: "missing_music21_instrument",
              message: "Roster part #{id.inspect} is missing music21: class name.",
              repair_instruction: "Declare the exact music21.instrument class name, e.g. part :oboe, \"Oboe\", " \
                                  "music21: \"Oboe\".",
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
    end
  end
end
