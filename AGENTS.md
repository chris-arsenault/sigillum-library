# Sigillum Library Agent Instructions

## Start Here

- One CLI for everything: run `partitura/bin/partitura` bare for the verb map, then
  `partitura/bin/partitura help index`. Follow the focused topic whose `use_when`
  matches the current decision, and load only its named docs when the short response
  is insufficient. Use `partitura/bin/partitura help documentation_index` only for
  the expanded Markdown catalogue.
- Explaining the LLM-facing architecture? Run `partitura/bin/partitura help llm_design`
  and read `docs/architecture/partitura/LLM_CONTEXT_ARCHITECTURE.md`.
- Composing a new piece end-to-end? Do NOT read the whole procedure - run it:
  `partitura/bin/partitura start <piece_dir> --source <SOURCE.rb> --brief "<commission>"`
  emits one stage at a time; `partitura/bin/partitura status` re-orients a fresh context.
- Searching for a technique card? `partitura/bin/partitura cards <term>`
  (`technique_library/dsl/README.md` explains citation format).
- Before composition or musical revision, read
  `reference/written/craft/composition_feedback.md`, then the owning references
  relevant to the piece. Apply contextual lessons without turning them into quotas.

## Rules

- Keep this repo piece-agnostic. Do not add symphony-specific movement material here.
- Put reusable score framework, analysis, DSL, technique-card, craft, and procedure material here.
- When the user supplies composition feedback for library learning, update its
  owning craft guidance and the coverage register above, including conflicting
  recipes and applicable card usage notes. Recording feedback does not authorize
  score edits or regenerating exports over the user's hand corrections.
- Path helpers must support consumer repos. Prefer `PARTITURA_PROJECT_ROOT` or current working directory over hard-coded repository roots.
- For newly composed score sources, do not generate sounding musical material with helpers, loops, comprehensions, repeaters, transposers, pattern expanders, or code that stamps out notes. Write the note lists themselves.
