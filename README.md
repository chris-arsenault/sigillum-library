# Sigillum Library

Reusable framework, orchestral DSL, technique cards, craft references, and
analysis tooling split out of the Sigillum symphony workspace.

## Layout

- `framework/` - Python score helpers, analysis modules, path/export helpers, and Ruby orchestral DSL
- `technique_library/` - reusable DSL card specimens and technique-card manifests
- `reference/` - craft notes, procedures, and surveys used across works
- `docs/architecture/` - framework and DSL architecture
- `docs/research/` - reusable research notes
- `experiments/orchestral_dsl/` - DSL surface studies
- `tools/` - framework/library command modules
- `tests/` - Python framework and library tests

## Project Roots

Python and Ruby path helpers resolve generated outputs relative to the current
working directory by default. Set `SIGILLUM_PROJECT_ROOT=/path/to/project` when a
caller needs to force outputs and raw-input paths to a specific consumer repo.

## Tests

```bash
python -m pytest
RUBYLIB=framework/orchestral_dsl/ruby/lib ruby framework/orchestral_dsl/ruby/test/test_orchestral_dsl.rb
```
