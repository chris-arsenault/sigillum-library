# Orchestral DSL Experiments

Reusable DSL surface studies and proof points live here. These files are not
composition projects; they exist to validate authoring surfaces, projections,
transport behavior, and notation coverage for the shared library.

## Layout

- `surface_lab/` - small focused studies for individual notation surfaces.
- `production_hybrid_study.rb` - mixed-surface production-authoring proof.
- `storyteller_surface_study.rb` - larger production-surface proof with orchestral roles.
- `proof_points/` - focused parity checks for specific notation or transport features.

## Proof Points

- `proof_points/harp_technique_reference.rb` - harp notation parity check covering
  rolled chords up/down, chained glissandi across barlines, laissez vibrer, key
  changes, grand-staff harp routing, and `harp_pedals` controls.
