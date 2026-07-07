# Examples Manifest

These examples are executable retrieval anchors for LLM composition work.

## Production Surface

- `experiments/partitura/production_hybrid_study.rb`

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
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb compile
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb harmony_with_melody --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb verticals --bars 1-4
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb line --part clarinet
partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
```

## Baseline Prototype

- `experiments/partitura/storyteller_surface_study.rb`

Purpose: shows the first Ruby object/projection prototype. Treat as a biased baseline because it is
still close to note-list thinking.

## Surface Lab

Purpose: executable exploration studies. Use them to compare representation shapes, not as the
production API.

- `experiments/partitura/surface_lab/degree_key_32.rb`
  - Proves: degree/function view over 32 bars.
- `experiments/partitura/surface_lab/relative_interval_32.rb`
  - Proves: motivic contour and transformation can be represented without absolute pitches.
- `experiments/partitura/surface_lab/split_pitch_rhythm_32.rb`
  - Proves: pitch and rhythm can be independently inspectable.
- `experiments/partitura/surface_lab/staff_grid_32.rb`
  - Proves: vertical bar-local representation can replace after-the-fact reconstruction.
- `experiments/partitura/surface_lab/phrase_placement_32.rb`
  - Proves: phrase placement can be explicit without hiding the phrase source.
- `experiments/partitura/surface_lab/hybrid_phrase_staff_32.rb`
  - Proves: recommended model, combining phrase continuity with staff checkpoints.

## Example Commands

```bash
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb structure
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb transport
partitura/bin/surface_view experiments/partitura/surface_lab/hybrid_phrase_staff_32.rb structure
partitura/bin/surface_view experiments/partitura/surface_lab/staff_grid_32.rb bars
partitura/bin/surface_view experiments/partitura/surface_lab/phrase_placement_32.rb placements
```
