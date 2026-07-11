# Stage 4 - Compose Primary Materials First

Compose the main musical identities before filling the texture.

Composition methods available - pick per musical job, and pick BEFORE writing the
first material, not after (`partitura help decision` routes; no method outranks
another):

- `degrees` + rhythm - tonal/modal function; key- and mode-aware ("c4", "D4 dorian")
- `intervals` + rhythm - motivic cells and their transformations
- split pitch/rhythm or `absolute` streams - editable long lines, register-bound material
- `texture` + `score` grid - composite vertical mechanisms: engines, ostinati,
  distributed chords, swells (the grid IS the source)
- `fill` / `fill_material` - reusable sub-bar figures, transposed/inverted/retrograded
  per entrance
- `anacrusis:` - pickups (`at:` stays the arrival downbeat)
- `chords "bN:X"` - declared harmony per bar; `harmony_check` closes the loop


For theme-led pieces:

- Name A, B, and any important secondary cells.
- Give each material a rhythmic identity that survives the clapping test.
- Give the material a rhythm whose durations have metric function: what is held for weight, what is
  short because it leads to an event, where silence creates accent or breath, and where the cadence
  remains rhythmic instead of inert.
- Define cell, contour, range, peak, cadence behavior, and harmonic implication.
- Write at least one clear statement as explicit DSL phrase material.
- Make phrase ids stable enough for `material_map` to show returns.

For process-led pieces:

- Name the process: passacaglia ground, fugue subject, toccata cell, chorale phrase, rhythmic cell,
  field, relay process, refrain, or figuration dialect.
- Write the first complete manifestation explicitly.
- State what can change later: register, harmony, rhythm, instrumentation, density, role, or
  placement.

Inspect and revise before continuing:

```bash
partitura view SOURCE.rb phrases
partitura view SOURCE.rb adjacency_profile
partitura view SOURCE.rb recurrence_map
# secondary (declared intent): material_map, foreground
```

`adjacency_profile` is the material's engine fingerprint (repeated/step/skip/leap shares);
`recurrence_map` shows whether returns exist IN THE NOTES (exact, transposed, rhythm-only) rather
than in phrase ids.

The material is accepted only when it has a clear identity without relying on accompaniment labels.
No clause may be rhythmically uniform bar-to-bar unless uniformity is the declared engine: ostinato,
passacaglia, ritual, chant, mechanical fixation, or exposed proclamation. Variation is structured,
not random: a phrase should state, answer, develop, compress, broaden, pause, or hand off.

