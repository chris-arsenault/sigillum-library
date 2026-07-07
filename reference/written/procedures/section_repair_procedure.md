# section_repair_procedure — SECTION REPAIR PROCEDURE (agent-executable)

> DSL-era note: for pieces whose source of truth is the production Ruby DSL, run the
> guided successor instead:
> `partitura start <piece_dir> --procedure section_recomposition --source <SOURCE.rb>`
> (`reference/written/procedures/partitura/section_recomposition/`). This document
> remains the craft source for the Python/symphony-shaped workflow it describes.

Hand-compose a fix for ONE section (or sub-passage) of a movement, SURGICALLY — keep everything that
works, replace only the named defect. Reuses orchestration_procedure's section-agent refine loop (compose → inspect →
adapt, never one-shot) but for a targeted repair, grounded in the contract + the line spine + the
texture-card library. **Neutral across craft dimensions** — the section's own narrative and the craft
decide what's load-bearing; do not import the composer's current preoccupations.

## INPUT (handed per task)
- The section / passage to repair, its bar-span, and **what is wrong** with it (the defect).
- **What to PRODUCE**: which voices, against what (the spine lead/bass stay fixed).
- **LIBRARY SEARCH TERMS** — a few terms you'll probably want (the orchestrator hands these; e.g. a
  string-romance agent gets `chamberstrings, color, comp, counter, tender`). You know what they mean.
- Pointers (read them, don't recall): the contract, the spine module, the meta arc, the neighbour
  material (the frozen "keep" version), any carry-forward inputs.

## STEP 1 — GROUND (read, don't recall)
- The movement's **meta arc** + this section's **narrative + per-4-bar plan** (the contract docs +
  the movement narrative).
- The **thematic core**: this section's LEAD and BASS lines + the chord progression — the material
  to hold to. You own all the section's voices; shape them (lead, bass, inner) to serve the music,
  grounded in that core and connecting cleanly to the neighbour seams.
- The **neighbour seams**: the bars just before/after your span (from the frozen keep-version) so your
  fix connects — momentum through, pickups, dynamics.
- The **library — DON'T load it; SEARCH it.** Run `ruby tools/lib.rb <term>` with each of your
  handed SEARCH TERMS (category like `chamberstrings`, or a facet like `color`/`rhythm`/`comp`/
  `tender`) to list matching cards, then `ruby tools/lib.rb show <NAME>` for the DSL specimen — pull
  ONLY what your phrase needs, when you need it (`ruby tools/lib.rb terms` lists valid terms). A
  card's `cite` points to its craft annex (the craft annexes + technique surveys); read that annex if the technique needs it.
  The frozen sections and the P-cards are the complexity bar.

## STEP 2 — COMPOSE (hand-composed note-lists; never a generator function)
Realize the assigned voices at full craft, on the spine — voicing, counterpoint, figuration, interplay,
whatever the section calls for. Every note hand-chosen. Stay in the section's harmony and character.

## STEP 3 — INSPECT → ADAPT (refine loop, several passes)
Render your voices TOGETHER WITH the spine lead+bass (and the neighbour seam bars); listen/measure;
critique it AS MUSIC. Is it alive? does it serve the arc? do the seams connect? Iterate — really finish
it, don't pass off a first draft.
Then **RE-WALK YOUR PER-4-BAR PLAN element by element** (this tier is YOUR job, not the merge's): for
every planned event / instrument / gesture, account — realized, deliberately diverged, or missed. Fix
anything missed. Anything you diverged from the plan is DOCUMENTED with **why it is *better*** (not
merely acceptable) and escalated in your return. Nothing the plan called for is silently absent.
Verify (silent): each voice's bars sum correctly, in-range for its instrument, in the section's
harmony, renders clean.

## STEP 4 — RETURN
The repaired voices as NOTE-LISTS (per voice, aligned to the section's bar-span), named, plus a short
note on the seams and any escalation (HARD rules never silently rewritten — escalate instead). A
MERGE AGENT (below) — not the centre — assembles the result.

## MERGE (Phase D) — by a MERGE AGENT (not the centre)
The merge is itself an agent task; the centre only assigns it. A dedicated agent receives the frozen
keep-version + every repair's returned voices (note-lists) + the spine, and:
- SPLICES each repair into place (replacing the named defective voices for its bar-span);
- masks the composed interruptions / caesuras;
- walks the SEAMS at the splice boundaries, the global dynamic arc, and the verticals at those
  boundaries (reconciling only non-spine voices — never the spine);
- **PLAN-ADHERENCE (MID-LEVEL + MOVEMENT-LEVEL — NOT the per-4-bar; the section agents own that):**
  diff the assembled movement against the plan's ROSTER, the structural/leitmotif ROLES, the mid-level
  section FUNCTIONS, the dynamic ARC and the carry-forward. **Flag to the user any planned voice /
  role / idea that is unrealized or dropped.** (A whole planned instrument — the celesta — went silent
  across the entire movement because no step owned this.) A divergence is allowed only if documented
  with **why it is *better*** (not merely acceptable) — surfaced, never silent.
- renders the full movement and reports (including the plan-adherence findings).
Gates are a floor; the ear is the verdict (J3). (This replaces the centre doing the merge by hand —
same vertical-slice model as the section repairs, just an agent instead of the orchestrator.)

## NOTES
- **DIVERGENCE RULE (every review cycle, every tier):** a divergence from the plan is allowed ONLY if
  documented with why it is *better*, not merely acceptable — and surfaced, never silent.
- The other sections are frozen — don't rewrite them; you own your assigned voices, grounded in the
  thematic core.
- Hand-composed, judged by the ear. No single-axis checklist, no imported fixation.
