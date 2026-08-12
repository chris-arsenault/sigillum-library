# Extending LLM Capability Without Fine-Tuning

Partitura is an example of a tool-assisted way to move an LLM into an unfamiliar,
specialized domain without changing the model's weights. It combines a discoverable
command surface, focused just-in-time documentation, a typed domain language,
mechanical validation, alternate read projections, and durable workflow state.

The claim is narrower than "documentation makes a model an expert." Partitura supplies
domain concepts at inference time, makes valid actions easier to discover, rejects many
structural mistakes, and preserves exact state across context changes. It does not create
musical taste, replace judgment, or teach facts that are absent from its documentation,
examples, and runtime.

## Why A Markdown Wiki Alone Is Not Enough

Markdown remains useful for explanations, examples, craft knowledge, and design rationale.
The problem is using a wiki as the only interface an agent has to a domain:

- discovery depends on filenames, links, or a search query the agent must already know to
  ask;
- a long linear reading order puts unrelated material into the same context window;
- stale and current instructions can look equally authoritative;
- prose can describe a valid shape but cannot reject an invalid value or reference;
- the agent must reconstruct state, identity, and next actions from text after every
  context change;
- copying examples out of prose can preserve syntax while losing the domain relationship
  that made the example correct.

Partitura keeps Markdown, but places it behind executable routing and typed interfaces.
For agent work in a structured domain, that hybrid is more reliable than a raw wiki alone.

## The Implemented Pattern

### 1. A cold-start command teaches the available verbs

```bash
partitura/bin/partitura
partitura/bin/partitura help index
```

The bare command answers "what can I do?" The help index answers "which small topic do I
need?" An agent does not need a memorized repository map before it can begin.

### 2. JIT help uses progressive disclosure

Every help topic has the same response fields:

- `use_when`: the decision that should trigger this topic;
- `rules`: the small set of constraints that must remain in working context;
- `example`: a minimal executable shape;
- `next_topics`: valid non-linear continuations;
- `docs`: the deeper files to load only when needed.

The topic graph supports non-linear exploration. A melody question can move from
`decision` to `degrees` to `projections`; an external-analysis task can move directly to
`score_observation` or `annotation_observation`. Neither path requires loading the whole
documentation tree. This reduces accidental context contamination from irrelevant or
superseded instructions.

### 3. The DSL turns prose conventions into checked domain structure

The Ruby DSL makes musical concepts explicit: piece, section, span, material, phrase,
placement, role, control, and staff checkpoint. Pitch surfaces are declared locally rather
than mixed implicitly. Closed vocabularies cover marks, requirement facets, relations,
review criteria, and other values.

The compiler can therefore reject unknown references, bad pitch spellings, mismatched
pitch/rhythm streams, invalid bar boundaries, unstable graph targets, and similar errors.
Its structured error response supplies a repair instruction and the focused help topic to
request next. Markdown explains the contract; the runtime enforces the mechanical part.

### 4. Projections let the agent revisit the same source from another angle

One canonical source can be read as a foreground line, vertical sonorities, an ensemble
grid, harmony comparison, control timeline, material map, Composition Graph, or concrete
composition snapshot. These are derived views, not competing copies of the score.

This matters for effective context because an agent rarely needs the entire source to make
one decision. It can request the bars, part, relationship, or graph scope that exposes the
current problem. The source retains specificity while the view narrows attention.

### 5. Typed state survives context boundaries

Long work is not kept in conversational memory alone:

- guided procedures store their current stage, artifacts, gates, pass-note schema, and
  append-only event log in the consumer project;
- stable Composition Graph paths keep sections, spans, materials, phrases, and placements
  addressable after edits or declaration reordering;
- versioned, digest-bound JSON protocols connect external proposers, critics, annotation
  sources, and evaluation tools without giving them ownership of the score model;
- accepted music remains explicit Ruby source, while generated candidates and learned
  artifacts stay outside it until Partitura validates and promotes exact source bytes.

A fresh agent can re-enter a guided run with `partitura status`, or consume a precise graph
or observation payload, instead of reconstructing state from a transcript summary.

## Where Specificity Comes From

Specificity does not come from putting more prose in the prompt. It comes from keeping one
authority for each kind of fact:

| Fact | Authority |
|---|---|
| Accepted musical plan and notes | Production Ruby source |
| Current procedure stage and decisions | `procedure/run.json` and `procedure/log.jsonl` |
| Graph identity and requirement state | Derived Composition Graph |
| External MusicXML facts | Versioned score observation |
| Bound external annotations | Versioned annotation observation |
| Candidate and selection evidence | Digest-bound workflow messages and trajectory |
| Learned features, weights, and checkpoints | External ML consumer |

Typed IDs, closed enums, rational timing, schema versions, and content digests make those
boundaries machine-checkable. Prose remains attached to concrete source entities or audible
mechanisms where interpretation is unavoidable.

## What Fine-Tuning Would And Would Not Change

Partitura does not fine-tune an LLM. The model receives domain guidance and tool results in
its current context, and the runtime constrains what can enter durable state. This has useful
properties:

- a new model can use the same public contracts immediately;
- corrections land in one library rather than requiring another training run;
- rules remain inspectable and testable;
- consumer repositories can share the capability while retaining their own score source;
- learned systems can participate through versioned protocols without replacing the domain
  runtime.

Fine-tuning may still help a model propose better music or choose better revisions. It would
not remove the need for discoverable commands, stable state, executable validation, canonical
ownership, or held-out evaluation. Those are system properties, not weights.

## Limits Of The Pattern

- JIT retrieval can omit needed context if topics and links are incomplete, so topic integrity
  is tested and the index remains the fallback.
- Typed schemas prevent representational mistakes; they do not prove musical quality.
- Projections can focus attention but can also bias judgment, so Partitura distinguishes
  sounding facts from declared intent and keeps quality decisions outside mechanical gates.
- The approach works best where a domain has stable concepts, useful projections, and errors
  that can be checked. Purely tacit judgment still requires examples, audition, and human or
  learned evaluation.

Partitura's reusable lesson is therefore concrete: keep deep Markdown references, but make
the agent enter through a small executable router; express durable work in typed domain
objects; expose focused projections instead of duplicate summaries; and persist state outside
the context window.
