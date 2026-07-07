# DSL NEW-COMPOSITION PROCEDURE v2

This is the canonical procedure for composing new music whose source of truth is the Ruby production
DSL. It starts from a new-composition brief and carries the piece through research, form design,
material design, section writing, revision, export, audition, and closeout in one pass stack.

The purpose is not to create more paperwork. The purpose is to stop an agent from satisfying the
procedure by naming a form, citing research, filling a DSL file, and asking review questions in prose.
Every procedure artifact below is useful only if it changes notes, timing, register, harmony, role,
texture, control, or silence.

## Cardinal Principle

The DSL exists to make the music readable while it is being composed. The score source should expose
the relationships the ear needs: foreground, bass, counterline, pulse, pad, color, silence, harmony,
entrance timing, register plan, phrase shape, controls, and local verticals.

Compiler success is only a floor. A piece is not done until the notation itself explains the musical
engine, the materials have identity, the accompaniment is composed, and the form moves from purpose
rather than from blocks of technique.

**Sounding projections are primary.** The projection suite is split: SOUNDING projections
(adjacency_profile, recurrence_map, peak_axes, rhythm_profile, articulation_map, breath_map,
implied_harmony, ensemble_grid, exposed_clashes, verticals, line, grid) derive from the notes and
report what a listener hears; declared-intent projections (roles, harmony, harmony_with_melody,
foreground, bass_path, material_map, gesture_map, structure) read authored assertions and are
SECONDARY - they verify that prose and roles match the music, never that the music is good. Judge
every pass by the sounding readouts first; a declared-intent view can only confirm bookkeeping.

## Completion Standard - No Draft Exit

When the user asks to run the whole DSL procedure, the expected output is a completed composition, not
an exportable first draft. Do not stop merely because the source compiles, exports, has a plausible
form contract, and passes mechanical projections.

The procedure is not complete while any of these statements would still be true:

- "This is a complete draft."
- "This still needs a real musical revision pass."
- "This still needs listening, score-reading, idiom, range, breath, or playability review."
- "The next pass should decide whether the material is memorable or idiomatic."
- "The result is mechanically complete, but not musically finished."

If the preferred review medium is unavailable, use the strongest available substitute and keep going.
If audio playback is unavailable, perform a score-and-MIDI read using the exported MusicXML/MIDI plus
DSL projections; that is still an audition step and must produce musical judgments tied to bars and
parts.

Do not exit by downgrading the task after the fact. If the user asked for the musical procedure and
you discover that it was not actually run, run the missing procedure stages. Do not replace the work
with a status label, a patch-only closeout, a question about whether to continue, or mechanical
validation.

A first full source plus export is the start of completion, not the end. After first export, run a
post-export musical audit, revise the DSL source, re-export, and re-check. Repeat until the audit no
longer finds material weaknesses. The closeout must name the final musical verdict, not only the
commands that passed.

## Source Discipline

Write the sounding music into the DSL source itself.

The committed score source should show the actual pitches, rhythms, chords, rests, controls,
placements, and checkpoints a reader needs to inspect the passage. It should not depend on code that
expands elsewhere into eight bars of accompaniment, transposes a pattern through a progression, or
repeats a card as final sounding material. Such code can help with analysis, validation, extraction,
or temporary drafting, but the finished score source must contain the resulting musical material
directly.

The reason is musical: when the notes are only produced indirectly, the agent cannot see whether the
passage has become blocky, unplayable, harmonically unsupported, or generic.

## Read Order

For a new DSL composition, read in this order:

1. `docs/architecture/orchestral_dsl/INDEX.md`
2. `docs/architecture/orchestral_dsl/00_llm_contract.md`
3. `docs/architecture/orchestral_dsl/01_container.md`
4. `docs/architecture/orchestral_dsl/02_surface_decision.md`
5. `docs/architecture/orchestral_dsl/05_compile_api.md`
6. the relevant surface files under `docs/architecture/orchestral_dsl/surfaces/`

Before authoring, also ask the runtime what the current DSL supports:

```bash
partitura/bin/dsl_help production
partitura/bin/dsl_help decision
```

If using an unfamiliar surface or export path, call the focused help topic before writing that part
of the source.

The default authoring shape is:

```text
production_piece -> section -> span -> phrase -> placement -> staff_bar -> control -> projection
```

## Binding Craft Imports

The older procedures are not a second checklist to run in parallel. Their binding musical standards
are imported here:

| Imported standard | DSL procedure location | When to reread the older source |
|---|---|---|
| Journey and destination, not default climax | Stages 0, 1, 9 | When destination placement or peak axes are unclear. |
| Big structural contrast between pieces | Stage 0 | When composing inside a larger set. |
| Engine first; every player has a role | Stages 1, 4, 5, 9 | When a span's active engine is vague. |
| Bass as line, accompaniment as composed material | Stages 4, 5, 9 | When support is roots, pads, or repeated figures by default. |
| Texture identity and contrast ledger | Stage 1 | When section contrast or reserve is weak. |
| Rhythmic sentence law and complementary rhythm | Stages 1, 4, 5, 9 | When rhythm sounds uniform or stratification is unclear. |
| Prose labels do not substitute for music | Source Discipline, Stages 4, 5, 9 | When a gesture claim is not audible without text. |
| Directed fractalization below section level | Stages 5, 6, 9 | When the piece sounds like technique blocks. |
| Returns must carry identity and change | Stages 4, 7, 9 | When themes/processes recur. |
| Validation gates are floors | Stages 5, 9, 10 | When compiler/export success tempts early closure. |
| Fresh attention on small musical units | Stages 1, 5, 9, 10 | When the piece is being authored as one long undifferentiated pass. |
| Carry-forward chain and divergence rule | Stages 1, 5, 7, 9 | When material returns, transforms, or moves between sections. |
| Per-4-bar or phrase-grain narrative | Stages 1, 5, 9 | When spans risk becoming blocks of technique. |
| Beat/bar-level differentiation and rests | Stages 1, 4, 5, 6, 9 | When local blocks are decent but the whole piece feels monotonous. |
| Block-transition failure modes | Stages 1, 5, 6, 9 | When a texture, card, or accompaniment starts behaving like a section-sized stencil. |

Use the old files for depth when the relevant musical problem appears. Do not reread them
ritualistically if the imported standard already gives a clear action.

## Fresh Attention Model

The agent-based orchestration procedure uses multiple agents to force fresh attention on small musical
units. The DSL procedure keeps the workflow lighter, but imports that purpose: a complete DSL run must
separate attention into distinct passes. For a nontrivial complete piece, actual fresh contexts or
agents are the preferred standard, especially for span realization and whole-piece review. Do not avoid
fresh agents merely to move faster.

Same-agent sequential passes are a fallback, not an equivalence claim. Use the fallback only when
multi-agent execution is unavailable, the user explicitly asks for one-context work, or the piece is a
true miniature. When using the fallback, stop between passes, reread the relevant contract/projection
before judging the next unit, and record the pass note before continuing. The requirement is not
parallelism. The requirement is that planning, local composition, merge review, and completion audit do
not blur into one long pass.

Unless the user explicitly opts out, use fresh agents or fresh contexts for any DSL run that is more
than a brief miniature: roughly over 90 seconds, more than three forces, more than three sections, or
requested as "the whole DSL procedure." At minimum, separate fresh attention must cover the span-pass
work and the merge/completion review. If only one agent is available, state that limitation in the
closeout and treat the same-agent pass notes as a weaker substitute, not proof that attention was
equally fresh.

Required attention passes:

1. **Form pass.** Stages 0-1 decide the piece type, journey, destination, axis split, section
   functions, texture identities, per-4-bar or phrase-grain events, beat/bar differentiation, and
   material carry-forward.
2. **Frame pass.** Stage 3 creates a living DSL frame: sections, spans, harmony regions, controls, and
   initial source landmarks. The frame guides composition but does not lock it.
3. **Span pass.** Stage 5 writes one musical phrase/arc at a time. A span pass owns all sounding
   voices in that phrase, composes the active engine and support, inspects the projection, revises, and
   records outputs or divergences before the next phrase starts.
4. **Merge pass.** Stage 9 reads the whole piece after the span passes as if written by someone else:
   seams, journey, single-voice continuity, plan adherence, unused commitments, and silent divergences.
5. **Completion pass.** Stage 10 audits the exported result, revises the DSL source, re-exports, and
   records a musical closeout verdict.

Do not collapse the span pass and merge pass just because the source compiles. For very short works the
written pass notes may be compact, but the passes still occur in order. A useful pass note names:

```text
Pass | bars/spans | decisions made | weaknesses found | source revisions | outputs/divergences
```

The old multi-agent breakdown is intentionally not imported wholesale. The DSL needs enough fresh
attention to prevent loss of focus halfway through the work, not a separate agent for every conceptual
layer.

## Research Routing

Load research by musical job. Do not cite a document unless it changes the music.

**Form and large-scale process**

- `reference/written/procedures/unified_procedure.md`
- `reference/written/procedures/composition_method.md`
- `reference/written/craft/texture_identity_contrast_ledger.md`
- `reference/written/surveys/ground_bass.md`
- `technique_library/dsl/README.md` categories `dsl:forms`, `dsl:callresponse`, `dsl:dialogue`

If the chosen form type is not covered by existing repo research, do a focused form-research pass
before writing the DSL frame. The minimum result is not a literature report; it is a section plan,
return scheme, cadence/denial plan, and destination contract.

**Melody, theme, and motive identity**

- `reference/written/craft/melody_primacy.md`
- `reference/written/craft/melody_theory_foundations.md`
- `reference/written/craft/MELODY_CRAFT_DOCTRINE.md`
- `reference/written/craft/exposing_the_progression.md`
- `reference/written/craft/melody_progression_exemplars.md`
- `reference/written/surveys/implied_harmony_single_line.md`
- `reference/written/surveys/melodic_harmonic_implication_theory.md`
- `reference/written/surveys/harmonic_ambiguity_failure_modes.md`
- `reference/written/surveys/harmonic_mislead.md`
- `reference/written/surveys/descending_fifths_melodic_sequence.md`
- `reference/written/surveys/modal_melody.md`
- `reference/written/surveys/modulating_melody.md`
- `reference/written/surveys/jazz_outlining_changes.md`
- `reference/written/surveys/axis_recolor_engine.md`

Use these when composing A/B themes, cells, foreground lines, melodic returns, and melody-only
harmonic implication.

**Rhythm, accompaniment, and figuration**

- `reference/written/craft/orchestral_rhythm.md`
- `reference/written/craft/keyboard_figuration.md`
- `reference/written/craft/texture_diagnosis.md`
- `reference/written/surveys/complementary_rhythm.md`
- `reference/written/surveys/running_counterpoint.md`
- `reference/written/surveys/sixteenth_deployment.md`
- `reference/written/surveys/ground_bass.md`
- `technique_library/16th_note_figures.md`
- `technique_library/dsl/README.md`

Use these when writing bass, inner motion, accompaniment, figuration, rhythmic engines, and
technique-derived passages.

**Texture, orchestration, voicing, and color**

- `reference/written/craft/texture_identity_contrast_ledger.md`
- `reference/written/craft/texture_craft.md`
- `reference/written/craft/chord_scoring.md`
- `reference/written/craft/dialogue_doubling.md`
- `reference/written/craft/ornamentation.md`
- `reference/written/surveys/orchestration_techniques.md`
- `reference/written/surveys/string_techniques.md`
- `reference/written/surveys/piano_voicing.md`
- `reference/written/surveys/reinforce_contrast.md`

Use these when assigning roles, shaping mass, scoring chords, designing pads/fields, writing dialogue,
placing doublings, or managing register and color.

**Technique library**

Use `technique_library/dsl/README.md` for card references. The auditionable DSL
card specimens live under `technique_library/dsl/cards/`. Search with:

```bash
ruby tools/lib.rb <term>
```

Then cite the result as `dsl:<category>/<id>`, never as a Python module path, in any new DSL brief or
score note. Cards can supply technique names, high-water marks, role models,
dialect seeds, and concrete listening checks. They do not replace composition.
If a card influences a new piece, read the card's `.rb` source, adapt its
musical idea to the piece's own material, and write the adapted notes directly
in the DSL.

## Stage 0 - Brief, Form, And Destination

Before writing notes, state the piece in structural terms:

- Forces and approximate duration.
- Meaningful form type: sonata, rondo, fugue, passacaglia, theme and variations, chorale prelude,
  elegy, toccata, etude, ritornello, song form, suite movement, scene, miniature, or another real
  type.
- Journey and destination state: arrival, transformation, rupture, exhaustion, release, suspension,
  disappearance, homecoming, ritual lock, refusal, plateau, collapse, or withheld arrival.
- Destination placement: early revelation, midpoint turn, late arrival, final bar, recurring return,
  plateau, collapse, or withheld arrival.
- Primary musical materials expected: A, B, ground, refrain, subject, countersubject, bass law,
  rhythmic engine, harmonic field, or figuration dialect.
- Which axes are separate and which may converge: dynamic maximum, density maximum, registral
  maximum, harmonic arrival, mass/tutti arrival, attack/percussion spend, melodic high point, and
  formal destination.
- Journey curve: the sequence of musical state changes that makes the whole piece travel. Name at
  least the starting state, the destination state, and the aftermath or changed-return state. Do not
  let this collapse into "section A, then section B, then louder return."

If the piece belongs to a larger set, check the other current pieces enough to make this one
different by large structural levers: form type, forces, tempo, register, texture class, rhythmic
engine, destination placement, and force profile. Do not rely on mood, idiom, or subtle color alone.

## Stage 1 - Form And Texture Contract

Before creating the DSL frame, make the form specific enough that the source will not become a row of
containers.

This is a musical contract, not paperwork. Keep it short, but make it concrete:

- **Form behavior.** How the chosen form works in this piece: section functions, approximate
  proportions, return scheme, cadence/denial points, and destination placement.
- **Journey behavior.** The state-change job of each section: what becomes more exposed, compressed,
  unstable, transformed, refused, released, exhausted, or clarified compared with the previous section.
- **Material behavior.** Which materials return, transform, disappear, interrupt, or carry the form.
- **Texture identity.** The active engine and texture class for each section.
- **Rhythmic identity.** The dominant rhythmic sentence, value classes, cross-rhythm, pulse, or
  silence behavior for each section.
- **Bass behavior.** Line, ground, pedal, drone, walking, tacet/window, punctuation, or registral
  event.
- **Register/color plan.** High-only, low-only, compressed, wide, chamber, full, hollow, or reserved
  register/color states.
- **Reserve.** Any sound, register, mass, technique, or silence saved for a specific formal job.
- **Required audible event.** One event each section must make real in the notes.
- **Carry-forward.** Named material each section produces as an output, and named material it consumes
  as an input. If there is no dependency, say so.
- **Phrase-grain narrative.** For each 4-bar group or coherent phrase cell: the active engine, the
  event/change from the previous group, the active roles, and the required audible event.
- **Beat/bar differentiation.** For each 4-bar group or coherent phrase cell: the per-bar job and at
  least one beat-level mechanism such as a rest accent, pickup, hold, syncopation, off-beat entry,
  mid-bar gesture break, value-class change, handoff, register event, or local cut.
- **Rest and silence behavior.** Where rests, breaths, tacets, holes, or held fields create accent,
  pressure, punctuation, exposure, release, or aftermath. Silence is a musical event, not leftover
  duration.
- **Transition behavior.** How each section connects, interrupts, cuts, overlaps, or leaves an
  afterimage. Abrupt transitions are allowed only when they are the declared event; otherwise compose
  the seam.

A useful compact row is:

```text
Section | bars | state-change job | material | inputs | outputs | cadence/denial | texture engine | bass | register/color | phrase-grain events | bar/beat differentiation | transition | required audible event
```

Use a fuller ledger from `texture_identity_contrast_ledger.md` only when the piece's scale needs it.
The contract is accepted when it would guide different notes if any row changed.

Beware the block-transition failure mode: four decent bars, four similar bars, then an abrupt new
block. That shape can work only when the music itself makes block collision, ritual repetition, or
stasis the point. Otherwise the contract should describe how melody, progression, register, role
relation, rhythm, silence, or orchestration causes one passage to become the next.

The form contract is binding, not infallible. A later musical pass may change it only by documenting a
divergence with why the change is better for the piece. Silent drift from the contract is a failed pass.

## Stage 2 - Research-To-Music Commitments

Choose the research set that matches the actual piece, then translate each important reading into a
musical decision.

Use this compact form:

```text
Research source/section -> principle -> musical decision -> affected bars/parts
```

Examples of decisions that count:

- A theme will use a repeated-note cell plus one saved leap at its peak.
- A passacaglia ground will persist while surface rhythm, register, and harmony transform.
- A long melody note will trigger a different-register answer instead of held accompaniment.
- A piano current will move under held melody and thin when the melody becomes active.
- A brass return will be highlighted by octave crown only at the phrase peak.

Do not keep citations that do not change a musical decision. If the research is only decorative, it
has not earned a place in the procedure.

Also record the DSL surfaces likely needed. If a surface is unfamiliar, run the relevant JIT help
before authoring it.

Keep an unused-commitments ledger while working:

```text
Commitment | source stage/research | intended bars/parts | used? | if unused, reason or replacement
```

Every important research decision, reserved sound, planned return, required audible event, and
technique-library influence must either enter the score or be explicitly replaced by a better musical
choice.

## Stage 3 - DSL Frame

Create the source frame:

- `production_piece`
- `meter` and `beat_pattern` where needed
- key or key-region declarations in the source's established style
- `tempo`
- `roster`
- `section` blocks with bars, type, journey, and destination
- `span` blocks with texture and harmony
- initial `control` block for tempo, dynamics, pedal, and technique spans

Use placeholders only as temporary scaffolding. They must be replaced by composed material before the
piece is complete.

The frame is a living scaffold. It may contain thin lines, landmarks, and initial harmonic intentions,
but it must not become a locked skeleton that later span passes merely fill in. If a span pass needs to
reshape harmony, register, role assignment, or a line to make better music, document the divergence and
revise the frame/source accordingly.

Run:

```bash
ruby -c SOURCE.rb
partitura/bin/dsl_help production
partitura/bin/production_view SOURCE.rb compile
partitura/bin/production_view SOURCE.rb structure
```

## Stage 4 - Compose Primary Materials First

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

## Stage 5 - Compose Each Span In A Verdict Loop

Before composing each substantial span, write a compact micro-decision table:

```text
Bars/phrase | active engine | event/change | per-bar jobs | beat-level mechanism/rest | parts with jobs | input material | output material | checks needed
```

For every span, write the music in this order:

1. Foreground or primary engine.
2. Bass behavior: line, ground, drone, pedal, walking bass, tacet, or punctuation.
3. Counterline or inner motion.
4. Accompaniment and harmonic support: counterline, walking bass, ostinato, chorale, arpeggiation,
   repeated pulse, tremolo, drone, sustained pad, harmonic field, rests, or tacet.
5. Controls: dynamics, hairpins, pedal, tempo, and technique spans.
6. Staff checkpoints where vertical, role, handoff, cadence, or register alignment must be readable.
7. Gesture prose only when it names an audible mechanism already present in the notation.

Use the surface that exposes the job:

- degrees for tonal/function melody
- intervals for motivic transformation
- split pitch/rhythm for long editable lines
- absolute pitch for register-bound material
- staff grid for dense vertical inspection
- phrase placement for entrances, handoffs, and returns
- hybrid for mixed orchestral or multi-role passages

After each span or small section, run the loop:

1. Compose the exact DSL material.
2. Project the span.
3. State the musical verdict in one or two sentences.
4. Revise the notes, controls, placements, or span shape if the verdict exposes weakness.
5. Re-project the changed area.

Use focused projections:

```bash
partitura/bin/production_view SOURCE.rb ensemble_grid --bars START-END
partitura/bin/production_view SOURCE.rb exposed_clashes --bars START-END
partitura/bin/production_view SOURCE.rb verticals --bars START-END
partitura/bin/production_view SOURCE.rb line --part PART_ID
partitura/bin/production_view SOURCE.rb breath_map --part PART_ID
partitura/bin/production_view SOURCE.rb controls
# secondary (declared intent): roles --bars, harmony_with_melody --bars
```

Read the ensemble_grid as a conductor (every attack in a stratum, choirs together, punctuation
shared); adjudicate exposed_clashes findings musically (prepared suspensions, cadential sevenths,
pedal stacks, and resolving passing tones are correct music - fix only the unprepared exposed
clashes).

A span passes when the active engine, bass, accompaniment, and any gesture claim are audible in the
notation. A clean projection is not enough.

Use this bar/beat failure-mode checklist during span review:

- Does the passage feel like counted bars of texture rather than a phrase with cause and consequence?
- Has a texture, accompaniment pattern, card behavior, or same-color field continued by inertia after
  its musical job is done?
- Does an apparent repeat, continuation, or stasis have an audible reason: ritual, pressure, suspense,
  insistence, aftermath, breath, or refusal?
- Do duration choices express metric function: held weight, pickup, anticipation, breath, pressure,
  cadence, denial, or release?
- Each phrase has per-bar jobs, not just bar counts: call, answer, hold, fill, breath, pickup,
  compression, cadence, denial, afterimage, interruption, or release.
- Rests and tacets have function. A rest may be an accent, breath, cut, anticipation, exposure,
  suspension, or release; if it only fills arithmetic, rewrite it.
- Simultaneous layers need rhythmic separation unless the passage deliberately uses homorhythm as a
  scarce punctuation.
- A seam is composed by pickup, tail-crossing, liquidation, sequence, harmonic acceleration, caesura,
  cut, or resonance wake. Abrupt reset is a special event, not the default way to change blocks.

After composing that span, record the pass note before starting the next one. The pass note must say
which planned phrase-grain events were realized, which outputs were produced, what changed from the
contract, and what weakness was revised. A first write is not a span pass until it has been inspected
and revised or given a concrete no-change musical verdict.

## Stage 6 - Interleave Ideas Below The Section Level

Do this while composing, not as an afterthought.

First map opportunity zones:

- two bars before and after each section boundary
- first statement and every return of primary material
- long same-color or same-technique spans
- aligned entrances or exits across many layers
- melody long notes and phrase gaps
- cadences, denials, interruptions, and destination approach

Then choose only incidents with musical leverage. Reject passages where the form simply becomes
"four bars of one technique, four bars of another." A section may have a strong identity, but real
musical flow usually changes at the phrase, bar, and beat level.

Specifically scan for the common failure mode: eight bars of the same behavior followed by an abrupt
transition into eight bars of another same behavior. Fix it by making the first behavior evolve, by
composing a seam through overlap/cut/afterimage/pickup, or by proving that the block collision itself
is the formal event. Do not repair monotony by sprinkling unrelated ornaments; the added event must
change causality, role, rhythm, register, silence, or journey.

Possible local actions:

- anticipation
- interruption
- inheritance from the previous idea
- leakage into the next idea
- role swap
- dovetail or overlap
- pickup
- early clearing
- partial return
- local silence
- bass preparation
- counterline answer
- accompaniment borrowing the foreground tail

The purpose is not density. The purpose is local causality: each bar should sound like it follows
from the piece, not from a template. If an incident does not clarify the form, remove it.

## Stage 7 - Material Returns And Identity

For every primary material or process, maintain a short return ledger:

```text
Material/process:
Source phrase id and first bars:
Identity carried forward: rhythm / contour / pitch cell / bass law / texture engine
Return bars:
Transformation:
Audible highlighting mechanism:
Support difference:
DSL phrase/placement ids:
```

Use:

```bash
partitura/bin/production_view SOURCE.rb recurrence_map
partitura/bin/production_view SOURCE.rb peak_axes
# secondary (declared intent): material_map, placements, foreground, harmony_with_melody
```

`recurrence_map` proves returns exist as sounding material; `peak_axes` shows where the
registral/dynamic/density maxima and the longest note actually landed and whether the axes
converge - check it against the declared journey and destination.

A return is not highlighted by a label. It is highlighted by notation: register, voicing, octave,
doubling, clearing, dynamic, articulation, accent, pedal, rhythmic setting, accompaniment relation, or
formal placement.

## Stage 8 - Harmony, Accidentals, And Verticals

Inspect verticals as music:

- Same-letter chromatic conflicts such as G/G#, E/Eb, B/Bb, and F/F# are suspects.
- Cross-relations can be intentional, but the surrounding harmony must make them sound intentional.
- A leading tone should point somewhere.
- A mixture tone should belong to local color or be isolated as an event.
- A dissonance should have placement, weight, and release.
- Chords should obey register and spacing logic from `chord_scoring.md`, adjusted for the forces.
- Held notes across harmony changes are suspensions or common tones; if neither, revoice or release.

Use:

```bash
partitura/bin/production_view SOURCE.rb exposed_clashes --bars START-END
partitura/bin/production_view SOURCE.rb verticals --bars START-END
partitura/bin/production_view SOURCE.rb implied_harmony --bars START-END
# secondary (declared intent): harmony_with_melody; raw data: transport
```

`implied_harmony` reports per-bar chord candidates from the sounding pitches - compare them with
the declared span harmony: where they disagree, either the notes or the declaration is wrong.

If the note is right but the support is wrong, move the harmony around it. If the support is right but
the note sounds like an artifact, respell or change the note.

## Stage 9 - Whole-Piece Musical Revision

Run this stage as a fresh merge pass. Read the source and projections as if all prose labels were
removed and as if the spans had been written by other hands. Revise any passage that fails these
questions:

- What is the active engine in each span?
- Would each player understand their role from the notes?
- Does the journey change the listener's understanding of the material?
- What state-change job does each section perform, and is the changed state audible rather than only
  described?
- Where is the destination, and does its placement belong to this form?
- Which axes converge and which remain separate?
- Does every simple passage have a positive reason: declaration, breath, exposure, suspension,
  silence, ritual lock, or release?
- Does every dense passage have a musical job beyond activity?
- Are any spans only library technique demonstrations?
- Do A/B or equivalent materials have identity and return?
- Are labels such as lock, stripping, cameo, displacement, arrival, or breath audible without the
  label?
- Does any passage repeat the same rhythmic/texture behavior and then escape by abrupt transition?
- Do rests, holes, and tacets create rhythm, pressure, breath, or form, or is the surface nearly
  continuous by default?

Also perform the merge checks imported from the agent procedure:

- **Seams.** Walk every span and section boundary, including two bars before and after: pickup,
  momentum, caesura, overlap, resonance tail, interruption, and re-entry.
- **Journey and single voice.** Confirm the destination, axis split, dialect, and pacing read as one
  piece rather than adjacent blocks.
- **Bar/beat differentiation.** Read each phrase for per-bar jobs, value-class changes, mid-bar
  breaks, rests, handoffs, and non-identical clause rhythm. Repeated stasis must sound like a musical
  state, not fatigue. Run `figure_timeline` per part: long identical-figure runs are the
  block-failure fingerprint (the reference etudes max out at 2-4 bars, and their longer same-rhythm
  runs rotate contour/register/harmony every 1-2 bars - check `bar_profile` on any long run).
- **Plan adherence.** Diff the source against the Stage 1 form contract, phrase-grain narrative,
  texture identity rows, material return ledger, reserves, and required audible events.
- **Carry-forward.** Confirm every declared input/output is present as actual musical material, not as
  a prose label or guessed paraphrase.
- **Divergences.** Surface every changed plan item with why it is better. Anything silently dropped is
  either restored, replaced, or logged as an unresolved weakness.
- **Unused commitments.** Close the unused-commitments ledger: each unused research decision, card
  influence, reserve, event, or return gets a musical reason or a replacement.

Also run an idiom and performability audit matched to the forces:

- **Voices:** range, tessitura, breath, vowel practicality, leaps, sustained notes, and whether every
  vocal line is singable without relying on instrumental cover.
- **Fixed-pitch instruments:** exact pitch inventory, idiomatic attack density, resonance, decay, and
  whether unavailable pitches are avoided or assigned elsewhere.
- **Harp/keyboard/plucked resonance:** pedal or hand plausibility, register spacing, decay blur, and
  whether arpeggiation or rolls serve phrase structure rather than filling space.
- **Winds/brass/strings:** range, register color, breath/bow/string logic, articulation practicality,
  and whether doublings obscure the intended solo or counterline role.
- **Percussion and attacks:** reserve, stroke density, resonance tails, and whether attacks clarify
  form instead of decorating it.

Revision is part of composition. Fix the notes, placements, controls, span structure, local form, or
instrument assignment until the answers are strong. A yes/no checklist is not enough: write a brief
bar-and-part verdict for each weak area you find, revise the source, and re-project the affected bars.

After the merge fixes, run a short capstone local-causality pass across the whole piece. Look for
places where a small musical incident would make the score sound composed through the seams: early or
late starts, cross-seam tails, one-bar cuts, role swaps, selective doubling, register holes, reserve
spends, resonance wakes, or sudden clearings. Add only incidents that improve form, pacing, or role
clarity; remove decorative events that do not.

## Stage 10 - Export, Audition, And Close The New Source

Run:

```bash
ruby -c SOURCE.rb
partitura/bin/production_view SOURCE.rb compile
partitura/bin/production_view SOURCE.rb peak_axes
partitura/bin/production_view SOURCE.rb rhythm_profile
partitura/bin/production_view SOURCE.rb articulation_map
partitura/bin/production_view SOURCE.rb breath_map
partitura/bin/production_view SOURCE.rb exposed_clashes
partitura/bin/production_view SOURCE.rb controls
# secondary (declared intent): structure, roles, material_map
partitura/bin/production_export SOURCE.rb OUT_DIR --stem STEM
for test_file in partitura/test/test_*.rb; do ruby "$test_file" || exit $?; done
git diff --check
```

After export, audition the result by score, MIDI, audio, or the best available rendering for the
project. Listen/read for weak spans, inert accompaniment, bad pacing, unreadable verticals,
unidiomatic writing, unclear returns, accidental artifacts, and over-mechanical interleaving. If any
appear, return to the relevant stage and revise the source.

The first successful export never closes the procedure by itself. Complete at least one post-export
revision cycle:

1. Inspect the exported score/playback and focused projections as music, not only as data.
2. Record concrete findings by bar, part, and musical problem.
3. Revise the DSL source itself.
4. Re-run compile, focused projections, export, and any affected tests.
5. Repeat while the audit still finds material weaknesses.

If the post-export audit finds no change needed, document why in musical terms, tied to specific
sections and roles. Do not use "no obvious compiler issue" or "mechanically valid" as a musical
verdict.

Clean up only what belongs to this new composition: scratch transport JSON, temporary analysis files,
draft render artifacts, and outdated local status notes. Keep research and brief material that helps
future work continue.

## Exit Criteria

The new composition pass is complete only when:

- The source is a readable `production_piece`.
- The fresh attention passes were run separately and recorded, even if by the same agent.
- The form contract is audible in the score.
- The form contract includes phrase-grain events and material input/output commitments appropriate to
  the piece's scale.
- The form contract names a journey curve with section state-change jobs, not only a destination label.
- Research commitments changed actual musical decisions.
- Primary materials or engines are explicit and return audibly.
- Primary materials and accompaniment rhythms use duration, rests, and beat placement as musical
  functions, not bar-filling.
- Bass, accompaniment, counterlines, and pads have positive musical jobs.
- Span pass notes account for realized events, produced outputs, divergences, and revisions.
- The closeout includes a musical review of bar/beat failure modes in substantial spans.
- Technique-library influence has been adapted into the piece's own notes.
- Flow is interleaved below the section level where the form needs it.
- The closeout explicitly addresses whether any unchanged texture block escapes by abrupt transition,
  and any retained block behavior is defended as a musical event.
- Rests, tacets, holes, or silence are either used as musical events or consciously withheld for a
  stated reason.
- Accidentals and verticals are accountable.
- The merge pass checked seams, journey, plan adherence, carry-forward, divergences, and unused
  commitments.
- The capstone local-causality pass was run after merge fixes.
- The idiom and performability audit for every force has either passed or caused source revisions.
- The verdict loops and whole-piece revision pass musical judgment, not only compiler checks.
- Exported score/playback has been auditioned after the first successful export.
- At least one post-export musical audit and revision/no-change cycle has been completed and recorded.
- Any discovered weaknesses were revised in source and re-exported.
- The DSL source compiles and exports.

Do not describe the result as a draft in the closeout. If it is still a draft, the procedure is not
finished.
