# Surface: Texture + Score Grid

Use when a passage is a composite sounding mechanism: broken-chord ostinato,
distributed chord, ensemble swell, or vertical orchestration block.

## Syntax Shape

```ruby
texture :string_engine, bars: 45..48 do
  control do
    dynamic :mp, at: :start
    crescendo from: :start, to: :end
  end

  score grid: :sixteenth do
    violin "E5 B5 G5 B5 | F5 C6 Ab5 C6"
    viola  "B4 G5 E5 G5 | C5 Ab5 F5 Ab5"
    cello  "E3 .  B3 .  | F3 .  C4 ."
    bass   "E2 .  .  .  | F2 .  .  ."
  end

  line :trumpet_call, part: :trumpet, role: :foreground, surface: :intervals do
    anchor "E5"
    intervals "0 +7 -5 +2 | +1 +7 -5 +2"
    rhythm    ".5 .25 .25 1 | .5 .25 .25 1"
  end
end
```

## Rules

- `texture` is sounding source, not a checkpoint. It is unrelated to the span keyword
  `texture: :label`, which is prose metadata.
- `score` is vertical/grid notation. One token is one grid slot; grids: `whole`, `half`,
  `quarter`, `quarter_triplet`, `eighth`, `eighth_triplet`, `sixteenth`, `thirty_second`.
- Slot counts are verified: every bar of every lane must carry exactly the meter's slot
  count for the chosen grid, with one `|` per barline (compile error
  `score_grid_slot_mismatch` naming the texture, lane, and bar otherwise). A grid that
  does not divide the meter evenly is rejected with a finer-grid suggestion.
- Grid tokens: pitch/chord = attack, `_` = sustain previous note, `.` = silence.
- Chord tokens use existing bracket spelling: `[E4,G4,B4]`.
- Inline marks attach to attacks: `G5{accent}`, `[E4,G4]{arp}` (closed mark vocabulary
  applies - see `partitura help marks`).
- `_` across a barline emits authored ties (chords tie member-by-member).
- `line` embeds existing phrase surfaces (`degrees`, `intervals`, `absolute`) in the same texture.
  A line normally enters at the texture's first bar; use `anacrusis N` inside the line
  when its written pickup starts before that barline, or write leading rests for a later
  entrance.
- `control` inside a texture attaches dynamics/hairpins/text to the composite mechanism and expands
  to participating parts (embedded lines included); `:start`/`:end` anchor to the texture's bars.
- `staff_bar` remains a verified checkpoint; use `score` when the vertical grid should create sound,
  and a `staff_bar` when you want the vertical asserted and re-verified on every compile.

## Projection Needed

Use `verticals`, `grid`, `controls`, and `metrics` after authoring.
