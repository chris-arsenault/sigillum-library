# Sigillum Library Agent Instructions

## Start Here

- One CLI for everything: run `partitura/bin/partitura` bare for the verb map, then
  `partitura/bin/partitura help index` and read `docs/architecture/partitura/INDEX.md`.
  Load only the focused topic docs it names, not the whole documentation set.
- Composing a new piece end-to-end? Do NOT read the whole procedure - run it:
  `partitura/bin/partitura start <piece_dir> --source <SOURCE.rb>` emits one stage at a
  time; `partitura/bin/partitura status` re-orients a fresh context.
- Searching for a technique card? `partitura/bin/partitura cards <term>`
  (`technique_library/dsl/README.md` explains citation format).

## Rules

- Keep this repo piece-agnostic. Do not add symphony-specific movement material here.
- Put reusable score framework, analysis, DSL, technique-card, craft, and procedure material here.
- Path helpers must support consumer repos. Prefer `PARTITURA_PROJECT_ROOT` or current working directory over hard-coded repository roots.
- For newly composed score sources, do not generate sounding musical material with helpers, loops, comprehensions, repeaters, transposers, pattern expanders, or code that stamps out notes. Write the note lists themselves.
