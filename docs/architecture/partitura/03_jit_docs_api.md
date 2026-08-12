# JIT Documentation API

Partitura's help system is a small executable router over the deeper Markdown library.
It lets an agent explore the domain non-linearly and keep only the rules for its current
decision in working context.

JIT help does not replace long documentation. It decides which long document, if any,
is relevant now.

## CLI

```bash
partitura/bin/partitura help index
partitura/bin/partitura help documentation_index
partitura/bin/partitura help llm_design
partitura/bin/partitura help production
partitura/bin/partitura help decision
partitura/bin/partitura help degrees
partitura/bin/partitura help guided
partitura/bin/partitura help composition_workflow --json
partitura/bin/partitura help score_observation
partitura/bin/partitura commands --json
partitura/bin/partitura catalog views --json
```

The help branch loads independently of the full score runtime so cold-start discovery
does not require parsing a score or initializing exporter dependencies.

## Ruby API

```ruby
require "partitura"

puts Partitura.help(:decision)
data = Partitura.help_data(:hybrid)
```

## Response Contract

Every known help response includes:

- `schema_version`: version of the machine-readable JIT response contract;
- `topic`: normalized topic identifier;
- `use_when`: the decision or task that should trigger the topic;
- `rules`: the constraints to retain in working context;
- `example`: a minimal executable or data shape;
- `next_topics`: valid focused continuations;
- `docs`: repository-relative deep references.

Text and JSON render the same data. Unknown topics return `topic: unknown` and the
complete topic list in `next_topics`. They do not raise a raw exception or force the
expanded Markdown index into context.

Repository tests verify that every topic has the required fields, every `next_topics`
entry resolves, and every listed documentation file exists.

## Navigation Protocol

1. Run `partitura/bin/partitura help index`; do not preload the Markdown index.
2. Choose the topic whose `use_when` matches the current decision.
3. Retain its `rules` and `example` while acting.
4. Follow one `next_topics` edge when a new decision appears.
5. Load a file under `docs` only when the short response is insufficient. Use
   `documentation_index` only when the complete catalogue is needed.
6. Ask the runtime for a focused projection after authoring instead of copying a large
   source region into context.

This route minimizes accidental context contamination from unrelated procedure stages,
surface syntax, historical reviews, or external-analysis contracts.

## Topic Families

- Design: `llm_design`, `documentation_index`.
- Authoring: `production`, `container`, `roster`, `decision`, `degrees`, `intervals`,
  `split_pitch_rhythm`, `absolute`, `marks`, `controls`, `texture`, `staff_grid`,
  `phrase_placement`, `hybrid`, `harmony`, `hand_edit_import`.
- Reading and output: `projections`, `compile_api`, `export`, `build`.
- Library retrieval: `cards`, `examples`.
- Stateful work: `guided`, `composition_graph`, `composition_workflow`, `protocol`, `evaluation`.
- External data: `score_observation`, `annotation_observation`.

Aliases normalize common names such as `graph`, `score_tree`, `chords`, and
`harmony_check` to their canonical topics.

## Focused Readouts

Run the view command without a source to discover the current catalogue. Discovery is
a successful operation and supports structured output:

```bash
partitura/bin/partitura view
partitura/bin/partitura view --json
```

Then request only the needed scope:

```bash
partitura/bin/partitura view SOURCE.rb line --part clarinet
partitura/bin/partitura view SOURCE.rb verticals --bars 1-4
partitura/bin/partitura view SOURCE.rb harmony_with_melody --bars 1-4
partitura/bin/partitura view SOURCE.rb controls
partitura/bin/partitura view SOURCE.rb composition_resolution
```

Views derive from the source. They are not summaries to edit or feed back into the DSL.

## Repair Loop

Compile failures and other Partitura domain errors return a `help_topic` and focused
`docs`. The intended loop is:

```text
compile or workflow command
  -> structured error
  -> request help_topic
  -> edit canonical source or response
  -> rerun the same command
```

This closes the gap between documentation and action: the runtime names the relevant
rule at the point of failure, and the typed boundary rejects an invalid repair.
