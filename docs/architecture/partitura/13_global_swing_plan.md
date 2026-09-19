# Global swing timing and consumer composition

## Outcome and ownership

Provide global eighth-note, sixteenth-note and off controls on the existing
control timeline. Authors write straight durations; every sounding projection,
MusicXML and MIDI uses the same exact realized timeline. Source declarations
remain editable in authored time. Local implementation and consumer composition
are authorized; publication and repository operations are outside this work.

The consuming composition is maintained outside this library. Its feedback asks
for an orchestral story using funk motifs, with consequences across sections,
instead of an extended groove. The consumer procedure owns the musical detail.

## Reuse and decisions

`production/models/event_resolution.rb` resolves placements and pickup overwrites;
that resolved event stream is the single swing boundary. Existing sounding views
and both exporters already consume it. `offset_for_reference` remains authored;
an explicit realized-reference API supplies control, tempo and checkpoint timing.
No exporter-only timing patch and no generated source note transformation.

`control { swing :eighth, at: "bar 5 beat 1" }` and `:sixteenth` / `:off` are
global. Eighth pairs span one quarter; sixteenth pairs span half a quarter.
Each midpoint maps to two thirds of the pair, with rational piecewise-linear
interpolation. Map event starts and ends independently, including rests, chords,
ties and pickups. Pairing restarts at barlines; incomplete terminal pairs stay
straight. Changes require barlines or boundaries shared by both adjoining modes.
Conflicting simultaneous declarations fail with a typed diagnostic.

Active complete pairs require binary authored endpoints. Explicit tuplets there
fail with a repair instruction instead of being silently swung twice. Literal
tuplets remain supported with swing off. Imports retain literal timing and never
infer another swing transform. A straight comparison overrides the same context
for events and controls. Expanded MusicXML must not invite a second playback swing.

## Milestones and Sulion mapping

Root: `6f610645-67ef-46c9-b13d-7fa9e4ee526e` in the consumer repository.

### M0 — Shared swing timeline (phase 1)

Scope: DSL, validation, exact shared realization, controls and tempo, source/runtime
presentation, straight override, notation, documentation and regression tests.
Acceptance: all parts and downstream sounding views share one clock; notation
has valid complete tuplets, and unswung input/output behavior is preserved.
Evidence: focused real-consumer tests, exported proof point and independent
notation importer; dotted and cross-pair notes must be exercised explicitly.

#### Execution steps

1. Implement the shared timeline and wire all consumers. Files: control builder,
   production models/event resolution/export adapter, perceptual timing/dynamics,
   checkpoint and graph/readout consumers as established by reference searches.
   Verify rational endpoints, transitions, odd meters, invalid source timing,
   ties, pickups and context-wide straight override. State: complete.
2. Complete notation and public authoring contract [depends on #1]. Files:
   MusicXML duration splitting/grouping, control rendering, CLI help and surfaces
   documentation. Verify dotted durations, long syncopations, rests and chords
   through actual MusicXML and MIDI plus an independent notation consumer.
   State: complete. Regression:271tests,2224assertions, no failures/errors/skips.
   The proof point imports through Verovio with62/62swung and54/54straight
   noteheads and no notation issues. Ensemble-grid spacing now preserves exact
   rational attacks that the previous fixed sixteenth grid omitted.

### M1 — Orchestral development (phase 2) [depends on M0 for swing migration]

Traverse the full consumer score in a new section_recomposition procedure.
Retain motif identity and separate drum parts; turn repeated accompaniment into
changes of musical purpose. Establish narrative causality through migration,
fragmentation, augmentation, harmonic pressure, withheld resolution and altered
return. Handwrite all sounding notes, with straight values under global swing.
Musical design and straight-region composition may proceed alongside M0.
Acceptance: every passage has a contextual musical judgment, the earlier motif
changes what later passages do, and the ending answers earlier tensions.
Evidence: vertical score reading, all six perceptual views and independent review.

#### Execution steps

1. Diagnose and recompose the instrumental-purpose scheme across all104bars.
   Consumer procedure stages0/1 read the current sources and actual original
   September roster; stage2 writes explicit source lists. Scope includes
   assembly/pocket, ritual/breakdown, through-developed middle and altered return.
   The user's roster correction supersedes the initial electric-bass assumption.
   State: complete. Full104bar source compiles under the corrected roster.
2. Read every passage with neighboring bars [depends on #1]. Compare the solo
   subject, string inheritance, harmonic consequences and final cadence. Use all
   six perceptual views and cross-review between passage authors, then revise
   actual weaknesses. State: complete; generated readings under
   `/tmp/boreal_orchestral_review/`. The consumer notes retain detailed judgments.
   Expansion: `ee0b3697-c737-4ed3-b331-460c0a3e0b35`. Two independent passage
   reviews found a ghost-reference adaptation and two invalid harmonic marks;
   both were repaired. The bowed contrabass middle is an intentional sparse
   harmonic-support departure, not a replacement electric-bass line.

### M2 — Independent completion (phase 3) [depends on M0, M1]

Export the single current MusicXML/MIDI pair. Refresh the straight comparison
through the shared override. Check consumer notation, MIDI parity, source motif
identity, every seam and complete-score perceptual findings. Revise review
failures before closing; report lack of audio audition without claiming listening.

#### Execution steps

1. Export and compare the current consumer score in realized and straight timing.
   The consumer verifier exports the same Piece with the off override, verifies
   MusicXML/MIDI parity including staccato/ties, motif identity and unchanged
   pitches. Import both notation files in the independent consumer. Refresh full
   perceptual views after final source repairs. State: complete. Both XML/MIDI
   pairs agree exactly for1225 sounding notes; Verovio retains1287 realized and
   1276 straight noteheads with no note/timing differences. All six perceptual
   views reran successfully after the final repairs.
2. Record exact evidence and limitations [depends on #1]. Update current consumer
   README and closeout, distinguish historical reports, check source/export
   freshness and close the procedure and plan. State: complete. Consumer docs32
   records current hashes, independent review provenance, source departures,
   offset-text layout limits and lack of audio audition. Partitura completed
   at2026-09-17T18:15:20Z. M2 expansion:
   `1acd0460-9e72-49e6-8eb2-6c797fcb542f`.

## Current state

All milestones are complete. M0 expansion:
`d1d2f362-6c05-4713-b174-66a3ef10dbe7`. Shared timing, notation, projections,
source/runtime provenance and the straight override are implemented and tested.
The consumer's section_recomposition procedure is complete with one current
export pair. The score was independently read; actual listening acceptance and
the user's notation application remain unverified.

During composition the user corrected a mistaken roster assumption inherited
from the previous score. The supplied MIDI instruments were writing vehicles;
the intended work is orchestral with bassoon carrying the funk bass subject.
The original full contract was reread. Consumer scope now explicitly excludes
electric bass and full kit, restores sparse contrabass and melodic string
rhythm functions, and permits only occasional concert drums. This correction
does not change the shared framework's timing contract. The consumer procedure
records the revised ownership; composition and review must honor it.
