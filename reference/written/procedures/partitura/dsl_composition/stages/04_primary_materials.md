# Stage 4 - Compose Primary Materials First

Compose the main musical identities before filling the texture.

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
partitura/bin/production_view SOURCE.rb phrases
partitura/bin/production_view SOURCE.rb adjacency_profile
partitura/bin/production_view SOURCE.rb recurrence_map
# secondary (declared intent): material_map, foreground
```

`adjacency_profile` is the material's engine fingerprint (repeated/step/skip/leap shares);
`recurrence_map` shows whether returns exist IN THE NOTES (exact, transposed, rhythm-only) rather
than in phrase ids.

The material is accepted only when it has a clear identity without relying on accompaniment labels.
No clause may be rhythmically uniform bar-to-bar unless uniformity is the declared engine: ostinato,
passacaglia, ritual, chant, mechanical fixation, or exposed proclamation. Variation is structured,
not random: a phrase should state, answer, develop, compress, broaden, pause, or hand off.

