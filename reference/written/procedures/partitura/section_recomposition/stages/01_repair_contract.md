# Stage 1 - Repair Contract

Decide the surgery's exact boundary before composing. Write `procedure/repair_contract.md`:

- **Replace**: which voices, which bars, which phrases/placements/staff_bars in the
  source. Name the DSL constructs that will change.
- **Preserve (frozen)**: the spine (lead, bass, chord track) and every bar outside the
  span. If the defect genuinely lives in the spine, say so here and widen the contract
  deliberately - that is a bigger repair, not a silent drift.
- **Per-bar jobs for the recomposed material**: what each bar of the replacement must
  do (call, answer, fill, breath, pickup, compression, cadence, denial), and at least
  one beat-level mechanism per phrase group. A repair that re-fills the bars with
  equivalent wallpaper has not repaired anything.
- **Seam behaviour**: how the recomposed span connects at each boundary - pickup,
  tail-crossing, overlap, caesura, or a declared cut. Abrupt reset is allowed only as
  a named event.
- **Harmony**: the chord track for the span (declare one with `chords "bN:X ..."` if
  the span has none - it is the cheapest way to keep the repair honest via
  `harmony_check`).
- **Technique sources**: if the repair needs models, search the card library now and
  name the candidates:

```bash
partitura cards <defect-shaped terms>   # e.g. "walking bass", "counterline", "comp"
partitura cards show <NAME>
```

  A card influences the repair only after its idea is adapted into this piece's own
  notes; cite it as `dsl:<category>/<id>` in a source comment.
- **Success criteria**: the specific projections/readouts that will show the defect
  gone, and what they should show instead.

The contract is accepted when it would forbid at least one plausible wrong repair
(too wide, too shallow, or spine-violating).
