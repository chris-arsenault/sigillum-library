# Hand-Edit Import: MusicXML Round-Trip Into Production-DSL Source

Audience: LLM agents only.

When the user hand-edits an exported score in a notation app (MuseScore etc.)
and the hand file becomes the source of truth for a bar range, the DSL source
must be rebuilt from it exactly - never re-derived from memory or approximated.
`Partitura.production_musicxml_import` makes that import deterministic and
`production_musicxml_import_verify` gives it a diff gate.

## Workflow

1. **Convert** the hand-edited MusicXML into DSL event bodies:

   ```ruby
   conversion = Partitura.production_musicxml_import(
     "Flows from X/score.musicxml",
     bars: 1..84,
     segments: "bridge:41-44,ladder:45-52,gm_ground:53-68,gm_drive:69-84",
     perc_map: { "D3" => "C3" }
   )
   puts conversion.render
   ```

   Output per part per segment is a paste-ready `events %q{ ... }` body, one
   line per source bar, plus a `HARMONY TRACK` block (the hand file's chord
   symbols as paste-ready `text ... for: :all` control lines) and a key/tempo/
   wedge metadata listing for reconciling the control layer.

2. **Author the wrappers by hand.** The converter emits notes only. Sections,
   phrase names, placements, roles, realizations, `staff_bar` checkpoints,
   journey/process prose, and the main-file control layer (hairpins from the
   WEDGE listing, tempo map, key changes) are composition-judgment work and
   stay hand-written.

3. **Export and verify.** After the section files compile and export:

   ```ruby
   verification = Partitura.production_musicxml_import_verify(
     "Flows from X/score.musicxml",
     "outputs/.../piece.musicxml",
     bars: 1..84,
     perc_map: { "D3" => "C3" }
   )
   puts verification.render
   raise "MusicXML import mismatch" unless verification.ok?
   ```

   `verify` compares the two files bar by bar at **sounding pitch** with ties
   merged and reports differing bars per part. The import is done only when the
   imported range reports `TOTAL differing bars: 0`. The Ruby verification
   result is structured (`ok?`, `total_differing_bars`, `to_h`) so the caller
   gates the pass without a sidecar Python command.

## What the converter handles

- **Concert pitch**: each part's `<transpose>` element is applied (Bb trumpet
  written +2, octave-transposing contrabass), so bodies are DSL-ready.
- **Ties**: tied same-pitch chains merge into one event, including across
  barlines (a line may then sum past its bar; the stream stays correct).
- **Cursor tracking**: `backup`/`forward` are followed, so dynamics, technique
  words, and chord symbols anchor to their true beat, not document order.
- **Inline marks**: articulations (`stacc`, `accent`, `marc`, `ten`), slurs
  (`slur(`/`slur)`), dynamics (`{mf}`), rolled chords (`<arpeggiate>` →
  `arp`/`arp:down`), glissandi (`<glissando>`/`<slide>` → `gliss(`/`gliss)`),
  laissez vibrer (`<tied type="let-ring">` → `lv`), and technique words
  (`{txt:pizz.}`, spaces become underscores). Chord-name words are filtered
  out of `txt:` marks because they already land in the HARMONY TRACK.
- **Percussion**: unpitched display pitches remap through `--perc-map`
  (repeatable), e.g. `D3=C3` maps a notation-app snare line onto this repo's
  `C3 snare / F2 bass drum / G3 cymbal` roster convention.
- **Durations**: quarter = 1.0, dotted/sixteenth values as decimals, triplets
  as fractions (`2/3`).

## What to review by hand after converting

- A dynamic or word anchored after a bar's last note attaches to the nearest
  following event, occasionally a rest - move it to the intended note.
- Chords and grace notes are skipped with a `warning` line in the metadata;
  the production surface is monophonic per phrase, so decide their fate
  deliberately.
- `--beats` defaults to 2 (2/4). Set it for other meters so whole-bar rest
  fill is correct.
- Segment boundaries must not cut through a tie chain; pick boundaries at
  phrase seams (the converter merges ties within a segment only).

## First use

The Banner Recursion exploration, bars 1-84: hand-edited
`Flows from The Banner Recursion/*.musicxml` imported into
`explorations/banner_recursion_dsl/dsl/sections/{s1_field_gate,s2_a_first_strain,s3_em_fm_gm_escalation}.rb`,
verified to zero differing bars. See the "Hand-Edit Import" entry in
`explorations/banner_recursion_dsl/05_full_score_v2_procedure_log.md`.
