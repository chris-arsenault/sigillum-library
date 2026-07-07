# frozen_string_literal: true

require_relative "melody_analysis/report"
require_relative "melody_analysis/texture"
require_relative "melody_analysis/harmony"
require_relative "melody_analysis/figuration"
require_relative "melody_analysis/utilities"

module Partitura
  module Production
    class MelodyAnalysis
      PC = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze
      PC_NAMES = %w[C C# D Eb E F F# G Ab A Bb B].freeze
      KS_MAJOR = [6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88].freeze
      KS_MINOR = [6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17].freeze
      SCALE_OFFSETS = {
        major: [0, 2, 4, 5, 7, 9, 11],
        minor: [0, 2, 3, 5, 7, 8, 11]
      }.freeze
      CHORD_TONE = { 0 => "R", 3 => "3", 4 => "3", 6 => "5", 7 => "5", 8 => "5", 10 => "7", 11 => "7" }.freeze

      HARM_WINDOW = 2.0
      HARM_HOP = 1.0
      HARM_OFF_PENALTY = 0.55
      STEP_MAX = 2
      LEAP_MIN = 3
      MIN_RUN = 3
      MIN_ARP = 3
      SUSTAIN_X = 1.8
      TRILL_MAX_DUR = 0.5
      CELL_LENGTHS = [5, 4, 3].freeze
      MOTIF_MIN_GAP = 0
      MIN_MELODY_NOTES = 6
      MIN_MELODY_PCS = 3
      MAX_BIG_LEAP_FRACTION = 0.15
      BIG_LEAP = 12
      MIN_COVERAGE = 0.5

      MIN_RESTATEMENT = 0.25
      MAX_APEX_HITS = 3
      APEX_EDGE = 0.12
      MIN_RANGE = 5
      MAX_RANGE = 28
      MIN_DISTINCT_DUR = 3
      MIN_STRONGBEAT_CT = 0.70
      MIN_DOWNBEAT_ROOT = 0.40
      NCT_LO = 0.05
      NCT_HI = 0.45

      NoteEvent = Struct.new(:onset, :offset, :midi, :duration, :part, keyword_init: true)
      AnalyzedNote = Struct.new(:onset, :offset, :midi, :duration, :part, :features, keyword_init: true)
      SegmentFeatures = Struct.new(:contour, :archetype, :apex_position, :range_semitones, :style, keyword_init: true)

      attr_reader :piece, :part, :bars, :notes, :segment, :key

      include Figuration
      include Harmony
      include Report
      include Texture
      include Utilities

      def self.for_piece(piece, part: nil, bars: nil)
        new(piece, part: part, bars: bars)
      end

      def initialize(piece, part: nil, bars: nil)
        @piece = piece
        @part = part&.to_sym
        @bars = bars
        @texture = build_texture
        @total = @texture.map { |event| event.onset + event.duration.to_f }.max || 0.0
        @melody = melody_line(@texture)
        @estimated_key = estimate_key(pc_histogram(@texture))
        @key = declared_key || @estimated_key
        @windows = windowed_harmony(accompaniment(@texture, @melody))
        @ordinals = diatonic_ordinals(*@key)
        @notes = analyze_notes
        @segment = summarize_segment
      end

      def to_h
        {
          title: piece.title,
          part: part,
          bars: bars && "#{bars.begin}-#{bars.end}",
          key: key_label,
          estimated_key: estimated_key_label,
          declared_key: declared_key && declared_key_label,
          melody_notes: notes.map { |note| note_to_h(note) },
          segment: segment_to_h
        }
      end

      def note_to_h(note)
        {
          offset: piece.format_offset(note.offset),
          part: note.part,
          pitch: label_of(note.midi),
          duration: note.duration,
          tonal: note.features.fetch(:tonal),
          harmony: note.features.fetch(:harmony),
          figuration: note.features.fetch(:figuration),
          motif: note.features.fetch(:motif),
          metric: note.features.fetch(:metric)
        }
      end

      def segment_to_h
        {
          contour: segment.contour,
          archetype: segment.archetype,
          apex_position: segment.apex_position,
          range_semitones: segment.range_semitones,
          style: segment.style
        }
      end

    end
  end
end
