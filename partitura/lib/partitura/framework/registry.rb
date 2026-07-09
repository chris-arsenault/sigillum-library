# frozen_string_literal: true

require "pathname"

module Partitura
  module Framework
    MovementSpec = Struct.new(
      :id, :title, :source, :output_stem, :bars, :roman, :status,
      keyword_init: true
    ) do
      def key
        id.to_s
      end

      def stem
        (output_stem || id).to_s
      end

      def source_path(base_dir: Paths::ROOT)
        path = Pathname.new(source.to_s)
        path.absolute? ? path : Pathname.new(base_dir.to_s).join(path)
      end

      def output_dir
        Paths.movement_dir(stem)
      end

      def export(base_dir: Paths::ROOT)
        piece = Partitura.load_production_file(source_path(base_dir: base_dir))
        piece.validate!
        xml_path = Paths.musicxml_path(output_dir, stem)
        midi_path = Paths.midi_path(output_dir, stem)
        xml_path.write(Partitura.production_musicxml(piece))
        midi_path.binwrite(Partitura.production_midi(piece))
        { musicxml: xml_path, midi: midi_path }
      end
    end

    class Registry
      attr_reader :movements

      def initialize(base_dir: Paths::ROOT)
        @base_dir = Pathname.new(base_dir.to_s)
        @movements = []
      end

      def register(**kwargs)
        @movements << MovementSpec.new(**kwargs)
      end

      def find(value)
        key = value.to_s
        @movements.find { |movement| [movement.id.to_s, movement.stem].include?(key) } ||
          raise(KeyError, "unknown movement: #{value}")
      end

      def export(selection = "all")
        selected = selection.to_s == "all" ? @movements : [find(selection)]
        selected.map { |movement| movement.export(base_dir: @base_dir) }
      end

      def self.load_file(path)
        path = Pathname.new(path.to_s)
        registry = new(base_dir: path.dirname)
        context = Object.new
        context.define_singleton_method(:movement) do |id, **kwargs|
          registry.register(id: id, **kwargs)
        end
        context.instance_eval(path.read, path.to_s)
        registry
      end
    end
  end
end
