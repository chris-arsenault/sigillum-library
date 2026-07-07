# Stage 2 - Recompose In Verdict Loops

Compose the replacement material, one passage at a time, inside the contract's
boundary. This stage is iterative: commit each passage with
`partitura commit --unit "bars A-B ..." --notes -`, and close the stage with
`partitura commit --stage-complete --notes -` when the whole span is recomposed.

Rules of composition (imported from the span-pass standard):

- Hand-write the note lists. No generators, loops, or pattern expanders produce
  sounding material.
- Write in this order within the passage: foreground/engine, bass behaviour (frozen
  spine bass is read, not rewritten), counterline/inner motion, accompaniment,
  controls, staff checkpoints where the vertical must be readable.
- Use the surface that exposes the job (degrees for tonal function, intervals for
  cells, split pitch/rhythm for editable lines, absolute for register-bound material);
  `partitura help decision` when unsure. Respect the notation gates: `|` on barlines,
  one bar of attacks per segment, checkpoints that tell the truth.
- Stay inside the declared chord track; where the repair improves the harmony, update
  the `chords` declaration in the same commit and say so in the pass note.
- For notation-only defects (compile-blocking markers, lanes, marks): re-mark the same
  sounding music and verify identity - `line`/`timed_events` before vs after must
  match. Say "notation-only, sounding music unchanged" in the pass note.

The loop, per passage:

1. Compose the exact DSL material.
2. Project it - together with the frozen spine and the seam bars, not in isolation:

```bash
partitura/bin/partitura view SOURCE.rb ensemble_grid --bars A-B
partitura/bin/partitura view SOURCE.rb exposed_clashes --bars A-B
partitura/bin/partitura view SOURCE.rb harmony_check --bars A-B
partitura/bin/partitura view SOURCE.rb line --part PART --bars A-B
partitura/bin/partitura view SOURCE.rb lint SOURCE.rb
```

3. State the musical verdict in one or two sentences against the contract's per-bar
   jobs and success criteria.
4. Revise until the verdict is strong; a clean projection is not a verdict.

Account for the contract element by element as you go: realized, deliberately diverged
(with why it is better), or missed - fix anything missed before committing the unit.
