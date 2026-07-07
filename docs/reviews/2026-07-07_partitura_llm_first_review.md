# Partitura LLM-First Review — Findings and Remediation Plan

Date: 2026-07-07
Scope: DSL ergonomics, written library reference material, and DSL musical references,
reviewed against the repo's stated purpose (LLM-only composition aid; discoverable;
just-in-time documentation; context-frugal; multi-style composing; views that trigger
quality judgment; discourage metric-based composition). Real usage evidence taken from
the six `production_piece` movements in `../sigillum/symphony/movements/`.

Status: all six finding areas below are accepted for remediation, not only the
highest-priority items.

Implementation status (2026-07-07): every remediation in Areas 1-6 is implemented,
including the Area 4 guided procedure wrapper and CLI consolidation
(`docs/architecture/partitura/08_cli_and_guided_runs.md`, milestones M1-M3 plus the M4
doc rewiring; still open: a `section_recomposition` manifest and a consumer-repo trial
run). The consolidated `partitura` binary carries all verbs; the composition procedure
runs stage-at-a-time via `partitura start/status/commit/next/back/log`. Also
implemented: bar-marker/onset/span-overflow compile requirements; verified
staff_bar checkpoints; closed mark vocabulary with `marks` help topic; phrase/section
context on compile errors; enforced roster ranges plus `range_check`; the configurable
lint framework (phrase length, surface nudges) with `lints:` in the compile response;
mode-aware degrees with piece-key inheritance; the per-bar chord track (`chords`) with
`harmony_check` and the per-bar `harmony_with_melody`; declared-key melody reports with
de-scored observation rows; entry-chain pointers in README/AGENTS; doc/JIT sync; ranked
free-text card search; and CLI view listings with structured unknown-view errors. The
flagship example's phantom hand-drum, misaligned late-answer rhythm, off-by-one
checkpoint lanes, and five defective library cards were fixed after the new gates
caught them.

---

## Verdict

The architecture is unusually well-matched to its purpose. The container/surface split,
the JIT help contract (`use_when`/`rules`/`example`/`next_topics`/`docs`), structured
compile errors with repair instructions, and the sounding-vs-declared projection split
are genuinely good LLM-first design. The sounding projections (`ensemble_grid`,
`implied_harmony`, `peak_axes`, `melody_report`) are exactly the "fresh view that
triggers quality problems" the repo aims for.

The weaknesses concentrate in three places:

1. The compiler does not enforce the alignment invariants LLM authoring depends on.
2. Real usage shows the recommended surfaces losing to exactly the token-wall style the
   DSL exists to prevent, with no feedback loop catching it.
3. Discoverability breaks at both ends of the funnel: repo entry and card search.

Unifying theme: the repo's philosophy says "the notation must expose relationships,"
but the compiler currently **trusts** the notation instead of **verifying** it. A staff
constrains what can be written — that constraint is why it is trustworthy to read.
Partitura's machine-staff needs the same property: every visual/structural claim in the
source (`|`, checkpoints, marks, ranges) is either verified or is an error.

---

## Area 1 — Compiler guardrails: silent failures on the errors LLMs actually make

### Findings

**1a. Bar separators (`|`) are stripped, not verified.** A phrase declaring 6 beats
before the `|` in a 4/4 bar compiles with status `ok`. The note authored as "last event
of bar 1" sounds at bar 2 beat 2, and every subsequent event cascades late — including
spilling past the declared span (`bars: 1..2` produced a sounding note in bar 3) with no
diagnostic. Stream-vs-stream event counts are checked per bar segment; stream-vs-meter
time is not. Token-count misalignment is the canonical LLM error and the `|` syntax
invites exactly the mental model ("everything left of `|` is bar 1") that the compiler
fails to check.

**1b. `staff_bar` checkpoints are unverified prose.** Lanes are echoed in declared
views but never cross-checked against the compiled timeline. The flagship example
(`experiments/partitura/production_hybrid_study.rb`) models the failure: the
`hand_drum` pulse exists only in `staff_bar` lanes, has no phrase/placement, and
`ensemble_grid` shows the part silent for the whole piece. The construct meant to be
the machine-staff vertical checkpoint can lie, and the canonical example does lie.

**1c. Unknown marks pass silently.** `{staccato}`, `{slurr(}` compile `ok`, fall
through to text-word rendering, and `articulation_map` reports zeros. The mark
vocabulary is closed and known (`partitura/lib/partitura/export/musicxml/note_rendering.rb`).

**1d. Compile errors omit the phrase id and source location.**
`"pitches has 3 events but rhythm has 2 in bar 1."` — in a 2,000-line movement with 40
phrases this is a hunt. The error shape (code/repair_instruction/help_topic/docs) is
excellent; it lacks the anchor.

**1e. `range:` on roster parts is dead metadata.** Accepted, stored, used by nothing —
no range-violation projection, no compile check — while the composition procedure
demands an idiom/performability audit for every force. Declared-but-unenforced metadata
implies a check that never runs.

**1f. CLI error polish.** `production_view SOURCE.rb bogus_view` dumps a raw Ruby stack
trace with no list of valid views; bare `production_view` usage does not enumerate
views. This contradicts the compile API's own principle that every error names the next
step.

### Remediation (decided)

- **Bar alignment is a requirement, not a warning.** Compile **error** when the events
  in a `|`-delimited segment do not fill the bar per the active meter. Compile **error**
  when a multi-bar pitch/rhythm stream omits `|` separators. Compile **error** when
  placed phrase material sounds past the end of its containing span/section.
- **Verify `staff_bar` lanes** against the compiled timeline, zero-diff style (same
  discipline as the `07_hand_edit_import.md` MusicXML verify gate). A checkpoint that
  contradicts the sounding result is a compile error naming the bar, lane, and first
  divergent slot. Fix the flagship example's phantom hand-drum as part of this.
- **Mark linting:** unknown mark → compile error listing the closed vocabulary and the
  `marks` help topic (topic to be added, see Area 4).
- **Every compile error carries the phrase id** (and section/span ids where relevant),
  plus the source file/line when derivable.
- **Implement range checking:** a sounding projection (worklist style, like
  `exposed_clashes`) that reports notes outside a part's declared `range:`, and a
  compile-level error for notes outside it. If range enforcement is not wanted for a
  part, the author omits `range:`.
- **CLI:** unknown view error lists all valid views (primary and secondary, matching the
  compile response); bare usage prints the view list.

### Linter framework (decided)

Introduce a lint pass distinct from compile errors, run as part of `compile` output
(a `lints:` array in the response) and as a standalone `production_view SOURCE.rb lint`.
Rules are configurable (per-piece via a `lint` block or per-repo config file), each with
warn/error thresholds. Initial rules:

- **Phrase length:** warn when a single phrase exceeds ~8 bars, error at ~24
  (configurable). Long phrases are where stream alignment and readability degrade;
  the fix is splitting into named sub-phrases, which also improves `recurrence_map`
  and `material_map` legibility.
- **Surface-choice nudges:** warn on `absolute` / `split_pitch_rhythm` phrases whose
  content suggests a better surface — e.g. a tonal melodic line in `absolute` (nudge:
  degrees), a short cell repeated in transposition (nudge: intervals), long
  same-register streams with no bar markers (error under the bar rule above). The
  warning names the suggested surface and its help topic. These are lint warnings, not
  errors: the agent may keep the surface, but must see the nudge. Purpose: create the
  missing feedback loop identified in Area 2 (agents defaulting to per-voice
  token-dumps).
- Framework should make later rules cheap to add (e.g. missing `staff_bar` checkpoints
  in dense multi-part spans, phrases with zero rests over long stretches).

---

## Area 2 — Real usage abandons the recommended surfaces

### Findings

Tally across the six `../sigillum` movements:

| Surface | Doc stance | Actual use |
|---|---|---|
| `absolute` / `split_pitch_rhythm` | situational | ~370 phrases (dominant everywhere) |
| `degrees` | recommended default | 1 movement of 6 |
| `intervals` | motivic identity | zero |
| `staff_bar` | checkpoint layer | ~30 total, absent in half |
| `gesture`, `control` | core concepts | nearly absent |

Dominant real pattern: one giant `split_pitch_rhythm` phrase per voice per section,
placed at "bar N beat 1" — a per-voice MIDI dump. `m2_refrain.rb` has 120-token pitch
and rhythm heredocs with **no bar separators at all**, wrapped at arbitrary widths,
where correlating pitch 47 with rhythm 47 requires ordinal counting across wrapped
lines. That is the "wall of tokens" the LLM contract forbids, and nothing in the
toolchain pushes back.

Two concrete reasons the higher surfaces don't pay for themselves:

**2a. Degrees are major-scale-only.** `MAJOR_STEPS` is hardcoded in
`partitura/lib/partitura/production/parser.rb`; `key "c"` is declared but ignored by
degree resolution. The one minor-key movement using degrees (`mvt1`) is littered with
`b3 b6 b7` on nearly every token — in minor, the surface that should "show scale
function" renders the diatonic third as an alteration. This plausibly explains the
abandonment.

**2b. Long phrases have no enforced per-bar layout**, so `split_pitch_rhythm`'s
"editable line" claim degrades as phrases grow.

### Remediation (decided)

- **Mode-aware degrees:** `key_context` accepts mode (e.g. `"C4 minor"`, `"D4 dorian"`);
  degree resolution uses the declared scale; accidentals then mean actual inflections.
  Honor the piece-level `key` declaration (lowercase = minor convention, or explicit
  mode) as the default `key_context` mode.
- **Bar-marker requirement + phrase-length lints** (Area 1) enforce readable per-bar
  layout and cap the token-wall failure mode.
- **Surface-nudge lint warnings** (Area 1) push agents from `absolute`/
  `split_pitch_rhythm` toward the representation that exposes the musical job, at the
  moment of authoring rather than in documentation they may not have loaded.

---

## Area 3 — Composing styles: "by chord" is missing; harmony is prose

### Findings

Coverage against the intended styles: melody-first ✓ (degrees/phrase layer), per voice ✓
(dominant), by section ✓ (section/span), by interval ✓ (surface exists, unused in
practice), by figure ~ (technique cards as adaptable models; deliberately no expander —
the anti-stamping stance is correct and consistently held).

**By chord is unsupported.** `harmony` on a span is a free-text string. Consequences:

- No way to author chords-first and realize voices against a declared progression.
- `harmony_with_melody` repeats the entire prose string on every event line
  (`harmony="F home; raised 1 is melodic bite, not a modulation."` × every note) —
  context pollution carrying zero per-note information.
- Agents already invented a structured microformat under pressure:
  `harmony "b17:Am b18:Am b19:Dm ..."` in `m2_refrain.rb`. Users are telling us the
  schema they need.
- `melody_report` estimates its own key ("estimated key C major" for a piece declared in
  F) and ignores the declaration.

### Remediation (decided)

- **Structured per-bar harmony track:** formalize the `bN:Chord` microformat (letter
  and/or roman numeral) as a first-class optional span/section declaration. Free prose
  remains allowed as commentary but is separate from the chord track.
- `harmony_with_melody` renders the per-bar chord (once per bar), not repeated prose.
- New mechanical diff: `implied_harmony` vs declared chord track, reported as a
  worklist (where they disagree, either the notes or the declaration is wrong — Stage 8
  of the procedure currently asks the agent to do this by eyeball).
- Chords-first authoring path: declare the chord track first, then compose voices; the
  diff view closes the loop.
- `melody_report` uses the declared key/mode; the independent estimate may be shown as a
  cross-check ("declared F major; estimated C major — investigate") rather than as the
  only key.

---

## Area 4 — Reference material: strong core, broken entry chain, monolithic procedure

### Findings

**Good:** the read-order in `INDEX.md`, the LLM contract, and the JIT topic design are
exemplary. `reference/written/craft/README.md` and `surveys/README.md` route by musical
job with one-line hooks. Doc sizes are reasonable (largest survey 751 lines). Research
routing maps documents to musical jobs rather than demanding full reads.

**4a. Entry chain gap.** A cold agent reads `README.md` (directory layout only) and
`AGENTS.md` (four rules, no pointers). Neither mentions
`docs/architecture/partitura/INDEX.md` or `partitura/bin/partitura_help`. The
discoverability apparatus is only discoverable by spelunking.

**4b. The composition procedure is a 763-line monolith.**
`reference/written/procedures/partitura/dsl_composition_procedure.md` is the best single
document in the repo and it violates the repo's own just-in-time principle: an agent
must hold all ten stages, the imported-standards table, and the exit criteria in context
for the entire composition. It also mandates fresh-context span agents — each of which
currently re-pays the full document.

**4c. Doc/reality drift.** Degrees doc documents `1'` but not the `,` octave-down used
by the cards (`5,`), and the `bad_degree` repair message "Use degree tokens like 5, #1,
b6, or 1'." makes `5,` read as "5-comma" in a list. Docs show only decimal rhythm
(`.25`) while all real usage is fractional (`1/4`, `3/2`) — both work, no doc says so.
Docs show only block-form `placement`; real usage prefers kwarg form. The inline-mark
vocabulary (including span marks `slur( cresc( dim)`) is fully documented only inside
`surfaces/absolute.md`, where a degrees-authoring agent has no reason to look.

### Remediation (decided)

- **Fix the entry chain:** `AGENTS.md` and `README.md` open with the one command to run
  first (`partitura/bin/partitura_help index`) and the one file to read
  (`docs/architecture/partitura/INDEX.md`).
- **Split the procedure into per-stage files** behind a compact stage index, same
  pattern as `surfaces/`.
- **Guided wrapper (decided design):** turn the multi-stage procedure into an
  interactive process so agents cannot (or at least are strongly discouraged to) read
  the whole procedure at once. Full accepted design (CLI consolidation, run state,
  gates, manifests): `docs/architecture/partitura/08_cli_and_guided_runs.md`. Sketch:
  - `partitura start <dir>` — initializes a procedure run in `<dir>` (state file +
    audit log), emits the first stage's instructions only.
  - `partitura next` — emits the next stage's instructions.
  - `partitura commit` — records the stage transition in the audit log (pass notes,
    decisions, divergences — the artifacts Stages 5/9 already require) and then emits
    the next stage. `commit` is the preferred transition; `next` is the escape hatch.
  - The state file records current stage, completed stages, and pointers to recorded
    pass notes, so a fresh-context span agent can `partitura start`-resume and receive
    exactly its stage.
  - Each stage payload follows the JIT help response contract (use_when / rules /
    example / next_topics / docs) and names only the docs that stage needs.
- **Add a `partitura_help marks` topic** carrying the full closed mark vocabulary
  (point marks, span pairs, techniques, `txt:` policy), referenced from every surface
  topic.
- **Sync docs with real syntax:** fractional rhythm tokens, kwarg-form `placement`,
  `,` octave-down markers (and reword the `bad_degree` repair message), mark vocabulary
  pointer from `degrees.md` / `split_pitch_rhythm.md`.

---

## Area 5 — Technique library: excellent cards, search that fails its main query pattern

### Findings

The 130+ compilable card specimens with dense behavior prose are a real asset —
auditionable, cited, with the adapt-don't-copy rule guarding against stamping.
`ruby tools/lib.rb show <ID>` output is well-shaped.

But `tools/lib.rb <term>` matches only exact category/facet names. `arpeggio`, `arp`,
`ostinato`, `pedal`, `fanfare` all return "no cards" — despite `OG1_ARP_ENGINE` and
`OB2_FANFARE` existing, and despite `arpegg` literally appearing in the FACETS keyword
table inside `lib.rb` itself. Meanwhile `figuration` returns 75 cards — more than half
the library — so the working terms have no precision. This is the difference between
the card library being consulted mid-composition and being skipped.

### Remediation (decided)

- Route free-text queries through the existing FACETS keyword lists (the classifier
  vocabulary becomes the query vocabulary).
- Substring/word match over card ids, names, and behavior text.
- Rank/limit results so broad terms return a useful shortlist, not half the library;
  suggest narrowing facets in the output.
- "No cards" responses should suggest near-miss terms instead of only dumping the
  category list.

---

## Area 6 — Metric-avoidance: philosophy well executed, residual metric bait

### Findings

The sounding-primary/declared-secondary split is threaded consistently: secondary views
print a self-demoting banner, the compile response separates the two lists, `peak_axes`
reports placement of maxima rather than scoring them, `exposed_clashes` is framed as a
worklist to adjudicate musically. The AGENTS.md no-generated-notes rule plus the
"realization must be inspectable" placement rule close the stamping loophole. This is
the strongest part of the design.

Residual bait: `melody_report` prints `OK`/`CHECK` verdicts with numeric thresholds
("0% of notes recur as a motif", "100% of strong beats are chord tones") — a pass/fail
metric panel wearing a projection's clothes. An agent optimizing to flip `CHECK`→`OK`
is doing metric composition. `transport_metrics` deserves the same review.

### Remediation (decided)

- Reframe `melody_report` rows as neutral observations that demand a judgment ("no
  recurring cell found — decide whether this line needs one"), dropping the OK/CHECK
  scoring while keeping all information.
- Audit `transport_metrics` (and any other projection emitting verdict-like tokens) for
  the same pattern.

---

## Evidence appendix (commands run during review)

- Bar overflow accepted silently: 6-beat bar segment in 4/4 → `compile` status `ok`;
  `line` shows the cascade; sounding note lands outside the declared span.
- Unknown marks accepted silently: `{staccato}`, `{slurr(}` → `ok`;
  `articulation_map` reports zeros.
- Phantom checkpoint: `production_hybrid_study.rb` `hand_drum` appears only in
  `staff_bar` lanes; `ensemble_grid --bars 1-2` shows the part fully silent.
- Card search misses: `ruby tools/lib.rb arpeggio|arp|ostinato|pedal|fanfare` → no
  cards; `figuration` → 75 cards.
- Harmony pollution: `harmony_with_melody` repeats the span's full prose harmony string
  on every event line.
- Key mismatch: `melody_report` on the F-major hybrid study reports "estimated key
  C major".
- Minor-key degree friction: `../sigillum .../mvt1_invocation_merged.rb` uses `b3 b6 b7`
  on nearly every degrees line under `key "c"`.
- Surface tally: grep across the six movements (table in Area 2).
- CLI: `production_view SOURCE.rb nonsense_view` → raw ArgumentError stack trace.
- Full test suite passes (`bin/test`, exit 0) as of this review.
