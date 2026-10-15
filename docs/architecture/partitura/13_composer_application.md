# Composer application

Partitura exposes musical authoring tools through MCP so a conversational composer can
work without writing Ruby, editing repository files or invoking the CLI. The application
owns score construction, timing, validation, persistence and exports. Absolute event
lists and optional degrees with rhythm retain their existing musical meanings.

## Connect a client

Install this checkout's dependencies with `bundle install`. Configure a client that
supports local stdio MCP servers to run:

```json
{
  "mcpServers": {
    "partitura": {
      "command": "bundle",
      "args": ["exec", "ruby", "/absolute/path/to/sigillum-library/partitura/bin/partitura",
               "mcp", "--root", "/absolute/path/to/consumer-workspace"],
      "env": {"BUNDLE_GEMFILE":"/absolute/path/to/sigillum-library/Gemfile"}
    }
  }
}
```

Client configuration formats differ. `BUNDLE_GEMFILE` selects this checkout's dependencies
independently of the client's working directory. The workspace must already exist.
`--root` defaults to `PARTITURA_PROJECT_ROOT` or the process working
directory. Consumers do not need to clone the library inside their workspace.

The client launches and stops the subprocess. It exchanges newline-delimited JSON-RPC
on stdin/stdout; diagnostic logs use stderr. The server implements the dated
[2025-11-25 lifecycle](https://modelcontextprotocol.io/specification/2025-11-25/basic/lifecycle)
and [stdio transport](https://modelcontextprotocol.io/specification/2025-11-25/basic/transports),
also negotiating 2025-06-18. It exposes tools and readable resources. This is a local
transport; remote-only conversational clients need a separately deployed transport and
identity boundary. This implementation does not open a network listener or publish music.

## Composing

The server supplies the [composer guide](../../../partitura/lib/partitura/composer/agent_guide.md)
during initialization. `composer_start` returns current pieces, unfinished work and that
guide. Only load help for the decision being made.

| Tool | Purpose |
| --- | --- |
| `piece_start` | Save a commission, opening context and forces. |
| `piece_adopt` | Preview and adopt an existing trusted exploration at its original path. |
| `music_read` | Read form, written voices and sounding ensemble context. |
| `music_revise` | Save related musical and structural changes together, or preview them. |
| `music_inspect` | Read a selected sounding projection and bar range. |
| `music_export` | Export local MusicXML/MIDI and return artifact resource links. |
| `composer_help` | Get task guidance, notation, instrument identifiers or one operation's fields. |
| `composer_reference` | Search and read craft references or technique specimens. |

For example, start a piece with `piece_start`:

```json
{"id":"study","title":"Study","brief":"A singing clarinet over a restrained cello.",
 "meter":"4/4","key":"F","tempo":"quarter = 72",
 "parts":[{"id":"cl","name":"Clarinet","instrument":"Clarinet"},
          {"id":"vc","name":"Cello","instrument":"Violoncello"}]}
```

Use the returned `revision` in `music_revise`. This example shows the `changes` field:

```json
[
  {"type":"set_section","section":{"id":"opening","name":"Opening","bars":2}},
  {"type":"write_passage","section":"opening","passage":{
    "id":"call","at":1,"bars":2,"chords":"b1:F b2:C7",
    "voices":[
      {"id":"song","part":"cl","events":"C5:1{slur(} A4:1 G4:2 | E4:2 F4:2{slur)}"},
      {"id":"ground","part":"vc","role":"bass","events":"F2:4 | C3:4"}
    ]
  }}
]
```

The composer authors every sounding note. Durations are quarter-note units and fractions
are exact. Each `|` marks a barline. Existing inline marks, chords and rests work unchanged.
Optional degree input supplies `degrees`, `rhythm` and `key_context` instead of `events`.
No helper, loop, reusable fill or transformation instruction generates new musical material.

## Revisions and form

`set_section` retains its passages and controls while updating name, length or context.
`write_passage` replaces the named passage in full. `write_voice` updates one voice and
preserves other voices, as well as existing entry/role metadata unless explicitly changed.
`set_part` updates roster fields. Explicit removal operations remove named targets;
remaining musical references and decisions must still validate in the resulting batch.

Part `name` is a staff label; `instrument` is the canonical instrument identifier.
MusicXML keeps these separate when identifying the instrument to a notation program.
Use `ensemble:true` for a section of unspecified size, a positive integer for its
player count, or `ensemble:false` for a single player. Omit it when unspecified.
This identity survives saving and adoption without changing notes or MIDI playback.

`arrange_sections` lists every section exactly once. Section timing is local: moving a
section carries its passages, chords, meter, key, tempo and expressive timeline. Each
section stores its opening context; moving it does not silently inherit a different key
or meter. Passage `at` positions are section-local; voice `entry` positions are
passage-local. Section controls use positions like `bar 1 beat 1`. Ranged controls may
end at the next section's boundary but cannot cross into its interior.

Extending a section creates unwritten space. It does not copy or stretch notes. Shortening
is refused if it would discard a passage or make placed music overflow. Pickups remain
explicit and are checked against their new location. Missing voices and uncovered section
bars are reported separately from explicit rests. `draft:true` permits an unfinished
export for audition; a normal export requires that reported unfinished work be resolved.

Use `remember`/`forget` for settled musical decisions, optionally attached to section and
passage IDs. Brief, form, voices, controls and decisions survive a new conversation.

Reads return musical text and a revision. Large reads return a continuation with its
revision binding. Follow that continuation rather than judging unseen material. A stale
read or write requires a fresh read. Preview compiles proposed changes without saving.

## Authority and execution

Existing `explorations/<id>/score.rb` entry points also appear in discovery.
An unmanaged entry is marked `needs_adoption`; reading it does not execute it.
`piece_adopt` explicitly loads that trusted local source through the production
loader, converts its explicit music and checks rebuilt musical parity. The default
is a preview. Saving requires `preview:false` and the preview's `source_revision`;
the revision covers Ruby files within the exploration, so changed section sources
invalidate the preview. Adoption atomically replaces the entry point at the same
path. Split source files remain untouched but are no longer loaded. No second
editable score is created. Unsupported graph, anchor, transformed-placement,
staff-analysis or cross-section control structures are refused rather than dropped.
Existing absent voices remain unwritten; author explicit rests where silence is
intended before a normal export.

`compositions/<id>.rb` is the single canonical source for an application-owned piece.
Its `composer_piece` declaration contains versioned JSON data in a non-interpolating Ruby
heredoc. This is application storage, not another musical input language for the composer.
There is no editable sidecar, duplicate set of notes or mutable in-memory authority.

Service reads parse the declaration as data and never evaluate musical input as Ruby.
The engine builds the existing production model from its explicit notation. The normal
production loader also accepts managed sources, so existing compile, view and export
commands can consume them. Ordinary hand-authored production sources remain supported
by the existing CLI; normal revisions refuse unmanaged sources. Only explicit
adoption can replace one after its conversion and revision checks.

Every mutation validates a closed request contract, applies the batch to an isolated
score, compiles it, checks the accepted revision under a filesystem lock, and replaces
one source file atomically. Invalid or conflicting batches leave the accepted source
untouched. No external model call occurs inside the service.

Exports are derived artifacts under ignored `outputs/compositions/<id>/<revision>/`.
The MusicXML/MIDI pair is published locally as an immutable revision directory. MCP
resource reads return MusicXML text or base64 MIDI bytes without uploading them. Generated
artifact directories can be removed when no longer needed; the canonical source persists.

Adopted explorations instead export one current pair at
`outputs/explorations/<id>/<id>/<id>.musicxml` and `.mid`. Publication and MCP
resource reads share the score lock. An ignored `.composer-export-revision`
next to the source binds that pair to its exported revision; it is invalidated
before replacement, so failed or superseded pairs cannot be served under an
older resource link. This is generated transport metadata, not musical source.
Ignore `.composer.lock` and `.composer-export-revision` in consumer repositories.

Tests cover the transport and musical operations using synthetic scores. They establish
mechanical behavior, not musical quality, listening acceptance or a particular client's UX.
