# UNIFIED PROCEDURE v5 — THE CANONICAL ENTRYPOINT (single-context)
Every movement run, rework, or card batch STARTS by reading this document end-to-end.
It contains NO summaries of technique: every stage binds to annex sections holding the
complete recipes VERBATIM. When a stage says APPLY 06x sN, open that section and apply
EVERY item. No stage may be satisfied from memory of an annex.
This is the SINGLE-CONTEXT (one-mind, no-agent) procedure — every stage run by one composer.
For FANNED multi-agent execution see the fork `reference/written/procedures/orchestration_procedure.md`;
its distribution differs, but unified_procedure's rules, stages, and annexes bind there verbatim.

## 0. THE SOURCES MAP (what binds when)

DESIGN (what the work IS — read at Stage 0 grounding):
  symphony/plan/           THE PLAN — the single, self-contained source: premise + study model +
                           tonal plan + orchestral roster (00_overview.md); the theme roster
                           (themes.md); the per-movement seeds (movements.md). Authoritative for
                           keys, names, theme assignments, forms, and studies.
  research_foundations  influence frameworks; the style brief

METHOD (how composing works):
  composition_method    rationale annex: per-section procedure A.1-A.9 (cast, line
                           first, counterline, BASS-AS-LINE, inner-voice motion,
                           orchestrate, vary every return, composed transitions, gates)
  unified_procedure (this doc)            control flow, rules, stages

CRAFT ANNEXES (verbatim research; stages bind to them):
  ornamentation ornamentation        recipes, fingerprints, placement checklist, density caps
  orchestral_rhythm orchestral rhythm    figure catalogue, complementary law, strata, cross-rhythm
  chord_scoring chord scoring        spacing/low-interval limits, doubling, family methods,
                           voicing templates, harmonic-rhythm law
  dialogue_doubling dialogue & doubling  antiphony, fills, echoes, relays, mixture recipes, halos
  melody_primacy melody primacy       earworm research + melody law R1-R10 (theme cards)
  keyboard_figuration keyboard & figuration nocturne/elegy/piano-collections standards; figuration
                           taxonomy s6b; piano technique universe s6c; RHYTHMIC
                           SENTENCE law s6d; HIGH-WATER MARK + dialect doctrine s6e
  texture_identity_contrast_ledger Phase-A identity/contrast contract: continuity identity,
                           section job, fractalization target, detail mode, reserve role,
                           contrast relation

THEMATIC CORE (the material to HOLD TO — guidance, freely reshaped to serve the music; see H3):
  symphony/materials/themes.py     the melodies/CPs/variations (the core; mostly adhere, may reshape)
  technique_library/dsl/cards/       auditionable production-DSL card specimens
  technique_library/INDEX.md         card spec, index, audition->lock workflow, deployment law
  technique_library/16th_note_figures.md prose catalogue for dsl:figures.16th cards
  tools/lib.rb                     SEARCH the library (never load it whole) on two axes —
                                   CATEGORY (piano/voicing/chamberstrings/orchestral/orch.*/
                                   dialogue/figuration/elegy/callresponse/forms/melody) +
                                   FACET (lead/comp/
                                   counter/bass/rhythm/voicing/color/figuration/tender/tension/
                                   grief/section): `ruby tools/lib.rb <term>` / `... show
                                   <NAME>` / `... terms`. Agents are handed a few terms and pull
                                   cards on demand (operational detail in orchestration_procedure/section_repair_procedure). Audition a
                                   card with `framework/orchestral_dsl/ruby/bin/production_export`
                                   on its `.rb` source.

ACCOUNTABILITY (written during runs):
  09-13_mvtN_narrative     per-4-bar narratives (IMMUTABLE once written)
  ledger                every decision, correction, escalation, verdict
  texture_diagnosis     the texture-crisis evidence (cautionary reference)

TOOLS: verification/verify.py (gates G1-G17 + manifests), verification/vertical_test.py +
  vertical_allow.json, tools/narrative_dump.py (walk), tools/texture_diag.py +
  tools/card_metrics.py (figuration metrics), tools/probe.py (per-bar who-sounds-what).

CURRENT-SOURCE AUTHORITY:
  Runs are authored from the live tree only. Pre-rework material was removed (recoverable from git
  history / tag v0.8) and is not a source, model, scaffold, shape example, or fallback — do not resurrect
  it. symphony/plan/ is THE plan — the single source for current keys, theme names, assignments, forms,
  and studies; symphony/materials/themes.py holds the theme pitches. Any plan, tonal map, or theme name
  in older docs (the retired 02/03, project notes) is stale and does not govern.
  Narrow exception for uniqueness only: Phase-A A1/A2 survey other current movement mid-level briefs
  (`symphony/movements/*/02_midlevel.md` and `symphony/work/*/phaseA/A2_midlevel.md`, excluding the
  current run folder and user-declared stale/failed variants) to understand existing destination
  placements, rhythmic engines, texture-classes, register plans, and force profiles. This survey never
  overrides symphony/plan/ and never supplies material to copy.

## 1. RULE TAXONOMY — what binds how

HARD RULES (machine-enforced or absolute; violation = the work is wrong):
  H1 Gates G1-G17 must PASS (verify.py); G16 vertical findings triaged fix-or-register;
     G17 figuration floors (enforcing once cards lock). Gate pass is a floor, not completion:
     a musically inert score that passes must be recomposed until it works as music.
  H2 THE NARRATIVE IS BINDING, NOT INFALLIBLE once written: discrepancies are implemented in the
     score or ESCALATED — never silently amended (Stage 7.0). If musical review shows the narrative
     itself is causing bad music, revise the narrative explicitly with a written reason and surface it.
  H3 THEMATIC CORE: the themes (materials/themes.py: M1/S/M3/M2…) and the chord progression
     are the core to hold to. Make complex, interesting, good-sounding music that fits the
     style and mostly adheres to them; shape the melody, harmony, and bass as the music wants
     — they are yours to compose, grounded in that core.
  H4 CALIBRATION LAW: no gate floor is ever scaled DOWN by self-serve justification;
     downward calibration = user escalation.
  H5 MACHINE COUNTS (E4): all patch arithmetic asserted; bar sums asserted; gates
     detect mechanical flaws. They do not certify musicality; musical judgment still rules.
  H6 Concert pitch entry + atSoundingPitch export (core.py); XML written-pitch spot
     check at close. The deliverable is the XML.
  H7 FROZEN ARCHIVE: C:\Users\carse\Documents\Sigillum is never written to; exports
     go to a new folder only on user request.
  H8 ALIGNMENT LAW: EVERY moving line (melody AND counterlines AND borrowed/threaded
     material) is checked clause-bar-vs-ground-bar BEFORE threading (the five-times-
     proven failure class: phase, cycle, cadence misalignment).
  H9 E9 ORIGINALITY LAW: legible lineage to a named copyrighted work = fail,
     regardless of pitch differences; describe behavior, never provenance; the user's
     own works and traditional/generic vocabulary are free.

DOCTRINE (binding craft law; deviations need a written, narrative-named reason):
  D1 Melody law melody_primacy R1-R10; theme statements grounded in the theme material (G15 audits).
  D2 Engine-first ordering: establish the section's primary musical engine before accompaniment detail.
     In melody-led sections this means the lead first; in passacaglia, ostinato, groove, drone, chorale,
     ritual, or field-led sections, the bass/pulse/harmonic field may be the primary engine.
  D3 Accompaniment is COMPOSED, never generated (Stage 4.5): choose the type the passage
     calls for — counterline, walking bass, figuration, ostinato, chorale, pulse, drone,
     sustained pad/field, silence, or tacet. Realize it through locked texture cards or a new
     card escalated for audition FIRST. Bass has a musical role; inner voices have musical roles;
     a figure or field is thematic too and varies or breathes at phrase boundaries.
  D4 Figuration taxonomy keyboard_figuration s6b: type declared per layer per section. Broken-chord
     figuration and repeated figuration types are guarded against default reuse, but may dominate or
     recur when they are the declared engine of the form/passage and are varied musically.
  D5 RHYTHMIC SENTENCE law keyboard_figuration s6d: phrases traverse >= 2-3 value classes; rests are
     words; sentences pass between voices; uniform-value bars are declared effects.
  D6 DEPLOYMENT LAW: cards are vocabulary, pieces speak sentences. Card-texture runs
     > ~4 consecutive bars unchanged are allowed only when declared as the engine,
     such as ostinato, passacaglia, ritual, mechanical process, or ground bass.
     Otherwise vary deployment; use >= 2 value-class regions and >= 1 mid-bar
     gesture break per 8-bar span.
  D7 DIALECT DOCTRINE keyboard_figuration s6e.6: each movement declares at Stage 0 a SMALL set of
     signature sentence-shapes and complexity dialects DERIVED FROM ITS OWN THEME
     CELLS; movements never inherit another movement's signatures.
  D7b TEXTURE IDENTITY & CONTRAST LEDGER: Stage 0/A2 declares a ledger per
      texture_identity_contrast_ledger: each mid-level section gets a continuity identity,
      section job, fractalization target, detail mode, motion source, bass behavior, string role,
      density/space plan, register/color plan, reserve role, contrast relation, library search
      terms, and required audible event. The ledger states positive musical assignments at
      role/behavior level; section agents invent the notes and card realization inside it.
  D7c DIRECTED FRACTALIZATION: each stage contains more musical decisions than the prior stage
      by adding specificity on the assigned target: line, rhythm, color, register, silence,
      density, counterpoint, tutti, decay, seam, reserve, harmonic rhythm, figuration, pad/field,
      or dialogue.
      Increased detail can mean exact exposure, exact tacet/reserve, exact decay, exact handoff,
      exact tutti grammar, or denser counterpoint according to the section job.
  D8 Ornaments on RETURNS (ornamentation s3.5-6): default to clear first statements, but ornamented
     first statements are allowed when the style/form requires ornament as the identity. Dialect per
     dramatic context; density caps are interpreted against the passage's declared texture.
  D9 Union-surface law (orchestral_rhythm s2 / keyboard_figuration s6): when the section asks for
     active multi-layer texture, attacks of all layers make a continuous surface and no single layer
     carries it all. Monody, solo texture, chant, drone/field, exposed windows, and deliberate voids
     use their own declared engine instead.
  D10 Registered-dissonance dramaturgy (gathers, blows, collapses) is licensed by the
     movement's narrative and ANSWERED (resolved/destroyed); cards may carry such
     phrases, the movement must express them correctly.
  D11 Composed transitions and composed endings (composition_method A.8): liquidation -> sequence ->
     acceleration -> caesura, cut, cadence, chorale, held field, resonance, or another concrete ending
     type. Endings dissolve through the orchestra only when dissolution is the music's real ending.
  D12 chord_scoring verticals: every vertical walks the audit checklist; re-attack/re-voice at
      changes; suspensions in traceable colors.
  D13 JOURNEY / DESTINATION LAW: every movement declares a varied musical journey toward a named
      destination, not a generic build to a climax. The destination is the musical state the movement
      travels toward: arrival, transformation, rupture, exhaustion, release, suspension,
      disappearance, homecoming, ritual lock, or refusal. Do not assume the destination occurs at
      70-80% of the movement; if the strongest event lands in the last third, explain why the form
      requires it. Dynamic maximum, density maximum, registral maximum, harmonic arrival, tutti
      arrival, percussion spend, melodic high point, and formal destination are separate axes unless
      the movement explicitly declares convergence.

JUDGMENT (verdicts, not floors — written into the ledger):
  J1 THE HIGH-WATER MARK (keyboard_figuration s6e; user-locked): P17-P19 define the complexity bar.
     Per section: does some passage REACH it? Does the movement SKEW toward
     sentence-class writing? Is every simple stretch simple ON PURPOSE and NAMED
     (silence / proclamation / theme declaration)?
  J2 THE BAR IS NOT A RHYTHM: complexity earns the bar on ANY axis (rhythmic,
     contrapuntal, harmonic, registral, textural, conversational) — the V sentence
     shape is V's dialect, not a formula. Machine indicators locate; judgment decides.
  J3 The grace-walk question is "would a musician praise the CRAFT of this passage,"
     never "did it pass a floor." Also ask: what is the active engine, and would the
     passage work if all prose labels were removed? Taste is the user's; the craft floor is the gates'.

## 2. EXECUTION RULES (mechanics of fidelity)
The failure mode is not forgetting: at generation time the pull is toward the generic
prior, and research loses unless these hold. Mandatory:
 E1 RE-READ: each stage begins with a literal Read of its annex IN THE SAME WORK UNIT
    as the writing. Earlier-session reading is gist; only just-read text binds.
 E2 SMALL UNITS: compose one section (8-24 bars) under one stage. Never "do the
    movement" — averaging over long spans is where the mean wins.
 E3 DECIDE BEFORE COMPOSING — TWO LAYERS: Layer 1 (Stage 0, once): what each section
    IS — no bar placements, but including its identity/contrast ledger row. Layer 2 (per stage,
    per section, immediately before composing): a written micro-decision table MUSICAL EVENT ->
    annex item -> bar/beat, made by reading the music as it now stands. Composing implements a
    written decision; it is never free generation from gist.
 E4 MACHINE COUNTS: asserts on all arithmetic; gates measure what annexes demand. Counts locate
    possible problems; they do not overrule the ear.
 E5 UNUSED-ITEMS LEDGER: per section, log applied annex items; after the movement,
    diff against the full item list; every unused item gets a reason or a placement.
 E6 PER-4-BAR NARRATIVE: grounding prerequisite (re-read symphony/plan/ (the movement seed) +
    Stage 0 frames in the same work unit); then per 4-bar group: (a) every orchestral
    section gets a verb ("sustains" is valid whenever the intended texture is a pad, field,
    chorale, pressure, resonance, or held breath; repeated sustain needs shape, variation, or a named
    function; tacet needs a because); (b) >= 1 EVENT vs the previous group, or a written justification.
    PLUS (texture amendment): the narrative declares FIGURATION PLANS per group —
    card name + type + variation triggers + active fractalization target, with
    role labels plus concrete action.
    8-bar blocks only while a melody/progression genuinely develops across both halves.
 E7 DENSITY / EVENT LAW (calibrated vs the reference score): gates G12/G13 hold the density required
    by the movement's declared form, scaled per movement BY ESCALATION ONLY (H4). Required events are
    form-dependent, not universal: seam fill, dual melody, background run, driver inversion, and
    3-job stratification are available tools only when the movement's type calls for them. The narrative
    names the actual required events for this movement.
 E8 EXAMPLES ARE ILLUSTRATIONS, NOT SPECS: a user example points at a QUALITY;
    extract the principle, realize it through OWN invention, differently each time.
    Never cite an example back as "the user's requirement." THIRD FLAVOR (committed
    2026-06: examples -> closed taxonomy -> "LAW"): encoding the user's examples as
    an exhaustive list is the same failure as copying them — it closes the space
    they were opening. The correct response to examples: SEARCH the space, harvest
    parallels beyond them, INVENT forms fitted to the current movement, and leave
    the category open.
 E9 ORIGINALITY LAW: see H9; originality check at every theme/card review (name the
    nearest reference; state why lineage is NOT legible).
 E10 QUESTIONS ARE QUESTIONS: when the user asks whether something is intentional or
    how it works — ANSWER, then propose options and ASK. Executing a "correction" to
    an un-asked-for change is overcompensation (committed once: V2 rev 2).
    Corollary: when a gate/law fights the music, the order is (1) raise the craft,
    (2) escalate; never silently lower the bar or silently rewrite the claim.

## 3. THE STAGES (in order; stages 2-5 run whole-movement before the next begins,
##    section-by-section within each under the E3 Layer-2 loop)

STAGE 0 — PLAN (Layer 1; no bar placements)
 a. GROUNDING: re-read symphony/plan/ (the movement seed + theme roster)
    for the movement's material + this document.
 b. CROSS-MOVEMENT MID-LEVEL SURVEY (D13): A1/A2 read the other current movement mid-level briefs
    named by the centre or found at `symphony/movements/*/02_midlevel.md` and
    `symphony/work/*/phaseA/A2_midlevel.md`, excluding the current run folder and stale/failed variants.
    Return a compact contrast note: where existing movements place destinations, what engines and
    texture-classes they use, their register/force profiles, and how this movement will be unique.
 c. JOURNEY / DESTINATION MAP (D13): name the destination state and its placement — early revelation,
    midpoint turn, late arrival, final bar, recurring return, plateau, collapse, or withheld arrival.
    Split the axes explicitly: dynamic maximum, density maximum, registral maximum, harmonic arrival,
    tutti arrival, percussion spend, melodic high point, and formal destination. Coincide them only
    when convergence is the declared design.
 d. Section frames: bars, harmony timeline, function, journey curve [symphony/plan/ + D13]; rhythm
    profile row [orchestral_rhythm s6]; texture cast (LINE/COUNTER/MOTION/BASS/FLOOR/PUNCT) from
    the STANDARD ROSTER; dialogue cast (2-3 characters) [dialogue_doubling sA2]; doubling
    vocabulary (<=4 recipes, theme-mapped) [dialogue_doubling s5-s7]; ornament budget [ornamentation s4-s5].
 e. TEXTURE IDENTITY & CONTRAST LEDGER (D7b-D7c): one row per mid-level section from
    texture_identity_contrast_ledger, declaring continuity identity, section job,
    fractalization target, detail mode, motion source, bass behavior, string role,
    density/space, register/color, reserve role, contrast relation, search terms, and
    required audible event.
 f. DIALECT DECLARATION (D7): the movement's signature sentence-shapes + complexity
    dialects, derived from its own theme cells; its card-set named (existing cards
    or new cards to compose AND AUDITION before threading).
 g. ALIGNMENT PRE-CHECK (H8): every melody/CP/threaded line vs the actual ground,
    clause-bar-vs-ground-bar, BEFORE any threading.
 h. Manifest declared in verify.py: lead[], theme[], harm{} timeline, den/rot, ost,
    floor, lil_ok, voids (justified), destination_shape, climax only if applicable,
    orn_min, perc — with MIDI-name matching verified (probe one bar).
 i. Sketch audit if a sketch exists: keep/credit vs rebuild, written.

STAGE E6 — THE NARRATIVE (binding but revisable by explicit musical escalation; see H2/E6 above)

STAGE 1 — PRIMARY ENGINE / LINES (engine-first; accompaniment detail waits for the engine)
 1.1 PRIMARY ENGINE per section: complete melodic thought, bass ground, ostinato, chorale, pulse,
     drone/field, or other declared engine. Theme statements = locked cards when the engine is thematic;
     melody_primacy R1-R10 applies to melody-led passages; fingerprint declared [ornamentation s2].
     G15 audits thematic statements.
 1.2 COUNTER: species discipline, suspensions at changes, invertible, displaced
     high point or destination axis — and H8-checked against the ground.
 1.3 BASS-AS-LINE / BASS-AS-FIELD (composition_method A.4): walking motion, passing tones,
     anticipations, register events, or an intentional pedal/field/drone when that is the engine.
     ROOTQ-style whole-note roots are failures only when they are undeclared placeholders; declared
     floor/field roles must be shaped.
 1.4 VARIATION PLAN for every restatement, device chosen now [ornamentation s3.5 / dialogue_doubling sA3-A4 /
     H7-reharmonization / re-register / new countermelody].
 CHECK: engine-through — the declared musical engine is audible every 4 bars, or the void is declared.

STAGE 2 — RHYTHMIC FABRIC -> APPLY orchestral_rhythm IN FULL
(figure catalogue with idiom notes; value classes one per layer; complementary law
 bar-by-bar incl. union target where the section asks for multi-layer motion; homorhythm budget and
 approach/exit shaped by form; cross-rhythm dosage; intensity dial across journeys/builds.)

STAGE 3 — DIALOGUE -> APPLY dialogue_doubling PART A IN FULL
 (fills WHERE/WHO + checklist 1-2; echo conversions one axis; Mahler relays; antiphonal
 escalation; heterophony on M3; 2-3 consistent characters per section.)

STAGE 4 — ORNAMENT -> APPLY ornamentation IN FULL
(placement checklist per lead phrase; deterministic recipes; dialect by context;
 idiom table + density caps interpreted by texture; returns by default, first statements when ornament
 is the style/form's identity.)

STAGE 4.5 — ACCOMPANIMENT PASS (the texture-crisis stage; D3-D6, D9)
 Accompaniment is COMPOSED through the movement's declared card-set, mixed at phrase
 level per the DEPLOYMENT LAW, sentences per the SENTENCE LAW, types per the
 TAXONOMY ration. Any texture without a locked card: compose the card, AUDITION with
 the user, lock, THEN thread. The library grows ahead of the music.

STAGE 5 — VERTICALS & COLOR -> APPLY chord_scoring IN FULL + dialogue_doubling PART B
 (the 10-item vertical audit on EVERY vertical; voicing templates; doubling checklist
 1-8 incl. grey-sound scan and event-only/peak-only highlighting as the form declares.)

STAGE 6 — FINISH
 (hairpins on intensifications/decays/fields; articulation + technique text at every change;
 percussion budget follows the movement type: structural downbeats, color events, ritual pulse,
 cadence, destination/convergence, or withheld percussion as declared.)

STAGE 7 — VERIFY & CLOSE
 7.0  NARRATIVE WALK (H2): narrative_dump.py per 4-bar group vs the narrative, GROUP
      BY GROUP — every verb, event, foreground claim, seam fill, figuration plan,
      identity/contrast row, fractalization target, detail mode, deployment citation.
      Discrepancies: implement in score, or escalate; score exceeding a claim = logged
      bonus. The narrative is the working bar; if that bar is causing bad music, revise it explicitly
      and surface why.
 7.04 GRACE WALK (J1-J3): written verdict per section against the high-water mark;
      simple stretches named-or-recomposed; verdicts to the ledger.
 7.05 VERTICAL TEST: vertical_test.py; every finding FIXED (programming error) or
      REGISTERED with a reason naming the design object (vertical_allow.json). G16.
 7.1  verify.py until PASS G1-G17. PASS is not DONE: if the grace walk or audition says the music is
      inert, trope-driven, or only explained by prose labels, return to composition.
 7.2  Manifest finalized (justified voids/floors/ost/destination_shape; climax only if it is the
      declared destination or event).
 7.3  Chordify seam checks; rebuild movement + assemblies; update the 04 audit row.
 7.35 XML SPOT CHECK (H6): written pitches on one transposing part (or spelling on a
      flat-side movement).
 7.4  LEDGER the run (decisions, escalations, verdicts, unused-items diff) and
      PRESENT. Taste is the user's; the craft floor is the gates'.

## 4. ANTI-REGRESSION CLAUSES (the failure modes this document exists to prevent)
- Pads-first writing (default sustained accompaniment before the lead or musical engine exists).
  Pads themselves are permitted when the movement or passage calls for a sustained field.
- "*N" stencil expansion outside declared ostinato, passacaglia, ritual, mechanical,
  or ground-bass roles; chord-transposed stencils (same figure, new chord) count as
  stencils when they function as accidental copy/paste rather than declared engine
  repetition.
- Positional rules (every-Nth-bar); variation triggers are musical events.
- Default last-third swell: grow-peak-recede is rejected unless the movement's researched form and
  cross-movement survey justify that destination placement and split-axis convergence.
- Undeclared emptiness; undeclared simplicity (J1.3).
- Reactive spot-fixing across stages; whole-movement stage ordering holds.
- Substituting a remembered summary for annex text (summarization once destroyed 90%
  of research fidelity).
- Lowering a gate, amending a narrative, or recomposing on an un-asked question
  instead of raising craft / escalating / answering (H4, H2, E10).
- One-technique blocks in pieces (the deployment law D6): the exposition format of
  cards never ships as movement fabric.
- Importing another movement's dialect (D7) or treating the bar as one rhythm (J2).
- Fractalization breadth: added detail lives in exposure, reserve, register relief,
  role change, silence, seam craft, and homorhythm.

## 5. STANDING USER RULINGS (verbatim anchors; never relitigate silently)
- "do not regress to the mean" — every run diligent, task-tracked, no compression.
- Melody primacy: hummable paragraphs with start/middle/end; the movement plan (symphony/plan/)
  governs all threading.
- Narrative immutability rulings: keep the stagger / keep the cut / keep the 4-link
  relay (Mvt II walk).
- The high-water mark: P17-19 = the bar, as JUDGMENT; simplicity allowed when named
  (silence/proclamation/declaration); "there are millions of permutations" (J2).
- Cards may carry dramaturgic dissonance; movements must express and resolve it (D10).
- The library grows AHEAD of the music; cards lock only by user audition.
- Gate floors move only by escalation (H4). Frozen archive (H7).

## 6. EXECUTION MODE
This is the SINGLE-CONTEXT (one-mind, no-agent) procedure: every stage is run by one composer.
For FANNED multi-agent execution (one agent per stage per section), see
`reference/written/procedures/orchestration_procedure.md` (a fork; unified_procedure's H/D/J rules + stages bind verbatim there).
