# ORCHESTRATION PROCEDURE orchestration_procedure v2 — multi-agent execution (section-agents that refine)

A fork of unified_procedure for fanning a movement across fresh agents. unified_procedure's rules/stages/annexes (H/D/J, §1–§3)
bind VERBATIM; this governs only DISTRIBUTION. NOT for speed — for density + fresh attention.

## THE CARDINAL PRINCIPLE — each stage has MORE detail than the last (fractal elaboration; floors not ceilings)
The pipeline is `movement-plan → narrative → frame → section → ornament`. The movement plan is the
ONLY deliberately sparse thing — the seed. **Every stage after it must contain substantially MORE
detail than the stage before: the narrative is richer than the plan, the frame richer than the
narrative, the section richer than the frame, the ornamentation richer still. Detail increases
monotonically and COMPOUNDS at every level — there is no "keep the early layers lean" exception; the
narrative and the frame expand just as the section does.** Each stage's input is a FLOOR to clear and
vastly exceed, NEVER a ceiling to write up to: where the input casts N voices, names a part tacet,
gives a thin gesture, or describes an arc in one sentence, that is the MINIMUM scaffolding — elaborate
it several-fold, creatively, on your own initiative. The failure is UNDER-elaboration: transcribing
the input faithfully and stopping at it (so a sparse seed yields a thin, dead realization at every
level below). A detailed upstream layer does NOT cap the next — the next adds yet more detail to every
element of it, and may RESHAPE it (each layer is LIVING, never a lock — E10/never-lock). Never hand an
agent a checklist of specific fixes or the composer's own example complaints — that just relocates the
bar and kills the agent's invention; state this principle and trust the agent to invent.

## PREMISES THIS VERSION ENCODES (the load-bearing principles)
- **Fractalization means added musical specificity on the assigned dimension.** Independent, layered
  voices create aliveness when the section job asks for density; exposure, reserve, register relief,
  silence, homorhythm, color handoff, and subtraction are equally valid detail modes when assigned by
  the Phase-A ledger.
- **The goal is GOOD MUSIC, never a metric.** Friction is a color; blandness is the failure. The
  agents and the merge polish MUSIC, judged by the ear — never a clash-count, gate pass, checklist
  completion, or aggregate number.
- **A movement has a journey and destination, not a default climax.** The destination is the musical
  state the movement travels toward: arrival, transformation, rupture, exhaustion, release, suspension,
  disappearance, homecoming, ritual lock, or refusal. The plan validates the changed state of the
  material, not a density swell near the last quarter.
- **The last-third climax is a default gravity to resist.** Do not assume the destination occurs around
  70-80% of the movement. Declare whether the destination is an early revelation, midpoint turn, late
  arrival, final bar, recurring return, plateau, collapse, or withheld arrival. If the strongest event
  lands in the last third, explain why the form requires it.
- **Peak axes are separate until the music joins them.** Dynamic maximum, density maximum, registral
  maximum, harmonic arrival, tutti arrival, percussion spend, melodic high point, and formal destination
  may coincide only when convergence is the movement's declared design. Otherwise distribute them so the
  journey has contour, surprise, and aftermath.
- **Agents REFINE, never one-shot.** A section is composed, inspected, and revised across several
  passes (the Phase-C loop) — a first draft is not a section.
- **Sections are MUSICAL phrases/arcs, never arbitrary bar-counts.** A phrase/arc boundary makes a
  section internally coherent and lets the centre hold the outer arc in words; an arbitrary slice does
  neither.
- **A section agent owns ALL its voices and makes its own harmony** — on coherent material, refined.
- **Ornamentation/enlivening is a first-class, weighted stage** (Stage 6): every sounding voice receives
  a precise musical job, and every reserved/silent voice receives a precise dramatic job. A sparse or
  "solo" texture stays gestural through fills in the lead's gaps, a single counterline, a color handoff,
  a held breath, a cut, an arpeggio/flourish, suspension, chorale, counterpoint, or an intentionally
  voiced pad/field. Pads and sustained fields are acceptable texture-classes when the music calls for
  them; they are not acceptable as the default substitute for composing an accompaniment.
- **Voicing has its own discipline** — voice by hand, judge by ear, never a voicing-generator function
  (it stamps one shape = blandness). Pull the voicing craft from the library on demand (the
  piano-voicing survey + the voicing cards): rootless forms, open LH, spread voicings, comp rhythm.
- **Returns are REAL NOTE-LISTS, never prose** describing what the notes would be. The centre validates
  every return as parseable note-lists before accepting it (Phase D); a prose return is a failed pass.

## CURRENT-SOURCE LAW — live tree only, no stale-plan override
The current rebuild is authored from the **live tree only.** The pre-rework movements, plans, and
material were removed (recoverable from git history / tag `v0.8`) and are **not a source, precedent,
scaffold, data-shape example, narrative input, frame input, harmony model, or section model.** No agent
may resurrect them from git history or old tags to infer "the exact shape," and no brief may point at
removed material — unless the user explicitly asks for archaeology in that turn.

Source authority: the symphony plan lives in **`symphony/plan/`** — the single, self-contained,
internally-consistent source for keys, names, theme assignments, forms, studies, the study model, and the
orchestral roster (`00_overview.md` = the whole-symphony frame; `themes.md` = the theme roster;
`movements.md` = the per-movement seeds). **An agent brief points at `symphony/plan/` and needs nothing
else for plan authority; agents do NOT search the repo for the plan.** Narrow exception: Phase-A A1/A2
must survey other current movement mid-level briefs only for contrast and destination placement:
`symphony/movements/*/02_midlevel.md` and `symphony/work/*/phaseA/A2_midlevel.md`, excluding the current
run folder and any user-declared stale/failed variant. This survey is not source authority and never
licenses copying material; it tells the agent how this movement must differ by form, destination
placement, rhythmic engine, texture-class, register plan, and force profile. The theme NOTE-LISTS (the actual pitches) live in
`symphony/materials/themes.py` (symbols named in `symphony/plan/themes.md`). No other document overrides
`symphony/plan/`; treat any movement plan, tonal map, study, or theme name found elsewhere (older
architecture/materials docs, project notes, the ledger) as **non-authoritative and stale.**

Before spawning A1, the centre performs a **current-source preflight**: from `symphony/plan/`, name in
the brief the movement key, the one theme it studies (+ its nods), the current theme symbols, and the
orchestral roster — so the agent receives the plan, not a search task. The brief also lists the other
current movement mid-level briefs A1/A2 must survey for contrast; if none exist, state that explicitly.

## THE CONTROL MODEL — consistency lives in WORDS, across THREE narrative tiers, each AUTHORED BY ITS OWN AGENT (Phase A)
The orchestrator can hold a movement consistent because it reduces to ~8–20 word-described sections —
a span one mind keeps faithful — and each section is internally coherent because one agent owns a
whole phrase. The three tiers (each its own single-purpose Phase-A agent, so the cardinality/fractal
rule holds tier-by-tier):
- **META (whole movement) [agent A1]:** the through-line / dramaturgy / dialect / journey/destination — a detailed
  high-level narrative of WHAT THE MOVEMENT ACCOMPLISHES, grounded in a RESEARCHED understanding of the
  movement's TYPE and its place in the whole symphony, and establishing the vocabulary/terms the later
  stages reuse. The words that bind ALL sections. ("add a meta layer.")
- **MID-LEVEL SECTION (8–24 bars; ~8–20 per movement) [agent A2 = structure; A3 fills its narrative]:**
  a coherent THEMATIC ARC or PHRASE — its function, harmony, theme, character, and how it hands off to
  its neighbors. **THE UNIT OF FAN-OUT, drawn on MUSICAL boundaries (a phrase, an arc) — NEVER arbitrary
  bar-counts.**
- **PER-4-BAR (kept, E6) [agent A3]:** the fine grain within each section — verbs, events, figuration plans.
Outer (cross-section) consistency is controlled by the META + MID-LEVEL words; inner-phrase
consistency comes from one agent owning a whole musical section.

## THE CARRY-FORWARD CHAIN — section OUTPUTS (exact thematic recall, not paraphrase)
Words describe a recurring idea but can't guarantee a later section reproduces the EXACT material —
S5's agent would re-invent the motif S1 wrote and they'd drift. The fix: a section DECLARES OUTPUTS —
named musical artifacts it actually produces (a motif's notes, a voicing, a countermelody, a rhythmic
cell, a cadence shape, a card-realization) — and downstream sections DECLARE the INPUTS they consume.
The orchestrator threads each produced output INTO the dependent agent's brief, so a recall is the
EXACT upstream material, not a re-description.
- This makes the fan-out a DAG / **chain**, not pure parallel: a section runs only once its inputs
  exist; sections with no unmet dependency still parallelize. The orchestrator schedules the order.
- Phase-A agent A2 (the mid-level plan) declares, per section: OUTPUTS (name + what it is + how downstream uses it) and INPUTS
  (which upstream outputs it receives). The variation-on-return law becomes MECHANICAL — the return
  section is HANDED the original and varies IT; recurring-motif tells (a leitmotif creeping in/out,
  etc.) thread the same way, identically each time.
- An agent's brief therefore carries both: "PRODUCE these OUTPUTS [spec] and return them named" and
  "here are your INPUTS [the actual upstream material]."
- Example: S1 introduces a melodic concept → outputs `S1.motif` (the actual notes); S5 develops it →
  receives `S1.motif` verbatim and transforms it, instead of guessing at "that motif."

## PHASE A — a PIPELINE of single-purpose agents (each step its own agent so the cardinality/fractal rule holds tier-by-tier; the centre only schedules + threads)
The contract AND the lines are AUTHORED BY AGENTS, like the sections and the merge — the centre does
NOT compose them by hand. Hand-authoring a "skeleton" is how a locked, lifeless spine slips in (a central
mind writes one and treats it as fixed); fanning Phase A keeps fresh attention on it and keeps it a
living starting-shape, not a cage (E10/never-lock, J3). The centre runs unified_procedure Stage 0
(grounding, identity/contrast ledger D7b, directed fractalization D7c, dialect declaration D7,
card-set, alignment pre-check H8, manifest),
then runs FOUR Phase-A agents AS A PIPELINE and threads their returns — **each agent receives ALL prior
steps' outputs as its inputs**:
- **A1 — META / HIGH-LEVEL agent.** Inputs: the movement-plan seed, the intended movement TYPE, the
  movement's THEME ASSIGNMENT, and where it sits in the whole — all from **`symphony/plan/`** (the seed in
  `movements.md`, the theme in `themes.md`, the frame in `00_overview.md`; see CURRENT-SOURCE LAW).
  It surveys the other current movement mid-level briefs for contrast only, then RESEARCHES the movement
  type (external, fresh — no library, no cards), then authors a **detailed high-level narrative of WHAT
  THE MOVEMENT ACCOMPLISHES** (its through-line, dramaturgy, dialect, journey, and destination),
  naming how this movement fits differently from the surveyed movements,
  and establishes the VOCABULARY/TERMS the later steps reuse. How this movement relates to the others —
  what it studies, how distinct it must be from its neighbours, whether and how it draws on other
  material — is defined by `symphony/plan/` (the study model), NOT by this procedure: read it and realize
  that design. A1 also splits the peak axes: dynamic maximum, density maximum, registral maximum,
  harmonic arrival, tutti arrival, percussion spend, melodic high point, and formal destination. These
  axes coincide only if convergence is explicitly the destination. Returns the high-level narrative +
  the form research + the destination map + the axis split + the cross-movement contrast note + the terms.
- **A2 — MID-LEVEL PLAN agent.** Inputs: A1. Builds the movement's MID-LEVEL skeleton **AS the researched
  form** — its section sequence, proportions, destination kind/placement, and return scheme ARE the form's,
  so the form gives the plan its shape. It checks the surveyed mid-level briefs and places this movement
  where it will be structurally unique: form, destination placement, rhythmic engine, texture-class,
  register plan, and force profile must differ in big audible ways. If the strongest event or formal
  destination lands in the last third, A2 explains why the form requires that placement rather than
  default narrative gravity. A2 divides on MUSICAL seams (a phrase/arc, NEVER bar-counts); and DECLARES the
  CARRY-FORWARD CHAIN (each section's OUTPUTS + INPUTS) which fixes the fan-out DAG. A2 also authors the
  **TEXTURE IDENTITY & CONTRAST LEDGER** from
  `reference/written/craft/texture_identity_contrast_ledger.md`: one row per section declaring continuity
  identity, section job, fractalization target, detail mode, motion source, rhythmic identity, bass
  behavior, string role, wind/brass/key/percussion roles, density/space plan, register/color plan,
  reserve role, contrast relation, library search terms, and required audible event. Returns the
  mid-level sectioning + the DAG + the ledger.
- **A3 — NARRATIVE agent.** Inputs: A1 + A2. Writes each section's dramatic NARRATIVE and its PER-4-BAR
  grain INTO the skeleton — verbs, events, figuration plans — at cardinal-principle detail. A3 expands
  each ledger row into per-4-bar choices: which fractalization target is active, which detail mode is
  being elaborated, which continuity identity carries through, and which contrast relation gives the
  group its role in the section. This (with A1 + A2) IS the contract every section agent implements
  (diverge only where clearly BETTER, per the DIVERGENCE RULE). Returns structured text.
- **A4 — FRAME agent.** Inputs: A1–A3. Authors, AS NOTE-LISTS, the movement's **frame** — the harmonic
  plan (chords + key plan + cadence/denial structure, developed across the movement's span for its style
  and dramatic argument), the bass-as-line that grounds it, the one global layer, and the skeletal
  principal lines. A THIN, LIVING scaffold the section agents elaborate and MAY reshape — never locked
  (E10/never-lock). It is given the theme ASSIGNMENTS (which theme sounds where). RECORDS any divergence
  with WHY IT IS BETTER, surfaced never silent.
- The centre does NOT hand-edit any return: it VALIDATES each (research grounded; musical seams; real
  note-lists for the frame; NO locked spine — a frame that forbids the sections from moving a line is a
  failed pass, re-run it), threads each step's output into the next, and schedules the DAG execution order.
## PHASE C — SECTION AGENTS (one per MID-LEVEL section; they REFINE, never one-shot)
Agents run in the carry-forward DAG order (a section waits for its INPUTS; independents parallelize).
Each agent receives: its mid-level section narrative + the META + its identity/contrast ledger row
and adjacent rows + its per-4-bar plans + the section's LINES + the ±neighbor boundary bars + its
INPUTS (the actual upstream OUTPUTS it consumes) + a few
**LIBRARY SEARCH TERMS** (it pulls cards on demand via `ruby tools/lib.rb <term>` / `... show
<NAME>` — never loads the whole library; a card's `cite` points to its craft annex). It runs a LOOP:
  1. **COMPOSE** the section — you own ALL its voices, the lead and bass included. This is where the
     theme's notes enter and the frame's thin scaffold becomes real music. Shape every line to serve
     the music. **Your section
     narrative + cast + frame lines are a FLOOR, not a ceiling (THE CARDINAL PRINCIPLE):** the cast
     names the MINIMUM voices, the frame lines are a thin skeleton — pour in FAR more than the shell
     literally states. Bring in voices it left tacet where the music wants them, give every line its
     own rhythmic life, invent the inner detail the shell only gestures at. A section that merely
     realizes its cast list has failed; the thin shell exists to be elaborated several-fold. Build the
     full chamber texture (Stages 2–5) according to the ledger's section job and detail mode — dense,
     chamber, sparse, tutti, subtractive, homorhythmic, registrally exposed, reserve-focused, or
     seam-focused as assigned. Choose the accompaniment type the section actually needs: counterline,
     walking bass, figuration, ostinato, chorale, pulse, drone, sustained pad/field, silence, or tacet.
     If you use a pad/field, make its register, color, harmonic function, entry/release, and dynamic life
     audible; if the section needs motion, write motion instead. Keyboard parts follow the
     VOICING DISCIPLINE: the piano-voicing survey + the hand-composed voicing cards (rootless/open/comp;
     avoid low close clumps unless the passage deliberately wants mud, pressure, or weight). Returns are
     NOTE-LISTS, never prose descriptions of what the notes would be. Card use
     must be present in those notes; score text may name only performer techniques/instructions, not
     themes, section functions, provenance, or narrative claims.
  2. **ORNAMENT & ENLIVEN (the weighted ornamentation stage).** Give each sounding part a precise
     active job — fills in the soloist's gaps, an active inner countermelody, gestural figuration
     (arpeggios/flourishes/runs), color handoff, held breath, pad/field, chorale/suspension, or
     counterpoint.
     Give each silent/reserved part its dramatic identity from the ledger. A sparse texture is still
     gestural. (Stage 6, E6 figuration, made first-class here.)
     EXPRESSION as you compose: every entering voice carries a DYNAMIC; work the full range
     (mp–mf–f is the working middle, not only pp and fff — shape phrases with swells); and when the
     pulse eases (a morendo / rit.), resolve it with an `a tempo` unless the piece is ending.
  3. **INSPECT** its own work: render/measure it, critique it AS MUSIC — does it serve the arc? is it
     alive, or is it mud / busywork / a stencil? are the seams to the neighbor bars prepared?
     What is the section's active engine, and would each player understand their role if all prose labels
     were removed? Do not accept a section because each checklist item has a token event; accept it only
     if it works as music. (Inspection is musical judgment + measurement, not clash-counting.) Then **RE-WALK YOUR PER-4-BAR
     PLAN element by element** and the **IDENTITY & CONTRAST LEDGER ROW**: for every planned event /
     instrument / gesture / ledger axis, account — realized, deliberately diverged, or missed. Confirm
     the section's continuity identity, fractalization target, detail mode, reserve role, contrast
     relation, and required audible event are realized as promised. Fix anything missed; anything you
     diverged from is DOCUMENTED with WHY IT IS BETTER (not merely acceptable) and escalated. Nothing
     the plan called for is silently absent. (The per-4-bar tier is the SECTION AGENT's responsibility
     — not the merge's.)
  4. **ADAPT & REFINE** — iterate (several passes) on what inspection found; really polish the phrase
     before passing it off. This is the audit/revise loop a one-shot pass lacks.
  5. Return the refined section AND its declared OUTPUTS, named (the exact material downstream
     sections consume), as NOTE-LISTS. Also export `CARD_ANCHORS` = [(card_name, bars, parts,
     fingerprint, note_list_excerpt), …] for every card claim. `CARDS_USED` may remain a short
     bibliography, but it is not proof of use. (+ any escalation note; HARD rules never silently
     rewritten, E10.)
Because the agent owns a whole phrase, its section is internally coherent; because it refines, it is
finished, not a first draft.

## PHASE D — MERGE (a MERGE AGENT, or the centre): seams + the whole (the genuine blind spot)
The merge is itself a fan-out task — a MERGE AGENT (see section_repair_procedure), not necessarily the orchestrator by hand.
- **VALIDATE EACH RETURN FIRST.** Every section's voices must parse as real note-lists (bar-sums
  correct, in-range, NOT prose strings). A prose return = a failed pass: re-run that section's agent
  with a stricter brief; do NOT let the merge silently paper over it by realizing the notes by hand.
- **SEAMS** are the real cross-section blind spot (the A/B agreed): walk every mid-level boundary —
  momentum through, pickup hand-offs, the composed caesuras/interruptions cut clean, the journey curve.
- **GLOBAL JOURNEY + SINGLE-VOICE:** does the destination land across the sections? do the split axes
  create contour instead of a generic last-third swell? does it read as one
  composer? (dialect drift is the mode's risk; the tiered narrative is the guard.)
- **PLAN-ADHERENCE (MID-LEVEL + MOVEMENT-LEVEL — NOT the per-4-bar; that is the section agents' job).**
  Diff the realization against the movement ROSTER, the structural/leitmotif ROLES, the mid-level
  section FUNCTIONS, the TEXTURE IDENTITY & CONTRAST LEDGER, the journey/destination map, the split
  peak axes, and the carry-forward.
  Flag to the user any planned voice / role / idea / ledger assignment that is unrealized or dropped
  (a whole planned instrument can otherwise go silent across a movement when no step owns this check;
  a movement's continuity identity can also become accidental default when no step owns contrast).
  Divergences allowed only with a documented "why it's
  BETTER," surfaced — never silent.
- Stage 7 (gates as a FLOOR only, narrative walk, grace walk, ledger). The verdict is the user's ear
  (J3); the merge does not minimize dissonance or maximize checkmarks — it serves the music. A score
  that validates but sounds inert returns to composition.

## PHASE E — POST-MERGE CYPHER/FRACTALIZATION FINAL PASS
After Phase D validates the merged movement, run
`reference/written/procedures/post_merge_cypher_fractalization_procedure.md`.
This is a whole-movement capstone pass for localized musical incidents that make
the score sound composed through the merge: early/late starts, cross-seam tails,
role swaps, one-bar cuts, sudden arrivals, rhythmic locks, selective doublings,
register holes, reserve spends, and resonance wakes. It is not a section repair
pass and not a checklist; the texture identity/contrast ledger axes are prompts
for invention, not slots to fill.

## CAUTIONS
- **DIVERGENCE RULE (every review cycle, every tier).** A divergence from the plan is allowed ONLY if
  documented with why it is *better*, not merely acceptable — and surfaced, never silent. "Acceptable"
  is not a license to drop or override a planned element; "better" is.
- Keep the assigned texture job; friction is color, and space is form. Polish toward good.
- Sparsity is not inactivity. If a section is sparse, it still needs a positive musical engine: melody,
  bass, pulse, harmonic field, pad, timbre process, register process, or silence-as-form.
- Pads are not banned. Use them when they are the right accompaniment or texture-class; avoid only
  unshaped default pads that replace a needed musical engine.
- A destination is required; a climax is optional. The destination may be loud, soft, dense, sparse,
  early, late, final, circular, withheld, broken, or suspended. Generic grow-peak-recede plans fail.
- Sections are MUSICAL phrases/arcs (8–24 bars), never arbitrary slices; aim for ~8–20 per movement.
- Agents REFINE (inspect→adapt loop); one-shot is forbidden.
- The genuinely hard rules — the calibration floors (H4) and the alignment law (H8) — are never
  fanned; agents escalate those.
- The user's ear is the verdict; the run yields a complete, refined draft for audition (J3).

## EXECUTION — the mechanics (data shapes, file layout, render)
Project conventions, not musical content — the WHAT-this-movement-is lives in `symphony/plan/`.
- **ARTIFACT MAP.** Read the movement's key / form / theme-assignment / study from **`symphony/plan/`**
  (the single source — see CURRENT-SOURCE LAW); theme pitches from `symphony/materials/themes.py`. All of
  a run's artifacts (prose + Python) live under `symphony/`, per the FRAME SPINE / SECTION / ASSEMBLER
  items below.
- **NOTE-LIST GRAMMAR** (the lingua franca every agent returns) is the production DSL absolute-event
  stream: note `C4:1`, rest `r:1`, chord `[C3,G3]:1`, marks `C4:1{mf,ten}`; flats use `Bb`, sharps
  use `F#`; AUDIBLE dynamics are the dynamic marks (`pp`..`fff`). Text markings are performer-facing
  only: techniques/instructions, not narrative labels, theme names, output ids, audits, or provenance.
  Bar-sums must validate through `production_view SOURCE.rb compile`.
- **FRAME SPINE** (A4's output) — `symphony/movements/<mvt>_spine.py` exposes: `ROSTER` /
  `ROSTER_NAMES` (the cast, score order, instrument classes), `SECTIONS` (the mid-level seams + per-section
  ql), `TEMPO_EVENTS`, `TOTAL`, `chord_map()`, `refs()`, the carry-forward cells, and the per-section LINES
  (each a `(roster_name, notelist)`).
- **SECTION REALIZATION** (each section agent's output) — `symphony/sections/<mvt>_s<n>_<label>.py`
  exposes: `PARTS` = `{roster_name: notelist}` (ACTIVE voices only — the assembler rest-fills the tacit
  ones), the named OUTPUTS it declares, `CARD_ANCHORS`, optional `CARDS_USED`, `DIVERGENCES`, and a
  `__main__` block asserting every PART sums to the section ql.
- **ASSEMBLER + RENDER** — `symphony/movements/<mvt>.py` imports the sections, rest-fills tacet voices to
  the full ROSTER, concatenates in `SECTIONS` order, builds via `mk_part`/`mk_score`, and emits the
  editor-aids package. Render: `PYTHONPATH=. python3 -m symphony.movements.<mvt>` → `outputs/movements/<mvt>/`.
  Every module/tool runs with `PYTHONPATH=.`. Use the schema in this document and live `framework/`
  helpers for the exact shape; only live current movement modules under `symphony/` may be consulted —
  removed/pre-rework material (git history, tag `v0.8`) is out of scope.
