# Production Compile, Transport, And Export Contract

This is the implemented authoring compile/readout and export contract for the Ruby
production surface.

## Principle

Compiler responses are not just success/failure. They must tell the composing agent what to request
next and which focused docs to load.

## Success Response Shape

```json
{
  "status": "ok",
  "source_model": "production_hybrid",
  "surface_summary": ["degrees", "intervals", "split_pitch_rhythm", "absolute"],
  "available_projections": ["adjacency_profile", "recurrence_map", "peak_axes", "rhythm_profile", "articulation_map", "breath_map", "implied_harmony", "ensemble_grid", "exposed_clashes", "composite_stalls", "bar_profile", "figure_timeline", "bar_probe", "line", "verticals", "grid", "timed_events", "controls", "metrics", "melody_analysis", "melody_report"],
  "secondary_declared_intent_projections": ["structure", "roles", "phrases", "placements", "staff_bars", "foreground", "bass_path", "harmony", "harmony_with_melody", "material_map", "gesture_map"],
  "projection_note": "available_projections are SOUNDING (note-derived) and primary; secondary views read authored assertions and only verify them against the music",
  "available_exports": ["musicxml", "midi"],
  "next_help_topics": ["projections", "hybrid", "controls"],
  "docs": ["docs/architecture/partitura/INDEX.md"]
}
```

## Error Response Shape

```json
{
  "status": "error",
  "code": "surface_event_count_mismatch",
  "message": "pitches has 2 events but rhythm has 1 in bar 1.",
  "repair_instruction": "Make the two streams align event-by-event, splitting the phrase if needed.",
  "help_topic": "split_pitch_rhythm",
  "docs": ["docs/architecture/partitura/surfaces/split_pitch_rhythm.md"],
  "minimal_example": "phrase :line, surface: :split_pitch_rhythm do ..."
}
```

## Required Compiler Behavior

- Every error names a `help_topic`.
- Every error includes a repair instruction.
- Every response lists only relevant docs.
- Compiler checks remain mechanical and authoring-surface oriented.
- No response should pretend to judge musical quality.

## Implemented Calls

```ruby
piece = Partitura.load_production_file("experiments/partitura/production_hybrid_study.rb")
piece.compile_response
Partitura.production_readout(piece, :compile)
Partitura.production_readout(piece, :harmony_with_melody, bars: 1..4)
Partitura.production_musicxml(piece)
```

CLI:

```bash
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb compile
partitura/bin/production_view experiments/partitura/production_hybrid_study.rb compile
partitura/bin/production_export experiments/partitura/production_hybrid_study.rb --stem production_hybrid_study
```

## Transport Shape

Exporters consume the compiled model directly. Use `Partitura.production_musicxml(piece)` and `Partitura.production_midi(piece)`; there is no serialized JSON handoff.

## Related JIT Help

```bash
partitura/bin/partitura_help compile_api
```
