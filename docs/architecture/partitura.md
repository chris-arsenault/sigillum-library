# Partitura Design

Status: implemented Ruby authoring, analysis, guided-workflow, observation, and
MusicXML/MIDI runtime.

Partitura gives an LLM a score source in which melody, harmony, texture,
orchestration, formal identity, and dramatic intent remain inspectable together. It
also gives the agent a way to discover only the domain guidance needed for its current
decision. The broader inference-time capability pattern is documented in
`docs/architecture/partitura/LLM_CONTEXT_ARCHITECTURE.md`; active tasks should enter
through the JIT help index. `docs/architecture/partitura/INDEX.md` remains an optional
expanded catalogue.

```bash
partitura/bin/partitura
partitura/bin/partitura help index
partitura/bin/partitura help llm_design
```

## Implemented Architecture

```text
production Ruby DSL source (accepted musical authority)
  -> typed production object model
     -> focused text/JSON projections
     -> Composition Graph and composition snapshot
     -> direct Ruby MusicXML/MIDI exporters
     -> guided procedure gates and graph-addressed workflow

external MusicXML/MXL
  -> score observation
  -> optional annotation observation

external proposer/assessor/selector
  <-> versioned, digest-bound JSON messages
  -> Ruby-owned sandbox validation and exact-byte promotion
```

The exporters consume the compiled object model directly. There is no public JSON
authoring format and no serialized handoff between the model and the exporters.
`composition_snapshot`, `score-observation`, and `annotation-observation` are separate,
versioned, read-only consumer contracts.

## Why The Source Is A DSL

A flat list of `(pitch, duration, marks)` can render a score, but it hides many of the
relationships an agent needs while composing. Cross-voice harmony, full-line melody,
foreground handoffs, texture roles, recurring identity, and formal dependencies must
then be reconstructed from events after the fact.

Partitura stores those relationships beside the notes. The compiler resolves them into
sounding events and rejects mechanical contradictions. This retains specificity that a
prose-only description cannot enforce, while keeping exact sounding material visible in
source.

## Design Principles

1. **Optimize for composition.** The source and its projections should help the agent
   read and revise music. Mechanical validation is a floor, not a quality score.

2. **Keep musical relationships first-class.** Roles, entrances, register, harmony,
   material identity, controls, and vertical checkpoints belong in the same local
   structure as their notes.

3. **Use typed locality.** Different musical jobs need different notation surfaces.
   Each phrase declares its surface, and untyped mixing is rejected.

4. **Keep sounding material explicit.** Score sources do not hide notes behind helpers,
   loops, comprehensions, repeaters, transposers, or pattern generators. Transform metadata explains
   provenance; it does not replace the realized notes in source.

5. **Attach prose to audible mechanism.** A dramatic claim identifies the rhythm,
   timing, register, contour, harmony, orchestration, density, relation, or silence that
   makes it audible.

6. **Derive views instead of copying summaries.** Projections, graph paths, and
   observations are rebuilt from one authority. They do not become editable competing
   descriptions of the score.

7. **Keep consumer strategies outside the score runtime.** Partitura owns score
   semantics, mechanical validation, scheduling, promotion, and evidence integrity.
   External tools decide how to propose, assess, or select revisions.

## Standard Container And Local Surfaces

The outer shape is stable:

```text
production_piece -> section -> span -> phrase/texture -> placement -> projections
```

The local notation surface depends on the musical job:

| Musical job | Surface |
|---|---|
| Tonal or functional melody | degrees plus separate rhythm |
| Motivic contour | anchor plus relative intervals |
| Independently editable pitch and rhythm | split pitch/rhythm streams |
| Exact register and spelling | absolute pitch |
| Sounding dense vertical mechanism | texture score grid |
| Vertical verification point | staff checkpoint |
| Mixed orchestral passage | hybrid phrases, placements, and checkpoints |

This is the core typed-locality decision: standardize the container and the closed set
of surfaces, rather than forcing every passage into one notation.

## Minimal Source Shape

```ruby
production_piece "Study", id: :study do
  meter "4/4"
  key "F"

  material(:call) { identity pitch: "rising fourth", rhythm: "short short long" }

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
    part :cello, "Violoncello", music21: "Violoncello", family: :string
  end

  section :opening, "Opening", bars: 1..2 do
    span :opening_call, bars: 1..2, texture: :melody_over_bass do
      plan do
        requires :material, :call, relation: :statement
        requires :role, :foreground
      end

      chords "b1:F b2:C7"

      phrase :call_clarinet, pitch: :degrees,
              material: :call, relation: :statement do
        key_context "F4"
        degrees "1 4 3 2 | 1 r r r"
        rhythm  "1 1 1 1 | 1 1 1 1"
      end

      placement :call_clarinet, id: :call_clarinet_first,
                part: :clarinet, role: :foreground, at: "bar 1 beat 1"
    end
  end
end
```

The plan may begin open or partial. Concrete phrases and placements bind its
requirements without changing the stable identities. Binding proves authored coverage,
not musical quality.

## Reading The Same Source Non-Linearly

The view catalogue is discovered at runtime:

```bash
partitura/bin/partitura view
```

Representative focused reads:

```bash
partitura/bin/partitura compile SOURCE.rb
partitura/bin/partitura view SOURCE.rb line --part clarinet
partitura/bin/partitura view SOURCE.rb verticals --bars 1-4
partitura/bin/partitura view SOURCE.rb harmony_check --bars 1-4
partitura/bin/partitura view SOURCE.rb controls
partitura/bin/partitura view SOURCE.rb composition_resolution
partitura/bin/partitura view SOURCE.rb composition_snapshot --json
```

Sounding projections derive from notes and are the primary evidence for what the score
does. Declared-intent views show roles, harmony commentary, material labels, and gesture
claims; they help compare declarations with the sounding result but do not prove those
claims true.

## Long-Running Work

Guided procedures externalize stage order, artifacts, gates, pass-note fields, and the
event log into the consumer project. The default composition procedure requires a caller
supplied commission:

```bash
partitura/bin/partitura start <piece_dir> --source <SOURCE.rb> --brief "<commission>"
partitura/bin/partitura status <piece_dir>
```

Graph-addressed external composition uses a separate protocol:

```bash
partitura/bin/partitura observe SOURCE.rb --trajectory TRAJECTORY.jsonl
partitura/bin/partitura evaluate SOURCE.rb --trajectory TRAJECTORY.jsonl \
  --proposals PROPOSAL_RESPONSE.json
partitura/bin/partitura step SOURCE.rb --trajectory TRAJECTORY.jsonl \
  --proposals PROPOSAL_RESPONSE.json --selection SELECTION_RESPONSE.json
```

The guided procedure, the accepted score, the derived graph, and the external workflow
have distinct authority. See `docs/architecture/partitura/08_cli_and_guided_runs.md` and
`docs/architecture/partitura/09_composition_graph.md`.

## Export And External Observation

```bash
partitura/bin/partitura export SOURCE.rb --stem study
partitura/bin/partitura score-observation path/to/score.mxl
partitura/bin/partitura annotation-observation score-observation.json \
  --profile PROFILE --annotation KIND=FILE
```

Export writes MusicXML and MIDI under the source repository's `outputs/` tree.
Observation commands do not import an external score into the production DSL. They emit
content-addressed factual projections for downstream analysis.

## Non-Goals

- A general-purpose programming or workflow language.
- A second editable score model in JSON or Python.
- A scalar musical-quality validator.
- Hidden generation in committed score source.
- An implementation of any consumer's generation, assessment, or selection strategy.

Detailed syntax, contracts, and examples live in the modular files named by
`partitura help <topic>`. Use `partitura help documentation_index` only when the
complete Markdown map is needed.
