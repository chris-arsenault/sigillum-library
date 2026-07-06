# Production Compile, Transport, And Export Contract

This is the implemented authoring compile/readout, transport, and export contract for the Ruby
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
  "available_projections": ["adjacency_profile", "recurrence_map", "peak_axes", "rhythm_profile", "articulation_map", "breath_map", "implied_harmony", "ensemble_grid", "exposed_clashes", "bar_profile", "figure_timeline", "line", "verticals", "grid", "timed_events", "controls", "transport"],
  "secondary_declared_intent_projections": ["structure", "roles", "phrases", "placements", "staff_bars", "foreground", "bass_path", "harmony", "harmony_with_melody", "material_map", "gesture_map"],
  "projection_note": "available_projections are SOUNDING (note-derived) and primary; secondary views read authored assertions and only verify them against the music",
  "available_exports": ["transport_json", "musicxml", "midi"],
  "next_help_topics": ["projections", "hybrid", "controls", "transport_export"],
  "docs": ["docs/architecture/orchestral_dsl/INDEX.md"]
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
  "docs": ["docs/architecture/orchestral_dsl/surfaces/split_pitch_rhythm.md"],
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
piece = Sigillum::OrchestralDSL.load_production_file("experiments/orchestral_dsl/production_hybrid_study.rb")
piece.compile_response
Sigillum::OrchestralDSL.production_readout(piece, :compile)
Sigillum::OrchestralDSL.production_readout(piece, :harmony_with_melody, bars: 1..4)
Sigillum::OrchestralDSL.production_transport_json(piece)
```

CLI:

```bash
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb compile
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb transport
framework/orchestral_dsl/ruby/bin/production_export experiments/orchestral_dsl/production_hybrid_study.rb outputs/orchestral_dsl --stem production_hybrid_study
```

## Transport Shape

The transport JSON has:

- `schema`: `sigillum.orchestral_dsl.transport`
- `schema_version`: `3`
- score metadata: title, meter, beat pattern, key, tempo marks/events, anchors, controls, total duration
- authored structures: parts, sections, spans, phrases, placements, staff bars, gestures
- backend-ready `timed_events` with part, role, phrase, `event_type`, `pitches`,
  `pitch_label`, local marks, offset, duration, and labels

The Python backend is:

```bash
python -m framework.orchestral_dsl_transport TRANSPORT.json OUT_DIR --stem STEM
```

It consumes timed events, fills only silent gaps, attaches span harmony text, attaches tempo/control
markings, and writes MusicXML/MIDI through `framework.foundation.exports.write_score_pair`.

## Related JIT Help

```bash
framework/orchestral_dsl/ruby/bin/dsl_help compile_api
```
