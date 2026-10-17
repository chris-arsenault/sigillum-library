# frozen_string_literal: true

require_relative "contracts"

module Partitura
  module Composer
    module Guidance
      TOPICS = {
        "compose" => "Start from the commission and the music's identity. Establish forces and form, then compose " \
                     "connected passages and accompaniment. Use set_section and write_passage; remember settled " \
                     "decisions. Read craft/composition_feedback and the relevant owning references.",
        "revise" => "Read the actual passage with its ensemble and neighboring music. Use write_voice for one voice " \
                    "or write_passage for the whole passage; save related changes together. Other voices " \
                    "remain intact with write_voice. Read the result and inspect its musical consequences.",
        "notation" => "Use events for explicit absolute notes: C5:1{accent} E5:.5 r:.5 G5:2 | F5:4. " \
                      "Durations are quarter-note units: 1=quarter, .5=eighth, .25=sixteenth; fractions such as 1/3 " \
                      "are exact. Chords: [C4,E4,G4]:2. Barline: |. Rest: r:1. Marks: {stacc,accent,ten}, " \
                      "{slur(} and {slur)}, {tie(} and {tie)}. Alternatively supply degrees, rhythm and key_context " \
                      "together, e.g. degrees='1 3 5 | 4', rhythm='1 1 2 | 4', key_context='F4'. " \
                      "Voice entries sit within passages. anacrusis is a pickup duration; write its notes too.",
        "form" => "Sections have stable IDs, a name and length in bars. Their order determines global bar positions. " \
                  "set_section creates or updates section context while retaining its music. write_passage supplies " \
                  "a passage ID, section-local at bar, length and voices. arrange_sections lists every section " \
                  "once. Extending a section leaves new bars unwritten; shortening cannot discard existing passages. " \
                  "Chords use passage-local bars: b1:F b2:Bb b3-4:C7.",
        "controls" => "write_control attaches an ID and kind to a section-local position. Point controls use at and " \
                      "value; dynamic, text, pedal, clef, harp_pedals and key_signature name for (part, family, " \
                      "role or a list). Hairpins use from, to and for. Tempo ramps use from and to. a_tempo uses at. " \
                      "Other kinds: tempo, key, meter, swing, chord. Tempo values look like 'quarter = 88'; swing is " \
                      "'off', 'eighth' or 'sixteenth'. A control's end may land on the next section's boundary, " \
                      "but it cannot reach into another section. Internal meter changes land at beat 1. " \
                      "intentional_dissonance uses from, to, for and value (a musical reason). It annotates " \
                      "exposed_clashes for the involved pair and harmony_check within the range; findings and " \
                      "severity remain visible. It adds no printed direction and does not waive errors.",
        "projections" => "Inspect the relationship at issue: ensemble_grid for combined attacks and releases; " \
                         "line for continuity; verticals and harmony_check for harmony; rhythm_profile " \
                         "for rhythm; exposed_clashes for pitch collisions. Find other views in music_inspect. " \
                         "Read flags in context; they do not establish musical failure or success."
      }.freeze

      module_function

      def guide
        File.read(File.join(__dir__, "agent_guide.md"))
      end

      def help(input)
        topic = input.fetch("topic")
        text = topic == "instruments" ? instruments : TOPICS.fetch(topic)
        result = { text: text }
        if input["operation"]
          operation = input.fetch("operation")
          contract = Operations::CONTRACTS.find { |item| item.dig("properties", "type", "const") == operation }
          result[:operation_schema] = contract
          result[:text] += "\n\nOperation #{operation}:\n#{JSON.pretty_generate(contract)}"
        end
        result
      end

      def instruments
        values = (Export::MusicXML::INSTRUMENT_SOUNDS.keys + Export::MusicXML::MIDI_PROGRAMS.keys +
                  Export::MusicXML::PERCUSSION_CLEF_INSTRUMENTS).uniq.sort
        "For each part give id, display name and instrument. Supported common instrument identifiers:\n" +
          values.join(", ") + "\nOptional: family, range (E3-C6), abbreviation, notation_group and " \
          "notation_staff (1, 2 or auto). ensemble is true for a section of unspecified size, a positive integer " \
          "for its player count, or false for one player; omit it when unknown. Staff labels stay separate from " \
          "standard exported instrument names. Percussion can map pitch identifiers to named devices " \
          "through percussion_map."
      end
    end
  end
end
