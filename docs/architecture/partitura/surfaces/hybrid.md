# Surface: Hybrid Phrase + Staff

Recommended default.

## Good For

- most orchestral passages,
- long melodic continuity plus vertical checkpoints,
- mixed line/harmony/rhythm passages,
- avoiding one-surface bias.

## Syntax Shape

```ruby
phrase :foreground, pitch: :degrees do
  key_context "F4"
  degrees "5 4 3 #1 1"
  rhythm  "1.5 .25 .25 .5 1"
end

placement :foreground, part: :clarinet, at: "bar 1 beat 1" do
  role :foreground
end

staff_bar 1 do
  foreground "clarinet: C5 _ _ Bb4/A4 F#4 F4 _"
  bass "cello: F2 _ _ C3 _ F2 _"
  pulse "hand_drum: X . X X . X ."
end

gesture :not_prose_only do
  idea "answer does not meet the call"
  mechanism "answer enters late against active bass"
end
```

## Rules

- Phrase layer carries long thought.
- Placement layer carries timing and orchestration.
- Staff checkpoints carry vertical/handoff/cadence clarity.
- Use one typed pitch surface per phrase.
- Ask for projections after writing each span.

## Projection Needed

Use structure, placements, staff bars, and foreground readouts.

## Example

See `experiments/partitura/production_hybrid_study.rb` for production syntax and
`experiments/partitura/surface_lab/hybrid_phrase_staff_32.rb` for the exploratory 32-bar study.
