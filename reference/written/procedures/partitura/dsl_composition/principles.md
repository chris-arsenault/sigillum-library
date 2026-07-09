# DSL Composition Procedure - Principles And Standing Orders

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

1. `docs/architecture/partitura/INDEX.md`
2. `docs/architecture/partitura/00_llm_contract.md`
3. `docs/architecture/partitura/01_container.md`
4. `docs/architecture/partitura/02_surface_decision.md`
5. `docs/architecture/partitura/05_compile_api.md`
6. the relevant surface files under `docs/architecture/partitura/surfaces/`

Before authoring, also ask the runtime what the current DSL supports:

```bash
partitura help production
partitura help decision
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
bars | decisions | weaknesses | improvements | outputs | musical_verdict
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
partitura cards <term>
```

Then cite the result as `dsl:<category>/<id>`, never as a Python module path, in any new DSL brief or
score note. Cards can supply technique names, high-water marks, role models,
dialect seeds, and concrete listening checks. They do not replace composition.
If a card influences a new piece, read the card's `.rb` source, adapt its
musical idea to the piece's own material, and write the adapted notes directly
in the DSL.


## Improvement, Not Remediation - Countering The Good-Enough Lens

You carry a known bias: you generalize toward not doing work. Left alone, you read a
passage as if it were good enough, hunt for hard errors to fix, and stop when nothing
is broken. That lens produces mechanically valid, musically inert scores. Every review
inside this procedure therefore runs in EDITING mode, not AUDIT mode: the default
question per bar is "what would make this better," with keep as the justified
exception - never "is it broken," with change as the exception.

- There is always room for improvement. A "no change" musical_verdict is legal only
  when it names what you tried to improve and why the music is better without the
  change. "Nothing is broken" is not a verdict; it is the bias talking.
- Edit means improve, not delete. Deletion feels safe because new notes can be wrong;
  that safety is the tell. Every finding names music to COMPOSE - ornamented returns,
  countermelodies, answers in phrase gaps, elaborated figures - never only what to
  remove. A rest opened for breath is paired with music composed in the space it opens.
- Projections and gates measure difference and validity, never quality. Apply "would a
  listener notice this is BETTER" to every edit; bookkeeping shuffles that only a
  spreadsheet can hear do not count as improvement.
- The pass note's `improvements` field records what got compositionally better this
  pass, or the best improvement candidate you found and why you did or did not take
  it. It comes back to you in later stage payloads; write it as material to build on.

## The Drafting Lens Decays The Other Dimensions

Whichever dimension you led with while drafting a passage - whatever it was for that
passage - comes out roughly sound; every dimension you were not attending to decays
while you work. This is a known property of your composing, observed in both
directions: line-first drafts with bad verticals, verticals-first drafts with dull
lines. Do not install a fixed ranking of dimensions to compensate - the crown itself
is the bug. Instead:

- After drafting any span, name what your drafting lens actually was.
- Then run deliberate editing traversals of the same bars with the neglected lenses -
  total coverage, every bar gets read, projections as the reading tool but never the
  scope-setter - and make edits: alignment between layers, whether the bed breathes or
  stamps the same skeleton, masked entrances, spacing, seams.
- Revisiting music with an eye for improvement is not optional polish; it is the only
  mechanism that brings the neglected dimensions up to the quality of the led one.
  The span verdict loop, the merge pass, and the closeout audits exist for this.
