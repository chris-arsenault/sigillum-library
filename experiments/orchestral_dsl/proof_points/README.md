# DSL Proof Points

Small, focused `production_piece` sources used to prove that a library feature
round-trips through the Ruby DSL, transport, Python renderer, and MusicXML
export. These are deliberately not standalone compositions.

Run from a consumer repo or from `sigillum-library` with:

```bash
RUBYLIB=partitura/lib ruby partitura/bin/production_export experiments/orchestral_dsl/proof_points/<source>.rb
```

When running from another repo, set `SIGILLUM_PROJECT_ROOT` if generated outputs
must land somewhere other than the current working directory.
