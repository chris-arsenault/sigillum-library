# Surface: Controls And Tempo

Use when a marking belongs to a location, span, instrument subset, family, role, or the whole score.

## Good For

- score-wide tempo marks,
- ritardando and accelerando spans,
- dynamics for one instrument, a family, a role, or all parts,
- crescendos and diminuendos across a range,
- pedal and technique text that should not clutter phrase pitch/rhythm streams.

## Syntax Shape

```ruby
anchor :answer_entry, at: "bar 3 beat 1.5"
anchor :answer_exit, at: "bar 4 beat 3"

tempo do
  mark "quarter = 72", at: "bar 1 beat 1"
  change "quarter = 96", at: "bar 9 beat 1"
  ritardando from: "bar 15 beat 1", to: "bar 16 beat 3.5"
  a_tempo at: "bar 17 beat 1"
end

control do
  dynamic :mf, at: "bar 9 beat 1", for: :piano_upper
  dynamic :pp, at: "bar 13 beat 1", for: [:clarinet, :solo_violin]
  crescendo from: "bar 9 beat 1", to: "bar 12 beat 3.5", for: :string
  diminuendo from: :answer_entry, to: :answer_exit, for: [:clarinet, :solo_violin]
  pedal :down, at: "bar 9 beat 1", for: :keyboard
  pedal :up, at: "bar 10 beat 3", for: :keyboard
  harp_pedals "D# C# B# | E# F# G# A#", at: "bar 5 beat 1", for: :harp_rh
end
```

## Rules

- Use inline event marks for point marks tied to one event: `{mf}`, `{accent}`, `{stacc}`, `{txt:pizz.}`.
- Use `control` for marks that span time or target more than one event.
- Use `tempo` for score tempo. Use `change` or `mark` for explicit tempo marks.
- Use `meter` for score meter changes. Meter changes must be at bar boundaries.
- Locations are explicit strings like `"bar 9 beat 1"` or named anchors.
- `for:` accepts `:all`, a part id, a family selector such as `:string`, a role selector, or a list.
- `harp_pedals` takes the seven pedals in diagram order `D C B | E F G A` (optional `#`/`b` per pedal)
  and renders a real MusicXML `<harp-pedals>` diagram above the target's top staff — set it at the
  start, at every key change, and before glissandi. Never spell pedal settings as `text`.
- Controls are not phrase material. They should not hide missing notes, rhythm, or orchestration.

## Projection Needed

Use `controls` to inspect anchors, tempo events, and scoped controls. Use `transport` before export
when checking exact offsets and target selectors.
