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

# Pickup: at: is the arrival downbeat; sounding starts one beat earlier.
placement :answer, part: :oboe, at: "bar 5 beat 1", role: :answer, anacrusis: 1

# Reusable sub-bar figure, defined once at piece level and realized per entrance:
fill_material :turn, surface: :intervals do
  anchor "A4"
  intervals "0 +2 -2 -1"
  rhythm    ".25 .25 .25 .25"
end

fill :flute_turn, from: :turn, part: :flute, at: "bar 6 beat 4" do
  transpose_to "D5"
end
```

## Rules

- A placement must state part, location, and role.
- Phrase ids must be unique across the production piece.
- Repeated placement is allowed only when each entrance has a musical job.
- A pickup/upbeat entrance is an `anacrusis`: give `at:` the arrival downbeat and
  `anacrusis:` the pickup length in beats, so the material starts that many beats before
  the downbeat. Declare it on the phrase (`anacrusis 1`) or the placement
  (`placement :call, ..., anacrusis: 1`). The pickup must land the downbeat on a barline.
  Anacrusis overwrites earlier same-part material in its pickup window: rests disappear
  silently, while overwritten sounding notes compile with a warning.
- A reusable fill is short material, not a label. Define it once with
  `fill_material :turn, surface: :intervals do ... end`, then realize it with
  `fill :flute_turn, from: :turn, part:, at:, anacrusis:`. Fills must be shorter than
  one bar, can be reused across voices, and support `transpose_to`, `transpose_by`,
  `invert`, `retrograde`, and degree `key_match`.
- A one-off `fill :turn, part:, at:, anacrusis:, surface: ... do ... end` is allowed,
  but it is still duration-checked and placed with role `:fill`.
- Fills are the sanctioned transformation mechanism precisely because they are capped
  below one bar and materialized at compile (every realized note is inspectable in
  `line`/`timed_events`). The cap is what keeps `from:`/transforms from becoming the
  hidden stamping the LLM contract forbids - section-scale material is always written out.
- Transformed placement must be inspectable as realized notes/degrees/grid.
- Never use phrase placement as hidden stamping.

## Projection Needed

Use placement map and materialization/readout.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/phrase_placement_32.rb` for the exploratory 32-bar study.
