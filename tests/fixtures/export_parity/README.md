# Export Parity Fixtures

These fixtures are the current export target for the Ruby MusicXML and MIDI
ports.

They were rendered from the four canonical exploration DSL sources in
`../sigillum-explorations` using the current `production_export` path:

- `explorations/banner_recursion_dsl/dsl/banner_recursion_canonical.rb`
- `explorations/basin_aria_dsl/dsl/basin_aria.rb`
- `explorations/hammer_gate_toccata/dsl/hammer_gate_toccata.rb`
- `explorations/quarry_rounds_dsl/dsl/quarry_rounds.rb`

Each case keeps the transport JSON that the Ruby exporters should consume, the
MusicXML emitted by the existing music21-backed path, and the MIDI emitted by
that same path. The MusicXML parity test normalizes only current-path volatile
fields: `encoding-date` and generated MusicXML part/instrument IDs.
