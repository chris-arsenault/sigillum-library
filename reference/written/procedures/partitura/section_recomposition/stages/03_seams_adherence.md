# Stage 3 - Seams And Plan Adherence

Read the spliced result as if someone else composed it. This is the merge-agent pass:
the recomposed span must belong to the piece, not sit in it.

**Seams.** Walk each splice boundary including two bars before and after: pickups,
tails crossing the boundary, dynamic continuity, register handoff, momentum. Project
the boundary windows, not just the span:

```bash
partitura/bin/partitura view SOURCE.rb ensemble_grid --bars (A-2)-(A+2)
partitura/bin/partitura view SOURCE.rb ensemble_grid --bars (B-2)-(B+2)
partitura/bin/partitura view SOURCE.rb verticals --bars (A-2)-(A+2)
partitura/bin/partitura view SOURCE.rb breath_map --part PART
```

**Identity.** Does the recomposed material carry the piece's material identity - the
cells, rhythmic sentences, and engine logic of its neighbours - or does it read as a
different composer's insert? Check returns and recurrences still hold:

```bash
partitura/bin/partitura view SOURCE.rb recurrence_map
partitura/bin/partitura view SOURCE.rb peak_axes
partitura/bin/partitura view SOURCE.rb figure_timeline --part PART
```

`peak_axes` matters especially: a repair must not accidentally relocate the piece's
registral/dynamic/density maxima unless the contract said so.

**Plan adherence.** Diff the result against the piece's plan documents and the repair
contract: every planned voice, role, and event in the span is realized, deliberately
diverged (documented as better), or restored. Nothing the plan called for is silently
absent, and nothing outside the contract's Replace list changed - check with
`git diff` on the source: the diff's bar/phrase footprint must match the contract.

**The defect.** Re-run the exact evidence commands from the Stage 0 diagnosis and
paste the before/after into the pass note. The defect is gone in the projections, not
in the prose.

Fix what these readings expose, then commit. If a fix requires touching frozen
material, that is an escalation: record it, return to Stage 1, and widen the contract
deliberately.
