# Orchestral DSL Documentation Index

Audience: LLM agents only. This DSL is designed for agent composition work, not human hand-entry.

Load this index first, then load only the files relevant to the current composing decision.

## Implemented Production Surface

Use the production Ruby surface for new source:

```bash
framework/orchestral_dsl/ruby/bin/dsl_help production
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb structure
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb harmony_with_melody --bars 1-4
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb verticals --bars 1-4
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb line --part clarinet
framework/orchestral_dsl/ruby/bin/production_export experiments/orchestral_dsl/production_hybrid_study.rb outputs/orchestral_dsl --stem production_hybrid_study
framework/orchestral_dsl/ruby/bin/sigillum_transport experiments/orchestral_dsl/production_hybrid_study.rb outputs/orchestral_dsl --stem production_hybrid_study
```

Production entry points:

- source file top-level: `production_piece "Title" do ... end`
- Ruby load API: `Sigillum::OrchestralDSL.load_production_file(path)`
- Ruby readout API: `Sigillum::OrchestralDSL.production_readout(piece, :verticals, bars: 1..4)`
- Ruby transport API: `Sigillum::OrchestralDSL.production_transport_hash(piece)`
- CLI readouts: `structure`, `roles`, `phrases`, `placements`, `timed_events`, `verticals`,
  `staff_bars`, `foreground`, `bass_path`, `line`, `harmony`, `harmony_with_melody`,
  `controls`, `material_map`, `gesture_map`, `transport`, `compile`
- CLI export: `production_export SOURCE.rb OUT_DIR --stem STEM`
- Ruby framework transport build: `sigillum_transport SOURCE.rb OUT_DIR --stem STEM`
- Ruby framework registry build: `sigillum_build REGISTRY.rb [movement|all]`

## Read Order

1. For every DSL task, read `00_llm_contract.md`.
2. If composing a new score, read `reference/written/procedures/dsl/README.md` and
   `reference/written/procedures/dsl/dsl_composition_procedure.md`.
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
  source with `tools/mxl_to_dsl.py` (convert + zero-diff verify gate).

## Composition Procedure

Use the project-neutral DSL procedure for new composition work:

- `reference/written/procedures/dsl/README.md`
- `reference/written/procedures/dsl/dsl_composition_procedure.md`

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
framework/orchestral_dsl/ruby/bin/dsl_help index
framework/orchestral_dsl/ruby/bin/dsl_help production
framework/orchestral_dsl/ruby/bin/dsl_help decision
framework/orchestral_dsl/ruby/bin/dsl_help controls
framework/orchestral_dsl/ruby/bin/dsl_help hybrid
framework/orchestral_dsl/ruby/bin/dsl_help transport_export
```

The help response is intentionally short and names the next topics to request.

## Exploratory Material

The `experiments/orchestral_dsl/surface_lab/*.rb` files are executable exploration studies for
comparing notation options. They are not the production authoring API.
