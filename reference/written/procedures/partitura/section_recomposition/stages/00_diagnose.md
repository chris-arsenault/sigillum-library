# Stage 0 - Diagnose

Ground the repair in evidence before touching any note. Read, don't recall.

Gather (into `procedure/diagnosis.md`):

- **The target**: piece source path, section id(s), exact bar span, and the parts
  involved.
- **The defect, named musically**, by bar and part, with the evidence attached:

```bash
partitura/bin/partitura compile SOURCE.rb                     # notation defects arrive as errors
partitura/bin/partitura view SOURCE.rb ensemble_grid --bars A-B
partitura/bin/partitura view SOURCE.rb exposed_clashes --bars A-B
partitura/bin/partitura view SOURCE.rb figure_timeline --part PART
partitura/bin/partitura view SOURCE.rb bar_profile --part PART --bars A-B
partitura/bin/partitura view SOURCE.rb harmony_check --bars A-B
partitura/bin/partitura view SOURCE.rb range_check
partitura/bin/partitura view SOURCE.rb line --part PART --bars A-B
```

  A piece that no longer compiles under the notation gates is a valid starting state:
  record every compile error against its bar/phrase and classify each as
  **notation-only** (the sounding music is right; re-mark it: add `|` at barlines,
  correct checkpoint lanes, fix mark spellings) or **musical** (the notes themselves
  are the defect).
- **The structural cause, not just the symptom.** For each defect ask "what structural
  or process failure produced this?" and state the defect at that altitude. A symptom
  list (a clash here, a stall there) never sets the repair's scope; the cause does. If
  ten bars show the same disease, the defect is the scheme that produced them.
- **The spine to preserve**: the lead line, the bass line, and the declared
  harmony/chord track across the span - quote them (from `line`, `bass_path`,
  `harmony`/`harmony_check` readouts), because they are the material the repair holds
  to unless the contract says otherwise.
- **The neighbour seams**: the two bars before and after the span - what enters, what
  tails across, what dynamic level the span inherits and hands off.
- **What the piece's own plan says** about this section, if plan documents exist
  (form contract, section narrative, per-4-bar rows): the repair must serve the
  declared job, or explicitly argue a better one.

The diagnosis is accepted when a different agent could execute the repair from it
without re-deriving anything: target, defect(s) with evidence, spine, seams, plan
pointers.
