# DSL procedure - production DSL new composition

This folder contains the default new-composition procedure for scores whose source of truth is the
Ruby production DSL.

The older procedures in `reference/written/procedures/` remain useful craft law, especially
`unified_procedure.md`, `composition_method.md`, `orchestration_procedure.md`, `merge_procedure.md`,
and `post_merge_cypher_fractalization_procedure.md`. They are still symphony/Python-shaped in their
mechanics. This procedure keeps their musical standards but replaces their source model with
`production_piece`, typed surfaces, projections, transport, and export.

## Start Here

- `dsl_composition_procedure.md` - one coherent DSL-first procedure for composing new music, including
  research routing, material design, section writing, flow/interleaving, whole-piece revision, export,
  and closeout.

## Binding Source Model

This procedure assumes the production Ruby DSL documented in:

- `docs/architecture/orchestral_dsl/00_llm_contract.md`
- `docs/architecture/orchestral_dsl/01_container.md`
- `docs/architecture/orchestral_dsl/02_surface_decision.md`
- `docs/architecture/orchestral_dsl/05_compile_api.md`

Use the DSL runtime as a reading tool while composing:

```bash
partitura/bin/dsl_help production
partitura/bin/production_view SOURCE.rb compile
partitura/bin/production_view SOURCE.rb structure
partitura/bin/production_view SOURCE.rb roles
partitura/bin/production_view SOURCE.rb verticals --bars 1-4
partitura/bin/production_view SOURCE.rb harmony_with_melody --bars 1-4
partitura/bin/production_export SOURCE.rb outputs/orchestral_dsl --stem STEM
```

## Technique Library Status

Use `technique_library/dsl/README.md` and `technique_library/dsl/cards/` as the
technique-card library for new production-DSL composition.

- Cite cards and categories as `dsl:<category>/<id>` from `technique_library/dsl/README.md`.
- Use `ruby tools/lib.rb <term>` to find matching cards and their DSL specimen paths.
- Use cards as auditionable musical models, dialect seeds, or high-water marks.
- If a card influences a passage, adapt it into the new piece's own material and write the resulting
  notes, roles, placements, controls, and staff checkpoints directly in the DSL source.
