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

- `texture` is sounding source, not a checkpoint.
- `score` is vertical/grid notation. One token is one grid slot.
- Grid tokens: pitch/chord = attack, `_` = sustain previous note, `.` = silence.
- Chord tokens use existing bracket spelling: `[E4,G4,B4]`.
- Inline marks attach to attacks: `G5{accent}`, `[E4,G4]{arp}`.
- `_` across a barline emits authored ties.
- `line` embeds existing phrase surfaces (`degrees`, `intervals`, `absolute`) in the same texture.
- `control` inside a texture attaches dynamics/hairpins/text to the composite mechanism and expands to participating parts.
- `staff_bar` remains a verified checkpoint; use `score` when the vertical grid should create sound.

## Projection Needed

Use `verticals`, `grid`, `controls`, and `metrics` after authoring.
