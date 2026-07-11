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

module Partitura
  module Export
    module MusicXML
      DIVISIONS = 10_080
      NOTES_PART_ID = "__notes__"
      MAX_HAIRPIN_BARS = 2
      TEMPO_RAMP_STEP_QL = Rational(1)
      MUSICXML_NUMBER_LEVELS = (1..16).to_a.freeze
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
        "Timpani" => 48,
        "Trumpet" => 57,
        "Trombone" => 58,
        "Tuba" => 59,
        "Viola" => 42,
        "Violin" => 41,
        "Violoncello" => 43
      }.freeze

      ALTO_CLEF_INSTRUMENTS = %w[
        Viola
      ].freeze
      BASS_CLEF_INSTRUMENTS = %w[
        Bass BassTrombone Bassoon Cello Contrabass Contrabassoon DoubleBass
        ElectricBass Euphonium StringBass Timpani Trombone Tuba Violoncello
      ].freeze
      PERCUSSION_CLEF_INSTRUMENTS = %w[
        BassDrum CrashCymbals Cymbals HiHatCymbal Percussion RideCymbals
        SnareDrum Tambourine TomTom Triangle Woodblock
      ].freeze
      CLEF_SIGNATURES = {
        "treble" => ["G", "2"].freeze,
        "alto" => ["C", "3"].freeze,
        "tenor" => ["C", "4"].freeze,
        "bass" => ["F", "4"].freeze,
        "percussion" => ["percussion", nil].freeze
      }.freeze

      WRITTEN_TRANSPOSITIONS = {
        "Horn" => {
          written_diatonic: 4,
          written_chromatic: 7,
          diatonic: -4,
          chromatic: -7,
          octave_change: 0,
          key_fifths_delta: 1
        }.freeze,
        "Contrabass" => {
          written_diatonic: 7,
          written_chromatic: 12,
          diatonic: 0,
          chromatic: 0,
          octave_change: -1,
          key_fifths_delta: 0
        }.freeze
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
        "Timpani" => "Timp.",
        "Trombone" => "Trb",
        "Trumpet" => "Tpt",
        "Tuba" => "Tba",
        "Viola" => "Vla",
        "Violin" => "Vln",
        "Violin I" => "Vln. I",
        "Violin II" => "Vln. II",
        "Violoncellos" => "Vc.",
        "Contrabasses" => "Cb.",
        "Horns 1-2" => "Hn. 1-2",
        "Tenor and Bass Trombones" => "Tbn.",
        "Orchestral Battery" => "Perc."
      }.freeze

      module_function

      def render(piece)
        Renderer.new(piece).render
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

        def initialize(piece)
          @data = deep_stringify(Production.export_data(piece))
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
