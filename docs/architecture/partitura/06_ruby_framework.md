# Ruby Framework Boundary

Ruby owns production source loading, the compiled score model, projections, framework
registries, mechanical validation, Composition Graph semantics, MusicXML export, and MIDI
export.

```text
Ruby DSL source
  -> Ruby compiled model and audit
  -> Ruby MusicXML/MIDI exporters
```

There is no Python renderer or serialized JSON step in this build path.

## Commands

Compile and export one source:

```bash
partitura/bin/partitura compile path/to/source.rb
partitura/bin/partitura export path/to/source.rb --stem demo
```

Build one or all entries from a framework registry:

```bash
partitura/bin/partitura build path/to/registry.rb all
partitura/bin/partitura build path/to/registry.rb movement_id
```

The compatibility shims `production_export` and `partitura_build` still exec these
commands. New callers should use the consolidated CLI.

## Project-Root Contract

Path helpers support consumer repositories. Generated paths resolve from the current
working directory or the source's Git root as appropriate. A consumer may set
`PARTITURA_PROJECT_ROOT=/path/to/project` when it must force framework outputs and raw
input paths to a specific project.

Library code and documentation must not hard-code the `sigillum-library` checkout path or
assume the consuming score lives in this repository.

## External-System Boundary

Python or another external runtime may consume versioned Partitura snapshots,
observations, workflow requests, and review records. It may return proposals, learned
critic results, or selections through those contracts. It does not replace Ruby parsing,
score semantics, graph identity, sandbox validation, promotion, or export.
