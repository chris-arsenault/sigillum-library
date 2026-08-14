# Production Compile And Export Contract

The compile response is a machine-readable orientation and repair boundary for the
production Ruby surface. It reports mechanical validity, current lint observations,
available reading views, exports, and relevant JIT topics. It does not score musical
quality.

## Success Response

`partitura/bin/partitura compile SOURCE.rb` emits JSON. The exact projection arrays are
generated from the current runtime; this abbreviated shape shows the stable fields:

```json
{
  "status": "ok",
  "source_model": "production_hybrid",
  "surface_summary": ["degrees", "intervals", "split_pitch_rhythm", "absolute"],
  "lints": [],
  "diagnostics": [],
  "available_projections": ["adjacency_profile", "harmony_check", "verticals", "controls"],
  "secondary_declared_intent_projections": ["structure", "roles", "material_map"],
  "projection_note": "available_projections are SOUNDING (note-derived) and primary; secondary views read authored assertions and only verify them against the music",
  "available_exports": ["musicxml", "midi"],
  "next_help_topics": ["projections", "hybrid", "controls"],
  "docs": ["docs/architecture/partitura/05_compile_api.md"]
}
```

Run `partitura/bin/partitura view` without a source for the complete current view
catalogue. Compile's arrays intentionally distinguish sounding evidence from secondary
declared intent. Data views such as `composition_snapshot` are also listed by the view
catalogue.

## Error Response

```json
{
  "status": "error",
  "code": "surface_event_count_mismatch",
  "message": "phrase :long_line: pitches has 3 events but rhythm has 2 in bar 1.",
  "repair_instruction": "Make the two streams align event-by-event, splitting the phrase if needed.",
  "help_topic": "split_pitch_rhythm",
  "docs": ["docs/architecture/partitura/surfaces/split_pitch_rhythm.md"],
  "minimal_example": "phrase :line, surface: :split_pitch_rhythm do ...",
  "phrase": "long_line",
  "surface": "split_pitch_rhythm",
  "section": "s9",
  "span_bars": "1-2",
  "diagnostics": [
    {
      "severity": "error",
      "code": "surface_event_count_mismatch",
      "message": "phrase :long_line: pitches has 3 events but rhythm has 2 in bar 1.",
      "object_path": "phrase:long_line",
      "source_file": null,
      "source_line": null,
      "repair_instruction": "Make the two streams align event-by-event, splitting the phrase if needed.",
      "help_topic": "split_pitch_rhythm",
      "details": {
        "docs": ["docs/architecture/partitura/surfaces/split_pitch_rhythm.md"],
        "minimal_example": "phrase :line, surface: :split_pitch_rhythm do ...",
        "phrase": "long_line",
        "surface": "split_pitch_rhythm",
        "section": "s9",
        "span_bars": "1-2"
      }
    }
  ]
}
```

Every production compile error identifies a repair action and focused topic. Checks cover
source mechanics such as references, pitch/rhythm alignment, bar boundaries, spans,
roster ranges, checkpoints, controls, and exportability. They do not determine whether a
valid phrase is expressive or appropriate.

`diagnostics` is additive. Existing consumers may continue reading top-level `status`,
`code`, `message`, `repair_instruction`, `help_topic`, `docs`, and `minimal_example`.
Each diagnostic supplies the common machine fields `severity`, `code`, `message`,
`object_path`, `source_file`, `source_line`, `repair_instruction`, `help_topic`, and
`details`. Successful compilation returns an empty array unless lint diagnostics are
present.

## Ruby API

```ruby
piece = Partitura.load_production_file("SOURCE.rb")
piece.compile_response
Partitura.production_readout(piece, :verticals, bars: 1..4)
Partitura.production_musicxml(piece)
Partitura.production_midi(piece)
```

## CLI

```bash
partitura/bin/partitura compile SOURCE.rb
partitura/bin/partitura lint SOURCE.rb
partitura/bin/partitura view SOURCE.rb verticals --bars 1-4
partitura/bin/partitura export SOURCE.rb --stem study
partitura/bin/partitura help compile_api
```

`view SOURCE.rb compile` remains compatible, but the dedicated `compile` verb is the
canonical command.

## Serialization Boundaries

MusicXML and MIDI exporters consume the compiled Ruby model directly. They do not read a
public transport JSON file.

Partitura exposes separate read-only JSON contracts for other purposes:

- `composition_snapshot` contains a production source's Composition Graph and concrete
  score records with digests. Graph-enabled sources carry stable phrase and placement
  provenance; legacy sources may omit unstable placement identities;
- `score-observation` records facts from external MusicXML/MXL;
- `annotation-observation` binds supported external analytical sources to an exact score
  observation;
- composition-workflow protocol messages bind external proposals and selections to exact
  source and snapshot state.

None is an authoring format, exporter handoff, or competing score authority.
