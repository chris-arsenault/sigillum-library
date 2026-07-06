# Surface: Split Pitch/Rhythm

Use when pitch contour and rhythm need independent revision.

## Good For

- long foreground lines,
- rhythm-first variations,
- melodic rewrite over fixed phrase rhythm,
- spotting where text claims a line but rhythm is inert.

## Syntax Shape

```ruby
phrase :line, surface: :split_pitch_rhythm do
  pitch_bars  "C5 Bb4 A4 F#4 F4 | G4 A4 Bb4 C5 r"
  rhythm_bars "1.5 .25 .25 .5 1 | 1 .5 .5 1 .5"
end

phrase :marked_line, surface: :split_pitch_rhythm do
  pitches "[A3,C4,E4]{accent} r F#4{stacc}"
  rhythm  "1 .5 .5"
end
```

## Rules

- Pitch and rhythm streams must have the same bar count and the same event count per bar.
- Keep bars aligned with `|`.
- Pitch tokens may be scalar notes, rests, or bracketed chords.
- Inline marks attach to the pitch token and travel with the event.
- Do not hide phrase rhythm inside prose.
- Use this for editable line design, not dense vertical events.
- Put crescendos, diminuendos, and shared dynamics in `control`, not in a third parallel stream.

## Projection Needed

Request phrase-event view and vertical view after placement.

## Example

See `experiments/orchestral_dsl/production_hybrid_study.rb` for production syntax and
`experiments/orchestral_dsl/surface_lab/split_pitch_rhythm_32.rb` for the exploratory 32-bar study.
