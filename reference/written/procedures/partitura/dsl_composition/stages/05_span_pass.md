# Stage 5 - Compose Each Span In A Verdict Loop

Before composing each substantial span, write a compact micro-decision table:

```text
Bars/phrase | active engine | event/change | per-bar jobs | beat-level mechanism/rest | parts with jobs | input material | output material | checks needed
```

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
- staff grid for dense vertical inspection
- phrase placement for entrances, handoffs, and returns
- hybrid for mixed orchestral or multi-role passages

After each span or small section, run the loop:

1. Compose the exact DSL material.
2. Project the span.
3. State the musical verdict in one or two sentences.
4. Revise the notes, controls, placements, or span shape if the verdict exposes weakness.
5. Re-project the changed area.

Use focused projections:

```bash
partitura/bin/production_view SOURCE.rb ensemble_grid --bars START-END
partitura/bin/production_view SOURCE.rb exposed_clashes --bars START-END
partitura/bin/production_view SOURCE.rb verticals --bars START-END
partitura/bin/production_view SOURCE.rb line --part PART_ID
partitura/bin/production_view SOURCE.rb breath_map --part PART_ID
partitura/bin/production_view SOURCE.rb controls
# secondary (declared intent): roles --bars, harmony_with_melody --bars
```

Read the ensemble_grid as a conductor (every attack in a stratum, choirs together, punctuation
shared); adjudicate exposed_clashes findings musically (prepared suspensions, cadential sevenths,
pedal stacks, and resolving passing tones are correct music - fix only the unprepared exposed
clashes).

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

After composing that span, record the pass note before starting the next one. The pass note must say
which planned phrase-grain events were realized, which outputs were produced, what changed from the
contract, and what weakness was revised. A first write is not a span pass until it has been inspected
and revised or given a concrete no-change musical verdict.

