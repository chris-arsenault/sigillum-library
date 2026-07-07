# Orchestral DSL Documentation Index

Audience: LLM agents only. This DSL is designed for agent composition work, not human hand-entry.

Load this index first, then load only the files relevant to the current composing decision.

## Implemented Production Surface

Use the production Ruby surface for new source:

```bash
partitura/bin/partitura_help production
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb structure
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb harmony_with_melody --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb verticals --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb line --part clarinet
partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
partitura/bin/partitura_transport experiments/partitura/production_hybrid_study.rb outputs/partitura --stem production_hybrid_study
```

Production entry points:

- source file top-level: `production_piece "Title" do ... end`
- Ruby load API: `Partitura.load_production_file(path)`
- Ruby readout API: `Partitura.production_readout(piece, :verticals, bars: 1..4)`
- Ruby transport API: `Partitura.production_transport_hash(piece)`
- CLI readouts: `structure`, `roles`, `phrases`, `placements`, `timed_events`, `verticals`,
  `staff_bars`, `foreground`, `bass_path`, `line`, `harmony`, `harmony_with_melody`,
  `controls`, `material_map`, `gesture_map`, `transport`, `compile`
- CLI export: `production_export SOURCE.rb --stem STEM`
- Ruby framework transport build: `partitura_transport SOURCE.rb OUT_DIR --stem STEM`
- Ruby framework registry build: `partitura_build REGISTRY.rb [movement|all]`

## Read Order

1. For every DSL task, read `00_llm_contract.md`.
2. If composing a new score, read `reference/written/procedures/partitura/README.md` and
   `reference/written/procedures/partitura/dsl_composition_procedure.md`.
3. If choosing representation, read `02_surface_decision.md`.
4. If writing source, read `01_container.md` plus the relevant surface file.
5. If asking the runtime for help, read `03_jit_docs_api.md`.
6. If importing a user's hand-edited MusicXML, read `07_hand_edit_import.md`.

## Core Files

- `00_llm_contract.md` - non-negotiable LLM-first rules.
- `01_container.md` - the standardized container architecture.
- `02_surface_decision.md` - how to choose the local notation surface.
- `03_jit_docs_api.md` - JIT documentation call/response contract.
- `04_examples_manifest.md` - executable examples and what each proves.
- `05_compile_api.md` - implemented LLM-native compiler, transport, and export contract.
- `06_ruby_framework.md` - Ruby build/audit layer and Python writer boundary.
- `07_hand_edit_import.md` - importing hand-edited MusicXML back into DSL
  source with `Production::MusicXMLImport` (convert + zero-diff verify gate).

## Composition Procedure

Use the project-neutral DSL procedure for new composition work:

- `reference/written/procedures/partitura/README.md`
- `reference/written/procedures/partitura/dsl_composition_procedure.md`

## Surface Files

- `surfaces/degrees.md` - key-relative degrees plus rhythm.
- `surfaces/intervals.md` - anchor plus relative intervals.
- `surfaces/split_pitch_rhythm.md` - independent pitch and rhythm streams.
- `surfaces/absolute.md` - absolute pitch stream plus rhythm.
- `surfaces/staff_grid.md` - bar-local vertical/staff-grid lanes.
- `surfaces/phrase_placement.md` - phrase definitions placed into bar/beat locations.
- `surfaces/controls.md` - anchors, dynamics, hairpins, pedals, text, and tempo timeline.
- `surfaces/hybrid.md` - recommended default: phrase layer plus staff checkpoints.

## Runtime Discovery

Use:

```bash
partitura/bin/partitura_help index
partitura/bin/partitura_help production
partitura/bin/partitura_help decision
partitura/bin/partitura_help controls
partitura/bin/partitura_help hybrid
partitura/bin/partitura_help transport_export
```

The help response is intentionally short and names the next topics to request.

## Exploratory Material

The `experiments/partitura/surface_lab/*.rb` files are executable exploration studies for
comparing notation options. They are not the production authoring API.
