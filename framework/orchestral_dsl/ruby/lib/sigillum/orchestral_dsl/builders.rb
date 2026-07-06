# frozen_string_literal: true

require_relative "model"
require_relative "parser"

module Sigillum
  module OrchestralDSL
    class PieceBuilder
      def initialize(title)
        @piece = Piece.new(title: title)
      end

      def build(&block)
        instance_eval(&block) if block
        @piece
      end

      def meter(value, beat_pattern: nil, bar_length: nil)
        @piece.set_meter(value, beat_pattern: beat_pattern, bar_length: bar_length)
      end

      def key(value)
        @piece.set_key(value)
      end

      def tempo(text)
        @piece.add_tempo(text)
      end

      def roster(&block)
        RosterBuilder.new(@piece).build(&block)
      end

      def material(id, &block)
        builder = MaterialBuilder.new(id)
        material = builder.build(&block)
        @piece.add_material(material)
        material
      end

      def section(id, name, bars:, type: nil, &block)
        builder = SectionBuilder.new(id, name, bars: bars, type: type)
        section = builder.build(&block)
        @piece.add_section(section)
        section
      end
    end

    class RosterBuilder
      def initialize(piece)
        @piece = piece
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def part(id, name, music21: nil, family: nil, range: nil, description: nil)
        @piece.add_part(Part.new(
          id: id,
          name: name,
          music21_instrument: music21,
          family: family,
          range: range,
          description: description
        ))
      end
    end

    class MaterialBuilder
      def initialize(id)
        @material = Material.new(id: id)
      end

      def build(&block)
        instance_eval(&block) if block
        @material
      end

      def description(text)
        @material.description = text
      end

      def notes(text)
        @material.add_notes(NoteParser.parse(text))
      end

      def allowed_transform(text)
        @material.allow_transform(text)
      end
    end

    class SectionBuilder
      def initialize(id, name, bars:, type: nil)
        @section = Section.new(id: id, name: name, bars: bars, type: type)
      end

      def build(&block)
        instance_eval(&block) if block
        @section
      end

      def journey(text)
        @section.add_journey(text)
      end

      def destination(text)
        @section.add_destination(text)
      end

      def span(bars:, label: nil, texture: nil, &block)
        builder = SpanBuilder.new(bars: bars, label: label, texture: texture)
        span = builder.build(&block)
        @section.add_span(span)
        span
      end

      def gesture(id, &block)
        builder = GestureBuilder.new(id)
        gesture = builder.build(&block)
        @section.add_gesture(gesture)
        gesture
      end
    end

    class SpanBuilder
      def initialize(bars:, label: nil, texture: nil)
        @span = Span.new(bars: bars, label: label, texture: texture)
      end

      def build(&block)
        instance_eval(&block) if block
        @span
      end

      def harmony(text)
        @span.add_harmony(text)
      end

      def process(text)
        @span.add_process(text)
      end

      def line(part_id, role:, enters: 0, technique: nil, &block)
        builder = LineBuilder.new(part_id, role: role, enters: enters, technique: technique)
        line = builder.build(&block)
        @span.add_line(line)
        line
      end

      def gesture(id, &block)
        builder = GestureBuilder.new(id)
        gesture = builder.build(&block)
        @span.add_gesture(gesture)
        gesture
      end

      def moment(bar:, beat:, label: nil, &block)
        builder = MomentBuilder.new(bar: bar, beat: beat, label: label)
        moment = builder.build(&block)
        @span.add_moment(moment)
        moment
      end
    end

    class LineBuilder
      def initialize(part_id, role:, enters:, technique:)
        @line = Line.new(part_id: part_id, role: role, entry_offset: enters, technique: technique)
        @current_phrase = nil
        @current_material_use = nil
      end

      def build(&block)
        instance_eval(&block) if block
        @line
      end

      def phrase(name, &block)
        unless block
          @current_phrase = name.to_s
          return
        end

        old_phrase = @current_phrase
        @current_phrase = name.to_s
        instance_eval(&block)
      ensure
        @current_phrase = old_phrase if block
      end

      def quote(material_id, transform: nil, comment: nil, notes: nil, &block)
        material_use = MaterialUse.new(material_id: material_id, transform: transform, comment: comment)
        @line.add_material_use(material_use)
        old_phrase = @current_phrase
        @current_phrase ||= material_id.to_s
        @current_material_use = material_use
        self.notes(notes) if notes
        instance_eval(&block) if block
      ensure
        @current_material_use = nil
        @current_phrase = old_phrase
      end

      def relation_to(part_id, text)
        @line.add_relation(part_id, text)
      end

      def role_detail(text)
        @line.add_role_detail(text)
      end

      def notes(text)
        @line.add_notes(
          NoteParser.parse(text),
          phrase: @current_phrase,
          material_use: @current_material_use
        )
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

    class MomentBuilder
      def initialize(bar:, beat:, label:)
        @moment = Moment.new(bar: bar, beat: beat, label: label)
      end

      def build(&block)
        instance_eval(&block) if block
        @moment
      end

      def sonority(text)
        @moment.add_sonority(text)
      end

      def foreground(part_id, pitch = nil)
        @moment.add_foreground(part_id, pitch)
      end

      def bass(part_id, pitch = nil)
        @moment.add_bass(part_id, pitch)
      end

      def color(part_id, text = nil)
        @moment.add_color(part_id, text)
      end

      def relation(text)
        @moment.add_relation(text)
      end
    end
  end
end
