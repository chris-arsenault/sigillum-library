# frozen_string_literal: true

module Partitura
  module Production
    # Letter chord-symbol parsing for the declared per-bar chord track.
    # Grammar: root letter, optional accidental (#, b, or music21-style -), optional
    # quality suffix, optional /bass. Examples: F, Am, E7, Bb, A-, Cm7, G7/B, Fsus4.
    module Chords
      TEMPLATES = {
        "" => [0, 4, 7], "m" => [0, 3, 7], "dim" => [0, 3, 6], "aug" => [0, 4, 8],
        "7" => [0, 4, 7, 10], "m7" => [0, 3, 7, 10], "maj7" => [0, 4, 7, 11],
        "dim7" => [0, 3, 6, 9], "m7b5" => [0, 3, 6, 10],
        "6" => [0, 4, 7, 9], "m6" => [0, 3, 7, 9],
        "sus4" => [0, 5, 7], "sus2" => [0, 2, 7]
      }.freeze

      LETTER_PCS = { "C" => 0, "D" => 2, "E" => 4, "F" => 5, "G" => 7, "A" => 9, "B" => 11 }.freeze
      ACCIDENTAL_OFFSETS = { "#" => 1, "b" => -1, "-" => -1, "" => 0 }.freeze

      Symbolized = Struct.new(:text, :root_pc, :quality, :pcs, :bass_pc, keyword_init: true)

      module_function

      def parse(text)
        match = text.to_s.strip.match(%r{\A([A-G])([#b-]?)([^/]*)(?:/([A-G])([#b-]?))?\z})
        return nil unless match

        letter, accidental, quality, bass_letter, bass_accidental = match.captures
        template = TEMPLATES[quality]
        return nil unless template

        root_pc = (LETTER_PCS.fetch(letter) + ACCIDENTAL_OFFSETS.fetch(accidental)) % 12
        pcs = template.map { |step| (root_pc + step) % 12 }
        bass_pc = bass_letter && ((LETTER_PCS.fetch(bass_letter) + ACCIDENTAL_OFFSETS.fetch(bass_accidental.to_s)) % 12)
        pcs |= [bass_pc] if bass_pc
        Symbolized.new(text: text.strip, root_pc: root_pc, quality: quality, pcs: pcs, bass_pc: bass_pc)
      end

      def valid?(text)
        !parse(text).nil?
      end
    end
  end
end
