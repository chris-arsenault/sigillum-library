# Surface: Phrase Placement

Use when material identity and entrance timing are the main object.

## Good For

- handoffs,
- displaced answers,
- quotation,
- explicitly written returns and transformations,
- comparing separately written realizations in different orchestration.

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

# Pickup: at: is the arrival downbeat; sounding starts one beat earlier.
placement :answer, part: :oboe, at: "bar 5 beat 1", role: :answer, anacrusis: 1

```

## Rules

- A placement must state part, location, and role.
- Phrase ids must be unique across the production piece.
- Newly composed source uses each explicit phrase note list for one sounding occurrence.
  Write a new phrase body for a literal repeat, varied return, transposition, inversion,
  retrograde, or sub-bar fill instead of generating it through placement reuse.
- A pickup/upbeat entrance is an `anacrusis`: give `at:` the arrival downbeat and
  `anacrusis:` the pickup length in beats, so the material starts that many beats before
  the downbeat. Declare it on the phrase (`anacrusis 1`) or the placement
  (`placement :call, ..., anacrusis: 1`). The pickup must land the downbeat on a barline.
  Anacrusis overwrites earlier same-part material in its pickup window: rests disappear
  silently, while overwritten sounding notes compile with a warning.
- `fill_material`, `fill from:`, placement reuse, and the `transpose_to`,
  `transpose_by`, `invert`, `retrograde`, and `key_match` helpers remain implemented so
  existing sources compile and their realized events stay inspectable. They are not an
  authoring path for newly composed score source.
- Never use phrase placement as hidden stamping. Projections make generated events
  visible, but visibility after compilation does not satisfy the explicit-source rule.

## Projection Needed

Use `placements`, `line`, and `timed_events` to confirm the explicit phrase starts at the
intended part and location.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/phrase_placement_32.rb` for the exploratory 32-bar study.
