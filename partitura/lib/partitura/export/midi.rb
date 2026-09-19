# frozen_string_literal: true

require_relative "midi/notation"
require_relative "midi/tracks"
require_relative "midi/values"

module Partitura
  module Export
    module MIDI
      DIVISIONS = 10_080

      PROGRAMS = {
        "Soprano" => 52,
        "Tenor" => 52,
        "Bass" => 52,
        "SteelDrum" => 114,
        "BassClarinet" => 71,
        "Bassoon" => 70,
        "Clarinet" => 71,
        "Contrabass" => 43,
        "ElectricBass" => 33,
        "Flute" => 73,
        "Harp" => 46,
        "Horn" => 60,
        "Oboe" => 68,
        "Piano" => 0,
        "Timpani" => 47,
        "Trumpet" => 56,
        "Trombone" => 57,
        "Tuba" => 58,
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

      def render(piece)
        Renderer.new(piece).render
      end

      def parity_ready?
        true
      end

      class Renderer
        include Notation
        include Tracks
        include Values

        def initialize(piece)
          @data = deep_stringify(Production.export_data(piece, exact_timing: true))
          @data["timed_events"] = exact_timed_events(piece)
          @dynamics = Production::SoundingReadout::PerceptualDynamics.new(piece)
        end

        def render
          tracks = [tempo_track]
          parts.each_with_index { |part, index| tracks << part_track(part, index) }
          tracks << notes_track while tracks.length < desired_track_count
          header = "MThd".b + [6, 1, tracks.length, DIVISIONS].pack("Nnnn")
          header + tracks.join.b
        end

        private

        # The general export adapter uses floats. Keep the model's rationals
        # for tie joins and dynamic boundaries, quantizing only at MIDI ticks.
        def exact_timed_events(piece)
          piece.timed_events(include_rests: true).map do |event|
            data = Production.export_timed_event(piece, event).merge(
              offset_ql: event.offset, duration_ql: event.duration, end_offset_ql: event.end_offset
            )
            deep_stringify(data)
          end
        end
      end
    end
  end
end
