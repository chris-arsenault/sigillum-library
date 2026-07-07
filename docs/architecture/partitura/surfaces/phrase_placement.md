# Surface: Phrase Placement

Use when material identity and entrance timing are the main object.

## Good For

- handoffs,
- displaced answers,
- quotation,
- transformations,
- comparing same phrase in different orchestration.

## Syntax Shape

```ruby
phrase :call_8 do
  key_context "F4"
  degrees "5 4 3 #1 1 | 2 3 4 5 r"
  rhythm  "1.5 .25 .25 .5 1 | 1 .5 .5 1 .5"
end

placement :call_8, part: :clarinet, at: "bar 1 beat 1" do
  role :foreground
  realization "materialized/readable result must be available"
end

# Equivalent compact keyword form (preferred when there is no block body):
placement :call_8, part: :clarinet, at: "bar 1 beat 1", role: :foreground,
          realization: "materialized/readable result must be available"
```

## Rules

- A placement must state part, location, and role.
- Phrase ids must be unique across the production piece.
- Repeated placement is allowed only when each entrance has a musical job.
- Transformed placement must be inspectable as realized notes/degrees/grid.
- Never use phrase placement as hidden stamping.

## Projection Needed

Use placement map and materialization/readout.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/phrase_placement_32.rb` for the exploratory 32-bar study.
