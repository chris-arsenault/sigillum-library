# LLM Contract

This DSL is LLM-native, LLM-only, and LLM-first. No human is expected to author
production source directly. Optimize for agent comprehension, local retrieval,
self-correction, and exact resumption across context changes.

Partitura supplies domain capability at inference time; it does not fine-tune the model.
The agent should rely on executable discovery, typed source, focused projections, and
persisted state instead of holding a raw documentation wiki or the full score in context.
See `LLM_CONTEXT_ARCHITECTURE.md` for the general design.

## Rules

- The source must expose musical relationships, not just final notes.
- One standard container is mandatory: `piece -> section -> span -> phrase/placement/texture/staff`.
- Local notation surfaces must be typed. Never switch from degrees to intervals to absolute notes
  without an explicit block boundary.
- Default long-line surface: key-relative degrees plus separate rhythm.
- Use the surface that fits the musical job; do not force all music into one notation.
- Dramatic text must attach to audible mechanism: rhythm, timing, register, contour, harmony,
  orchestration, density, entrance timing, or silence.
- A placement attaches one explicit phrase to its part and location. In newly composed
  source, write a separate note list for every sounding occurrence instead of reusing or
  transforming a phrase or fill to produce more notes.
- Projections are reading tools, not pass/fail musical validations. SOUNDING projections
  (note-derived: adjacency_profile, recurrence_map, peak_axes, rhythm_profile, articulation_map,
  breath_map, implied_harmony, harmony_check, ensemble_grid, exposed_clashes, composite_stalls,
  bar_profile, figure_timeline, range_check, bar_probe, metrics, melody_analysis,
  melody_report, verticals, line, grid) are PRIMARY;
  declared-intent projections (roles, harmony, foreground, material_map, gesture_map, ...) are
  secondary and only verify assertions against the sounding result.
- Mechanical checks are allowed, but they are private compiler safety only.

## Forbidden

- Unmarked mixed notation inside one phrase.
- Free-floating evocative prose.
- Helpers, loops, comprehensions, repeaters, transposers, pattern expanders, reusable
  fills, or repeated placements that generate finished sounding music.
- Choosing the old fused `pitch:duration` note-list surface as the default.
- Loading the full documentation set when one topic file is enough.
- Treating prose, a projection, or a saved JSON observation as a second editable source of truth.
- Reconstructing a guided run from chat history when `partitura status` can return exact state.

## Required Agent Habit

Before writing a passage, decide:

1. What is the active musical job?
2. Which local notation surface fits that job?
3. Which projection will reveal whether the notation stayed readable?

Use `partitura/bin/partitura help decision` when unsure.
