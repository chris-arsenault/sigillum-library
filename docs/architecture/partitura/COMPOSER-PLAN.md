# Composer application

## Existing exploration adoption

The user selected Axiom Interrupt for revision through MCP on October 13. This
extends the original new-composition scope to existing scores. Musical work is
tracked by Sulion plan `281fd895-1d85-4587-99c3-edaac006cd4d`; adoption execution
is branch `8308bbb0-3f12-452e-a72e-05b45fe8a353`, anchored to phase 2.

Outcome: open an existing `explorations/<id>/score.rb` through MCP while keeping
that path as the only active authority. A preview converts the trusted local
production source and compares notes, rests, marks, timing, instruments,
harmony and controls with a rebuilt composer score. Unsupported structures
must fail explicitly. Saving requires the preview's source revision, including
the exploration's Ruby dependencies, and replaces only the entry point.
Existing split source files remain untouched historical material and are no
longer loaded by the managed entry point. No editable duplicate is introduced.

Execution expansion:
1. Convert and verify (`93e5cceb-c5cf-41de-9034-388ada6e9286`): add a production
   adapter preserving explicit phrase segments, local placements, section
   metadata, percussion setup and control timelines. Compare normalized musical
   semantics before allowing a write; do not equate compiler success with parity.
2. Wire durable adoption (`829ea775-86df-43b2-9bbb-c6f06289ee0e`): expose
   `piece_adopt`, discover existing explorations, keep adopted writes at the same
   path, and reject stale previews, ambiguous identities and unsafe paths.
3. Verify (`bce87e8c-fa21-4a65-8443-6db65cb385f2`): test actual round trips,
   dependent-source changes, refused conversions and cold reopen; preview Axiom
   before adopting it. Document the real limits and resume musical work.

New composition storage remains unchanged. Adoption evaluates the existing
trusted workspace score through the established production loader; musical
text submitted through revision operations remains data. The converter does
not generate or alter sounding material.

Adoption implementation evidence: 32 composer tests, 162 assertions pass,
including a real stdio adoption/reopen call, stale dependent-source refusal,
discovery without evaluation and unsafe-path rejection. Changed Ruby files pass
RuboCop. Axiom's real conversion passed semantic parity and was adopted at its
existing entry point. Its original absence of three final-bar voices remains
explicitly flagged as unwritten, to be resolved with authored rests during revision.

Consumer export follow-up: branch `f45d17c1-f9fe-4776-a437-18fdc10aec9e`
implements the existing exploration's one-current-pair convention. The exporter
and resource reader share the score lock; generated revision binding outside
outputs refuses stale/incomplete resource reads. New composition exports remain
immutable. A real stdio adopted-score export/read and replacement/stale-resource
test cover this boundary alongside existing composition tests.

Axiom execution also exposed two existing engine defects: ranged line/vertical/
breath reads used the opening bar length after meter changes, and MIDI treated
player-specific text as a global Notes staff. Both were corrected with focused
regressions. The complete suite passes 403 tests and 3629 assertions. The real
candidate imports as nine balanced 113-measure parts; all2847 pitched MusicXML
onsets and3016 MIDI onsets match the compiled source, with no stuck MIDI notes.
The candidate uses four actual meter changes and lasts approximately178 seconds.
These are mechanical results; listening acceptance remains outstanding.

## Outcome and authorization

A conversational composer can start a piece, establish forces and form, author explicit
music, revise voices and sections together, inspect the result and export through MCP.
The user authorized this plan and local implementation. No publication, hosting, model
calls, consumer-score edits, commits or pushes are included.

The coding burden is an established problem. This work builds the solution; it does not
retest that premise or assess the composer's musical quality through software checks.

## Decisions and reuse

- Keep the existing absolute event notation and optional degree/rhythm notation. Do not
  introduce another note language or require graph declarations to author a score.
- One Ruby application service owns musical operations. Stdio MCP is its first adapter;
  it is launched by the client and needs no persistent development server.
- Keep one canonical application-owned Ruby score per piece. Its `composer_piece`
  declaration contains versioned authoring data, including the original musical text,
  brief and decisions. The runtime builds the existing production model directly from
  that declaration. There is no editable JSON sidecar or generated musical duplicate.
- Parse managed declarations as data on service reads. Musical input is never evaluated
  as Ruby. Existing production Ruby sources and their CLI remain supported.
- Reuse production phrase parsers, instrument metadata, meter/key/tempo/control models,
  compiler, sounding projections and Ruby MusicXML/MIDI exporters.
- Sections and passages have stable IDs. Timing within a section is local, so moving a
  section carries its passages, harmony and expressive controls. Crossing controls and
  pickups are checked explicitly rather than silently stretched or dropped.
- Writes require a revision from the current read and commit related operations atomically
  under a filesystem lock. Unwritten voices are distinguishable from authored rests.
- Musical content is the default read result. Bounded reads disclose omitted content and
  continuation. Discovery and craft references support composing without repository tools.

Actual usage was inspected in the exploration scores. Boreal Pocket and Axiom Interrupt
use absolute streams; degree/rhythm streams occur elsewhere. Quarry's input method was
user-imposed and is not evidence of autonomous surface selection. Boreal revision
`0587f58` demonstrates coordinated section, timing, harmony and control changes.

Local MCP is the transport choice for this implementation. Remote hosting and its identity
integration require a separate user decision; the service must not assume a provider.

## Milestones

Root Sulion plan: `a8e7fbe2-acac-4fc4-96b8-25d5cd2256f7`.

### M1 — Musical authoring model and durable source

Sulion phase: `09460224-b723-4a01-b81e-8f501e4ca7bb`.
Expansion: `4218a09c-9992-4b49-8b73-e7cb13cc970a`.
Steps: `50259091-89bb-4b66-9b5c-afb9e6d9c431`, `5d0300c3-de63-4bf4-8588-3c5e111de583`.

Acceptance: musical text, orchestration, form, brief and decisions survive a cold reopen;
managed source compiles through the existing production loader; strings cannot execute
code; no parallel editable score copy exists.

Execution:
1. Add versioned typed authoring state and an adapter to the production engine. Verify
   existing notation, marks, rational durations, meter, key, tempo and controls.
2. Add one-file managed source storage, safe declaration parsing and atomic replacement.
   Verify cold reopen, confinement and malformed-source refusal.

### M2 — Composition and structural operations [depends on M1]

Sulion phase: `1335f841-274b-4e94-9f43-97c31f2aff54`.
Expansion: `d35a3a6b-7788-42f7-8f07-788d4fdbfa88`.
Steps: `5b2be3f6-bda2-4694-8706-6bedeb3d59e5`, `ee60fb18-3681-45eb-b085-fb46ff85bd72`.
Acceptance: create a piece and revise its voices, passages and form without Ruby input;
related edits succeed or fail together; stale edits fail; moving/extending sections
preserves musical content and remaps timing; reads, projections and exports agree.

Execution:
1. Add closed operations for forces, section context, passages, voices, controls and
   decisions. Apply a related batch to an isolated copy, compile once, then compare
   revisions and atomically save. Verify rollback and stale-write refusal.
2. Add musical reads with ensemble and neighboring context, explicit unwritten coverage,
   structural revisions, sounding inspection and local exports. Verify moving sections
   with meter/key/tempo changes, controls and pickups; refuse invalid shortening.

### M3 — MCP and musical orientation [depends on M2]

Sulion phase: `f3a364a9-44e2-40e4-950f-53a1e314b43e`.
Expansion: `5c2574fa-c109-484a-8bf5-b41040b5d738`.
Steps: `04d4227f-39c1-41a3-be8a-f396c97ff1be`, `356306a4-dcc3-45d0-a6fb-1a7aead88767`.
Acceptance: a real stdio client initializes, discovers typed tools, reads music, submits
edits, obtains focused craft guidance and accesses local exports. Normal responses and
initial instructions concern music rather than shell commands or source editing.

Execution:
1. Share typed contracts between application dispatch and MCP discovery. Supply a musical
   agent guide, task help, craft-reference lookup and card reads as compiled musical content.
2. Implement the dated 2025-11-25 stdio MCP lifecycle, tool calls and local export resources.
   Verify through an actual subprocess, including malformed requests, domain errors,
   continuation, restart and resource access. No network listener is needed.

### M4 — Integrated verification and documentation [depends on M3]

Sulion phase: `c1c966f4-5370-4acd-8049-26759a0e0de5`.
Expansion: `1ede00e9-cd30-4886-abb7-7f4acd6725ab`.
Steps: `fd6c1a6a-e79c-49bc-95bd-bcf8a91781ef`, `d2d8babf-9c33-44dd-b070-ce14cd8928da`.
Acceptance: an end-to-end protocol exercise covers composition, coordinated revision,
structural revision, restart, conflict and invalid-input handling, projections and exports.
Existing applicable checks pass; setup and architecture documentation match implementation.
Software checks establish interface correctness, not musical quality or actual-client UX.

Execution:
1. Review the final authoring, persistence, protocol and resource boundaries. Add meaningful
   coverage for malformed controls, structural edge cases, restart and concurrent writers.
   Resolve changed-file lint without changing unrelated legacy code.
2. Update README, JIT routes and architecture documentation with client setup and the actual
   source contract. Run existing unit tests, structure checks and diff checks; report any
   pre-existing full-repository lint failures separately from the changed files.

## Current state

M1 complete: six focused tests (20 assertions) cover cold reopen, compilation through
the existing loader, literal strings, degree/rhythm parsing, stale writes and confinement.
The existing harmony-track tests also pass. M2 complete: eight service tests (44 assertions)
cover composition, coordinated revisions, rollback, previews, cold resume, context reads,
exports, reordering with meter/key/tempo/controls, extension and unwritten coverage.
M3 complete: five real subprocess tests cover MCP initialization,
discovery, composition, context reads, local XML/MIDI resources, errors and continuation.
M4 complete. `bin/test` passes all 56 suites: 394 tests, 3572 assertions, no failures,
errors or skips. The 25 changed Ruby files pass RuboCop; `git diff --check` passes.
The full structural gate reports 53 findings in unchanged files and none in the new
composer code. Full-repository RuboCop reports 225 offenses in unchanged files; these
are outside this feature's scope. Raw command output is in ignored `tmp/` logs.

The local implementation is complete. Client setup is documented in
`13_composer_application.md`. Consumer scores remain untouched. No commit, push,
hosting or external publication was performed. Actual conversational-client UX and
musical quality were not claimed by the mechanical checks.
