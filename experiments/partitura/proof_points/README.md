# DSL Proof Points

Small, focused `production_piece` sources used to prove that a library feature
round-trips through the Ruby DSL, compiled model, and Ruby MusicXML/MIDI
exporters. These are deliberately not standalone compositions.

Run from a consumer repo or from `sigillum-library` with:

```bash
partitura/bin/partitura export experiments/partitura/proof_points/<source>.rb
```

When running from another repo, set `PARTITURA_PROJECT_ROOT` if generated outputs
must land somewhere other than the current working directory.
