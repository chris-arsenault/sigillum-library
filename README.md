# Sigillum Library

Reusable Partitura score framework, technique cards, craft references, and
analysis tooling split out of the Sigillum symphony workspace.

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
