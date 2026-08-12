# Sigillum Library

Partitura is a reusable score framework and an example of extending an LLM into
an unfamiliar specialized domain without fine-tuning. A discoverable CLI routes
the agent to focused just-in-time documentation; a typed Ruby DSL and closed
schemas retain domain specificity; projections expose only the view needed for
the current decision; and guided state survives context changes.

Markdown still carries explanations, craft references, and examples. It is not
the only interface: runtime routing and validation prevent the agent from having
to treat a large wiki as working memory. See
`docs/architecture/partitura/LLM_CONTEXT_ARCHITECTURE.md` for the general pattern.

## Start Here (LLM agents)

Run `partitura/bin/partitura` bare for the verb map, then run
`partitura/bin/partitura help index`. Read
`docs/architecture/partitura/INDEX.md` only when the focused response points to it,
and load only the topic files needed for the current decision.

Useful entry points:

```bash
partitura/bin/partitura help llm_design
partitura/bin/partitura help production
partitura/bin/partitura cards <term>
partitura/bin/partitura start <piece_dir> --source <SOURCE.rb> --brief "<commission>"
partitura/bin/partitura status <piece_dir>
```

For graph-addressed composition, Partitura owns the trusted score runtime:
`observe` emits a scheduled request, `evaluate` validates external proposals in
isolated sources, and `step` promotes or retains exact source bytes and records the
trajectory. Proposal and selection strategies remain consumer-owned behind the
versioned JSON boundary.

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

Install the locked Ruby dependencies once before running commands beyond the bare
verb map or JIT help:

```bash
bundle install
```

```bash
bin/test
```

Slow corpus checks live under the integration target:

```bash
bin/test-integration
```
