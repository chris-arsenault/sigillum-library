# Stage 3 - DSL Frame

Before laying the frame, skim the full method palette (degrees/intervals/split/absolute
streams, texture + score grids, fills, anacrusis, chord track) - `partitura help decision` -
so the frame leaves room for the methods each section will need.

Create the source frame:

- `production_piece`
- `meter` and `beat_pattern` where needed
- key or key-region declarations in the source's established style
- `tempo`
- `roster`
- `section` blocks with bars, type, journey, and destination
- `span` blocks with texture and harmony
- initial `control` block for tempo, dynamics, pedal, and technique spans

Use placeholders only as temporary scaffolding. They must be replaced by composed material before the
piece is complete.

The frame is a living scaffold. It may contain thin lines, landmarks, and initial harmonic intentions,
but it must not become a locked skeleton that later span passes merely fill in. If a span pass needs to
reshape harmony, register, role assignment, or a line to make better music, document the divergence and
revise the frame/source accordingly.

Run:

```bash
ruby -c SOURCE.rb
partitura help production
partitura view SOURCE.rb compile
partitura view SOURCE.rb structure
```

