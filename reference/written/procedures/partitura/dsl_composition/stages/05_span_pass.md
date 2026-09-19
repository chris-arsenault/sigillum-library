# Stage 5 - Compose Each Span In A Verdict Loop

Before composing each substantial span, write a compact micro-decision table:

```text
Bars/phrase | active engine | event/change | per-bar jobs | beat-level mechanism/rest | parts with jobs | input material | output material | checks needed
```

Before choosing notes, apply the
[passage-context test](../../../../craft/MELODY_CRAFT_DOCTRINE.md#the-whole-is-the-unit-of-analysis).
Read the incoming phrase and establish how this span changes its expectations
and where it leads. Carry tonal color, recurring gestures, bass direction,
harmonic rhythm and dynamic momentum into the decisions. A sequence of locally
fitting notes or individually labeled bar jobs is not yet a phrase.

For every span, write the music in this order:

1. Foreground or primary engine.
2. Bass behavior: line, ground, drone, pedal, walking bass, tacet, or punctuation.
3. Counterline or inner motion.
4. Accompaniment and harmonic support: counterline, walking bass, ostinato, chorale, arpeggiation,
   repeated pulse, tremolo, drone, sustained pad, harmonic field, rests, or tacet.
5. Controls: dynamics, hairpins, pedal, tempo, and technique spans.
6. Staff checkpoints where vertical, role, handoff, cadence, or register alignment must be readable.
7. Gesture prose only when it names an audible mechanism already present in the notation.

Use the surface that exposes the job:

- degrees for tonal/function melody
- intervals for motivic transformation
- split pitch/rhythm for long editable lines
- absolute pitch for register-bound material
- texture + score grid to create composite vertical mechanisms (engines, distributed chords, swells)
- staff grid for dense vertical inspection
- phrase placement for entrances, handoffs, and returns (anacrusis: for pickups)
- explicit short phrases for figures in gaps and seams, one written note list per occurrence
- hybrid for mixed orchestral or multi-role passages

After each span or small section, run the loop:

1. Compose the exact DSL material.
2. Project the span with its preparation and continuation, extending to musical
   phrase boundaries where the effect depends on them.
3. State the musical verdict in one or two sentences: what expectation the
   passage establishes, what the gesture does to it, and what follows. Cite
   actual musical evidence rather than only a chord-fit result or device name.
4. Revise the notes, controls, placements, or span shape if the verdict exposes weakness.
5. Re-project the changed area through its phrase-level consequence.

Use focused projections:

```bash
partitura view SOURCE.rb ensemble_grid --bars START-END
partitura view SOURCE.rb exposed_clashes --bars START-END
partitura view SOURCE.rb verticals --bars START-END
partitura view SOURCE.rb line --part PART_ID
partitura view SOURCE.rb breath_map --part PART_ID
partitura view SOURCE.rb controls
# secondary (declared intent): roles --bars, harmony_with_melody --bars
```

Read the ensemble_grid as a conductor (every attack in a stratum, choirs together, punctuation
shared); adjudicate exposed_clashes findings in their passage context.
Prepared suspensions, cadential sevenths, pedal stacks and passing tones may
carry the line; an unprepared dissonance can also be intentional. Neither a
flag nor its absence decides whether a note belongs. Compare vertical tension
with the established tonal color and the phrase's direction before editing.

A span passes when the active engine, bass, accompaniment, and any gesture claim are audible in the
notation. A clean projection is not enough.

Use this bar/beat failure-mode checklist during span review:

- Does the passage feel like counted bars of texture rather than a phrase with cause and consequence?
- Has a texture, accompaniment pattern, card behavior, or same-color field continued by inertia after
  its musical job is done?
- Does an apparent repeat, continuation, or stasis have an audible reason: ritual, pressure, suspense,
  insistence, aftermath, breath, or refusal?
- Do duration choices express metric function: held weight, pickup, anticipation, breath, pressure,
  cadence, denial, or release?
- Each phrase has per-bar jobs, not just bar counts: call, answer, hold, fill, breath, pickup,
  compression, cadence, denial, afterimage, interruption, or release.
- Rests and tacets have function. A rest may be an accent, breath, cut, anticipation, exposure,
  suspension, or release; if it only fills arithmetic, rewrite it.
- Simultaneous layers need rhythmic separation unless the passage deliberately uses homorhythm as a
  scarce punctuation.
- A seam is composed by pickup, tail-crossing, liquidation, sequence, harmonic acceleration, caesura,
  cut, or resonance wake. Abrupt reset is a special event, not the default way to change blocks.

After composing that span, commit it as one unit (`partitura commit --span A-B --notes -`) before
starting the next. The realized material is in the source - the pass note does not re-list it. It
records `decisions` (what changed from the contract and why), `improvements` (what got
compositionally better this pass), the `musical_verdict`, and only in `carries` anything this span
genuinely cannot close yet - a dependency on a later span or stage, or half-finished material awaiting
a callout. A weakness you can fix, you fix here and now; it does not go in the note. A first write is
not a span pass until it has been inspected and revised or given a concrete no-change musical verdict
that names what you tried.

Before drafting each span, notice which dimension is leading your attention; after drafting, read
the same bars once more with the lenses you were not using - the neglected dimensions decay while
you compose, and this traversal is where they are brought back up. The stage cannot close until
every bar of every section belongs to some committed span unit (the `units_cover_source_bars` gate)
- coverage of attention is enforced; the quality of that attention is yours to prove in the notes.
