# Surface: Relative Intervals

Use when motivic identity is the main object.

## Good For

- short cells,
- inversion/augmentation/diminution thinking,
- contour-preserving transformations,
- identifying whether a transformed idea is still the same idea.

## Syntax Shape

```ruby
phrase :cell, pitch: :intervals do
  anchor "C5"
  intervals "0 -2 -1 -3 -1"
  rhythm    "1.5 .25 .25 .5 1"
end

phrase :stacked_cell, pitch: :intervals do
  anchor "A4"
  intervals "[0,+3,+7]{mf} +2 -1"
  rhythm    "1 1 1"
end
```

## Rules

- Declare an anchor.
- First interval should normally be `0`.
- Bracketed interval chords are stacks from the current pitch; the first member advances the current pitch.
- Inline event marks attach to that interval event only.
- Use intervals for contour, not for dense orchestral verticals.
- Add checkpoints when the phrase is long.
- Convert/read out to absolute pitch before scoring against harmony.

## Projection Needed

Use interval readout for identity and absolute-pitch/vertical readout for orchestration.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/relative_interval_32.rb` for the exploratory 32-bar study.
