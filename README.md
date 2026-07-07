# Sigillum Library

Reusable framework, orchestral DSL, technique cards, craft references, and
analysis tooling split out of the Sigillum symphony workspace.

## Layout

- `framework/` - Ruby orchestral DSL, production readouts, transport, MusicXML, and MIDI export
- `technique_library/` - reusable DSL card specimens and technique-card manifests
- `reference/` - craft notes, procedures, and surveys used across works
- `docs/architecture/` - framework and DSL architecture
- `docs/research/` - reusable research notes
- `experiments/orchestral_dsl/` - DSL surface studies and proof points
- `tools/` - Ruby framework/library command modules
- `partitura/test/` - Ruby framework and library tests

## Project Roots

Ruby path helpers resolve generated outputs relative to the current working
directory by default. Set `SIGILLUM_PROJECT_ROOT=/path/to/project` when a caller
needs to force outputs and raw-input paths to a specific consumer repo.

## Tests

```bash
for test_file in partitura/test/test_*.rb; do ruby "$test_file" || exit $?; done
```
