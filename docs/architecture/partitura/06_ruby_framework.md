# Ruby Framework Boundary

The symphony build path is:

```text
Ruby DSL source -> Ruby framework build/audit -> Ruby MusicXML/MIDI exporters
```

Ruby owns the source, build surface, compiled model, and final MIDI/MusicXML writing.

This is not a line-by-line port of the old Python framework. It is a Ruby framework layer around
the implemented DSL and compiled model, keeping only the parts needed before final notation/audio
export.

## Ported To Ruby

- repository/output path helpers
- movement registry and selected/all movement exports
- direct MusicXML/MIDI source export
- model-measured dynamics and tempo audit
- MusicXML writer
- MIDI writer

## Commands

Write one Ruby DSL source to MusicXML/MIDI:

```bash
ruby ```

Build one or all registered movements to MusicXML/MIDI:

```bash
ruby partitura/bin/partitura_build path/to/registry.rb all
ruby partitura/bin/partitura_build path/to/registry.rb mvt1
```

Export one Ruby DSL source to MusicXML and MIDI:

```bash
partitura/bin/production_export path/to/dsl/source.rb --stem demo
```

Use `partitura_build` or `production_export` when the Ruby
framework should export directly from the compiled model.
