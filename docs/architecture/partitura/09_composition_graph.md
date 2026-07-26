# Composition Graph

Status: IMPLEMENTED in `sigillum-library` through M4 (2026-07-26); M5 remains in `sigillum-ml`

This design adds a general, non-ML planning and refinement model to Partitura. It supports
whole-score composition and recursive coarse-to-fine authoring without turning Partitura into a
model-training framework, a graph database, or a second score language.

The public name is **Composition Graph**. `ScoreTree` is useful intuition for the containment
hierarchy, but it is incomplete: returns, derivations, dependencies, and realization bindings cross
tree boundaries.

## Decision Summary

1. The production Ruby source remains the only musical source of truth.
2. Plans and realized music coexist in that source. The plan is not a separate JSON document.
3. `CompositionGraph` is a deterministic projection built from a `Production::Piece`; it is not an
   independently edited or persisted model.
4. Piece, section, span, material, phrase, and placement receive typed stable identities.
5. Structural containment remains `piece -> section -> span`. New concepts extend this container;
   they do not create an unrelated top-level score structure.
6. Partial composition is represented by explicit requirements whose mechanical binding state is
   `open`, `partial`, or `bound`. There is no single "detail level" or "percent complete."
7. The first relation vocabulary is deliberately small: `contains`, `realizes`, `derives_from`,
   `returns_to`, and `depends_on`.
8. Compile and export behavior remains strict and unchanged. Graph validation is a separate
   mechanical check and never scores musical quality.
9. Guided-run history remains in `procedure/log.jsonl`; it is not copied into the composition graph.
10. `sigillum-ml` may consume versioned graph and concrete composition snapshots, then attach
    learned data by stable path. Embeddings, reward models, candidate branches, corpora, and
    checkpoints do not belong in Partitura or Git.

These decisions define the implemented v1 contract. Candidate variants and general layered
composition remain intentionally deferred rather than left as open schema questions.

## Problem

The original production model was strong once concrete phrases, placements, textures, and staff
events existed, but did not give a program a durable way to say:

- this section exists but its inner spans are not designed yet;
- this span needs harmony, foreground, bass, and a return of a named material;
- this phrase is a concrete realization of that material;
- these two remote spans are related even though neither contains the other;
- this plan survives bar edits and declaration reordering;
- an external generator or critic may address one exact scope without owning Partitura's data model.

A fixed sequence such as `form -> melody -> harmony -> orchestration -> detail` is too rigid. Real
composition is uneven: one span may have finished foreground but no bass, while another has a
harmonic and orchestration plan but no notes. Recursive refinement therefore needs a vector of
explicit open obligations, not a global stage number.

## Existing Boundaries Preserved

This design preserves Partitura's existing principles:

- The canonical container remains `production_piece -> section -> span`.
- Sounding material remains explicit in phrases, placements, textures, and staff checkpoints.
- Transformations explain provenance; they do not generate hidden committed notes.
- Projections help the composer read and navigate the score; they do not judge it.
- Compile validates concrete score mechanics. It does not become a musical-quality gate.
- Guided pass notes record decisions and carries. They do not duplicate realized material.

The graph describes the composition already declared in the production source. It is not a
general-purpose composition language layered over that source.

## Exemplar Review

The design borrows narrow ideas from the following primary exemplars.

| Exemplar | Useful idea | Adopt | Deliberately reject |
|---|---|---|---|
| [OpenMusic maquettes](https://support.ircam.fr/docs/om/om6-manual/co/Maquettes.html) | Nested temporal containers can hold other containers and preserve local position and duration. | Hierarchical structural traversal and explicit temporal scope. | Executable patch semantics and context-generated hidden musical values. |
| [Whole-Song Hierarchical Generation](https://arxiv.org/html/2405.09901v1) | Form, reduced lead sheet, lead sheet, and accompaniment form interpretable coarse-to-fine realizations. | Upper-level constraints condition lower-level work. | One fixed four-level hierarchy, pop-specific representations, and piano-roll source authority. |
| [music21 stream hierarchy](https://music21.org/music21docs/usersGuide/usersGuide_06_stream2.html) | A score can retain nested structure while exposing flattened reading views. | Keep containment authoritative and graph/flat views derived. | Replacing Partitura's authoring container with a generic event stream. |
| [MEI relations](https://music-encoding.org/guidelines/dev/mei-all_anyStart/elements/relationList.html) and [scholarly variants](https://music-encoding.org/guidelines/v4/content/scholarlyediting.html) | Stable IDs support robust cross-links; alternatives and derivations are explicit. | Typed stable identity and explicit cross-relations. | Inline apparatus for every generated candidate in the accepted score source. |
| [Muster](https://doi.org/10.1016/j.datak.2024.102340) | A score graph can combine rhythmic hierarchy with event flow and support remote structural queries. | A graph-shaped read model for containment and cross-links. | Note-level graph storage, Neo4j, and a second comprehensive score representation. |
| [W3C PROV](https://www.w3.org/TR/prov-o/) | Plans and entities are distinct from the activities that use and generate them. | Keep source entities, semantic derivation, and guided-run activity history separate. | RDF/OWL and a general provenance ontology. |
| [OpenUSD composition](https://openusd.org/22.08/glossary.html) | Stable scene paths, references, and non-destructive variants make large nested structures addressable. | Stable typed paths and explicit references. | Layer strengths, override resolution, composition arcs, and variant sets in v1. |
| [FIGARO](https://arxiv.org/html/2201.10936v4) | Interpretable expert descriptions and learned latent features are complementary. | Human-readable Partitura plans plus optional learned ML sidecars. | Storing opaque learned features in the Partitura source. |
| [NotaGen / CLaMP-DPO](https://arxiv.org/html/2502.18008v2) and [MusicRL](https://arxiv.org/pdf/2402.04229) | Learned preference signals can improve generation, but repeated reward optimization can trade away other objectives. | External learned critics, held-out evaluation, and multi-signal reward reporting. | A single Partitura quality score or an in-library RL loop. |

The most important synthesis is that hierarchy, stable identity, provenance, and learned
representation are different concerns. They interoperate through a small versioned boundary; they
do not share one implementation.

## Authority And Persistence

There are three kinds of state, each with one owner.

| State | Owner | Persistence |
|---|---|---|
| Musical plan and accepted realization | Production Ruby source | Source-controlled Ruby |
| Procedure stage, activity history, decisions, and carries | Guided run | `procedure/run.json` and append-only `procedure/log.jsonl` |
| Embeddings, candidates, critic outputs, preferences, and checkpoints | ML consumer | External artifacts, normally ignored by Git |

`CompositionGraph` is a read model over the first row. It is rebuilt after source edits and contains
no mutable authority. A consumer may save the versioned JSON projection as an experiment input, but
the saved snapshot is not loaded back as an authoring source.

This avoids three competing descriptions of the same composition. The form contract and research
artifacts may continue to explain why decisions were made, but machine-addressable musical
commitments migrate into the production source when they become part of the accepted plan.

## Domain Model

### Addressable node types

| Type | Purpose | Existing or new |
|---|---|---|
| `piece` | Whole-score scope and root plan | Existing object; add `id` |
| `section` | Form-level temporal unit | Existing object and `id` |
| `span` | Local composing/refinement unit | Existing object; add `id` |
| `material` | Non-sounding identity that may have many realizations | New |
| `phrase` | Explicit authored pitch/rhythm realization | Existing object and `id` |
| `placement` | One sounding occurrence of a phrase | Existing object; add `id` |

Gestures, controls, staff bars, notes, and timed events remain properties or bindings visible through
their owning nodes. They are not independent graph nodes in v1. This keeps the graph at composing
resolution instead of reproducing every score event.

### Stable identity

Every graph identity is typed:

```text
piece:study_one
section:exposition
span:opening_statement
material:theme_a
phrase:theme_a_clarinet
placement:theme_a_clarinet_first
```

Rules:

- IDs are explicit symbols and unique within their node type across one piece.
- IDs are never derived from titles, bar ranges, array positions, or source line numbers.
- Moving a node, changing its bars, or reordering declarations does not change its typed path.
- Renaming an ID is an identity change. References must be updated explicitly.
- References always carry a type; `span:theme_a` and `material:theme_a` cannot collide.
- A graph-enabled source requires explicit piece, span, and placement IDs. Section and phrase IDs
  are already explicit.
- Existing `texture` and `fill` builders create placements internally; those placements receive
  deterministic IDs derived from their authored phrase and part identities.
- Existing sources remain valid. A legacy graph view may expose generated, `stable: false`
  locations for missing IDs, but planning declarations and external sidecars may not target them.

Graph-enabled mode begins when a source declares a piece ID, material, plan requirement, or authored
graph relation. In that mode, missing required stable IDs are graph-validation errors. They are not
production-load or export errors unless graph-aware functionality is requested.

### Structural containment

Containment is derived, never redundantly authored:

```text
piece
  contains section
    contains span
      contains phrase
      contains placement
```

Materials are piece-scoped and do not sit in the temporal containment tree. A phrase or placement
links to a material through realization provenance. This distinction allows one material to recur in
many remote spans without pretending that one occurrence contains the others.

V1 does not add span-inside-span. Recursive composition means repeatedly revisiting the applicable
level of the existing hierarchy: piece to sections, section to spans, span to phrases and
placements, and phrase to explicit events. Finer temporal subdivision remains additional sibling
spans inside a section. This preserves the standard Partitura container and avoids a second
open-ended region tree.

### Material

`Material` names an audible identity before or across concrete realizations. It contains descriptive
identity facets, not generated notes:

```ruby
material :theme_a do
  identity pitch: "rising fourth followed by stepwise contraction",
           rhythm: "short short long",
           harmony: "stable scale degrees disturbed by raised 1"
end
```

The identity text must use the existing prose discipline: it attaches to audible pitch, rhythm,
harmony, register, texture, or orchestration. It is not a second phrase body. Concrete sounding
events remain materialized in phrases and placements.

### Plan requirements

A structural node may carry a plan block:

```ruby
plan do
  requires :harmony, coverage: :all_bars
  requires :role, :foreground
  requires :role, :bass_line
  requires :material, :theme_a, relation: :statement
  requires :part, :clarinet
end
```

The v1 requirement vocabulary is closed:

| Facet | Optional selector | Binding evidence |
|---|---|---|
| `harmony` | none | Machine-readable `chords` declarations |
| `material` | material ID | A placed phrase linked to that material |
| `role` | role ID | A sounding placement or texture lane with that role |
| `part` | part ID | Sounding authored material in that part |
| `texture` | texture ID | Matching span or sounding texture declaration |
| `control` | control kind | A matching scoped control |
| `checkpoint` | none | A `staff_bar` in scope |

`coverage` is `:presence` by default. `:all_bars` is available only for facets whose bindings have
bar coverage (`harmony`, `role`, and `part`). Unsupported facet/coverage combinations are invalid
rather than silently reinterpreted.

A requirement's scope is its owner's temporal subtree:

- piece requirement: all sections and spans;
- section requirement: that section's spans;
- span requirement: that span only.

A material requirement may also specify `relation: :statement`, `:return`, `:variation`, or
`:fragment`. These values describe the relationship of explicit material, not a generation command.

### Resolution state

Resolution is computed from the current production objects:

| State | Meaning |
|---|---|
| `open` | No applicable concrete binding exists. |
| `partial` | Some binding exists but an explicit coverage rule is not met. |
| `bound` | Concrete source objects meet the declared presence or coverage rule. |
| `invalid` | The declaration or reference is mechanically inconsistent. |

`invalid` makes graph validation fail. `open` and `partial` are valid during composition. A guided
closeout may require every declared requirement to be `bound`, but that gate checks authored
coverage only. It does not claim that the result is good, expressive, balanced, or finished.

There is intentionally no user-authored `resolution: 70%`, no scalar detail level, and no automatic
"complete" judgment.

### Relations

The v1 relation vocabulary is:

| Relation | Authorship | Meaning |
|---|---|---|
| `contains` | Derived | Structural parent owns a child. |
| `realizes` | Derived from material/phrase/placement declarations | Concrete authored material instantiates a named plan entity. |
| `derives_from` | Authored | One material or phrase is based on another; optional transform metadata explains how. |
| `returns_to` | Authored | A later span, material, or phrase explicitly recalls an earlier target. |
| `depends_on` | Authored | Refining one plan node requires another plan node to be established first. |

Example cross-link syntax:

```ruby
relation :returns_to,
  from: ref(:span, :recapitulation),
  to: ref(:material, :theme_a)

relation :depends_on,
  from: ref(:span, :orchestrated_coda),
  to: ref(:span, :harmonic_coda)
```

Containment and `realizes` are derived to prevent conflicting duplicate declarations.
`derives_from` and `depends_on` must be acyclic. `returns_to` may point backward or across branches
and is not part of dependency ordering. Unknown relation names or endpoint types are errors; v1 does
not accept an open-ended predicate string.

Transform metadata uses the existing provenance rule: it may say `augmentation`, `inversion`, or
`transposed`, but the resulting notes remain explicit.

## Authoring Surface

The complete shape fits inside the current container:

```ruby
production_piece "Composition graph study", id: :graph_study do
  meter "4/4"
  key "F"

  material :theme_a do
    identity pitch: "rising fourth followed by stepwise contraction",
             rhythm: "short short long"
  end

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
    part :cello, "Violoncello", music21: "Violoncello", family: :string
  end

  section :opening, "Statement", bars: 1..8, type: :statement do
    plan do
      requires :material, :theme_a, relation: :statement
      requires :harmony, coverage: :all_bars
    end

    span :opening_call, bars: 1..4, texture: :melody_over_bass do
      plan do
        requires :role, :foreground
        requires :role, :bass_line
      end

      chords "b1:F b2:Bb b3:C7 b4:F"

      phrase :theme_a_clarinet, surface: :degrees,
              material: :theme_a, relation: :statement do
        key_context "F4"
        degrees "1 4 3 2 | 1 r r r"
        rhythm  "1 1 1 1 | 1 1 1 1"
      end

      placement :theme_a_clarinet, id: :theme_a_clarinet_first,
                part: :clarinet, role: :foreground, at: "bar 1 beat 1"

      phrase :opening_bass, surface: :absolute do
        pitch_bars "F2 C3 Bb2 C3"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :opening_bass, id: :opening_bass_first,
                part: :cello, role: :bass_line, at: "bar 1 beat 1"
    end
  end

  section :return, "Return", bars: 25..32, type: :return do
    span :theme_a_return, bars: 25..28, texture: :compressed_return do
      plan do
        requires :material, :theme_a, relation: :return
        requires :role, :foreground
      end

      # The concrete varied phrase and placement are written here.
    end
  end

  relation :returns_to,
    from: ref(:span, :theme_a_return),
    to: ref(:material, :theme_a)
end
```

This source is valid while the return requirement is open. It becomes bound only when an explicit
placed phrase links to `theme_a` with `relation: :return`.

The exact method signatures above are the implementation contract. Builders may use internal value
objects, but should not introduce a second external planning syntax.

## Worked Refinement Without Identity Churn

A non-ML composer can begin with an intentionally open span:

```ruby
section :bridge, "Bridge", bars: 17..24, type: :development do
  span :rising_bridge, bars: 17..24, texture: :contrapuntal_build do
    plan do
      requires :material, :theme_a, relation: :fragment
      requires :role, :foreground, coverage: :all_bars
      requires :role, :bass_line, coverage: :all_bars
      requires :harmony, coverage: :all_bars
    end
  end
end
```

Its graph paths are stable immediately:

```text
section:bridge
span:rising_bridge
```

All four requirements are `open`. A later pass keeps those identities and adds concrete source:

```ruby
section :bridge, "Rising bridge", bars: 19..26, type: :development do
  span :rising_bridge, bars: 19..26, texture: :contrapuntal_build do
    plan do
      requires :material, :theme_a, relation: :fragment
      requires :role, :foreground, coverage: :all_bars
      requires :role, :bass_line, coverage: :all_bars
      requires :harmony, coverage: :all_bars
    end

    chords "b19:Dm b20:Dm b21:Bb b22:Bb b23:Edim b24:Edim b25:A7 b26:A7"

    phrase :theme_a_bridge_fragment, surface: :absolute,
            material: :theme_a, relation: :fragment do
      pitch_bars "A4 D5 C5 | A4 G4 F4"
      rhythm_bars "1 1 2 | 1 1 2"
    end

    placement :theme_a_bridge_fragment, id: :bridge_fragment_violin,
              part: :violin, role: :foreground, at: "bar 19 beat 1"

    phrase :rising_bridge_bass, surface: :absolute do
      pitch_bars "D2 F2 | G2 A2"
      rhythm_bars "2 2 | 2 2"
    end

    placement :rising_bridge_bass, id: :rising_bridge_bass_cello,
              part: :cello, role: :bass_line, at: "bar 19 beat 1"
  end
end
```

Moving the bridge from bars 17-24 to 19-26 does not change either structural path. Harmony becomes
`bound`; the material requirement becomes `bound`; and both all-bars role requirements become
`partial` because their current placements cover only the beginning of the span. Further engraving
revises the same phrase IDs or adds new phrases, controls, and placements. It does not replace the
plan with a new anonymous candidate.

## Graph Projection

Ruby API:

```ruby
graph = Partitura.composition_graph(piece)
graph.node("span:theme_a_return")
graph.requirements(state: :open)
graph.relations(kind: :returns_to)
graph.to_h
```

CLI:

```bash
partitura view SOURCE.rb composition_graph
partitura view SOURCE.rb composition_graph --json
partitura view SOURCE.rb composition_plan
partitura view SOURCE.rb composition_resolution
```

The text view is composer-facing. The JSON form is a deterministic, versioned consumer boundary:

```json
{
  "schema_version": 1,
  "piece": "piece:graph_study",
  "graph_digest": "sha256:...",
  "nodes": [],
  "requirements": [],
  "relations": []
}
```

Rules:

- Arrays use canonical type/path ordering so identical graphs have identical JSON.
- `graph_digest` hashes the normalized graph payload without the digest field.
- Nodes include typed path, parent path, temporal scope where applicable, source attributes, and
  `stable`.
- Requirements include owner, facet, selector, coverage, state, and binding paths.
- Relations include kind, typed endpoints, and normalized metadata.
- Note events are not copied into this graph.
- The graph JSON is a projection, not the backend MusicXML/MIDI transport and not an accepted-source
  import format.

### Concrete composition snapshot

External analysis and ML also need a machine-readable realized score. The current
`Production.export_data(piece)` is deliberately a private, schema-less in-memory exporter adapter,
so it is not an acceptable cross-repository contract.

The separate public projection is:

```bash
partitura view SOURCE.rb composition_snapshot --json
```

Its versioned payload contains:

```json
{
  "schema_version": 1,
  "graph_digest": "sha256:...",
  "snapshot_digest": "sha256:...",
  "graph": {},
  "score": {
    "parts": [],
    "meter_events": [],
    "key_events": [],
    "tempo_events": [],
    "controls": [],
    "phrases": [],
    "placements": [],
    "timed_events": []
  }
}
```

This is a read-only analysis interchange, not a new authoring source and not a handoff between the
MusicXML/MIDI exporters. It formalizes only the concrete fields an external consumer needs.

Every phrase and placement record includes its stable graph path. Timed events include their
placement path and phrase path, allowing score features to aggregate back to a span, section, or
material without parsing prose. Individual events use an ordinal local to their phrase occurrence
but are not stable graph nodes.

`graph_digest` changes when plan structure, requirements, relations, or realization bindings change.
`snapshot_digest` hashes the normalized complete payload without either digest field and therefore
also changes when pitches, durations, controls, instrumentation, or other concrete score data
changes. Plan-only consumers may key caches by `graph_digest`; score or critic consumers key by
`snapshot_digest`.

Serialization rules:

- `schema_version` is an integer. Breaking field or semantic changes increment it.
- Producers emit every required field. Consumers ignore unknown fields but reject unsupported
  higher schema versions.
- Symbols and typed paths serialize as UTF-8 strings.
- Quarter-length offsets and durations serialize as reduced rational strings such as `"3/2"`, not
  floating-point values.
- Optional absent values are omitted consistently rather than alternating between omission and
  `null`.
- Both digests use SHA-256 over UTF-8 canonical JSON with recursively sorted object keys and the
  declared array ordering.

## Validation

The Composition Graph builder reports all graph errors in one response where practical:

- duplicate typed IDs;
- missing required IDs in graph-enabled source;
- unknown or unstable referenced paths;
- node temporal scope outside its structural parent;
- requirements with unknown facets, selectors, relations, or coverage modes;
- material links to unknown material IDs;
- invalid relation endpoint types;
- cycles in `derives_from` or `depends_on`;
- bindings outside the requirement owner's subtree;
- contradictory duplicate requirements on the same `(owner, facet, selector, relation)` key.

Graph validation does not:

- rate melody, harmony, counterpoint, form, orchestration, or novelty;
- infer that prose is musically true;
- require every valid in-progress requirement to be bound;
- change compile or export behavior;
- generate repair music.

The CLI uses the standard error envelope with `code`, `message`, `repair_instruction`,
`help_topic`, and `docs`.

## Guided Procedure Integration

The guided runtime provides two closed mechanical gates:

| Gate | Check |
|---|---|
| `composition_graph_valid` | Graph builds with no `invalid` declarations or references. |
| `composition_graph_bound` | Every declared requirement in the selected run scope is `bound`. |

Early form and planning stages use `composition_graph_valid`; open requirements are expected.
Closeout may use `composition_graph_bound`. The current `source_compiles` gate remains independent.

Guided events and pass notes may carry `graph_paths` so a later stage can reopen the exact section,
span, or material. Activity timestamps, agent attribution, stage status, and carries remain in the
guided log. This mirrors the useful PROV distinction:

- graph nodes and accepted source are entities;
- plan requirements describe intended results;
- guided events are activities;
- user or agent identity belongs to the activity record.

No full PROV serialization is required.

## ML Boundary

Partitura provides:

- stable scopes and cross-relations;
- deterministic graph and concrete composition snapshots;
- explicit open/partial/bound requirements;
- existing concrete score/timed-event projections;
- mechanical validation.

`sigillum-ml` owns:

- graph and score encoders;
- expert and learned feature combinations;
- node-, section-, and whole-score critics;
- preference datasets and reward-model training;
- proposal policies and recursive refinement scheduling;
- candidate source variants;
- embeddings, checkpoints, MLflow runs, and evaluation reports.

A minimal ML sidecar record is keyed by graph identity:

```json
{
  "schema_version": 1,
  "graph_digest": "sha256:...",
  "snapshot_digest": "sha256:...",
  "producer": "encoder-name@checkpoint",
  "records": [
    {
      "path": "span:theme_a_return",
      "artifact": "embeddings/...",
      "scores": {
        "local_preference": 0.42,
        "global_preference": 0.31
      }
    }
  ]
}
```

The snapshot digest makes score-sensitive sidecars stale by construction after a concrete musical
change; the graph digest supports plan-only caches. Partitura does not interpret `scores`, load
checkpoint artifacts, or accept them as musical truth.

For learned-feature reinforcement learning, use at least separate local and whole-score signals plus
held-out human comparison. Do not collapse all critics into a permanent Partitura weight vector.
MusicRL's reported reward over-optimization is the concrete reason to keep reward diagnostics
plural and outside the score framework.

Generated candidates remain separate source files or patches. Accepting a candidate means
materializing all sounding notes in the canonical Ruby source and then rebuilding the graph. A
model may propose a transform; it may not leave a hidden generator in committed source.

## Recursive Composition Semantics

The graph enables fractal-like composition without installing a mandatory generation algorithm:

1. Declare the piece, sections, and coarse spans.
2. Attach requirements to the scopes that need refinement.
3. Select an open or partial requirement, or select any bound node whose musical result should be
   revised.
4. Add the applicable next-level structure, explicit material, phrase, placement, relation, control,
   or event revision.
5. Rebuild the graph and inspect local plus whole-score projections.
6. Repeat at any branch until requirements are mechanically bound and the composer accepts the
   musical result.

A model, an LLM, a human, or a deterministic tool may choose step 3. Partitura owns the state that
makes the choice addressable and inspectable, not the choice policy.

Binding is a coverage floor, not a stopping criterion. A learned critic or human may keep refining a
bound phrase or span; Partitura records the stable target but does not judge whether another pass is
needed.

The reusable refinement operations are therefore conceptual, not score-generating API calls:

- decompose the piece into sections or a section into spans;
- bind a declared requirement with explicit source material;
- relate a new realization to prior material;
- revise a node while retaining its stable identity;
- reopen a bound requirement after its binding is removed or moved out of scope.

Resolution can proceed at different depths in parallel because it is computed per requirement.

## Alternatives And Versioning

V1 does not embed competing candidates in one production source.

OpenUSD and MEI demonstrate that inline variants can be valuable, but they also require selection,
precedence, reference, and export semantics that Partitura does not currently need. For now:

- accepted music lives in one source;
- candidates live as separate ML artifacts, source files, or patches;
- Git records accepted revisions;
- `derives_from` records musical lineage inside one accepted composition;
- `graph_digest` associates plan-only evaluations with an exact semantic graph;
- `snapshot_digest` associates score-sensitive evaluations with an exact concrete realization.

Add a `variant_set` only after a concrete non-ML authoring use case requires simultaneous
alternatives in one source. Do not pre-install layer-strength or override semantics.

## Implementation Status

### M1 — Identity and graph kernel — implemented

- Add piece, span, and placement IDs with legacy compatibility.
- Add typed `GraphPath`, immutable node/relation/requirement value objects, graph builder, and
  deterministic serialization.
- Derive containment from current production objects.
- Implement duplicate/missing identity validation.

### M2 — Planning surface — implemented

- Add `material`, `identity`, `plan`, `requires`, `ref`, and `relation` builders.
- Add phrase-to-material metadata and relation modes.
- Implement requirement binding and relation-cycle validation.
- Keep all sounding material on existing phrase/placement/texture surfaces.

### M3 — Projections and behavioral tests — implemented

- Add `composition_graph`, `composition_plan`, and `composition_resolution` readouts.
- Add the public, versioned `composition_snapshot` analysis interchange with placement provenance.
- Expose graph and snapshot JSON through the consolidated CLI.
- Test deterministic output, stable identity across edits/reordering, partial-source behavior,
  requirement state transitions, relation errors, and unchanged legacy compile/export.
- Add one explicit hand-written score fixture; do not generate its notes with helpers or loops.

### M4 — Guided-run integration — implemented

- Add the two closed graph gates.
- Add graph paths to guided event/pass-note schemas without copying score content.
- Update the composition procedure so form commitments enter source as addressable plans and
  closeout checks binding.

### M5 — ML consumer — external, not yet implemented here

- In `sigillum-ml`, add graph/composition snapshot readers and the digest-keyed sidecar schema.
- Establish separate local and global critic interfaces before training an RL policy.
- Build recursive proposal/evaluation experiments only after the non-ML graph contract passes its
  behavioral tests.

M1-M4 belong in `sigillum-library`. M5 belongs in `sigillum-ml`.

## Acceptance-Test Matrix

| Scenario | Operation | Expected behavior |
|---|---|---|
| Legacy source | Build graph without piece/span/placement IDs | Source still compiles; graph marks generated locations unstable; no sidecar may target them. |
| Stable edit | Change a section name, span bars, and declaration order | Explicit typed paths remain unchanged. |
| Duplicate identity | Reuse one span or placement ID | Graph validation returns a structured duplicate-ID error. |
| Partial plan | Declare requirements with no concrete phrases | Graph is valid; requirements are `open`; compile semantics are unchanged. |
| Incremental binding | Add harmony for half an `:all_bars` scope | Requirement becomes `partial`, not `bound`. |
| Material realization | Add and place a phrase linked to the required material and relation | Requirement reports the phrase and placement paths as bindings. |
| Removed realization | Delete or move the only binding outside its owner scope | Requirement returns to `open` or `partial`; no stale `bound` flag persists. |
| Bad reference | Target an unknown material or unstable legacy path | Graph validation fails with repair instructions. |
| Dependency cycle | Create `depends_on` A-to-B and B-to-A | Graph validation reports the complete cycle. |
| Legitimate return | Point a later span's `returns_to` at earlier material | Relation is accepted and does not participate in dependency-cycle rejection. |
| Deterministic graph | Load the same source twice | Canonical graph JSON and `graph_digest` are byte-identical. |
| Musical edit | Change one explicit pitch without changing plan structure | `snapshot_digest` changes; `graph_digest` may remain unchanged. |
| Plan edit | Add a requirement or relation without changing notes | Both normalized payload and relevant digest change. |
| Export compatibility | Compile/export an existing fixture before and after M1-M4 | MusicXML and MIDI contracts remain unchanged. |
| No hidden generation | Load graph and snapshot projections | No API creates or alters a sounding event. |
| Guided reference | Commit a pass note with graph paths | Paths are logged; musical material is not copied into the pass note. |
| ML staleness | Join a sidecar with an old snapshot digest | Consumer rejects or explicitly marks every score-sensitive record stale. |

## Acceptance Criteria

Implementation is complete when:

- existing production sources compile and export unchanged;
- a graph-enabled source has stable piece, section, span, material, phrase, and placement paths;
- bar edits and declaration reordering preserve those paths;
- graph JSON is deterministic and digest-addressed;
- the concrete snapshot is versioned, placement-addressable, and digest-addressed;
- open and partial plans load and render without weakening concrete compile checks;
- adding/removing explicit source bindings changes requirement state predictably;
- invalid references, duplicate IDs, bad coverage, and dependency cycles return structured errors;
- no graph API produces sounding notes;
- guided history references graph paths but remains the only activity ledger;
- an ML consumer can join a sidecar to graph nodes and detect stale snapshots without Partitura
  knowing anything about its model or scores.

At that point the Composition Graph is useful for human/LLM whole-score planning, non-ML analysis,
and ML generation from the same public contract.
