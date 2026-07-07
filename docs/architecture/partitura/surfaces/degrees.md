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

phrase :lament, pitch: :degrees do
  key_context "c4"            # lowercase tonic = natural minor
  degrees "1 2 3 4 5 #7 1'"   # 3 = Eb; #7 = raised leading tone B natural
  rhythm  "1 1 1 1 1 1 2"
end

phrase :modal_cell, pitch: :degrees do
  key_context "D4 dorian"     # explicit mode word
  degrees "1 3 6 7"
  rhythm  "1 1 1 1"
end

phrase :degree_chords, pitch: :degrees do
  key_context "F4"
  degrees "[1,3,5]{ten} 2 r"
  rhythm  "1 1 1"
end
```

## Rules

- Declare key/mode context nearby. `key_context` is tonic + octave + optional mode:
  uppercase tonic = major (`"F4"`), lowercase = natural minor (`"c4"`), or an explicit
  mode word (`"D4 dorian"`; modes: major, minor, harmonic_minor, melodic_minor
  (ascending form; write `b6 b7` for the descent), dorian, phrygian, lydian,
  mixolydian, aeolian, ionian, locrian). Degrees are diatonic to that scale, so minor
  3/6/7 need no accidentals; use `#7` for a raised leading tone in natural minor,
  `#6`/`b2` etc. for other inflections.
- A phrase with no `key_context` inherits, in order: the span's `key`, the section's
  `key`, then the piece-level `key` (lowercase = minor everywhere).
- After a `key_change` control, silent inheritance is refused: a degrees phrase placed
  where a different key is active must sit under an explicit span/section `key` or its
  own `key_context` (compile error `key_context_required`).
- Keep rhythm separate. Duration tokens accept decimals (`.5`) and fractions (`1/2`, `3/2`, `1/3`).
- Use explicit accidentals: `#1`, `b6`.
- Use bracketed degree chords like `[1,3,5]` when harmony should remain key-relative.
- Use inline event marks only when the mark belongs to that single event; the closed mark
  vocabulary is in `partitura_help marks`.
- Use octave markers only when necessary: `1'` is an octave up, `1,` is an octave down
  (stack for two octaves: `1''`).
- Do not mix absolute pitches inside the same `degrees` phrase.
- Put score-level or section-level dynamics and tempo in `control` or `tempo`.

## Projection Needed

After authoring, request absolute-pitch and vertical readouts before deciding orchestration.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/degree_key_32.rb` for the exploratory 32-bar study.
