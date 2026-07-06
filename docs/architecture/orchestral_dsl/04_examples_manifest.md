# Examples Manifest

These examples are executable retrieval anchors for LLM composition work.

## Production Surface

- `experiments/orchestral_dsl/production_hybrid_study.rb`

Purpose: executable production authoring surface. Proves the supported production model:

- `production_piece -> roster -> section -> span`
- phrase surfaces: `degrees`, `intervals`, `split_pitch_rhythm`, `absolute`
- block-style phrase placement with role and realization
- staff checkpoints
- mechanism-backed gesture prose
- readouts: `phrases`, `timed_events`, `verticals`, `roles`, `line`, `harmony_with_melody`,
  `material_map`, `gesture_map`, `transport`, `compile`
- export: transport JSON, MusicXML, and MIDI through `production_export`

Run:

```bash
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb compile
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb harmony_with_melody --bars 1-4
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb verticals --bars 1-4
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb line --part clarinet
framework/orchestral_dsl/ruby/bin/production_export experiments/orchestral_dsl/production_hybrid_study.rb outputs/orchestral_dsl --stem production_hybrid_study
```

## Baseline Prototype

- `experiments/orchestral_dsl/storyteller_surface_study.rb`

Purpose: shows the first Ruby object/projection prototype. Treat as a biased baseline because it is
still close to note-list thinking.

## Surface Lab

Purpose: executable exploration studies. Use them to compare representation shapes, not as the
production API.

- `experiments/orchestral_dsl/surface_lab/degree_key_32.rb`
  - Proves: degree/function view over 32 bars.
- `experiments/orchestral_dsl/surface_lab/relative_interval_32.rb`
  - Proves: motivic contour and transformation can be represented without absolute pitches.
- `experiments/orchestral_dsl/surface_lab/split_pitch_rhythm_32.rb`
  - Proves: pitch and rhythm can be independently inspectable.
- `experiments/orchestral_dsl/surface_lab/staff_grid_32.rb`
  - Proves: vertical bar-local representation can replace after-the-fact reconstruction.
- `experiments/orchestral_dsl/surface_lab/phrase_placement_32.rb`
  - Proves: phrase placement can be explicit without hiding the phrase source.
- `experiments/orchestral_dsl/surface_lab/hybrid_phrase_staff_32.rb`
  - Proves: recommended model, combining phrase continuity with staff checkpoints.

## Example Commands

```bash
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb structure
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb transport
framework/orchestral_dsl/ruby/bin/surface_view experiments/orchestral_dsl/surface_lab/hybrid_phrase_staff_32.rb structure
framework/orchestral_dsl/ruby/bin/surface_view experiments/orchestral_dsl/surface_lab/staff_grid_32.rb bars
framework/orchestral_dsl/ruby/bin/surface_view experiments/orchestral_dsl/surface_lab/phrase_placement_32.rb placements
```
