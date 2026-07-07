# The `partitura` Command And Guided Procedure Runs

Status: IMPLEMENTED (2026-07-07) through milestone M3 plus the M4 doc rewiring.

- `partitura/bin/partitura` is the consolidated CLI (all verbs below); the old bins are
  exec shims. Engine: `partitura/lib/partitura/guided/` (manifest, run, gates,
  pass_note, payload). Tests: `partitura/test/test_guided_runs.rb`.
- First manifest: `reference/written/procedures/partitura/dsl_composition/`
  (manifest.json + principles.md + stages/*.md, split content-preserving from the
  former monolith, which is now a pointer page).
- Implementation deltas from the design below: the `tests_pass` gate is deferred
  (running the library suite inside a consumer-repo closeout is wrong-shaped; revisit
  when a consumer-side check command exists); `runs` scans a given root rather than
  only PARTITURA_PROJECT_ROOT; `commit --source` may register/update the source path.
- Still open from M4: the `section_recomposition` manifest and a real trial run in the
  consumer repo.

Companion finding source: `docs/reviews/2026-07-07_partitura_llm_first_review.md`
(Areas 1, 4, 5).

---

## Motivation

Two problems from the LLM-first review drive this design:

1. **Entry and discovery are fragmented.** Seven separate `bin/` scripts, card search
   hidden in `tools/lib.rb`, no single command that answers "what can I do here?", and
   CLI errors that dead-end (raw stack traces, no view list).
2. **The composition procedure is a 763-line monolith** that every agent must hold in
   context for the whole run, while the procedure itself mandates fresh-context span
   agents — each of which re-pays the full document. Agents satisfy procedures they can
   see all of; they skim them. The procedure must become an interactive protocol where
   the runtime owns the sequence and emits one stage at a time.

## Prior Art (LLM-guided workflow tooling, non-music)

| Tool | Mechanism | What we take |
|---|---|---|
| GitHub Spec Kit | specify→clarify→plan→tasks→implement; each phase emits a named artifact the next phase requires; templates as guardrails; state in workspace files | Artifact-gated transitions; templates constrain output; no daemon — state is plain files. Avoid its weakness: state implicit in branch/dir conventions ("where am I?" requires inference) |
| AWS Kiro | requirements.md→design.md→tasks.md with hard approval gates ("agent cannot proceed until approved"); sanctioned "Quick Plan" fast path | Gates attach to artifact review, not stage names; make the fast path official (`--miniature`) or agents invent unofficial ones |
| Task Master | `next_task` as central primitive — agent never holds the plan, queries it; core toolset trimmed for ~70% token reduction | "What's next" is a runtime query, never agent memory; payloads aggressively compact |
| BMAD method | Phase documents become mandatory context for later phases; "story files" bundle complete context for one unit; quality gates at transitions | Stage payload = self-contained work order naming exactly which artifacts to read; fresh agent needs one command to orient |
| Beads (Yegge) | Git-backed JSONL event log + cache; parallel-agent merge safety | Append-only JSONL audit log; git-friendly; human-inspectable; no hidden source of truth |
| git bisect / rebase sequencer, terraform plan/apply, DB migrations | Tool-owned stateful session (`start/good/bad/skip/reset`), resumable, replayable log; plan artifact gates apply; linear steps + applied-ledger | The tool owns sequence and state; the operator supplies judgments at checkpoints; `--continue/--abort` verbs; ledger of applied steps |

Design principles distilled:

1. One binary, verb subcommands; bare invocation teaches.
2. The runtime is the source of truth for "what's next."
3. Artifacts gate transitions; every transition is recorded.
4. Stage payloads follow the JIT help contract and name docs instead of inlining them.
5. State is git-friendly plain files in the consumer project.
6. Escape hatches are official, named, and logged — never silent.
7. A fresh agent is fully oriented by one command (`partitura status`).

---

## Decisions (from the design session)

| # | Decision | Choice |
|---|---|---|
| D1 | CLI scope | **Full consolidation**: one `partitura` binary owns all verbs; existing bins become shims, removed later |
| D2 | Enforcement | **Hard gates, logged skips**: `commit` refuses on failed gate or empty pass note; `next` exists but records `skipped_audit`; closeout blocks while skips are unresolved |
| D3 | State layout | **Visible `procedure/` directory** inside the piece directory — state, log, and musical artifacts all plainly listable, nothing hidden |
| D4 | Generality | **Generic over music-composition procedure manifests only** — ground-up composition, section recomposition, feedback addressing, card writing. Explicitly NOT a generic workflow manager; the engine may assume a piece directory, a DSL source, and compile/lint/export gates |

---

## Part A — The `partitura` Binary

Location: `partitura/bin/partitura`. All other bins become one-line shims that exec the
corresponding verb (kept through a transition window, then removed).

```text
usage: partitura <command> [args]

  compose    start | status | commit | next | back | log | abandon | runs
  author     compile | lint | view | help
  library    cards <query> | cards show <ID>
  output     export | transport | build
```

Verb map:

| Verb | Replaces | Notes |
|---|---|---|
| `partitura help [topic] [--json]` | `partitura_help` | unchanged contract |
| `partitura view SOURCE [view] [--bars A-B] [--part id]` | `production_view` | bare/unknown view lists all views (primary + secondary, matching the compile response) |
| `partitura compile SOURCE` | `production_view SOURCE compile` | promoted to a verb; response includes `lints:` |
| `partitura lint SOURCE [--json]` | (new) | lint pass alone; see review Area 1 |
| `partitura export SOURCE [--stem S] [--transport-only]` | `production_export` | |
| `partitura transport SOURCE OUT [--stem S]` | `partitura_transport` | |
| `partitura build REGISTRY [movement\|all]` | `partitura_build` | |
| `partitura cards QUERY` / `cards show ID` | `ruby tools/lib.rb` | with the Area-5 search fixes (facet-keyword routing, substring over ids/behavior text, ranked shortlist) |
| `partitura start/status/commit/...` | (new) | Part B |

Cross-cutting contracts:

- `--json` on every verb.
- Every error follows the compile-response error contract: `code`, `message`,
  `repair_instruction`, `help_topic`, `docs`. No raw stack traces reach the agent.
- Bare `partitura` prints the verb map — this plus the AGENTS.md pointer fix is the
  repo's cold-start discovery path.
- `PARTITURA_PROJECT_ROOT` / cwd resolution rules unchanged.

`surface_view` (exploratory lab) intentionally stays outside the consolidated binary;
the lab is not part of the production surface.

---

## Part B — Guided Procedure Runs

### Concepts

- **Procedure**: a versioned manifest of ordered stages with gates, drawn from the
  music-composition procedure family (D4).
- **Run**: one execution of a procedure against one piece directory.
- **Stage**: one unit of fresh attention. May be `iterative` (the Stage-5 span loop),
  in which case it accepts repeated unit commits before a closing commit.
- **Gate**: a mechanical check evaluated at `commit`. Gates are floors, never musical
  judgments (consistent with `00_llm_contract.md`). The musical judgment lives in the
  pass note, whose *presence and completeness* the gate enforces — never its content
  quality.
- **Pass note**: the structured record the current procedure already mandates
  (`Pass | bars/spans | decisions | weaknesses | revisions | outputs/divergences`).
- **Payload**: what the runtime emits after `start`/`status`/`commit` — the next
  stage's work order.

### State layout (D3)

Everything visible, inside the piece directory:

```text
movements/mvt5/
  procedure/run.json          # machine state (current stage, statuses, config)
  procedure/log.jsonl         # append-only audit log
  procedure/brief.md          # Stage 0 artifact
  procedure/form_contract.md  # Stage 1 artifact
  procedure/research_commitments.md
  procedure/return_ledger.md
  dsl/mvt5.rb                 # the score source (location recorded in run.json)
```

Musical artifacts are first-class files agents read and edit directly; `run.json` holds
pointers, never content. Everything is committed to git; `log.jsonl` is append-only so
parallel span agents merge cleanly (Beads lesson).

`run.json` shape:

```json
{
  "procedure": "dsl_composition",
  "procedure_version": 2,
  "mode": "full",
  "source": "dsl/mvt5.rb",
  "started_at": "2026-07-07T18:00:00Z",
  "current_stage": "s5",
  "stages": {
    "s0": { "status": "committed" },
    "s5": { "status": "in_progress", "units_committed": ["bars 1-8", "bars 9-16"] }
  },
  "artifacts": {
    "brief": "procedure/brief.md",
    "form_contract": "procedure/form_contract.md"
  },
  "open_flags": { "skipped_audits": ["s4"], "divergences_unresolved": 1 }
}
```

`log.jsonl` events (one JSON object per line):

```json
{"ts":"...","event":"run_started","procedure":"dsl_composition","mode":"full"}
{"ts":"...","event":"stage_committed","stage":"s1","gates":[{"id":"artifact_exists:form_contract","ok":true}],"pass_note":{...}}
{"ts":"...","event":"unit_committed","stage":"s5","unit":"bars 9-16","pass_note":{...}}
{"ts":"...","event":"stage_skipped","stage":"s4","reason":"...","flag":"skipped_audit"}
{"ts":"...","event":"stage_reopened","stage":"s5","reason":"merge pass found seam weakness b32-33"}
{"ts":"...","event":"run_closed","verdict":"..."}
```

### Command protocol

```bash
partitura start <dir> [--procedure dsl_composition] [--source FILE] [--miniature]
partitura status [<dir>]
partitura commit [--span A-B | --stage-complete] --notes FILE|-
partitura next --reason TEXT
partitura back --to sN --reason TEXT
partitura log [--json] [--stage sN]
partitura abandon --reason TEXT
partitura runs        # list runs under the project root
```

- **`start`** creates `procedure/`, writes `run.json`, logs `run_started`, emits the
  Stage 0 payload and nothing else. Refuses if a run already exists (resume with
  `status`; `--force-new` archives the old run directory first). `--miniature` is the
  sanctioned fast path (Kiro's Quick Plan): activates the manifest's declared miniature
  collapse, recorded in state — agents never need to invent shortcuts.
- **`status`** is the fresh-agent re-entry point: run summary (piece, procedure, mode,
  open flags), the current stage payload, and pointers to committed artifacts. A span
  agent spawned mid-run is fully oriented by `cd <dir> && partitura status`.
- **`commit`** (preferred transition, D2):
  1. validates the pass note against the stage's schema — refuses empty
     decisions/verdict fields;
  2. runs the stage's mechanical gates — refuses on failure with the standard error
     contract (code, repair_instruction, help_topic);
  3. appends `stage_committed` (or `unit_committed` for iterative stages) to the log;
  4. emits the next stage payload (or the next-unit prompt for iterative stages).
  `--notes -` reads the pass note from stdin; a file path is also accepted.
- **`next`** (escape hatch, D2): advances without a pass note. Requires `--reason`.
  Logs `stage_skipped` with flag `skipped_audit`. Open skips are surfaced by `status`
  and **block the closeout stage's gate**: Stage 10 `commit` fails with
  `closeout_blocked` while any `skipped_audit` is unresolved (resolved by returning via
  `back` and committing, or by an explicit resolution note recorded against the skip).
- **`back --to sN`** reopens an earlier stage (the procedure explicitly allows returning
  to stages); logs `stage_reopened` with the reason. Later stages' statuses become
  `stale`, not erased — the log keeps the full history.
- **`abandon`** closes the run as abandoned with a reason; the directory remains for
  the record.

### Stage payload contract

Payloads reuse the JIT help response contract so agents already know the shape:

```text
# Stage 5 — Span Pass (unit 3 of ~7)

use_when: compose one musical phrase/arc with all sounding voices, then verdict it.
inputs:
  - procedure/form_contract.md (rows for bars 17-24)
  - procedure/research_commitments.md (open commitments: 2)
  - previous unit pass note: bars 9-16 (log)
work: <the stage instructions, rendered from stages/05_span_pass.md>
pass_note_schema: bars | engine | decisions | weaknesses | revisions | outputs/divergences | verdict
gate: source_compiles + pass_note_complete
next: partitura commit --span 17-24 --notes -
docs:
  - reference/written/procedures/partitura/dsl_composition/stages/05_span_pass.md
```

Rules:

- The payload **names** docs and artifacts; it inlines only the stage's own
  instructions. Anti-pollution is the point: an agent loads its stage file plus the
  named artifacts, nothing else.
- Payloads include run-specific context the monolith could not: open divergences,
  unused commitments count, previous pass-note pointers, skipped-audit flags.
- `--json` yields the same payload structured.

### Gate vocabulary

Small, mechanical, closed (extended only in the manifest schema, not per-piece):

| Gate | Check |
|---|---|
| `artifact_exists:<id>` | the manifest-declared artifact file exists and is non-empty |
| `pass_note_complete` | pass note parses and required fields are non-empty |
| `source_compiles` | `partitura compile` returns ok |
| `lint_max:<level>` | no lints at or above `<level>` (ties into review Area 1 linter) |
| `export_current` | export artifacts exist and are newer than the source |
| `tests_pass` | repo test suite passes (closeout) |
| `no_open_skips` | no unresolved `skipped_audit` flags (closeout) |
| `no_stale_stages` | no stage left `stale` after a `back` (closeout) |

Explicitly out of scope: any gate that scores musical quality. The runtime enforces
that judgment was *recorded*, never what it concluded.

### Procedure manifests (D4)

A procedure is data: a manifest plus stage markdown files.

```text
reference/written/procedures/partitura/dsl_composition/
  manifest.json
  stages/00_brief.md
  stages/01_form_contract.md
  ...
  stages/10_export_audition_close.md
```

Manifest shape:

```json
{
  "id": "dsl_composition",
  "version": 2,
  "title": "DSL new-composition procedure",
  "stages": [
    {
      "id": "s0", "name": "Brief, Form, Destination",
      "doc": "stages/00_brief.md",
      "artifacts": [{ "id": "brief", "path": "procedure/brief.md" }],
      "gates": ["artifact_exists:brief", "pass_note_complete"]
    },
    {
      "id": "s5", "name": "Span Pass",
      "doc": "stages/05_span_pass.md",
      "iterative": true, "unit": "span",
      "gates": ["source_compiles", "pass_note_complete"],
      "stage_complete_gates": ["source_compiles", "lint_max:error"]
    },
    {
      "id": "s10", "name": "Export, Audition, Close",
      "doc": "stages/10_export_audition_close.md",
      "gates": ["export_current", "tests_pass", "no_open_skips", "no_stale_stages", "pass_note_complete"]
    }
  ],
  "miniature": {
    "collapse": [["s0", "s1"], ["s2", "s3"]],
    "note": "matches the procedure's documented true-miniature fallback"
  }
}
```

**Scope guard (D4):** manifests describe music-composition procedures only —
composition from the ground up, recomposition of a section, feedback addressing, card
writing. The engine may therefore assume: a piece directory, a DSL source file,
compile/lint/export gates, and pass notes about music. It must not grow toward a
generic workflow manager; a proposed manifest that needs non-musical gate types is out
of scope by definition.

Planned manifests, in order:

1. `dsl_composition` — split from `dsl_composition_procedure.md` (the split is
   independently valuable; the stage files remain readable without the wrapper, and the
   monolith becomes a pointer page).
2. `section_recomposition` — from `section_repair_procedure.md`.
3. `feedback_addressing` — new: user gives musical feedback on an exported piece; run
   routes locate → diagnose (projections) → revise → re-export → re-audition.
4. `card_writing` — from `card_writing_procedure.md`.

### Fresh-agent orchestration flow

```text
orchestrator:  partitura start movements/mvt5        # payload: Stage 0
               ... stages 0-3, committing each with pass notes ...
               spawn span agent per span/phrase-arc

span agent:    cd movements/mvt5 && partitura status  # oriented in one command
               ... compose, project, verdict, revise ...
               partitura commit --span 17-24 --notes -

orchestrator:  partitura status                        # sees units committed
               ... spawn merge agent for Stage 9, completion agent for Stage 10 ...

merge agent:   partitura back --to s5 --reason "seam weakness b32-33"   # if needed
```

The multi-agent fresh-attention model in the procedure maps 1:1 onto run state; the
same-agent fallback is just one agent issuing all the commands, with the pass notes
still forced between passes — which is precisely the separation the procedure's
"Fresh Attention Model" section demands.

---

## Interactions With Other Accepted Remediation Work

- The **linter** (review Area 1) plugs in as `lint_max` gates and as the `compile`
  response `lints:` array.
- The **entry chain** fix (Area 4) now points at one thing: bare `partitura`.
- **Card search** fixes (Area 5) ship inside `partitura cards`.
- The **`marks` help topic** (Area 4) is reachable as `partitura help marks`.
- Stage payloads give a natural home for **surface-nudge context**: the Stage 5 payload
  can carry the span's current lint state.

## Implementation Milestones

1. **M1 — binary + consolidation.** `partitura` with author/library/output verbs,
   shims for old bins, verb-map bare output, error-contract wrapper, `cards`
   integration with fixed search, `view` listing behavior. No workflow verbs yet.
2. **M2 — procedure split.** Monolith → manifest + `stages/*.md` (content-preserving
   refactor; monolith becomes a pointer). Valuable standalone: agents can already load
   per-stage files.
3. **M3 — run engine.** `start/status/commit/next/back/log/abandon/runs`, `run.json` +
   `log.jsonl`, gate vocabulary (minus `lint_max` until the linter lands), payload
   rendering, `--miniature`.
4. **M4 — adoption.** INDEX.md/AGENTS.md/README rewires; `dsl_composition_procedure.md`
   reduced to a pointer; second manifest (`section_recomposition`); trial run on a real
   piece in the consumer repo; retire old bins after the transition window.

## Open Items (deferred, not blocking)

- Pass-note format: structured markdown vs JSON via `--notes` (leaning markdown with a
  parseable header row, JSON accepted).
- `runs` listing across a large consumer repo: scan strategy and cost.
- Whether `back` should snapshot the source file hash so `stale` stages can show what
  changed since their commit.
- Concurrency: two span agents committing units simultaneously (JSONL append is safe;
  `run.json` update needs a lock or last-writer-wins with log reconciliation).

## Research Sources

- GitHub Spec Kit: https://github.com/github/spec-kit and
  https://github.com/github/spec-kit/blob/main/spec-driven.md
- AWS Kiro specs: https://kiro.dev/docs/specs/
- Task Master: https://github.com/eyaltoledano/claude-task-master
- BMAD method: https://docs.bmad-method.org/reference/workflow-map/
- Beads: https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a
