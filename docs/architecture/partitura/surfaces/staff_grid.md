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

- Every lane is `"<roster_part_id>: tokens"`; the tokens divide the bar into equal slots
  (the token count chooses the resolution).
- Tokens: a pitch is an attack, `A4/B4` is two attacks inside one slot in order, `_`
  sustains, `.` is silence, `X` is an unpitched attack.
- Checkpoints are verified, not decorative: at compile time every lane is re-derived from
  the sounding timeline, and any divergence is a compile error (`checkpoint_mismatch`
  naming bar, lane, and slot). A lane about music that does not exist will not compile.
- Keep lanes by role, not only by instrument.
- Prefer staff grid for checkpoints, not every long melodic phrase.

## Projection Needed

Use bar readout and role readout.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/staff_grid_32.rb` for the exploratory 32-bar study.
