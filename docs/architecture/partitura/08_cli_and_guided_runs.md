# The `partitura` CLI And Stateful Workflows

Status: implemented. `partitura/bin/partitura` is the canonical command. The older
per-command binaries remain compatibility shims but are not used in current examples.

The CLI is the executable entry point for Partitura's progressive-disclosure design. A
bare invocation exposes the verb map; JIT help routes the agent to one focused topic;
authoring commands return derived views or structured errors; and stateful workflows
persist what a later context needs to resume.

```bash
partitura/bin/partitura
partitura/bin/partitura help index
```

## Command Map

### Authoring and discovery

```text
help [topic] [--json]
compile SOURCE.rb
lint SOURCE.rb
view SOURCE.rb [view] [--part ID] [--bars A-B] [--json]
cards <query terms>
cards show <ID>
cards terms
export SOURCE.rb [--stem STEM]
build REGISTRY.rb [movement|all]
```

- `help` returns the fixed JIT response contract. Unknown topics return the complete
  topic list rather than a dead end.
- `compile` emits the structured compile response as JSON and exits nonzero on a compile
  error.
- `lint` renders authoring warnings. Error-level lints block compile; warning-level
  lints require judgment rather than automatic rewriting.
- `view` reads one projection from the canonical source. Run it without a source to see
  the current sounding, data, and declared-intent view catalogues.
- `cards` searches reusable technique specimens by category, facet, identifier, and
  behavior text.
- `export` validates the source and writes MusicXML and MIDI under
  `<source_repo>/outputs/<source_relative_directory>/<stem>/`.
- `build` exports one or all entries from a Ruby framework registry.

`surface_view` remains a separate exploratory command because the surface lab is not a
production authoring API.

### Guided composition procedures

```text
start <piece_dir> [--procedure ID] [--source FILE] [--brief TEXT]
                  [--miniature] [--force-new]
status [<piece_dir>] [--json]
commit [<piece_dir>] [--span A-B | --unit LABEL]
                     [--stage-complete] [--source FILE] --notes FILE|-
next [<piece_dir>] --reason TEXT
back [<piece_dir>] --to sN --reason TEXT
log [<piece_dir>] [--json]
abandon [<piece_dir>] --reason TEXT
runs [<root>]
```

The default `dsl_composition` manifest requires a caller-supplied `--brief`; the runtime
does not invent a commission. `section_recomposition` does not require one.

### Graph-addressed composition exchange

```text
observe SOURCE.rb --trajectory FILE
evaluate SOURCE.rb --trajectory FILE --proposals FILE|-
step SOURCE.rb --trajectory FILE --proposals FILE [--selection FILE]
review --trajectory FILE --reviews FILE --output DIR
       --transition ID --candidate ID --against original|ID
       --scale SCALE --criterion CRITERION
preference --reviews FILE --preferences FILE --review ID
           --outcome a|b|tie|abstain --rater ID
           --purpose LABEL --reason TEXT
```

`observe`, `evaluate`, and `step` accept `--no-export`, `--trajectory-origin`,
`--trajectory-quality`, and `--run-id` where the workflow parser applies them. Agent
origin is paired with the enforced `medium` provenance label; deterministic origin uses
`unrated`. These labels describe source provenance, not musical quality.
`step` requires `--selection` whenever evaluation emits a selection request; it may be
omitted only when the current state produces no such request.

### External observation and completed-score evaluation

```text
score-observation MUSICXML|MXL
annotation-observation SCORE_OBSERVATION.json --profile PROFILE
                       --annotation KIND=FILE [--annotation KIND=FILE ...]
benchmark-score SOURCE.rb
benchmark-review LEFT.rb RIGHT.rb --left-run ID --right-run ID
                 --benchmark ID --case ID --criterion CRITERION
                 --reviews FILE --output DIR
benchmark-preference --reviews FILE --preferences FILE --review ID
                     --outcome a|b|tie|abstain --rater ID --reason TEXT
```

## Error Boundary

Partitura-owned domain failures use structured fields:

```json
{
  "status": "error",
  "code": "surface_event_count_mismatch",
  "message": "pitches has 2 events but rhythm has 1 in bar 1",
  "repair_instruction": "Make the two streams align event-by-event.",
  "help_topic": "split_pitch_rhythm",
  "docs": ["docs/architecture/partitura/surfaces/split_pitch_rhythm.md"]
}
```

The error says what failed, how to repair the mechanical problem, and which small topic
to request. It does not claim to judge the resulting music.

Argument usage failures from the command parser remain short usage messages with exit
code 2. Domain validation failures use the structured envelope.

## Guided Procedure Model

A guided procedure is a versioned JSON manifest plus focused stage Markdown. The engine
owns the stage sequence and emits only the current work order. This lets a fresh context
resume without loading an entire long procedure or inferring state from prose.

Implemented manifests:

- `dsl_composition` v5: eleven stages from commission and form through export,
  audition, and closeout;
- `section_recomposition` v3: diagnosis, repair contract, iterative recomposition,
  seam/adherence review, and closeout.

The consumer project owns visible run state:

```text
<piece_dir>/
  procedure/run.json
  procedure/log.jsonl
  procedure/brief.md
  procedure/form_contract.md
  procedure/research_commitments.md
  procedure/return_ledger.md
  <registered score source>
```

Only artifacts declared by the selected manifest are required. `run.json` stores
current state and pointers. `log.jsonl` is the append-only transition history. Musical
content remains in the registered score source, not in procedure state.

### Starting and resuming

```bash
partitura/bin/partitura start <piece_dir> --source <SOURCE.rb> \
  --brief "<commission>"
partitura/bin/partitura status <piece_dir>
```

`start` creates the run and emits the first stage only. `--miniature` applies the
manifest's declared stage collapses; it does not skip the pass order or invent an
unrecorded fast path. `--force-new` archives an existing run before starting another.

`status` is the re-entry command. It returns the current stage, named inputs, open carry
history, gates, pass-note schema, and next command. A new context should run it rather
than reconstructing progress from the transcript.

### Pass-note schema

Both implemented manifests require these fields:

```text
decisions: why this pass took its chosen direction
carries: cross-stage dependency, unknown, or half-finished material that cannot close here
improvements: what became musically better during this pass
musical_verdict: the current judgment of the music
graph_paths: optional exact Composition Graph targets
```

`graph_paths` is optional. The other four fields must be present and non-empty; `none`
is valid only when a field genuinely has nothing to report. Continuation lines belong to
the most recent field.

Only `carries` feed forward as open threads. Realized material stays in the score and is
read through source and projections. A weakness that can be fixed during the current
stage is fixed there rather than logged for an unspecified later pass.

Example:

```text
decisions: viola takes the call's tail as a countermelody; cello keeps the ground
carries: the return still needs a registral destination in the final section
improvements: replaced the repeated pad with an off-beat viola answer in bars 6-7
musical_verdict: the span now answers the call instead of merely accompanying it
graph_paths: span:development, material:call_tail
```

### Iterative stages

An iterative stage accepts one or more unit commits before a closing commit:

```bash
partitura/bin/partitura commit <piece_dir> --span 5-8 --notes pass-note.md
partitura/bin/partitura commit <piece_dir> --stage-complete --notes pass-note.md
```

The span stage uses `units_cover_source_bars`, so every source bar must belong to a
committed span unit before the stage closes. The closeout uses an audit unit and requires
at least one audit commit. These are attention-coverage checks, not quality scores.

### Mechanical gates

The implemented gate vocabulary is closed:

| Gate | Checks |
|---|---|
| `artifact_exists:<id>` | Declared artifact exists and is non-empty. |
| `pass_note_complete` | Required pass-note fields parsed successfully. |
| `source_compiles` | Registered source returns compile status `ok`. |
| `composition_graph_valid` | Graph identities, requirements, and relations are valid. |
| `composition_graph_bound` | Every declared requirement is currently bound. |
| `lint_max:<level>` | No lint at or above the configured level. |
| `export_current` | Expected MusicXML exists and is no older than source. |
| `min_units:<n>` | Iterative stage has at least `n` committed units. |
| `units_cover_source_bars` | Span units collectively name every source bar. |
| `no_open_skips` | No skipped stage remains unresolved. |
| `no_stale_stages` | No reopened downstream stage remains stale. |

No gate scores melody, harmony, form, orchestration, novelty, or expressive success.
The runtime verifies that required work and judgment were recorded; the pass owns the
judgment.

### Exceptions and history

- `next --reason` skips the current stage, logs `skipped_audit`, and leaves closeout
  blocked until the stage is reopened and committed.
- `back --to sN --reason` reopens an earlier stage and marks later work stale rather
  than erasing history.
- `log` reads the append-only event stream.
- `abandon --reason` closes the run as abandoned without deleting its state.
- `runs` scans the requested root, then `PARTITURA_PROJECT_ROOT`, then the current
  directory.

## Composition Workflow Protocol

The graph-addressed exchange is separate from guided procedure stages.

1. `observe` loads the accepted Ruby source, rebuilds its graph and composition
   snapshot, selects one dependency-valid action, and emits a versioned
   `proposal_request`.
2. An external producer returns a request-bound `proposal_response` containing explicit
   source patches.
3. `evaluate` applies each patch to an isolated source, compiles it, optionally exports
   it, and emits a `selection_request` containing immutable candidate evidence. It does
   not change the accepted source.
4. An external selector returns a request-bound `selection_response` naming a validated
   candidate or `original`.
5. `step` revalidates live source and response bindings, promotes exact validated bytes
   or retains the original, verifies the resulting state, and appends one contiguous
   trajectory transition.

Workflow protocol messages use schema version 1. Persisted trajectory transitions use
schema version 2 and include the exact pre-edit Ruby source, full pre-edit snapshot,
candidate evidence, decision, after digests, and unresolved paths. Request and digest
bindings reject stale or mismatched responses.

The v1 wire key `critic_results` stores assessment evidence from any producer,
including Partitura's deterministic mechanical checks. The name is retained for schema
compatibility and does not imply an in-library learned model.

Pairwise transition review uses review/preference schema version 2. Review scale
(`local`, `seam`, `section`, `global`, or `export`) and criterion (`coherence`,
`identity`, `seams`, `orchestration`, or `reserve`) are separate closed fields. Public
A/B bundles omit candidate mappings; private append-only records retain them. The
consumer supplies a lowercase `purpose` label and decides how that review cohort is used.

## Completed-Score Evaluation

`benchmark-score` compiles and exports one completed source and reports exact structural,
identity, boundary, reserve, and fingerprint diagnostics. These measurements describe
the score; they are not a scalar quality score.

`benchmark-review` creates a blinded A/B MusicXML/MIDI bundle for two opaque system-run
sources. `benchmark-preference` stores one criterion-specific judgment. Its records are
separate from transition preferences; downstream cohort policy remains consumer-owned.

## Compatibility Shims

These still exec the consolidated command:

| Shim | Canonical command |
|---|---|
| `partitura_help` | `partitura help` |
| `production_view` | `partitura view` |
| `production_export` | `partitura export` |
| `partitura_build` | `partitura build` |

New documentation and agent instructions use `partitura/bin/partitura` so discovery,
examples, and errors share one command surface.
