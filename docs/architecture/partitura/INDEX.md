# Partitura Documentation Index

Audience: LLM agents. Production source is designed for agent composition and
machine-checked interchange, not direct human hand-entry.

Partitura extends an LLM's effective domain context at inference time. The CLI routes a
task to small JIT topics; the topics route to focused Markdown only when more depth is
needed; typed DSL objects and versioned schemas retain specificity; projections provide
non-linear reads over one canonical source; and persisted state lets a later context
resume without replaying the whole history. No model fine-tuning is required.

Read `LLM_CONTEXT_ARCHITECTURE.md` when explaining or evaluating that general pattern.
For actual work, start with the runtime:

```bash
partitura/bin/partitura
partitura/bin/partitura help index
```

Load only the topic files named by the response. Do not load this entire directory by
default.

## Task Routes

| Task | First command | Deep reference |
|---|---|---|
| Explain the LLM-context design | `partitura help llm_design` | `LLM_CONTEXT_ARCHITECTURE.md` |
| Author or inspect source | `partitura help production` | `00_llm_contract.md`, `01_container.md` |
| Choose a notation surface | `partitura help decision` | `02_surface_decision.md` |
| Run a composition procedure | `partitura help guided` | `08_cli_and_guided_runs.md` |
| Plan or address whole-score structure | `partitura help composition_graph` | `09_composition_graph.md` |
| Exchange proposals with an external system | `partitura help composition_workflow` | `09_composition_graph.md` |
| Compare candidates or completed scores | `partitura help evaluation` | `08_cli_and_guided_runs.md` |
| Observe external MusicXML/MXL | `partitura help score_observation` | `10_score_observation.md` |
| Bind supported external annotations | `partitura help annotation_observation` | `11_annotation_observation.md` |
| Find a technique card | `partitura cards <term>` | `technique_library/dsl/README.md` |

The commands in this table omit the repository-relative prefix for readability. From the
repository root, run them as `partitura/bin/partitura ...`.

## Core Contracts

- `LLM_CONTEXT_ARCHITECTURE.md` - reusable inference-time capability pattern and its
  limits.
- `00_llm_contract.md` - non-negotiable authoring and context rules.
- `01_container.md` - canonical source container and roster contract.
- `02_surface_decision.md` - local notation-surface selection.
- `03_jit_docs_api.md` - structured JIT help and navigation contract.
- `04_examples_manifest.md` - executable examples and what each demonstrates.
- `05_compile_api.md` - compile responses, structured repair, and export boundary.
- `06_ruby_framework.md` - Ruby build/export ownership and project-root behavior.
- `07_hand_edit_import.md` - deterministic MusicXML-to-event conversion and zero-diff
  verification for a hand-edited source range.
- `08_cli_and_guided_runs.md` - canonical CLI, guided manifests, workflow protocol,
  review, and benchmark commands.
- `09_composition_graph.md` - stable plan/realization graph, snapshots, and external
  composition boundary.
- `10_score_observation.md` - content-addressed external MusicXML/MXL facts.
- `11_annotation_observation.md` - versioned bindings from supported annotations to a
  score observation.

## Production Surface

New source uses `production_piece`. The Ruby loader is
`Partitura.load_production_file(path)`. The CLI exposes compilation, views, export, and
framework builds:

```bash
partitura/bin/partitura compile experiments/partitura/production_hybrid_study.rb
partitura/bin/partitura view experiments/partitura/production_hybrid_study.rb structure
partitura/bin/partitura view experiments/partitura/production_hybrid_study.rb \
  verticals --bars 1-4
partitura/bin/partitura export experiments/partitura/production_hybrid_study.rb \
  --stem production_hybrid_study
```

Run `partitura/bin/partitura view` without a source to list the current view catalogue.
Representative data views include `composition_graph`, `composition_plan`,
`composition_resolution`, and `composition_snapshot`; the catalogue is authoritative.

## Surface References

- `surfaces/degrees.md` - key-relative pitch plus rhythm.
- `surfaces/intervals.md` - anchor plus relative intervals.
- `surfaces/split_pitch_rhythm.md` - independently editable pitch and rhythm streams.
- `surfaces/absolute.md` - explicit pitch/register with rhythm or fused events.
- `surfaces/texture.md` - sounding score-grid texture with embedded lines.
- `surfaces/staff_grid.md` - verified vertical checkpoints.
- `surfaces/phrase_placement.md` - named material, entrances, pickups, and sub-bar fills.
- `surfaces/controls.md` - anchors, meters, tempo, dynamics, hairpins, pedals, clefs,
  text, and harp pedals.
- `surfaces/hybrid.md` - recommended combination for mixed passages.

## Guided Composition

Do not read the entire procedure before starting. The runtime emits one stage at a time:

```bash
partitura/bin/partitura start <piece_dir> --source <SOURCE.rb> \
  --brief "<commission>"
partitura/bin/partitura status <piece_dir>
partitura/bin/partitura commit <piece_dir> --notes -
```

The default manifest is
`reference/written/procedures/partitura/dsl_composition/manifest.json`; its current
pass-note schema is `decisions | carries | improvements | musical_verdict`, with optional
`graph_paths`. The stage payload names the exact artifacts and docs needed next.

## External Analysis And Composition

Use the Composition Graph and snapshot when the source is Partitura Ruby and stable
authored identities matter. Use `score-observation` when the accepted source is external
MusicXML/MXL. Add `annotation-observation` only when binding a supported annotation
profile to an exact score-observation digest.

External proposers, critics, and policies exchange versioned JSON with Partitura. They do
not own source parsing, graph semantics, candidate validation, promotion, or trajectory
continuity. Learned features and weights remain outside this repository.

## Exploratory Material

`experiments/partitura/surface_lab/*.rb` compares representation ideas. It is not the
production API. `partitura/bin/surface_view` remains separate from the consolidated CLI
for that reason.

The old `partitura_help`, `production_view`, `production_export`, and `partitura_build`
binaries remain compatibility shims. Current documentation uses the consolidated
`partitura/bin/partitura` command.
