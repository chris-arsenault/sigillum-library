# Hand-Edit Import: MusicXML Round-Trip Into Production-DSL Source

Audience: LLM agents only.

When the user hand-edits an exported score in a notation app (MuseScore etc.)
and the hand file becomes the source of truth for a bar range, the DSL source
must be rebuilt from it exactly - never re-derived from memory or approximated.
`partitura import-musicxml` makes that import deterministic and
`verify-musicxml-import` gives it a diff gate. The Ruby APIs remain available for
embedded callers.

## Workflow

1. **Convert** the hand-edited MusicXML into DSL event bodies:

   ```bash
   partitura/bin/partitura import-musicxml "Flows from X/score.musicxml" \
     --bars 1-84 \
     --segments bridge:41-44,ladder:45-52,gm_ground:53-68,gm_drive:69-84 \
     --perc-map D3=C3
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

   ```bash
   partitura/bin/partitura verify-musicxml-import \
     "Flows from X/score.musicxml" "outputs/.../piece.musicxml" \
     --bars 1-84 --perc-map D3=C3
   ```

   `verify` compares the two files bar by bar at **sounding pitch** with ties
   merged and reports differing bars per part. A mismatch exits `1`; the import is
   done only when the range reports `TOTAL differing bars: 0`. Add `--json` for a
   structured response. The Ruby verification result remains available through
   `Partitura.production_musicxml_import_verify`.

## What the converter handles

- **Concert pitch**: each part's `<transpose>` element is applied (Bb trumpet
  written +2, octave-transposing contrabass), so bodies are DSL-ready.
- **Ties**: event bodies retain explicit tie starts/stops and bar durations.
  Verification merges contiguous tied pitches independently, including chord
  members and ties across barlines.
- **Identity and polyphony**: complete part names remain distinct (basso is
  not bass clarinet). Multi-staff instruments produce separate staff lanes.
  Simultaneous equal-duration chord tones render as a DSL chord. Independent
  unequal-duration voices require separate phrases; rendering fails explicitly
  instead of dropping those notes. Duplicate part names also fail explicitly.
- **Cursor tracking**: `backup`/`forward` are followed, so dynamics, technique
  words, and chord symbols anchor to their true beat, not document order.
- **Inline marks**: articulations (`stacc`, `accent`, `marc`, `ten`), slurs
  (`slur(`/`slur)`; numbered overlaps retain `slur:2(`/`slur:2)`), dynamics (`{mf}`), rolled chords (`<arpeggiate>` →
  `arp`/`arp:down`), glissandi (`<glissando>` → `gliss(`/`gliss)`) and straight
  slides (`<slide>` → `slide(`/`slide)`),
  laissez vibrer (`<tied type="let-ring">` → `lv`), and technique words
  (`{txt:pizz.}`, spaces become underscores). Chord-name words are filtered
  out of `txt:` marks because they already land in the HARMONY TRACK.
- **Control evidence**: JSON metadata retains direction offsets, staff, dynamic
  and text values, wedge numbers, and explicit `<sound tempo>` samples. Use
  `tempo { playback 78.5, at: "bar 9 beat 1.25" }` for imported quarter-BPM
  samples without adding visible metronome marks. They drive MIDI and perceptual
  timing as well as MusicXML playback. Chord symbols retain slash basses,
  seventh qualities and altered degrees on import and export, including their
  offsets. They render above the top staff without creating another rest voice.
  Part-specific text remains on its target staff; only global text controls
  produce the auxiliary Notes ledger staff.
  Use `crescendo`/`diminuendo` with `exact: true` to preserve imported endpoints
  without notehead snapping or long-hairpin text substitution. Use scoped
  `key_signature "Eb", at: "bar 43 beat 1", for: :soloist` for a printed
  part signature that differs from the global `key_change` tonal context.
- **Percussion**: unpitched display pitches remap through `--perc-map`
  (repeatable), e.g. `D3=C3` maps a notation-app snare line onto this repo's
  `C3 snare / F2 bass drum / G3 cymbal` roster convention.
- **Durations**: quarter = 1.0, dotted/sixteenth values as decimals, triplets
  as fractions (`2/3`).

## What to review by hand after converting

- A dynamic or word anchored after a bar's last note attaches to the nearest
  following event, occasionally a rest - move it to the intended note.
- Grace notes remain unsupported and produce a warning; restore them explicitly
  before claiming notation parity. Review ornaments and spelling, not just pitches.
- The zero-difference gate compares sounding pitch, onset and tied duration in
  each staff. It does not certify directions, dynamics, ornamentation or layout;
  compare those separately against the source. JSON metadata is authoritative
  for control offsets; inline convenience marks can attach to nearby events.
- `--beats` defaults to 2 (2/4). Set it for other meters so whole-bar rest
  fill is correct.
- Keep tied phrases connected across segment boundaries in the destination DSL.

## Scope Boundary

The importer is a repair tool for a consumer score whose hand-edited MusicXML has become
authoritative for a known range. It is not a general MusicXML-to-Partitura authoring
pipeline. Structure, identity, roles, prose, controls, and final source ownership remain
explicit consumer-repository decisions.
