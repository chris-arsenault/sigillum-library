# Sigillum Library

Reusable Partitura score framework, technique cards, craft references, and
analysis tooling split out of the Sigillum symphony workspace.

## Start Here (LLM agents)

Run `partitura/bin/partitura` bare for the verb map, `partitura/bin/partitura help
index` for the JIT docs, then read `docs/architecture/partitura/INDEX.md` and load only
the focused topic files it names. Card search: `partitura/bin/partitura cards <term>`.
Composing a piece end-to-end: `partitura/bin/partitura start <piece_dir>` (guided,
stage at a time).

## Layout

- `partitura/` - Ruby Partitura library, commands, tests, MusicXML export, and MIDI export
- `technique_library/` - reusable Partitura card specimens and technique-card manifests
- `reference/` - craft notes, procedures, and surveys used across works
- `docs/architecture/` - framework and Partitura architecture
- `docs/research/` - reusable research notes
- `experiments/partitura/` - Partitura surface studies and proof points
- `tools/` - Ruby framework/library command modules
- `partitura/test/` - Ruby framework and library tests

## Project Roots

Ruby path helpers resolve generated outputs relative to the current working
directory by default. Set `PARTITURA_PROJECT_ROOT=/path/to/project` when a caller
needs to force outputs and raw-input paths to a specific consumer repo.

## Tests

```bash
bin/test
```

Slow corpus checks live under the integration target:

```bash
bin/test-integration
```
