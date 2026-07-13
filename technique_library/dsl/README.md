# DSL Technique Library

This is the production-DSL technique library for reusable composition cards.
Use these files instead of citing or reading Python module paths in new DSL
briefs, procedures, and score-source comments.

## Status

The cards are standalone `production_piece` files under
`technique_library/dsl/cards/`. Each card contains auditionable notes that can
compile and export to MIDI/MusicXML, but the notation surface is chosen locally:
degree/rhythm for functional melody, interval/rhythm for motivic contour, and
split pitch/rhythm for editable lines, accompaniment, and orchestration.

- `technique_library/dsl/cards/INDEX.md` - card-to-source index.
- `technique_library/dsl/cards/manifest.json` - machine-readable card source
  manifest.

A technique-library influence enters a DSL score only after the music has been
adapted into the score's own explicit notes, roles, placements, controls, and
staff checkpoints.

## Citation Format

Use `dsl:<category>/<card_id>` in DSL-era prose. Category-only references are
allowed when a brief is routing research rather than naming a specific specimen.
The auditionable card specimen for each card ID lives in
`technique_library/dsl/cards/`.

Card examples:

- `dsl:figuration/F6_TOCCATA_ALTERNATION`
- `dsl:piano/P12_MARTELLATO_OCTAVES`
- `dsl:forms/FM1_DUET_CONVERSATION`
- `dsl:orch.brass/OB2_FANFARE`
- `dsl:orch.accompaniment/OG1_ARP_ENGINE`

When a score source comments on influence, keep the comment short and point to
the adapted material already present in the source:

```ruby
# library_ref dsl:figuration/F6_TOCCATA_ALTERNATION - chromatic fence adapted in bars 41-44.
```

The comment is never a substitute for the notes.

## Finding Cards

Use:

```bash
ruby tools/lib.rb <term>
ruby tools/lib.rb show <NAME>
ruby tools/lib.rb terms
```

The lookup names the DSL specimen path for every matching card. The `show` command
prints the specimen path and metadata; read the `.rb` source for the auditionable
specimen and the representation choice. Do not cite `technique_library/*.py`
paths in new DSL briefs or score notes.

## Category Map

Core shelves:

- `dsl:piano` - keyboard and piano texture cards: `K1_*`, `P1_*` through
  `P21_*`.
- `dsl:voicing` - piano voicing cards: `PV1_*` through `PV6_*`.
- `dsl:chamberstrings` - chamber string and ground-bass cards: `GB_*`, `CS1_*`
  through `CS6_*`.
- `dsl:chip` - NES/2A03 chiptune cards (pulse echo, arpeggio harmonic
  compression, famichord voicing, triangle dual-duty bass/drums, noise drum kit,
  two-pulse counterpoint, hurry-up transform, boss engine): `CT1_*` through
  `CT8_*`. Research source: `docs/research/chiptune_nes_composition.md`.
- `dsl:orchestral` - older broad orchestral texture cards: `O1_*` through
  `O7_*`.
- `dsl:dialogue` - gap, relay, heterophony, regrouping, and decay cards:
  `D1_*` through `D9_*`.
- `dsl:figuration` - non-arpeggio figuration cards: `F1_*` through `F10_*`.
- `dsl:figures.16th` - fast 16th-note piano figure cards: `F01` through
  `F32`.
- `dsl:elegy` - slow grief-fabric cards: `EL1_*` through `EL3_*`.
- `dsl:callresponse` - call-response form cards: `X1_*` through `X3_*`.
- `dsl:forms` - narrator, duet, frame, and listener-form cards: `FM1_*`
  through `FM5_*`.
- `dsl:fugue` - fugue construction cards (exposition/tonal answer, episode
  sequence, stretto, double-fugue combination, augmentation/pedal, gigue-fugue
  dialect): `FG1_*` through `FG6_*`. Research source:
  `reference/written/surveys/fugue_construction.md`.
- `dsl:melody` - single-line melody cards: `MEL1_*`, `MEL2_*`, `MEL3_*`,
  `MEL5_*`, and `MEL6_*`.
- `dsl:phrasing` - composer-decision phrasing cards (repetition budget, pleasant
  subversion, long-note placement, the singable-skeleton test, bent runs, elided
  phrases, one-shot economy, terraced echo): `PH1_*` through `PH8_*`. Source:
  `reference/written/craft/phrasing_variation_line.md`.
- `dsl:variation` - how returns change (widening intervals, subtraction echo, phase
  displacement, changed exits, plateau acceleration, nested rates, cell resize):
  `V1_*` through `V7_*`. Source: `reference/written/surveys/etude_pitch_devices.md`.
- `dsl:linecraft` - single-line construction devices (refrain-bar spine, fixed apex,
  melody over walking bass, register dialogue, peak-as-ladder, harmony-typed gestures,
  planted leading tone, signature dissonance, neighbor integrity): `L1_*` through
  `L9_*`. Source: `reference/written/surveys/etude_pitch_devices.md`.

Orchestration families:

- `dsl:orch.winds` - `OW1_*` through `OW8_*`.
- `dsl:orch.brass` - `OB1_*` through `OB8_*`.
- `dsl:orch.tutti` - `OT1_*` through `OT8_*`.
- `dsl:orch.accompaniment` - `OG1_*` through `OG8_*`.
- `dsl:orch.percussion_choir` - `OPC1_*` through `OPC8_*`.
- `dsl:orch.antiphony` - `OA1_*` through `OA7_*`.
- `dsl:orch.doublings` - `OD1_*` through `OD9_*`.
- `dsl:orch.color` - `OC1_*` through `OC8_*`.
- `dsl:orch.chord_voicing` - `OV1_*` through `OV7_*`.

Related catalogues:

- `technique_library/16th_note_figures.md` is the prose catalogue for
  `dsl:figures.16th/F01` through `dsl:figures.16th/F32`.
- `technique_library/handpan_idiom.md` defines idiom guidance. Promote concrete
  idiom cards here when they have auditionable DSL specimens.

## Card Source Standard

A card source must have:

- a `production_piece` source containing auditionable note material;
- a local surface suited to the card's content, not a default event dump;
- successful `production_view SOURCE.rb compile`;
- an index entry here using the `dsl:<category>/<id>` citation form.
