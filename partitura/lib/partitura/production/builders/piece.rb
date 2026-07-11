# frozen_string_literal: true

module Partitura
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

      def lint(&block)
        LintConfigBuilder.new(@piece).build(&block)
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

      def fill_material(id, surface: nil, pitch: nil, &block)
        builder = FillMaterialBuilder.new(id, surface || pitch, default_key: @piece.key_value)
        material = builder.build(&block)
        validate_fill_material_duration!(material)
        @piece.add_fill_material(material)
      end

      def roster(&block)
        RosterBuilder.new(@piece).build(&block)
      end

      def section(id, name, bars:, type: nil, &block)
        section = Section.new(id: id, name: name, bars: bars, type: type)
        SectionBuilder.new(@piece, section, default_key: @piece.key_value).build(&block)
        @piece.add_section(section)
      end

      private

      def validate_fill_material_duration!(material)
        duration = FillMaterialRealizer.new(material).realize.duration
        return if duration < @piece.bar_length

        raise CompileError.new(
          code: "fill_material_too_long",
          message: "Fill material #{material.id} lasts #{Production.format_duration(duration)} beats; " \
                   "fills must be shorter than one bar.",
          repair_instruction: "Shorten the material or write it as a normal phrase/texture line instead of a fill.",
          help_topic: "phrase_placement",
          docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
        )
      end
    end

    class LintConfigBuilder
      def initialize(piece)
        @piece = piece
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def rule(name, **options)
        key = name.to_sym
        unless Lint::DEFAULTS.key?(key)
          raise CompileError.new(
            code: "unknown_lint_rule",
            message: "Unknown lint rule #{name.inspect}.",
            repair_instruction: "Use one of: #{Lint::DEFAULTS.keys.join(', ')}.",
            help_topic: "production",
            docs: ["docs/architecture/partitura/01_container.md"]
          )
        end

        @piece.lint_config[key] = (@piece.lint_config[key] || {}).merge(options)
      end
    end

    class RosterBuilder
      def initialize(piece)
        @piece = piece
      end

      def build(&block)
        instance_eval(&block) if block
      end

      def part(id, name, music21: nil, family: nil, range: nil, description: nil, percussion_map: nil,
               notation_group: nil, notation_staff: nil, abbreviation: nil)
        unless music21
          raise CompileError.new(
            code: "missing_music21_instrument",
            message: "Roster part #{id.inspect} is missing music21: class name.",
            repair_instruction: "Declare the exact music21.instrument class name, e.g. part :oboe, \"Oboe\", " \
                                "music21: \"Oboe\".",
            help_topic: "container",
            docs: ["docs/architecture/partitura/01_container.md"]
          )
        end

        normalized_percussion_map = normalize_percussion_map(id, family, percussion_map)
        @piece.add_part(Part.new(
          id: id,
          name: name,
          music21_instrument: music21,
          family: family,
          range: range,
          description: description,
          percussion_map: normalized_percussion_map,
          notation_group: notation_group,
          notation_staff: notation_staff,
          abbreviation: abbreviation
        ))
      end

      private

      def normalize_percussion_map(id, family, percussion_map)
        normalized = PercussionDevices.normalize_map(percussion_map)
        return normalized if normalized.empty? || family.to_s == "percussion"

        raise ArgumentError, "percussion_map requires family: :percussion"
      rescue ArgumentError => error
        raise CompileError.new(
          code: "bad_percussion_map",
          message: "Roster part #{id.inspect} has an invalid percussion_map: #{error.message}.",
          repair_instruction: "Map authored pitch identifiers to supported devices: " \
                              "#{PercussionDevices::DEVICES.keys.join(', ')}.",
          help_topic: "container",
          docs: ["docs/architecture/partitura/01_container.md"]
        )
      end
    end
  end
end
