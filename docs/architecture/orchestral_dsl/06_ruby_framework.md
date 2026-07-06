# Ruby Framework Boundary

The symphony build path is:

```text
Ruby DSL source -> Ruby framework build/audit -> JSON transport -> Python transport backend -> MIDI/MusicXML
```

Ruby owns the source and build surface. Python still owns final MIDI and MusicXML writing through
`framework.orchestral_dsl_transport` and `framework.foundation.exports.write_score_pair`.

This is not a line-by-line port of the old Python framework. It is a Ruby framework layer around
the implemented DSL and transport shape, keeping only the parts needed before final notation/audio
export.

## Ported To Ruby

- repository/output path helpers
- movement registry and selected/all movement transport builds
- transport-only source export
- transport-measured dynamics and tempo audit

## Deliberately Not Ported

- MusicXML writer
- MIDI writer
- Python building-block generators
- broad Python `framework.analysis` routines

The Python backend remains the supported writer until there is a separate decision to replace it.

## Commands

Write one Ruby DSL source to JSON transport only:

```bash
ruby framework/orchestral_dsl/ruby/bin/sigillum_transport path/to/source.rb outputs/tmp --stem demo
```

Build one or all registered movements to transport:

```bash
ruby framework/orchestral_dsl/ruby/bin/sigillum_build path/to/registry.rb all
ruby framework/orchestral_dsl/ruby/bin/sigillum_build path/to/registry.rb mvt1
```

Render an existing transport through the Python backend:

```bash
python -m framework.orchestral_dsl_transport outputs/tmp/demo.sigillum_transport.json outputs/tmp --stem demo
```

The older `production_export` command is still a convenience wrapper for source -> transport ->
Python backend. Use `sigillum_transport` or `sigillum_build` when the Ruby framework should stop at
the handoff boundary.
