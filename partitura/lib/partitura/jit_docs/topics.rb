# frozen_string_literal: true

require_relative "../marks"

module Partitura
  module JITDocs
    SURFACE_TOPICS = {
      index: {
        use_when: "Start here before authoring or when unsure which focused topic to request.",
        rules: [
          "Load only the relevant topic docs, not the whole documentation set.",
          "Use the production surface for new DSL source; surface_lab is exploratory only.",
          "Standardize the container; choose the local surface by musical job.",
          "Use `decision` before choosing a pitch/rhythm surface."
        ],
        example: "partitura_help production",
        next_topics: %i[production decision container hybrid projections transport_export],
        docs: ["docs/architecture/partitura/INDEX.md"]
      },
      production: {
        use_when: "Write or inspect executable LLM-native Partitura source.",
        rules: [
          "Use `production_piece` in source files loaded by `load_production_file`.",
          "Use one container: production_piece, roster, section, span, phrase, placement, staff_bar.",
          "Declare the span's harmony as a per-bar chord track: chords \"b1:F b2:Bb\"; verify with harmony_check.",
          "Every roster part declares display name plus exact `music21:` instrument class.",
          "Declare opening meter once; use `meter { change ... }` for bar-boundary meter changes.",
          "Use `pitch:` or `surface:` to declare each phrase surface.",
          "Use inline event marks for point markings and `control`/`tempo` for spans or shared markings.",
          "Use `production_view` projections after authoring each passage.",
          "Check `production_view SOURCE.rb lint`: warn lints prompt a judgment; error lints block compile.",
          "Lint thresholds are configurable: `lint do rule :phrase_length, warn: 8, error: 24 end`.",
          "Use `production_export` for transport JSON, MusicXML, and MIDI."
        ],
        example: <<~RUBY.strip,
            production_piece "Study" do
              meter "7/8", beat_pattern: [3, 2, 2]
              key "F"

              meter do
                change "4/4", at: "bar 9"
              end

              tempo do
                mark "quarter = 72", at: "bar 1 beat 1"
                change "quarter = 88", at: "bar 9 beat 1"
              end

              roster { part :clarinet, "Clarinet", music21: "Clarinet" }

              section :s1, "Opening", bars: 1..2, type: :hybrid_phrase_staff do
                span bars: 1..2, texture: :melody_over_bass do
                  phrase :call, pitch: :degrees do
                    key_context "F4"
                    degrees "5 4 3 #1 1"
                    rhythm  "1.5 .25 .25 .5 1"
                  end

                  placement :call, part: :clarinet, at: "bar 1 beat 1" do
                    role :foreground
                    realization "C5 Bb4 A4 F#4 F4"
                  end
                end
              end
            end
          RUBY
        next_topics: %i[decision degrees controls hybrid projections transport_export compile_api],
        docs: ["docs/architecture/partitura/01_container.md"]
      },
      decision: {
        use_when: "Choose the right local notation surface for a passage.",
        rules: [
          "Default long-line surface is degrees plus rhythm.",
          "Use intervals for motivic identity.",
          "Use staff_grid for dense vertical or timing-critical bars.",
          "Use hybrid for most orchestral passages.",
          "Use absolute when register is the musical object.",
          "Use controls for marks that span time or target multiple parts.",
          "Never mix untyped representations inside one phrase."
        ],
        example: "partitura_help hybrid",
        next_topics: %i[degrees intervals split_pitch_rhythm absolute staff_grid controls phrase_placement hybrid],
        docs: ["docs/architecture/partitura/02_surface_decision.md"]
      },
      container: {
        use_when: "Create or inspect the standard piece/section/span/phrase container.",
        rules: [
          "Keep the outer architecture stable: production_piece, section, span, phrase, placement, staff_bar.",
          "Do not invent a new top-level shape for a local passage.",
          "Roster parts use `part :id, \"Display Name\", music21: \"Music21Class\"`.",
          "Opening meter belongs at piece level; later meter changes must land on bar boundaries.",
          "Put representation-specific syntax inside typed phrase or staff blocks."
        ],
        example: <<~RUBY.strip,
            production_piece "Title" do
              meter "4/4"
              meter do
                change "3/4", at: "bar 5"
              end

              roster do
                part :oboe, "Oboe", music21: "Oboe", family: :woodwind
              end

              section :s1, "Opening", bars: 1..8 do
                span bars: 1..8, texture: :melody_over_bass do
                  # phrases, placements, staff checkpoints
                end
              end
            end
          RUBY
        next_topics: %i[decision hybrid projections],
        docs: ["docs/architecture/partitura/01_container.md"]
      },
      degrees: {
        use_when: "Write tonal melody where scale function and cadence tendency matter.",
        rules: [
          "key_context is tonic+octave+mode: \"F4\" (major), \"c4\" (lowercase = minor), \"D4 dorian\".",
          "Modes: major minor harmonic_minor melodic_minor dorian phrygian lydian mixolydian aeolian ionian " \
          "locrian.",
          "Degrees are diatonic to the declared scale: in \"c4\" a plain 3 is Eb; write #7 for the leading tone.",
          "A phrase without key_context inherits span `key`, then section `key`, then the piece `key`; " \
          "a key with no octave (\"c\", \"F\") pins the tonic to octave 4.",
          "After a key_change control, inheritance must be explicit: declare span/section `key` or key_context.",
          "Keep degrees and rhythm separate.",
          "Use explicit accidentals like #1 or b6 for inflections outside the scale.",
          "Octave markers: `1'` is an octave up, `1,` is an octave down (stack for two octaves: `1''`).",
          "Use bracketed degree chords like [1,3,5] when harmony should remain key-relative.",
          "Do not mix absolute pitches in the same degrees phrase."
        ],
        example: <<~RUBY.strip,
            phrase :call, pitch: :degrees do
              key_context "F4"
              degrees "5 4 [1,3,5]{ten} #1 1"
              rhythm  "1.5 .25 .25 .5 1"
            end

            phrase :lament, pitch: :degrees do
              key_context "c4"
              degrees "1 3 5 #7 1'"
              rhythm  "1 1 1 .5 .5"
            end
          RUBY
        next_topics: %i[marks hybrid staff_grid controls projections],
        docs: ["docs/architecture/partitura/surfaces/degrees.md"]
      },
      intervals: {
        use_when: "Write motivic cells where contour and transformation identity matter.",
        rules: [
          "Declare an anchor.",
          "First interval is usually 0.",
          "Use bracketed interval stacks like [0,+3,+7] for local simultaneity.",
          "Use checkpoints for long interval phrases.",
          "Convert/read out before scoring vertical harmony."
        ],
        example: <<~RUBY.strip,
            phrase :cell, pitch: :intervals do
              anchor "C5"
              intervals "0 -2 -1 -3 -1"
              rhythm    "1.5 .25 .25 .5 1"
            end
          RUBY
        next_topics: %i[marks degrees controls phrase_placement hybrid],
        docs: ["docs/architecture/partitura/surfaces/intervals.md"]
      },
      split_pitch_rhythm: {
        use_when: "Write long lines where pitch contour and rhythm need independent editing.",
        rules: [
          "Pitch and rhythm streams must align event-by-event.",
          "Bar markers are verified: every | must land on a barline, and one segment holds one bar of attacks.",
          "Sustained events and rests may cross barlines without a marker; attacks may not.",
          "Put point marks on pitch tokens, e.g. C5{stacc} or [A3,C4,E4]{accent}.",
          "Use this for line revision, not dense vertical moments."
        ],
        example: <<~RUBY.strip,
            phrase :line, surface: :split_pitch_rhythm do
              pitches "[A3,C4,E4]{accent} r F#4{stacc}"
              rhythm  "1 .5 .5"
            end
          RUBY
        next_topics: %i[marks degrees staff_grid controls hybrid],
        docs: ["docs/architecture/partitura/surfaces/split_pitch_rhythm.md"]
      },
      absolute: {
        use_when: "Write a line where register and exact pitch spelling are part of orchestration.",
        rules: [
          "Use explicit pitch names and octaves.",
          "Keep rhythm in a paired `rhythm_bars` stream.",
          "Use fused `events` when pitch, rhythm, and point marks should remain bound.",
          "Pitch and rhythm streams must align by bar and event count.",
          "Bar markers are verified: every | must land on a barline; one segment holds one bar of attacks.",
          "Use this for bass paths, registral anchors, and fixed orchestration."
        ],
        example: <<~RUBY.strip,
            phrase :piano_call, surface: :absolute do
              events "[A3,C4,E4]:1{mf,accent} r:.5 F#4:.5{stacc}"
            end
          RUBY
        next_topics: %i[marks split_pitch_rhythm controls hybrid projections],
        docs: ["docs/architecture/partitura/surfaces/absolute.md"]
      },
      marks: {
        use_when: "Attach a dynamic, articulation, technique, spanner, or text to a single event with `{...}`.",
        rules: [
          "The vocabulary is closed; an unknown mark is a compile error.",
          *Marks.vocabulary_lines,
          "Durations and marks: decimal (`.5`) and fractional (`1/2`, `3/2`, `1/3`) duration tokens are both valid.",
          "Spanner pairs open/close across events and may cross barlines: `C5{slur(,cresc(}` ... `F5{slur),cresc)}`.",
          "Reserve `txt:` for words that really are text (`txt:con_sord.`, vocal syllables); never spell a " \
          "technique above as `txt:`.",
          "Use `control`/`tempo` for marks that span time or target more than one part."
        ],
        example: <<~RUBY.strip,
            phrase :line, surface: :split_pitch_rhythm do
              pitches "C5{mf,stacc} [A3,C4,E4]{arp} r E5{slur(,cresc(} F5 G5{slur),cresc)}"
              rhythm  ".5 .5 .5 1/2 1/2 1"
            end
          RUBY
        next_topics: %i[controls degrees split_pitch_rhythm absolute projections],
        docs: ["docs/architecture/partitura/surfaces/absolute.md", "docs/architecture/partitura/surfaces/controls.md"]
      },
      controls: {
        use_when: "Write anchors, scoped dynamics, hairpins, pedals, text controls, or tempo changes.",
        rules: [
          "Use inline event marks only for marks tied to one event.",
          "Use `control` for marks that span time or target one part, a family, a role, a list, or all parts.",
          "Use `tempo` for score tempo and tempo changes; do not repeat tempo markings in part material.",
          "Use `meter` for bar-boundary meter changes.",
          "Locations are explicit bar/beat strings or named anchors.",
          "Inspect with `production_view SOURCE.rb controls` before export."
        ],
        example: <<~RUBY.strip,
            anchor :answer_entry, at: "bar 3 beat 1.5"

            meter do
              change "3/4", at: "bar 9"
            end

            tempo do
              mark "quarter = 72", at: "bar 1 beat 1"
              change "quarter = 96", at: "bar 9 beat 1"
              ritardando from: "bar 15 beat 1", to: "bar 16 beat 3.5"
              a_tempo at: "bar 17 beat 1"
            end

            control do
              dynamic :mf, at: "bar 9 beat 1", for: :piano_upper
              crescendo from: "bar 9 beat 1", to: "bar 12 beat 3.5", for: :string
              diminuendo from: :answer_entry, to: "bar 4 beat 3", for: [:clarinet, :solo_violin]
              pedal :down, at: "bar 9 beat 1", for: :keyboard
            end
          RUBY
        next_topics: %i[marks absolute split_pitch_rhythm phrase_placement projections transport_export],
        docs: ["docs/architecture/partitura/surfaces/controls.md"]
      },
      staff_grid: {
        use_when: "Write or inspect simultaneity, handoffs, cadence bars, exits, or rhythmic engines.",
        rules: [
          "Every lane is \"<roster_part_id>: tokens\"; tokens divide the bar into equal slots.",
          "Tokens: pitch = attack, A4/B4 = two attacks in one slot, `_` sustains, `.` silence, `X` unpitched attack.",
          "Checkpoints are verified against the sounding timeline at compile; divergence is a compile error.",
          "Use role lanes, not only instrument lanes.",
          "Prefer this for checkpoints rather than every long phrase."
        ],
        example: <<~RUBY.strip,
            staff_bar 9 do
              foreground "clarinet: C5 _ D5 E5"
              answer     "violin: . A4 _ G4"
              bass       "cello: F2 _ C3 F2"
              pulse      "drum: X . X X . X ."
            end
          RUBY
        next_topics: %i[hybrid phrase_placement controls projections],
        docs: ["docs/architecture/partitura/surfaces/staff_grid.md"]
      },
      phrase_placement: {
        use_when: "Place named material into instruments, bars, beats, or transformed entrances.",
        rules: [
          "Every placement states part, location, and role.",
          "Repeated placements need distinct musical jobs.",
          "Transformed placements must be inspectable or materialized.",
          "Do not use placement as hidden stamping."
        ],
        example: <<~RUBY.strip,
            placement :call_8, part: :clarinet, at: "bar 1 beat 1" do
              role :foreground
              realization "materialized/readable result is available"
            end
          RUBY
        next_topics: %i[hybrid staff_grid controls projections],
        docs: ["docs/architecture/partitura/surfaces/phrase_placement.md"]
      },
      hybrid: {
        use_when: "Default for most orchestral passages.",
        rules: [
          "Phrase layer carries long thought.",
          "Placement layer carries timing and orchestration.",
          "Staff checkpoints carry vertical/handoff/cadence clarity.",
          "Use one typed pitch surface per phrase.",
          "Use control/tempo timelines for spanning marks.",
          "Ask for projections after each span."
        ],
        example: <<~RUBY.strip,
            phrase :foreground, pitch: :degrees do
              key_context "F4"
              degrees "5 4 3 #1 1"
              rhythm  "1.5 .25 .25 .5 1"
            end

            placement :foreground, part: :clarinet, at: "bar 1 beat 1" do
              role :foreground
            end

            staff_bar 1 do
              foreground "clarinet: C5 _ _ Bb4/A4 F#4 F4 _"
              bass "cello: F2 _ _ C3 _ F2 _"
            end
          RUBY
        next_topics: %i[degrees staff_grid controls phrase_placement projections],
        docs: ["docs/architecture/partitura/surfaces/hybrid.md"]
      },
      projections: {
        use_when: "Choose the readout needed after authoring a passage.",
        rules: [
          "Use projections as reading views, not musical validations.",
          "Use foreground for long-line continuity.",
          "Use verticals or staff bars for simultaneity.",
          "Use ensemble_grid for attack/sustain alignment across parts.",
          "Use exposed_clashes and composite_stalls for sounding audit worklists.",
          "Use harmony_check to diff the declared per-bar chord track against sounding implied harmony.",
          "Use range_check to read each part's sounding span against its roster range.",
          "Use harmony_with_melody to read foreground notes per bar against the declared chord and active bass.",
          "Use melody_analysis or melody_report for per-note tonal, harmonic, figuration, and motif readouts.",
          "Use controls to inspect anchors, tempo events, and scoped markings.",
          "Use material/placement maps to avoid hidden stamping."
        ],
        example: <<~BASH.strip,
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb foreground
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb harmony_with_melody --bars 1-4
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb verticals --bars 1-4
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb ensemble_grid --bars 1-4
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb exposed_clashes --bars 1-4
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb composite_stalls --bars 1-4
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb melody_analysis --part clarinet
            partitura/bin/production_view experiments/partitura/production_hybrid_study.rb line --part clarinet
          BASH
        next_topics: %i[hybrid staff_grid controls phrase_placement transport_export],
        docs: ["docs/architecture/partitura/04_examples_manifest.md"]
      }
    }.freeze
  end
end
