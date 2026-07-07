# Partitura Design

Status: production Ruby authoring surface, transport JSON, and Ruby MusicXML/MIDI export implemented

This document tracks the design for Partitura, the LLM-facing score framework. The goal is not to make
a prettier notation exporter. The goal is to give an LLM a source format where melody, harmony,
texture, orchestration, and dramatic intent are visible at the same time.

Use the modular documentation index for active work:

- `docs/architecture/partitura/INDEX.md`

Implemented production entry points:

```bash
partitura/bin/partitura_help production
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb compile
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb harmony_with_melody --bars 1-4
partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb verticals --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb line --part clarinet
```

The current Python note-list source is good at rendering through music21, but it hides too much
musical structure. A part-level list of `(pitch, duration, marks)` is easy to export and hard to
compose against. Cross-voice harmony, full-line melody, foreground handoffs, and texture roles must
be reconstructed after the fact. That reconstruction is exactly where the agent loses the music and
starts writing generic blocks.

## Design Principles

1. Optimize for composition, not validation.

   The source should help the composer see and revise the music. It should not make musical quality
   look like a checklist. Mechanical compiler checks are allowed underneath, but they are private
   guardrails: valid pitch names, sane durations, known instruments, exportability. They are not the
   point of the DSL.

2. Musical relationships are first-class.

   The canonical source must preserve the relationship between lines, not just the finished notes.
   It should expose foreground, counterline, bass path, pulse, pad, color, tacet, harmonic region,
   entrance timing, register plan, and phrase shape in the same local span.

3. Projections are reading views, not pass/fail gates.

   Views such as vertical sonority, full foreground line, bass path, role map, and material usage are
   for composition. They are how the agent reads the score while writing. They must not become
   scorecards that replace musical judgment.

4. No stamp-style writing.

   The committed score source should not hide sounding material behind loops, repeaters, or
   generators. A transformed quotation can be declared, but the resulting notes should remain
   materialized in the source so the line can be read directly.

5. Transformations are provenance, not a note factory.

   It is useful to say a line is `fragment A transposed to B-flat` or `A in augmentation`, but the
   exact emitted notes still need to be present. The relationship explains the music; it does not
   obscure it.

6. Evocative prose must attach to audible mechanism.

   Dramatic language is allowed only when it is coupled to rhythm, register, contour, harmony,
   orchestration, density, entrance timing, silence, or a concrete relation between lines. No
   free-floating explanation should be able to stand apart from the notation.

## Non-Goals

- Do not build a general-purpose composition language.
- Do not build a validation-driven musical quality system.
- Do not optimize for compactness.
- Do not allow hidden generated score material in committed orchestral source.

## Implemented Architecture

Use Ruby as the authoring surface unless a concrete blocker appears. Ruby's block syntax is a good
fit for nested musical spans, local roles, and readable declarations.

Ruby is the rendering backend. The Ruby production model exports a versioned JSON
transport consumed by the Ruby MusicXML and MIDI exporters.

The implemented shape is:

```text
Ruby DSL source
  -> projections for composition
  -> Ruby production object model
  -> versioned transport JSON
  -> Ruby MusicXML/MIDI renderers
  -> MusicXML / MIDI
```

The transport is explicit, boring, serializable, and backend-facing. It carries roster, sections,
spans, phrases, placements, timed events, staff checkpoints, gestures, and total duration.

## Locked Recommendation

Standardize the container, not one note representation.

Default architecture:

```text
piece -> section -> span -> phrase -> placement -> staff checkpoints -> projections
```

Production source uses `production_piece` as the top-level call.

Default local surface:

- long tonal melody: key-relative degrees plus separate rhythm,
- motivic cells: anchor plus relative intervals,
- long editable lines: split pitch and rhythm streams,
- dense simultaneity: staff-grid lanes,
- transformed/reused material: phrase placement with inspectable realization,
- most orchestral passages: hybrid phrase layer plus staff checkpoints.

The DSL must make representation choice explicit and local. Multiple surfaces are allowed because
different musical jobs need different notation, but untyped mixing is forbidden.

## Core Source Model

The canonical source needs these concepts.

- `production_piece`: title, meter plan, key regions, roster.
- `section`: named form span, bars, musical type, journey, destination.
- `span`: local composing unit, usually one phrase or texture state.
- `phrase`: typed pitch/rhythm material: degrees, intervals, split pitch/rhythm, or absolute.
- `placement`: one phrase entering in a part at a bar/beat with role and realization.
- `staff_bar`: a bar/beat checkpoint where vertical or dramatic alignment matters.
- `harmony`: intended harmonic field or progression for a span.
- `texture`: the active engine: counterline, walking bass, ostinato, chorale, arpeggiation,
  repeated pulse, tremolo, drone, sustained field, rest, tacet.
- `gesture`: a dramatic or formal claim coupled to the musical mechanism that makes it audible.
- `projection`: a generated reading view over the same source.

## Default Sketch

This is the recommended direction, not the old note-list-like baseline.

```ruby
production_piece "Movement IV draft" do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"

  section :s1, "Plain telling", bars: 9..16, type: :plain_statement do
    span bars: 9..12, texture: :melody_over_pizzicato_bass do
      harmony "F home, Hijaz color as inflection"

      phrase :plain_call, pitch: :degrees do
        key_context "F4"
        degrees "5 4 3 #1 1 | 2 3 4 5 r"
        rhythm  "1.5 .25 .25 .5 1 | 1 .5 .5 1 .5"
      end

      phrase :bass_path, surface: :absolute do
        pitch_bars "F2 C3 F2 | Eb3 Bb2 C3 F2"
        rhythm_bars "1.5 1 1 | 1 .5 .5 1.5"
      end

      placement :plain_call, part: :clarinet, at: "bar 9 beat 1" do
        role :foreground
        realization "C5 Bb4 A4 F#4 F4..."
      end

      placement :bass_path, part: :cello, at: "bar 9 beat 1" do
        role :bass_line
        realization "absolute bass register anchors the phrase"
      end

      staff_bar 9 do
        foreground "clarinet: C5 _ _ Bb4/A4 F#4 _ F4"
        bass "cello: F2 _ _ C3 _ F2 _"
        pulse "hand_drum: X . X X . X ."
      end

      gesture :audible_not_captioned do
        idea "answer fails to meet the opening call cleanly"
        mechanism "answer enters late against active bass"
        line_relation :clarinet, :cello, "foreground timing is heard against bass motion"
      end
    end
  end
end
```

The important property is typed locality: the reader sees phrase function, placement, and vertical
checkpoint without collapsing every musical job into one notation.

## Projections

Production projections are text-first and composer-facing.

- `foreground`: continuous melody, including instrument handoffs.
- `line(part)`: one complete part with phrase labels and role changes.
- `verticals(bars:)`: beat-by-beat sonority, bass, foreground, active color, dissonance notes.
- `ensemble_grid(bars:)`: 16th-resolution attack/sustain/silence grid for all parts.
- `exposed_clashes(bars:)`: dissonant attack-point findings with preparation/resolution context.
- `composite_stalls(bars:)`: ensemble-wide attack gaps of at least 1.25 quarter lengths.
- `roles(bars:)`: who is foreground, bass, pulse, counterline, pad, color, tacet.
- `bass_path`: the complete bass line and its relation to harmony.
- `harmony`: span harmony text, scoped by bars.
- `harmony_with_melody`: foreground notes read against current span harmony and active bass.
- `material_map`: where named fragments appear, including transformed quotations.
- `gesture_map`: dramatic claims with the attached musical mechanism.

These views do not decide whether the music is good. They make the music easier to inspect.

Current Ruby implementation:

```bash
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb roles
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb foreground
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb harmony_with_melody --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb verticals --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb ensemble_grid --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb exposed_clashes --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb composite_stalls --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb gesture_map
partitura/bin/partitura_help production
partitura/bin/partitura_help hybrid --json
```

## Transport And Export

Inspect the versioned transport JSON without writing files:

```bash
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb transport
```

Write transport JSON, MusicXML, and MIDI:

```bash
partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
```

Write only transport JSON:

```bash
partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study --transport-only
```

The Ruby exporters consume already-authored timed events and fill only silent gaps between them.
It does not generate musical material.

## Surface Exploration

The first Ruby prototype is intentionally treated as a biased baseline because it still resembles
the existing Python note-list source. The separate surface lab keeps alternate representations
concrete and executable, but it is exploratory. New source should use the production surface above.

Run a comparison readout with:

```bash
partitura/bin/surface_view experiments/partitura/surface_lab/degree_key_32.rb structure
partitura/bin/surface_view experiments/partitura/surface_lab/relative_interval_32.rb structure
partitura/bin/surface_view experiments/partitura/surface_lab/split_pitch_rhythm_32.rb structure
partitura/bin/surface_view experiments/partitura/surface_lab/staff_grid_32.rb bars
partitura/bin/surface_view experiments/partitura/surface_lab/phrase_placement_32.rb placements
partitura/bin/surface_view experiments/partitura/surface_lab/hybrid_phrase_staff_32.rb structure
```

Current 32-bar surface examples:

- `degree_key_32.rb`: key-relative degrees, with rhythm separated from pitch function.
- `relative_interval_32.rb`: interval motion from an anchor, exposing motivic contour.
- `split_pitch_rhythm_32.rb`: absolute pitch bars and rhythm bars as separate surfaces.
- `staff_grid_32.rb`: bar-local grid view with foreground, bass, and pulse lanes together.
- `phrase_placement_32.rb`: phrase definitions placed at bar/beat locations, with placement records
  explicit.
- `hybrid_phrase_staff_32.rb`: phrase-level material plus staff-grid checkpoints for vertical
  inspection.

The surface lab deliberately avoids the old fused `pitch:duration` note token style in these
examples. It is not a renderer. Its job is to make competing authoring surfaces large enough to
judge before the project commits to one.

## Prose Discipline

The DSL should make this pattern natural:

```ruby
gesture :missed_arrival do
  mechanism "clarinet reaches the cadence beat early; violin answers late and lands elsewhere"
  line_relation :clarinet, :violin, "approach each other, then separate by contrary motion"
end
```

The DSL should make this pattern feel incomplete:

```ruby
comment "the lovers never meet"
```

A dramatic claim must sit next to the notes or relationships that make it audible. If the claim
cannot point to contour, rhythm, timing, harmony, register, density, orchestration, or silence, it is
not yet a composed event.

## Anti-Stamp Policy

Committed Partitura files should not include note-generating loops or repeaters for sounding
material.

Allowed:

- Exact notes written out.
- Named material definitions.
- Materialized transformed quotations with provenance.
- Tooling that can warn about suspicious repetition.
- Backend rendering code that converts already-authored notes into MusicXML.

Not allowed in score source:

- `8.times` blocks that emit notes.
- Repeat helpers that stamp a bar across a section.
- Hidden pattern expanders that make accompaniment without visible notes.
- Prose labels standing in for unwritten musical mechanism.

## Private Compiler Checks

The compiler can still protect against mechanical mistakes:

- Unknown part names.
- Bad pitch spelling.
- Missing phrase references.
- Missing placement roles.
- Mismatched paired pitch/rhythm stream lengths.
- Misaligned bar separators in paired streams.

These checks should stay boring and mechanical. They should not be marketed as musical validation,
and they should not shape the composition workflow.

## Progress Workflow

Use this checklist to track implementation. Keep it updated as work proceeds.

- [x] Implement the production Ruby authoring surface for `production_piece`, `roster`, `section`,
  `span`, `phrase`, `placement`, `staff_bar`, and `gesture`.
- [x] Implement phrase event parsing for degrees, intervals, split pitch/rhythm, and absolute
  pitch/rhythm streams.
- [x] Implement production readouts for `structure`, `roles`, `phrases`, `placements`,
  `timed_events`, `verticals`, `staff_bars`, `foreground`, `line`, `bass_path`, `harmony`,
  `harmony_with_melody`, `material_map`, `gesture_map`, `transport`, and `compile`.
- [x] Implement versioned transport JSON from the Ruby production model.
- [x] Implement Ruby export from transport JSON to MusicXML and MIDI.
- [x] Author a production surface proof: `experiments/partitura/production_hybrid_study.rb`.
- [x] Add production tests for documented syntax, degree spelling, surface coverage, placements,
  verticals, line views, staff checkpoints, harmony/melody readouts, transport JSON,
  material/gesture readouts, and structured repair data.
- [x] Add Python tests for transport rendering, rest filling, harmony text annotation, and
  MusicXML/MIDI writing.
- [x] Keep the original note-list-like Ruby prototype as baseline context only.
- [x] Implement the original prototype authoring surface for `piece`, `roster`, `material`,
  `section`, `span`, `line`, `gesture`, and `moment`.
- [x] Implement literal note parsing for the original prototype.
- [x] Implement original prototype projections.
- [x] Author a substantial surface proof: `experiments/partitura/storyteller_surface_study.rb`.
- [x] Add Ruby tests for the original prototype parser, loading, material provenance, phrase labels,
  gesture readouts, verticals, and line views.
- [x] Add separate surface-lab support so alternatives are not forced through the biased baseline
  model.
- [x] Build six 32-bar alternative surface examples: key-relative degree, relative interval,
  split pitch/rhythm, staff grid, phrase placement, and hybrid phrase+staff.
- [x] Add tests that all six surface examples load as 32-bar studies and avoid the old fused
  `pitch:duration` source idiom.
- [ ] Use the production surface to author another excerpt from a fresh prompt, not a retrospective
  study.
- [ ] Improve the authoring syntax based on the friction from that fresh excerpt.
- [ ] Compare the six surface examples explicitly on melody readability, vertical readability,
  rhythmic editability, transformation clarity, and risk of hidden stamping.
- [ ] Add private `stamp_warnings` readout for suspicious repeated literal material.

## Definition of a Useful Prototype

The first surface prototype is useful when it can express more than a tiny export demo:

- 5-8 active parts.
- A foreground line and at least one handoff or counterline.
- A bass path visible as a line.
- A harmonic region visible beside the notes.
- A dramatic gesture tied to audible musical mechanism.
- A vertical projection that can be read without reconstructing offsets by hand.
- Material provenance where transformed quotations are still materialized as exact notes.

It does not need a complete movement. It does not need polished Ruby syntax. It must make the music
easier to compose than the current flat note-list files.
