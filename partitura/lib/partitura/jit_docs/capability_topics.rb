# frozen_string_literal: true

module Partitura
  module JITDocs
    CAPABILITY_TOPICS = {
      roster: {
        use_when: "Declare instruments, playable ranges, notation staves, or percussion mappings.",
        rules: [
          "Every part has a stable id, display name, and exact `music21:` instrument class; exporters do not " \
          "infer instruments from display names.",
          "Use `range: \"E3-C6\"` when the compiler should reject sounding notes outside a playable range.",
          "Use one `notation_group` for logical lanes that export as one instrument; `notation_staff: 1|2|:auto` " \
          "selects or automatically splits grand-staff lanes.",
          "DSL pitches and analysis stay at sounding pitch; supported transposing instruments export in " \
          "conventional written pitch.",
          "A multi-sound percussion description declares `<pitch> <sound>` pairs; supported sound words are " \
          "snare, bass drum, cymbal, hi-hat, ride, tom, triangle, tambourine, and woodblock."
        ],
        example: <<~RUBY.strip,
            roster do
              part :english_horn, "English Horn", music21: "EnglishHorn",
                family: :woodwind, abbreviation: "E. Hn.", range: "E3-C6"
              part :piano_upper, "Piano Upper", music21: "Piano",
                family: :keyboard, notation_group: :piano, notation_staff: 1
              part :piano_middle, "Piano Middle", music21: "Piano",
                family: :keyboard, notation_group: :piano, notation_staff: :auto
            end
          RUBY
        next_topics: %i[container production controls projections export],
        docs: ["docs/architecture/partitura/01_container.md"]
      },
      cards: {
        use_when: "Find a reusable technique card or inspect the library's searchable vocabulary.",
        rules: [
          "Search by musical job, instrument, role, behavior, or character with `cards <terms>`.",
          "Use `cards terms` to discover current categories and facets, and `cards show <ID>` for one card.",
          "Cite DSL cards as `dsl:<category>/<id>`.",
          "Treat a card as an auditionable model or dialect seed; adapt it and write the resulting sounding " \
          "material explicitly instead of stamping or repeating the specimen."
        ],
        example: <<~BASH.strip,
            partitura/bin/partitura cards tender strings
            partitura/bin/partitura cards terms
            partitura/bin/partitura cards show dsl:chamberstrings/CS1_ROLE_ROTATION
          BASH
        next_topics: %i[production decision phrase_placement projections],
        docs: ["technique_library/dsl/README.md"]
      },
      examples: {
        use_when: "Find a canonical production example, exploratory surface study, or contract fixture.",
        rules: [
          "Use the runtime catalogue instead of scanning the experiments tree.",
          "Only entries with status `canonical` demonstrate the current production API.",
          "Exploratory and historical entries compare representations; do not copy their containers into new source.",
          "Contract fixtures verify protocols and may omit the musical completeness expected of examples."
        ],
        example: <<~BASH.strip,
            partitura/bin/partitura catalog examples
            partitura/bin/partitura catalog examples production_hybrid --json
          BASH
        next_topics: %i[production decision projections cards],
        docs: ["docs/architecture/partitura/04_examples_manifest.md"]
      },
      build: {
        use_when: "Build one or all entries from a Partitura framework registry.",
        rules: [
          "Use the consolidated `partitura build` command; `partitura_build` is only a compatibility shim.",
          "Pass `all` or one registry entry id after the registry path.",
          "Framework paths must work from consumer repositories; set `PARTITURA_PROJECT_ROOT` only when the " \
          "caller must force the project root.",
          "Ruby owns source loading, mechanical validation, and MusicXML/MIDI export directly."
        ],
        example: <<~BASH.strip,
            partitura/bin/partitura build path/to/registry.rb all
            partitura/bin/partitura build path/to/registry.rb movement_id
          BASH
        next_topics: %i[production compile_api export],
        docs: ["docs/architecture/partitura/06_ruby_framework.md"]
      }
    }.freeze
  end
end
