# frozen_string_literal: true

require "date"

require_relative "musicxml/beaming"
require_relative "musicxml/builder"
require_relative "musicxml/control_layout"
require_relative "musicxml/direction_rendering"
require_relative "musicxml/note_rendering"
require_relative "musicxml/score_structure"
require_relative "musicxml/segment_layout"
require_relative "musicxml/values"
require_relative "musicxml/voice_layout"

module Sigillum
  module OrchestralDSL
    module Export
      module MusicXML
        DIVISIONS = 10_080
        SCHEMA = "sigillum.orchestral_dsl.transport"
        SUPPORTED_SCHEMA_VERSION = 3
        NOTES_PART_ID = "__notes__"
        MAX_HAIRPIN_BARS = 2
        TEMPO_RAMP_STEP_QL = Rational(1)
        DEFAULT_TEMPO_RAMP_PERCENT = {
          "accelerando" => 125.0,
          "ritardando" => 65.0
        }.freeze

        DYNAMICS = %w[ppp pp p mp mf f ff fff fp sfz].freeze
        DYNAMIC_SOUND = {
          "ppp" => 19,
          "pp" => 31,
          "p" => 44,
          "mp" => 57,
          "mf" => 69,
          "f" => 88,
          "ff" => 107,
          "fff" => 114,
          "fp" => 88,
          "sfz" => 88
        }.freeze
        ARTICULATIONS = {
          "stacc" => "staccato",
          "accent" => "accent",
          "ten" => "tenuto",
          "marc" => "strong-accent",
          "spicc." => "spiccato",
          "detache" => "detached-legato",
          "choke" => "stopped"
        }.freeze
        MIDI_PROGRAMS = {
          "BassClarinet" => 72,
          "Bassoon" => 71,
          "Clarinet" => 72,
          "Contrabass" => 44,
          "Flute" => 74,
          "Harp" => 47,
          "Horn" => 61,
          "Oboe" => 69,
          "Piano" => 1,
          "Trumpet" => 57,
          "Trombone" => 58,
          "Viola" => 42,
          "Violin" => 41,
          "Violoncello" => 43
        }.freeze

        ABBREVIATIONS = {
          "Bass Clarinet" => "Bs Cl",
          "Bassoon" => "Bsn",
          "Cello" => "Vc",
          "Clarinet" => "Cl",
          "Flute" => "Fl",
          "Horn" => "Hn",
          "Oboe" => "Ob",
          "Piano" => "Pno.",
          "Trombone" => "Trb",
          "Trumpet" => "Tpt",
          "Viola" => "Vla",
          "Violin" => "Vln"
        }.freeze

        module_function

        def render(transport_hash)
          Renderer.new(transport_hash).render
        end

        def parity_ready?
          true
        end

        class Renderer
          include Beaming
          include ControlLayout
          include DirectionRendering
          include NoteRendering
          include ScoreStructure
          include SegmentLayout
          include Values
          include VoiceLayout

          def initialize(transport_hash)
            @data = deep_stringify(transport_hash)
            validate!
          end

          def render
            xml = Builder.new
            xml.raw(%(<?xml version="1.0" encoding="utf-8"?>))
            xml.raw(
              '<!DOCTYPE score-partwise  PUBLIC "-//Recordare//DTD MusicXML 4.0 Partwise//EN" ' \
              '"http://www.musicxml.org/dtds/partwise.dtd">'
            )
            xml.open("score-partwise", "version" => "4.0")
            render_header(xml)
            render_part_list(xml)
            rendered_parts.each_with_index { |part, index| render_part(xml, part, index) }
            xml.close("score-partwise")
            xml.to_s
          end
        end
      end
    end
  end
end
