# DSL Proof Points

Small, focused `production_piece` sources used to prove that a library feature
round-trips through the Ruby DSL, compiled model, and Ruby MusicXML/MIDI
exporters. These are deliberately not standalone compositions.

Run from a consumer repo or from `sigillum-library` with:

```bash
partitura/bin/partitura export experiments/partitura/proof_points/<source>.rb
```

When running from another repo, set `PARTITURA_PROJECT_ROOT` if generated outputs
must land somewhere other than the current working directory.

`mixed_tuplets_ghost.rb` exercises mixed eighth/sixteenth triplets after straight
rests, a late chord after a long collapsed rest, chord beams followed by single
notes, and ghost-note attenuation. The exporter must preserve exact note type
arithmetic, complete each mixed tuplet group, and put beams only on the first
member of each chord. Ghosts use parenthesized noteheads, MIDI velocity scaled
by `10**(-12/20)`, and a local -12 dB perceptual level change. They do not print
or change the continuing dynamic. MIDI velocity is not calibrated acoustic dB.

`musicxml_consumer_check.py` checks those structural properties on any local
MusicXML file and independently imports it through the optional public Verovio
Python package. It compares every part/measure's notehead count, written
diatonic pitch order, visible explicit accidentals, and exact durations, including chord members and tie
continuations. Unpitched notes are checked for count/order/duration only.
It reports differences and exits nonzero on missing notes, lost explicit accidentals, or malformed triplet
groups. This complements sounding XML/MIDI parity; it does not certify key or
accidental interpretation, playback, or import into a different application.

Accidental engraving is resolved chronologically across voices, separately for
each staff and octave, and resets to the written key signature each measure.
Naturals cancel previous alterations; tied continuations keep their inherited
pitch without establishing a new accidental for later fresh attacks. Conflicting
simultaneous alterations receive explicit signs and force the following attack
to state its alteration. Chord articulations print once, while ties and technical
marks remain attached to each applicable pitch.

```bash
python experiments/partitura/proof_points/musicxml_consumer_check.py \
  /path/to/score.musicxml --artifacts /tmp/notation-check --render-bars 1-4
```

The optional artifacts are JSON, MEI, and locally rendered SVG pages. Keep them
outside deliverable directories. The regression was verified with Verovio
6.3.0: duplicate beams on secondary chord members caused lost following notes;
the repaired export retained every note. Mixed tuplets had no complete visual
groups before repair. That grouping defect did not itself reproduce missing
notes in Verovio, so another application's behavior requires its own check.

`global_swing.rb` exercises authored straight values under global eighth and
sixteenth swing, off transitions, dotted values, long syncopations, rests,
chords, a cross-bar tie, offbeat controls/tempo, and odd-meter terminal pairs.
It includes literal triplets only while swing is off. Export both the loaded
piece and `piece.with_swing(:off)` to compare complete timing contexts. The
production swing and MIDI tests compare every fixture note against both exports;
the optional consumer checker independently verifies notation arithmetic,
complete tuplet groups and retained visible notes in Verovio.
