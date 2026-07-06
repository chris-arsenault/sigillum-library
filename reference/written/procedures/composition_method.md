# Composition Method — binding procedure (operationalizing the research)

Why this exists: the research (research_foundations) contained every principle later violated; each user-caught
flaw mapped to an already-written finding. The failure was process, not knowledge. This document
converts the research into (a) a per-section composition procedure and (b) measurable quality
gates enforced by `verification/verify.py`. Gates are a craft floor only. A movement is not done until
it passes its gates AND survives musical judgment: the accompaniment type fits the passage, the active
engine is audible, and the score works without prose explaining what it meant to do.

Movement planning declares a journey and destination, not a generic build to a climax. The destination
is the musical state the movement travels toward: arrival, transformation, rupture, exhaustion, release,
suspension, disappearance, homecoming, ritual lock, or refusal. The plan separates dynamic maximum,
density maximum, registral maximum, harmonic arrival, tutti arrival, percussion spend, melodic high
point, and formal destination unless the form specifically wants convergence.

## A. Per-section composition procedure (in this order, no skipping)

1. CAST the texture. Name the roles explicitly: who is the LINE (foreground melody/counterline),
   who is MOTION (figuration stratum), who is BASS (a line, not roots), who is FLOOR/FIELD
   (pedal, drone, pad, harmonic field, pressure, glow, or breath — if the passage calls for one).
   Every part in the section has a positive musical role.
   The MOTION / comp / figuration strata are realized from the locked texture-card library —
   SEARCH it by CATEGORY + FACET via `ruby tools/lib.rb <term>` (see unified_procedure / orchestration_procedure / section_repair_procedure), never
   stamped from a formula.
2. ESTABLISH THE PRIMARY ENGINE FIRST. In melody-led music, write the line as a complete melodic
   thought spanning the whole section — phrases with contour, destination/arrival, and breaths. In
   passacaglia, ostinato, groove, drone, chorale, ritual, or field-led music, establish the bass,
   pulse, harmonic field, or chorale engine first. Some musical engine is active except declared voids.
3. WRITE THE COUNTERLINE OR COMPLEMENTARY LAYER against it when the section's texture calls for one:
   species discipline, suspensions at chord changes, invertible counterpoint, rhythmic complement,
   or another role-specific response. Do not force fake counterpoint into monody, drone, or field-led
   passages.
4. WRITE THE BASS as a line: walking motion, passing tones, anticipations of harmonic change,
   register events at phrase boundaries (per the interlocked-bassline standard of rev 2).
5. FILL inner voices according to the accompaniment type the passage calls for. If the music needs
   motion, use stepwise lines, suspensions at changes, re-attacks, and hand-offs between desks. If the
   music needs a sustained pad or field, voice it intentionally: register, color, entry/release shape,
   dynamic life, and harmonic function must be clear. Pads are allowed; default pads are not.
6. ORCHESTRATE per research conventions as tools, not universal formulas: octave doublings over
   unisons where they help; celli+horn for noble lines where that color is wanted; response figures
   in phrase gaps; destinations, plateaus, cuts, or ritual arrivals orchestrated according to the
   movement type. Cymbals/percussion sound where the form earns them, not only at a generic peak.
7. VARY every return unless literal repetition is the declared engine (ostinato, passacaglia, ritual,
   incantation, mechanical fixation). Variation may be ornament, re-registering, extension,
   reharmonization, changed accompaniment, changed voicing, or new countermelody; literal repeats
   must be purposeful and framed.
8. CONNECT: sections join by composed transitions (liquidate -> sequence -> harmonic acceleration
   -> caesura/pickup), and endings are composed according to their musical type: dissolution through
   the orchestra, a chorale close, a held field, a cut, a cadence, or another concrete ending. Sustained
   chords are valid when they are the chosen ending, not when they are a default placeholder.
9. GATE-CHECK (run verify.py). Fix failures. Then do a musical review: if the passage passed the gates
   but sounds inert, trope-driven, or only justified by prose labels, revise the music.

## B. Quality gates (automated; manifests declare intentional exceptions)

- G1 PRIMARY ENGINE PRESENCE: every 4-bar window contains the declared musical engine. In melody-led
  music this is a line (>=4 onsets, >=3 pitches, stepwise majority) in some part; in other forms it may
  be bass ground, ostinato, chorale, drone/field, pulse, or silence-as-form — except declared VOID
  windows (max 2 consecutive).
  [catches: "one intro melody then nothing", "18 bars of undeclared whole notes"]
- G2 RHYTHMIC STRATA: per 8-bar window, >=2 strata present (fast <=8ths / medium q-h / slow);
  fast stratum present in >=70% of non-void windows.
  [catches: everything-at-half-note-speed]
- G3 LITERAL REPEAT / ENGINE REPETITION: identical >=8-bar repeats are failures when
  they are accidental stencil expansion. Declared ostinato, passacaglia, ritual,
  mechanical, or ground-bass roles may repeat literally when repetition is the engine;
  validation checks that surrounding context, voicing, dynamics, register, or formal
  placement makes the repetition purposeful.
  [catches: stencil expansion]
- G4 COUNTERPOINT / RELATIONSHIP QUOTA: per movement, the declared texture determines how much
  independent line-work is required. Contrapuntal movements need many windows where two simultaneous
  lines move with directional independence; monody, drone, chorale, and field-led forms may satisfy
  this with other clear foreground/background relationships.
  [catches: "maybe one counterpoint in a contrapuntal score"]
- G5 SUSTAIN HYGIENE: sustained notes or pads longer than 2 bars must be declared as FLOOR/FIELD,
  chorale, suspension, pressure, resonance, or another intentional role with shaped entry/release.
  [catches: accidental whole-note drones in non-sustain roles]
- G6 JOURNEY / DESTINATION AGREEMENT: measured density must match the movement's declared journey,
  destination, and split axes. A climax form may peak in its declared window; a passacaglia, chorale,
  ritual, plateau, rondo, early revelation, final-bar arrival, withheld arrival, or anti-climax may need
  a different density shape. The gate confirms the chosen form, not a universal swell-and-fade.
- G7 TEXTURE FLOOR: share of bars with >=4 independent sounding parts meets the per-movement
  floor (chamber IV lower; tuttis higher).

## C. Workflow

Recomposition queue uses the gate scorecard and the musical review together. Start with passages that
fail hard checks, but do not ignore passages that pass numerically and fail musically. Each movement:
full procedure (A), gates (B), then musical review against the intended form and accompaniment engine.
The user judges character and taste; the gates judge only craft floor.

## D. Texture pass stack
After sec A and before gates, run the explicit passes of reference/written/craft/texture_craft.md:
P1 ornamentation, P2 orchestral rhythm, P3 chord voicing, P4 dialogue, P5 strategic
doubling, P6 variation-of-return, P7 gates. One pass at a time, whole movement per sitting.

## SUPERSEDED FOR EXECUTION
The applicable runbook is reference/written/procedures/unified_procedure.md; this document remains the rationale annex.
