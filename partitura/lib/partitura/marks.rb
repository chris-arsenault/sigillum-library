# frozen_string_literal: true

module Partitura
  # Canonical closed vocabulary for inline event marks (`{...}` on note/degree/interval
  # tokens). The JIT `marks` help topic, the compile-time mark validator, and the
  # exporters all read from here so the vocabulary cannot drift.
  module Marks
    DYNAMICS = %w[ppp pp p mp mf f ff fff fp sfz].freeze
    ARTICULATIONS = %w[stacc accent ten marc spicc. detache choke].freeze
    TECHNIQUES = %w[harm lv trem pizz arco rimshot xstick].freeze
    ORNAMENTS = %w[trill].freeze
    SPANNERS = %w[slur( slur) tie( tie) cresc( cresc) dim( dim) gliss( gliss) trill( trill)].freeze
    ARPEGGIOS = %w[arp arp:up arp:down arp:non].freeze

    ALL = (DYNAMICS + ARTICULATIONS + TECHNIQUES + ORNAMENTS + SPANNERS + ARPEGGIOS).freeze

    # `txt:` carries free text (vocal syllables, `txt:con_sord.`); it is the only open
    # prefix. Techniques above must never be spelled as `txt:` labels.
    TEXT_PREFIX = "txt:"

    module_function

    def valid?(mark)
      ALL.include?(mark) || mark.start_with?(TEXT_PREFIX)
    end

    def vocabulary_lines
      [
        "dynamics: #{DYNAMICS.join(' ')}",
        "articulations: #{ARTICULATIONS.join(' ')}",
        "techniques: #{TECHNIQUES.join(' ')}",
        "ornaments: #{ORNAMENTS.join(' ')} (single note) / trill( trill) (span)",
        "spanner pairs: #{SPANNERS.join(' ')}",
        "rolled chords: #{ARPEGGIOS.join(' ')}",
        "free text: #{TEXT_PREFIX}<words_with_underscores>"
      ]
    end
  end
end
