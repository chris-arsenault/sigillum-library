# Surface: Key-Relative Degrees

Use when melody function matters more than absolute spelling.

## Good For

- tonal foreground melody,
- cadence tendencies,
- modal inflections,
- transposition without losing function.

## Syntax Shape

```ruby
phrase :call, pitch: :degrees do
  key_context "F4"
  degrees "5 4 3 #1 1"
  rhythm  "1.5 .25 .25 .5 1"
end

phrase :degree_chords, pitch: :degrees do
  key_context "F4"
  degrees "[1,3,5]{ten} 2 r"
  rhythm  "1 1 1"
end
```

## Rules

- Declare key/mode context nearby.
- Keep rhythm separate.
- Use explicit accidentals: `#1`, `b6`.
- Use bracketed degree chords like `[1,3,5]` when harmony should remain key-relative.
- Use inline event marks only when the mark belongs to that single event.
- Use octave markers only when necessary, e.g. `1'`.
- Do not mix absolute pitches inside the same `degrees` phrase.
- Put score-level or section-level dynamics and tempo in `control` or `tempo`.

## Projection Needed

After authoring, request absolute-pitch and vertical readouts before deciding orchestration.

## Example

See `experiments/orchestral_dsl/production_hybrid_study.rb` for production syntax and
`experiments/orchestral_dsl/surface_lab/degree_key_32.rb` for the exploratory 32-bar study.
