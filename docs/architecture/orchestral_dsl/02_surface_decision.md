# Surface Decision Guide

Recommendation: use the hybrid phrase+staff model as the default architecture.

## Default Choice

Use:

- phrase layer for long musical thought,
- local surface chosen by musical job,
- placement layer for timing/orchestration,
- staff-grid checkpoints for vertical inspection.

## Decision Table

| Musical job | Surface | Why |
|---|---|---|
| Tonal/function melody | `degrees + rhythm` | Shows scale function and cadence tendency. |
| Motivic cell identity | `intervals + rhythm` | Shows contour and transformation. |
| Long line revision | `split pitch/rhythm` | Lets pitch and rhythm be edited independently. |
| Bass with register as orchestration | `absolute` pitch stream | Register is part of the musical object. |
| Dense vertical moment | `staff_grid` | Shows simultaneity and collisions directly. |
| Reusing/transformed material | `phrase_placement` | Shows what enters where. Must expose realization. |
| Mixed orchestral passage | `hybrid` | Phrases carry line; staff checkpoints carry verticals. |

## Anti-Confusion Rule

Multiple surfaces are allowed only when typed and local.

Good:

```ruby
phrase :call, pitch: :degrees do
  degrees "5 4 3 #1 1"
  rhythm  "1.5 .25 .25 .5 1"
end
```

Bad:

```ruby
phrase :call do
  data "5 C5 -2 F#4 1.5 .25"
end
```

## Final Recommendation

Do not standardize on one note surface. Standardize on one container and a small typed set of local
surfaces.

## Implemented Production Surfaces

The production runtime supports:

- `phrase ..., pitch: :degrees` or `surface: :degrees`
- `phrase ..., pitch: :intervals` or `surface: :intervals`
- `phrase ..., surface: :split_pitch_rhythm`
- `phrase ..., surface: :absolute`
- `placement ... do role ... realization ... end`
- `staff_bar ... do foreground "part: tokens" ... end`

Inspect choices with:

```bash
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb phrases
framework/orchestral_dsl/ruby/bin/production_view experiments/orchestral_dsl/production_hybrid_study.rb material_map
```
