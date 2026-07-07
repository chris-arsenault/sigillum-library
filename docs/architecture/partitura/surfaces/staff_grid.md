# Surface: Staff Grid

Use when simultaneity matters more than phrase abstraction.

## Good For

- dense vertical bars,
- handoff moments,
- rhythmic engines,
- cadence or non-cadence inspection,
- silence/exits as composed events.

## Syntax Shape

```ruby
staff_bar 9 do
  foreground "clarinet: C5 _ D5 E5"
  answer     "violin: . A4 _ G4"
  bass       "cello: F2 _ C3 F2"
  pulse      "drum: X . X X . X ."
end
```

## Rules

- Grid symbols must be declared by the passage.
- `_` means sustain; `.` means rest.
- Keep lanes by role, not only by instrument.
- Prefer staff grid for checkpoints, not every long melodic phrase.

## Projection Needed

Use bar readout and role readout.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/staff_grid_32.rb` for the exploratory 32-bar study.
