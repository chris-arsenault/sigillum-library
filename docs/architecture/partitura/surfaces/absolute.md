# Surface: Absolute Pitch Stream

Use when exact pitch spelling and register are part of orchestration.

## Good For

- bass paths,
- fixed register anchors,
- registral counterlines,
- lines where transposition would obscure the musical job.

## Syntax Shape

```ruby
phrase :bass_path, surface: :absolute do
  pitch_bars  "F2 C3 F2 | Eb3 Bb2 C3 F2"
  rhythm_bars "1.5 1 1 | 1 .5 .5 1.5"
end

phrase :piano_call, surface: :absolute do
  events "[A3,C4,E4]:1{mf,accent} r:.5 F#4:.5{stacc}"
end
```

## Rules

- Use explicit pitch names and octaves.
- Use `r` for rests.
- Use chord tokens like `[A3,C4,E4]` when simultaneity belongs in one layer.
- Use fused `events` when pitch, rhythm, and point marks must stay visually bound.
- Use inline marks for event-local points: `{mf}`, `{accent}`, `{stacc}`, `{ten}`, `{marc}`, `{harm}`, `{trem}`.
- Playing techniques are first-class marks with real MusicXML notation — never spell them as `txt:` labels:
  - `{arp}` / `{arp:down}` / `{arp:up}` / `{arp:non}` — rolled chord (`<arpeggiate>`), plain `arp` is the default up-roll.
  - `{gliss(}` ... `{gliss)}` — glissando spanner (wavy line + "gliss." label) between the two events;
    chain on one event with `{gliss),gliss(}`; pairs may cross barlines.
  - `{lv}` — laissez vibrer (`<tied type="let-ring">`; renders as "l.v." text when the note already carries a tie).
  - `{trill}` (one note) or `{trill(}` ... `{trill)}` — trill mark + wavy extension.
  - `{pizz}` / `{arco}` — bowing state (real `pizzicato="yes"` on every note until cancelled).
  - `{slur(}` ... `{slur)}`, `{cresc(}` ... `{cresc)}`, `{dim(}` ... `{dim)}` — slur/wedge spanner pairs.
- Reserve `{txt:...}` for words that really are text (vocal syllables, `txt:con_sord.`), never for a technique above.
- Keep pitch and rhythm streams aligned by bar and event count.
- Use `|` bar separators in both streams when the phrase spans bars. Markers are verified:
  every `|` must land exactly on a barline at placement time, and one segment may hold at
  most one bar of attacks. Sustained events and rests may cross barlines without a marker.
- Placed material must end inside its span (compile error `phrase_exceeds_span`).
- Do not use this as the default melody surface when key function matters.
- Put shared dynamics, pedal spans, and tempo changes in `control` or `tempo`.
- Events may cross barlines: notation renders them as tied per-bar segments automatically.

## Projection Needed

Use `phrases`, `timed_events`, `bass_path`, and `verticals`.

## Example

See `experiments/partitura/production_hybrid_study.rb`.
