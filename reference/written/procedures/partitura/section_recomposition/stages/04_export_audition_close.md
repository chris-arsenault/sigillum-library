# Stage 4 - Export, Audition, And Close

Run the mechanical floor:

```bash
partitura compile SOURCE.rb
partitura lint SOURCE.rb
partitura export SOURCE.rb
```

Then audition the result by score, MIDI, audio, or the strongest available substitute
- as music, not as data. Listen/read across the whole piece, not only the repaired
span: the repair's success is that a fresh listener cannot find the splice.

This stage is iterative: each post-export improvement cycle is one committed unit
(`partitura commit --unit "audit: <focus>" --notes -`), and the stage cannot close
without at least one. An audit unit is an editing pass over the repaired region and
its seams with the lenses the recomposition neglected - findings are improvements to
COMPOSE, by bar and part, not a defect scan. Revise, re-export, commit the unit. A
"no change" unit must name what you tried to improve and why the music is better
without it.

The closeout pass note must record:

- the final musical verdict on the defect (gone / transformed into what), tied to bars
  and parts;
- the seam verdict at each boundary;
- every divergence from the piece's plan and from the repair contract, each with why
  it is better;
- any escalations (spine or frozen material touched, contract widened) and their
  resolution;
- what the repair changed in the exported artifacts (bars, parts, controls) - the
  surgical footprint.

Do not close while any of these is true: the diagnosis's evidence commands still show
the defect; a seam reads as an unplanned reset; the `git diff` footprint exceeds the
contract; a skipped or stale stage remains unresolved. A repair that merely compiles
is the start of completion, not the end.
