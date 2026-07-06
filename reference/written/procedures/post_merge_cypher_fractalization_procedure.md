# POST-MERGE CYPHER FRACTALIZATION PROCEDURE

This is the final whole-movement pass after a movement has already been merged,
validated, and made technically coherent. It belongs with
`orchestration_procedure.md`, after Phase D merge validation.

The pass exists because a multi-agent merge can still sound like a row of finished
sections. The cure is not another section-by-section polish pass. The cure is a
whole-movement search for local musical incidents that make the score feel
composed through time: early starts, early endings, carry-overs, surprising
subtractions, sudden arrivals, role swaps, partial doublings, rhythmic
convergences, cross-register locks, resonance wakes, and other exact decisions
that break the barline and section-grid without repainting the whole movement.

## Definition

**Cypher** is the rotation and misalignment of roles, entrances, exits, colors,
and functions so voices do not all begin, continue, and end at the obvious
section boundary.

**Fractalization** is added musical specificity on a chosen dimension. Density is
only one dimension. A more specific decision may be a one-bar silence, a two-beat
doubling, a sudden tutti, a melody handed off before a seam, an accompaniment
rhythm temporarily matching the lead, a family dropping out, a register hole, or
a color entering as an afterimage.

**Post-merge final pass** means the movement already exists as note-lists. The
task is to read the actual merged score and add a layer of local life that only a
whole-movement view can reveal.

## What This Pass Is Not

- It is not a voicing overhaul unless the user explicitly asks for one.
- It is not a section repair pass.
- It is not a pass over 2-bar windows.
- It is not a checklist that places one technique into every section.
- It is not a broad-brush density pass.
- It is not a metrics pass. Counts are only underreach alarms; the ear decides.
- It is not a literal implementation of user examples. Examples identify a
  quality of search. They are not requirements and not an exhaustive taxonomy.

## Inputs

Read these before editing:

1. The movement `STATUS.md`, `CONTRACT.md`, `spine.py`, assembler, and current
   section modules.
2. `reference/written/procedures/orchestration_procedure.md`, especially Phase D.
3. `reference/written/craft/texture_identity_contrast_ledger.md`.
4. The movement's current merged MusicXML/MIDI if available, plus any per-bar
   density or attack scans that already exist.

The ledger's 17-column matrix is a search manifold, not a coverage checklist:
`Section` plus the 16 musical axes:

- continuity identity
- section job
- fractalization target
- detail mode
- motion source
- rhythmic identity
- bass behavior
- string role
- wind/brass role
- keys/percussion/harp role
- density/space
- register/color
- reserve role
- contrast relation
- library search terms
- required audible event

Use the axes to notice what could vary. Do not assign one axis per section like a
spreadsheet exercise.

## Pass Order

### 1. Build The Whole-Movement Map

Before choosing incidents, make a compact map of the whole movement:

- section names, bar ranges, functions, and major formal events
- seams and the 50-percent-to-50-percent spans around them
- current lead/counter/bass carry-forward paths
- recurrent rhythmic engines, pads, and accompaniment figures
- places where entrances and exits are too aligned
- density and attack profile by bar
- tutti arrivals, abrupt cuts, empty windows, and reserve spends already present
- returns and restatements that risk sounding like transposed repeats

If the movement has about 13 sections, do not inspect 13 isolated boxes. Inspect
the whole arc, and when a boundary needs local focus, inspect from roughly halfway
through the previous section to halfway through the next.

### 2. Mark Opportunity Zones Before Editing

Scan for zones where one localized incident would change the listener's sense of
continuity, surprise, or phrase direction. Good zones include:

- the last third of one section and first third of the next
- a place where a new section restarts too cleanly
- a return that copies the old orchestration too literally
- a long phrase in one color that wants a relay
- a rhythmic engine that runs too evenly for too long
- a full texture that would be stronger with a one-bar hole
- a sparse texture that would be stronger with one startling flash
- a complex rhythm where another layer can suddenly lock to it
- a melody long-note or gap where another family can answer
- the bar before a cadence, not only the cadence itself
- the bar after a destination event or crest, where the expected continuation can disappear
- the approach to a tutti, where convergence or abrupt arrival can be staged

Do not edit yet. First mark more candidates than you will use.

### 3. Select Incidents By Musical Leverage

Choose incidents using these questions:

- Would the listener feel the movement becoming less section-blocked?
- Does the incident serve this movement's type, tone, and formal argument?
- Does it change one or two axes sharply without confusing the main line?
- Is it local enough to be memorable, not a new default texture?
- Is it different from nearby incidents?
- Does it preserve the movement's existing good material?
- Does it make the phrase read better when heard before and after, not just in
  the edited bar?

As a rough underreach guardrail for a 100-200 bar movement, expect the pass to
leave a visible footprint across multiple formal regions, often around 8-20
localized incidents or about 5-12 percent of bars touched. This is not a quota.
If fewer events are used, the pass report must explain why the existing movement
already has enough cypher behavior.

### 4. Compose The Incidents

Use the ledger axes to invent, not to sort. The following families are prompts:

**Line and seam behavior**

- start a melodic fragment before the seam
- let a phrase tail cross the seam instead of ending on it
- end one family early so the next family inherits the air
- overlap one or two notes in a Mahler-style relay
- let a counterline begin as residue before it becomes foreground

**Rhythm and lock**

- make a rhythm-section layer suddenly match the melody for a complex cell
- flip an accompaniment from sustain to off-beat reattack for one bar
- cut a motor for one bar so another layer is exposed
- converge layers over 2-4 bars into a hit, then fragment again
- briefly double a triplet, dactyl, syncopation, or displaced cell in a distant
  register

**Density and silence**

- remove the entire rhythm floor for one bar
- remove harmony while runs or melody remain
- create a chamber window inside a broad passage
- create a low-only or high-only window
- let a family be absent as a positive event, not an omission

**Doubling and color**

- add a 2-4 beat event-only doubling
- use attack halo on only the structural notes
- rescue a buried inner line with one contrasting color
- make a short composite timbre and remove it immediately
- strip mixtures just before a pure solo color appears

**Register and space**

- open a hollow register gap for one bar
- push a return into a new octave only at its answer point
- plunge or lift the bass before the harmony expects it
- leave the top empty after a high point so the afterimage is heard

**Tutti and abrupt arrival**

- allow true tutti when the form wants it
- make the arrival abrupt if the drama wants shock
- stage convergence into the tutti over 2-4 bars when the drama wants pressure
- cut away from tutti into exposed color instead of continuing mass
- spend a reserve color once, then make its absence audible

**Decay and afterimage**

- add a resonance wake after an event
- move the decay into a different family
- let percussion or harp stop before the visible cadence
- let one quiet voice outlast the mass by a bar
- answer a destination event or crest with subtraction rather than more force

These are examples, not requirements. The correct action is whatever the current
merged score makes musically available.

### 5. Edit With Local Accountability

For each incident, write down:

- bars/beats touched
- voices touched
- axis or axes changed
- musical reason
- expected audible effect
- validation command

Keep edits in the relevant section files unless the movement's architecture uses
a different artifact shape. Preserve bar sums and named carry-forward material
unless changing it is explicitly the point and is documented.

### 6. Verify The Pass

Run the touched section modules, then the full assembler. Also run any available
bar-density, attack, or texture scans. Use the numbers to find accidental damage:

- Did a one-bar cut actually cut the intended floor?
- Did a local flash accidentally create a new tutti plateau?
- Did a relay overlap correctly, or did it make a duplicated line?
- Did an event-only doubling leave immediately?
- Did a seam-crossing event preserve the section duration?

Then do a musical review over the whole movement. Ask:

- Does the piece now sound less like separate merged sections?
- Are some seams still too square?
- Did the pass create gimmick repetition?
- Did it overreact to feedback and flatten the movement's larger form?
- Are tutti and abrupt arrivals present where the type needs them?
- Are silence, reserve, and subtraction treated as events?

## Final Report Shape

The closeout should name the actual footprint, but must not pretend the footprint
is the musical verdict:

- incidents added, with bar numbers
- approximate bars touched
- formal regions affected
- main axes varied
- validation commands run
- any regions intentionally left alone, with reason

A good report says what changed and why it should be heard. A weak report only
says which examples were implemented.

## Anti-Failure Clauses

- Do not approach the movement section by section when the defect is sectioning.
- Do not hunt only at barlines. The strongest incident may be before or after the
  obvious seam.
- Do not use tiny windows unless validating an already chosen edit.
- Do not normalize the whole movement toward the feedback. Keep the movement's
  type, shape, and surprises.
- Do not make every incident a dropout. Surprise also includes sudden mass,
  convergence, role exchange, doubling, color, register, and decay.
- Do not remove all abruptness. Some tutti and abrupt arrivals are necessary.
- Do not make the pass evenly spaced. Positional regularity is another grid.
- Do not call an edit cypher if it only decorates a bar and does not alter how the
  phrase crosses, breathes, or projects.
