# Standard Container

The DSL standardizes the surrounding architecture, not one note representation.

## Canonical Shape

```ruby
production_piece "Title" do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"

  meter do
    change "4/4", at: "bar 9"
  end

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
    change "quarter = 88", at: "bar 9 beat 1"
  end

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
    part :cello, "Violoncello", music21: "Violoncello", family: :string
  end

  section :s1, "Plain statement", bars: 1..8, type: :plain_statement do
    journey "opening call becomes displaced answer"
    destination "answer is audible as displaced, not merely described"

    span bars: 1..8, texture: :melody_over_bass do
      chords "b1:F b2:Bb b3:C7 b4:F"
      harmony "raised 1 is melodic bite, not a modulation"

      phrase :call, pitch: :degrees do
        key_context "F4"
        degrees "5 4 3{ten} #1 1"
        rhythm  "1.5 .25 .25 .5 1"
      end

      placement :call, part: :clarinet, at: "bar 1 beat 1" do
        role :foreground
        realization "C5 Bb4 A4 F#4 F4"
      end

      staff_bar 1 do
        foreground "clarinet: C5 _ _ Bb4/A4 F#4 F4 _"
        bass "cello: F2 _ _ C3 _ F2 _"
      end

      gesture :not_prose_only do
        idea "answer does not meet the call"
        mechanism "answer enters late against active bass"
        line_relation :clarinet, :cello, "foreground is heard against bass timing"
      end
    end
  end

  control do
    dynamic :mf, at: "bar 1 beat 1", for: :clarinet
    crescendo from: "bar 1 beat 1", to: "bar 4 beat 1", for: :string
  end
end
```

## Required Concepts

- `piece`: movement/passage-level context.
- `section`: form-level unit with bars and structural type.
- `span`: local texture/composing unit.
- `chords`: the span's declared per-bar chord track, `"b1:F b2:Bb b3-4:C7"`. Symbols are
  letter chords (root, optional `#`/`b`, quality such as m/7/m7/maj7/dim/dim7/aug/m7b5/
  6/m6/sus4/sus2, optional /bass). This is the machine-comparable harmony declaration:
  `harmony_check` diffs it against the sounding `implied_harmony`, and
  `harmony_with_melody` prints it per bar. Chords-first composing starts here: declare
  the track, then write voices against it and close the loop with `harmony_check`.
- `harmony`: free prose commentary about the harmony (a string entirely in `bN:Chord`
  form is routed to the chord track automatically).
- `phrase`: melodic, rhythmic, bass, or figural material.
- `placement`: where a phrase enters (`anacrusis:` starts a pickup before the downbeat).
- `fill_material`/`fill`: reusable sub-bar figures defined once at piece level and
  realized per entrance (transpose/invert/retrograde/key_match), always materialized
  and capped below one bar.
- `texture`: a sounding composite mechanism inside a span - a vertical `score` grid
  (one token per slot; creates sound) plus embedded `line` phrases and texture-scoped
  `control`s. Distinct from the span's `texture:` label, which is prose metadata.
- `staff_bar`: local vertical checkpoint.
- `gesture`: optional prose claim tied to audible mechanism.
- `meter`: opening meter plus bar-boundary meter changes.
- `tempo`: score tempo timeline.
- `control`: scoped dynamics, hairpins, pedal, and text timeline.
- `projection`: an LLM reading view.

## Roster Notation Metadata

Logical composition lanes may be exported as a single notated instrument when they share a
`notation_group`.

```ruby
roster do
  part :piano_upper, "Piano Upper", music21: "Piano", family: :keyboard,
    notation_group: :piano, notation_staff: 1
  part :piano_middle, "Piano Middle", music21: "Piano", family: :keyboard,
    notation_group: :piano, notation_staff: :auto
  part :piano_lower, "Piano Lower", music21: "Piano", family: :keyboard,
    notation_group: :piano, notation_staff: 2
end
```

For piano groups, `notation_staff: 1` exports to the upper staff, `notation_staff: 2` exports to the
lower staff, and `notation_staff: :auto` splits the lane at middle C for grand-staff notation.

## Roster Instrument Contract

Every part declares both its score display name and its exact `music21.instrument` class name:

```ruby
part :english_horn, "English Horn", music21: "EnglishHorn", family: :woodwind
part :snare_drum, "Snare Drum", music21: "SnareDrum", family: :percussion
```

The Ruby exporters do not infer instruments from part names. Missing or unknown `music21:` values
are errors because export must preserve orchestration intent.

A part may declare a playable range as `range: "E3-C6"`. A declared range is enforced: any placed
note outside it is a compile error (`note_out_of_range`). Omit `range:` to skip enforcement for a
part. The `range_check` projection reports each part's sounding span against its declaration.

A multi-sound percussion staff declares its staff-position convention in the part description as
`<pitch> <sound>` pairs:

```ruby
part :percussion, "Percussion", music21: "Percussion", family: :percussion,
     description: "single staff: C3 snare, F2 bass drum, G3 cymbal"
```

The exporter converts such a part to real unpitched percussion: a percussion clef, one named
score-instrument per sound with its General MIDI drum mapping (per-note instrument tags in
MusicXML), and MIDI on channel 10. Recognized sound words: snare, bass drum, cymbal, hi-hat,
ride, tom, triangle, tambourine, woodblock. Percussion-family parts whose description declares
no pitch positions (timpani, glockenspiel, a single-sound snare part) are exported unchanged as
written.

## Container Rule

Do not invent unrelated top-level structures for a passage. Add local notation surfaces inside this
container instead.

Meter changes must land on bar boundaries, e.g. `change "3/4", at: "bar 5"`. Bar/beat placement,
section offsets, and export offsets are resolved against the meter timeline.

## Implemented API

New source uses `production_piece`. The production loader also accepts `piece` and `hybrid_piece`
inside files for compatibility, but documentation should prefer `production_piece`.
