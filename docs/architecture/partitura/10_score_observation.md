# External Score Observation

`score-observation` is Partitura's general read-only boundary for accepted
external MusicXML. It lets analysis tools validate and observe a score without
turning that score into production DSL source and without making another
language authoritative for musical semantics.

```bash
partitura/bin/partitura score-observation path/to/score.musicxml
partitura/bin/partitura score-observation path/to/score.mxl
```

The Ruby API is:

```ruby
observation = Partitura.score_observation("path/to/score.mxl")
```

## Contract

Schema version 1 contains:

- exact SHA-256 digests for the source bytes and uncompressed MusicXML
  document;
- the selected root member for compressed MXL;
- title, creators, declared parts, instruments, and per-part coverage;
- a measure timeline with rational quarter-length offsets and durations;
- meter, written key-signature, and tempo events;
- timed note, unpitched, and rest events with part, voice, staff, measure,
  local and absolute onset, duration, chord/grace/cue state, ties, and concert
  pitch where defined;
- a factual summary and explicit parser warnings;
- an observation digest over the canonical payload.

All rational values serialize as reduced strings such as `"3/2"`. MXL
rootfiles must be declared by `META-INF/container.xml`, stay inside the archive,
and be unencrypted. Only `score-partwise` MusicXML is accepted.

The observation is a score-fact transport, not an authoring format. It does not
infer form, phrase boundaries, material identity, orchestral roles, quality, or
training rewards. Corpus admission, annotation joins, lineage-safe splits,
learned features, and weights remain consumer responsibilities.

Production DSL snapshots and external-score observations are deliberately
separate:

- `composition_snapshot` preserves authored Composition Graph identity and
  requirement bindings for a Partitura source.
- `score-observation` preserves notated facts for an external score that has no
  authored Partitura graph.

Both keep Ruby Partitura authoritative for score semantics; neither is a
mutable score representation.
