# Ruby Framework Boundary

The symphony build path is:

```text
Ruby DSL source -> Ruby framework build/audit -> JSON transport -> Ruby MusicXML/MIDI exporters
```

Ruby owns the source, build surface, transport shape, and final MIDI/MusicXML writing.

This is not a line-by-line port of the old Python framework. It is a Ruby framework layer around
the implemented DSL and transport shape, keeping only the parts needed before final notation/audio
export.

## Ported To Ruby

- repository/output path helpers
- movement registry and selected/all movement transport builds
- transport-only source export
- transport-measured dynamics and tempo audit
- MusicXML writer
- MIDI writer

## Commands

Write one Ruby DSL source to JSON transport only:

```bash
ruby partitura/bin/partitura_transport path/to/source.rb outputs/tmp --stem demo
```

Build one or all registered movements to transport:

```bash
ruby partitura/bin/partitura_build path/to/registry.rb all
ruby partitura/bin/partitura_build path/to/registry.rb mvt1
```

Export one Ruby DSL source to transport JSON, MusicXML, and MIDI:

```bash
partitura/bin/production_export path/to/dsl/source.rb --stem demo
```

Use `partitura_transport`, `partitura_build`, or `production_export --transport-only` when the Ruby
framework should stop at the transport boundary.
