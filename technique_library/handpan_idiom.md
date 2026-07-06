# Handpan Idiom Catalogue

This catalogue is for composing handpan parts that read as handpan music, not as
flute, harp, or mallet-keyboard lines transferred onto a fixed pitch set.

The handpan is a resonant, hand-struck idiophone with pitch, touch, layout, and
decay bound together. A usable part must specify more than notes: it needs a
touch pattern, resonance behavior, register/layout logic, and a rhythmic job.

## Research Basis

- Handpan Guru, "How to Play Handpan": the Ding is the center/root/lowest note;
  surrounding tonefields alternate around it; clear tone depends on a light tap
  and immediate release; the Ding can overpower if struck too hard; slaps,
  hand independence, dynamics, and rhythmic patterning are central to real
  playing.
  https://handpanguru.com/how-to-play-handpan
- Notepan notation documentation: handpan notation distinguishes tonefields,
  Ding, Ding tonefield, palm mute, tak, slap, knock, fist, ghost note, muted
  notes, fifth and octave harmonics, knocked tonefield notes, finger rolls,
  grace notes, and flams.
  https://docs.notepan.fr/notation-system/notation
- Planet Handpan, Louis notation: handpan notation can separate rhythmic
  notation from pattern notation; tonefields are numbered by layout/pitch order;
  sticking and fingering can be indicated separately.
  https://www.planethandpan.com/louis
- HaganeNote, "Handpan Lesson 2 - Basic Drum Patterns": handpan practice often
  adapts drum-kit roles, using Ding as kick, slaps as snare-like punctuation,
  and repeated tonefields as a hi-hat-like layer; the goal is hand independence,
  not scalar note-picking.
  https://www.haganenote.com/learning/handpan-lesson-2-basic-drum-patterns/
- Milosc i Spokoj, "Handpan in Kurd scale": D Kurd 9 is commonly
  `D | A Bb C D E F G A`; D Kurd 10 adds high C; D Kurd is a minor scale based
  on a D3 Ding and common lateral tones.
  https://miloscispokoj.pl/en/kurd-handpan/
- Isthmus Instruments, "D Minor Handpans": D minor handpans draw from
  D, E, F, G, A, Bb, C; D Kurd includes the full D minor scale, while names and
  layouts are not fully standardized, so exact notes must be specified.
  https://www.isthmusinstruments.com/isthmus-handpan-blog/d-minor-handpan-scales
- Master the Handpan and Handpan Dojo glossaries: each tonefield includes
  fundamental, octave, and fifth-overtone components; sympathetic resonance and
  sustain are part of the instrument's behavior.
  https://www.masterthehandpan.com/blog/handpan-glossary-of-terms
  https://www.handpandojo.com/dictionary

## Core Failure Mode

Bad handpan writing treats the instrument as a fixed-pitch flute:

```text
F4 E4 D4 C4 | D4 C4 A3 D3
```

That is a scalar line, not yet a handpan idea. It may become playable, but only
if it is recast as a layout gesture: alternating hands, adjacent tonefields,
finger roll, muted sweep, harmonic effect, or a deliberate resonance tail.

A handpan phrase should usually be conceived as:

```text
Ding / tonefield / tonefield / slap or ghost / resonance
```

not:

```text
melody note / melody note / melody note / melody note
```

The pitch list is necessary, but it is not the idiom.

## Physical Model

### Ding

The Ding is the central root tone and low anchor. It functions like a soft bass
drum, tonic bell, or floor resonance, not like a normal melodic note.

Use the Ding for:

- section-opening identity;
- low gravitational returns;
- downbeat or half-bar anchor;
- sparse call before tonefield answers;
- final resonance or ritual floor.

Avoid:

- striking the Ding every bar by habit;
- treating the Ding as a walking bass;
- loud Ding attacks under exposed voices unless the overpowering weight is the
  intended event.

### Tonefields

Tonefields are physical locations. On common 9-note pans, they sit around the
Ding and alternate left/right in ascending layout. That means adjacent pitch
motion is also a hand/path decision.

Use tonefields for:

- left-right "zipper" cells;
- two-note color pairs;
- small circular patterns around the Ding;
- answering gestures after Ding attacks;
- resonance halos under long vocal or instrumental tones.

Avoid:

- long scalar lines without hand/path logic;
- treating every field as equally available at every speed;
- high-register runs that ignore decay and layout.

### Interstitial Percussion

The non-pitched or less-pitched surface matters. Slap, tak, knock, ghost, palm
mute, and muted notes give the instrument drum behavior.

These sounds are not decoration. They define pulse, breath, and physicality.
They are often what makes a line stop sounding like note-picking.

## Idiom Families

### 1. Ding-Field Call

Job: establish tonic gravity, then let fields answer.

Shape:

```text
Ding -- field field | rest -- field
```

Use when a section needs a ritual entrance, basin, or ground. Leave resonance
after the Ding; the answer should not cover the whole decay.

### 2. Hand-To-Hand Zipper

Job: make a small pitch contour feel physical through alternating hands.

Shape:

```text
L field / R field / L field / R field
```

This can ascend, descend, or circle, but the hand alternation is part of the
phrase identity. If the written line does not imply a plausible L/R path, it is
probably just a scalar melody.

### 3. Ding Plus Octave Or Fifth Color

Job: deepen a struck tone with its resonant relatives.

Shape:

```text
Ding + octave field
Ding + fifth-related field
```

Use as a two-hand touch, a rolled pair, or a separated call. Avoid block chords
larger than two simultaneous tonefields unless the player can roll them or the
score explicitly asks for an effect.

### 4. Slap/Tak Groove Between Notes

Job: make rhythm audible without filling pitch space.

Shape:

```text
Ding field field slap | field ghost field slap
```

Use when the part needs pulse under a voice or harp line. The slap/tak should
not create a loud snare track unless that is the form's event; it can be soft,
dry, and breath-like.

### 5. Ghost-Note Timekeeping

Job: keep internal motion while leaving melody and harmony sparse.

Ghosts are barely audible or very soft touches. They can track tempo for the
player and create shimmer without becoming foreground.

Use where a visible rest would make the part feel dead, but a real pitch would
crowd the texture. Mark as `ghost` or `very soft touch`.

### 6. Muted Punctuation

Job: stop resonance as a rhythmic event.

Muted tonefield or palm-muted Ding strokes are useful at denials, cutoffs,
seams, and cadential refusals. They should be written deliberately; muting a
handpan changes the instrument from halo to dry percussion.

### 7. Harmonic Touch

Job: turn a tonefield into a color event rather than a pitch event.

Fifth and octave harmonics are produced through axis/muting techniques. In an
ensemble score, use them sparingly as highlights, response colors, or aftertones.
Do not make them default melody notes unless the player and instrument are
known.

### 8. Finger Roll, Flam, Grace

Job: make a transition or accent physically handpan-like.

Finger rolls and flams are better for small arrivals than scalar pickups. A
short roll into a field can make a seam breathe without adding new harmonic
material.

### 9. Resonance Wake

Job: make silence active.

A handpan note keeps working after the strike. A written rest after a Ding or
field is often part of the sound, not empty duration. Use rests to let the pan
answer, decay, or hover under another instrument.

## D Kurd Deployment

For a common D Kurd 9 layout:

```text
Ding: D3
Tonefields: A3 Bb3 C4 D4 E4 F4 G4 A4
```

Useful functional groups:

- Gravity: D3, A3, D4
- Minor color: F4, Bb3
- Suspended/bright color: E4, G4, C4
- Open pair candidates: D3/A3, A3/D4, Bb3/F4, C4/G4, D4/A4
- Neighbor/circular cells: A3/Bb3/A3, C4/D4/C4, E4/F4/E4, F4/G4/F4

Unavailable chromatic tones such as C# or B natural must not be assigned to the
handpan unless the exact instrument has those pitches. If the ensemble harmony
needs those tones, the handpan should rest, play common tones, or use a
percussive sound.

## DSL Authoring Guidance

In the production DSL, `surface: :absolute` is still appropriate because exact
pitch inventory matters. But the phrase must expose touch and pattern logic
through marks, realization text, and staff checkpoints.

Prefer:

```ruby
phrase :handpan_basin, surface: :absolute do
  events <<~MUSIC
    D3:1.5{pp,txt:ding R} r:.5 A3:.5{txt:field L} C4:.5{txt:field R} |
    r:.5 D3:.5{txt:ghost ding} Bb3:1{txt:field L} r:1 |
    D3:1{txt:palm muted ding} r:.5 A3:.5{txt:field R} r:1 |
    C4:.5{txt:field L} D4:.5{txt:field R} r:2
  MUSIC
end
```

Avoid:

```ruby
phrase :handpan_flute_line, surface: :absolute do
  events <<~MUSIC
    F4:.5 E4:.5 D4:1 C4:1 |
    D4:.5 C4:.5 A3:1 D3:1
  MUSIC
end
```

The second example might be rescued if it is explicitly a roll, sweep, harmonic
gesture, or hand-to-hand path. Without that physical information, it is just a
melody line on a pan.

### Required Realization Details

For any exposed handpan part, include at least the relevant items from this list:

- exact pitch inventory;
- Ding vs tonefield vs interstitial sound;
- left/right hand path when the rhythm is active;
- whether notes ring, are muted, or are ghosted;
- where resonance is meant to continue through rests;
- whether a pitch event is a melody note, anchor, slap/tak groove, harmonic, or
  finger roll.

## Ensemble Use

### With Voice

The handpan should rarely compete with vocal line as a second melody. Better
roles are:

- Ding or open fifth under a held vocal point;
- soft slap/ghost pulse while the voice sustains;
- field answer in the breath after a vocal phrase;
- resonance wake after a vocal cadence;
- silence during chromatic vocal exposure.

### With Harp

Do not make handpan and harp both arpeggiate the same register. Pair them by job:

- handpan: attack, touch, pulse, fixed-scale identity;
- harp: extended resonance, chromatic harmony, rolled structural sonority.

If both play active figures, separate value class, register, and role.

### With Low Instruments

The Ding is not automatically the bass line. If bass clarinet, cello, basso, or
another low part carries a line, the handpan should become a punctuating anchor,
dry percussion, or resonance color.

## Review Questions

Use these before accepting a handpan part:

- Could the part be explained as Ding, tonefields, slaps/ghosts, mute/harmonic,
  and resonance, or only as a sequence of pitches?
- Does every active gesture imply a plausible two-hand path?
- Are rests functioning as decay, breath, or suspense?
- Is the Ding saved for structural weight, or has it become a lazy root marker?
- Does the part use percussive vocabulary when rhythm matters?
- Are unavailable chromatic pitches avoided?
- Could the same line be given to flute with little change? If yes, rewrite the
  handpan part.
- Is the handpan shaping the ensemble form through touch, resonance, and pulse,
  not merely adding exotic color?

## Common Repairs

- Replace scalar tails with a two-hand field pattern plus a rest.
- Replace continuous pitched motion with Ding, field, ghost, field, slap.
- Replace a downbeat pitch attack under a moving voice with a ghost or rest.
- Convert a cadence hit into muted Ding or palm-muted punctuation if the form
  wants denial.
- Let harp take long resonance if the handpan needs dry pulse.
- Let the handpan rest during chromatic harmony and return with a clearly
  audible fixed-scale color.
