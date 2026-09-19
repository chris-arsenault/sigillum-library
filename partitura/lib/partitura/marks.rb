# frozen_string_literal: true

module Partitura
  # Canonical closed vocabulary for inline event marks (`{...}` on note/degree/interval
  # tokens). The JIT `marks` help topic, the compile-time mark validator, and the
  # exporters all read from here so the vocabulary cannot drift.
  module Marks
    DYNAMICS = %w[ppp pp p mp mf f ff fff fp sfz].freeze
    ARTICULATIONS = %w[stacc accent ten marc spicc. detache choke].freeze
    TECHNIQUES = %w[harm lv trem pizz arco rimshot xstick ghost].freeze
    GHOST_ATTENUATION_DB = -12
    ORNAMENTS = %w[trill].freeze
    SPANNERS = %w[slur( slur) tie( tie) cresc( cresc) dim( dim) gliss( gliss) slide( slide) trill( trill)].freeze
    ARPEGGIOS = %w[arp arp:up arp:down arp:non].freeze
    HOLDS = %w[fermata].freeze
    NUMBERED_SLUR = /\Aslur:(?:[1-9]|1[0-6])[()]\z/.freeze

    ALL = (DYNAMICS + ARTICULATIONS + TECHNIQUES + ORNAMENTS + SPANNERS + ARPEGGIOS + HOLDS).freeze

    # `txt:` carries free text (vocal syllables, `txt:con_sord.`). Numbered slurs
    # use the bounded form above. Techniques must never be spelled as `txt:` labels.
    TEXT_PREFIX = "txt:"

    module_function

    def valid?(mark)
      ALL.include?(mark) || NUMBERED_SLUR.match?(mark) || mark.start_with?(TEXT_PREFIX)
    end

    def unnumbered(mark)
      NUMBERED_SLUR.match?(mark) ? mark.sub(/:\d+/, "") : mark
    end

    def vocabulary_lines
      [
        "dynamics: #{DYNAMICS.join(' ')}",
        "articulations: #{ARTICULATIONS.join(' ')}",
        "techniques: #{TECHNIQUES.join(' ')}",
        "ghost: parenthesized notehead and local -12 dB playback/model attenuation; " \
        "does not print or change the ongoing dynamic",
        "ornaments: #{ORNAMENTS.join(' ')} (single note) / trill( trill) (span)",
        "spanner pairs: #{SPANNERS.join(' ')}",
        "overlapping slurs: slur:2( slur:2) (numbers 1–16; unnumbered slurs use 1)",
        "rolled chords: #{ARPEGGIOS.join(' ')}",
        "holds: #{HOLDS.join(' ')} (notation only - MIDI playback keeps the written duration; " \
        "use tempo ritardando/a_tempo for timed holds)",
        "free text: #{TEXT_PREFIX}<words_with_underscores>"
      ]
    end
  end
end
