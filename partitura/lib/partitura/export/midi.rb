# frozen_string_literal: true

require_relative "midi/notation"
require_relative "midi/tracks"
require_relative "midi/values"

module Partitura
  module Export
    module MIDI
      DIVISIONS = 10_080
      SCHEMA = "partitura.transport"
      SUPPORTED_SCHEMA_VERSION = 3

      PROGRAMS = {
        "BassClarinet" => 71,
        "Bassoon" => 70,
        "Clarinet" => 71,
        "Contrabass" => 43,
        "Flute" => 73,
        "Harp" => 46,
        "Horn" => 60,
        "Oboe" => 68,
        "Piano" => 0,
        "Trumpet" => 56,
        "Trombone" => 57,
        "Viola" => 41,
        "Violin" => 40,
        "Violoncello" => 42
      }.freeze

      DYNAMIC_VELOCITY = {
        "ppp" => 25,
        "pp" => 35,
        "p" => 48,
        "mp" => 58,
        "mf" => 72,
        "f" => 88,
        "ff" => 104,
        "fff" => 116,
        "fp" => 88,
        "sfz" => 110
      }.freeze

      module_function

      def render(transport_hash)
        Renderer.new(transport_hash).render
      end

      def parity_ready?
        true
      end

      class Renderer
        include Notation
        include Tracks
        include Values

        def initialize(transport_hash)
          @data = deep_stringify(transport_hash)
          validate!
        end

        def render
          tracks = [tempo_track]
          parts.each_with_index { |part, index| tracks << part_track(part, index) }
          tracks << notes_track while tracks.length < desired_track_count
          header = "MThd".b + [6, 1, tracks.length, DIVISIONS].pack("Nnnn")
          header + tracks.join.b
        end

        private

        def validate!
          schema = @data["schema"]
          version = @data["schema_version"]
          return if schema == SCHEMA && version == SUPPORTED_SCHEMA_VERSION

          raise Error, "unsupported Partitura transport #{schema.inspect} version #{version.inspect}"
        end
      end
    end
  end
end
