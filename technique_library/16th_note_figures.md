# 16th-Note Piano Figure Catalogue

This canonical catalogue supports the standalone solo piano toccata brief
in `../explorations/hammer_gate_toccata/01_brief.md`. The goal is not to create final
music here. The goal is to define durable figure families that can later be
composed into real note-lists by hand.

Notation:

- Letter strings such as `A B C D` are pitch-shape examples, not final score
  material.
- `|` marks a beat or 4-note 16th group unless otherwise stated.
- Octaves are shown only when register is part of the figure's identity.
- All figures must vary by phrase boundary: direction, register, interval seam,
  top voice, bass anchor, accent pattern, harmony, or hand allocation.

## Research Basis

Fast wind-etude writing is a useful source because it isolates finger-work
problems into memorable figures. The relevant pattern classes are:

- scales, arpeggios, intervals, chromatic scales, and register studies;
- third, sixth, fourth, tritone, diminished-seventh, whole-tone, and broken-chord
  practice;
- low-note or anchor-note obsessions as mechanical identity;
- toccata-like cross-string or cross-register virtuosity translated into piano
  hand crossing and hand alternation.

Sources:

- Taffanel/Gaubert, *17 Grands exercices journaliers de mecanisme*, listed by
  IMSLP as exercises/studies for solo flute:
  https://imslp.org/wiki/17_Grands_exercices_journaliers_de_m%C3%A9canisme_%28Taffanel%2C_Paul%29
- Andersen, *24 Etudes for Flute*, Op. 15:
  https://imslp.org/wiki/24_Etudes_for_Flute%2C_Op.15_%28Andersen%2C_Joachim%29
- Analysis of Andersen Op. 15, finding interval work, arpeggios, chromatic
  scales, scale studies, 4/4, articulation, phrasing, and varied keys as central
  technical topics:
  https://files.eric.ed.gov/fulltext/EJ1291570.pdf
- Ferling, *48 Studies for Oboe*, Op. 31:
  https://imslp.org/wiki/48_Studies_for_Oboe%2C_Op.31_%28Ferling%2C_Franz_Wilhelm%29
- IDRS notes on Ferling: arpeggios, chromatic scale, wide intervals, trills,
  and a toccata study with cross-string virtuosity and pedal points:
  https://www.idrs.org/scores/Ferling/Narrative.html
- Klose clarinet method index: exercises on scales, arpeggios, and intervals in
  all keys:
  https://search.makemusic.com/p/celebrated-method-for-the-clarinet-26832/interactive
- Clarinet technique requirement examples: minor scales in thirds, diminished
  seventh arpeggios, whole-tone scales/arpeggios, fourths, tritones, and seventh
  arpeggio patterns:
  https://music.unt.edu/woodwinds/clarinet/files/technique_requirements_for_clarinet.pdf

## Deployment Rules

- A 16th-note surface must still have foreground/background roles. The ear needs
  to know whether the figure is line, bass, counterline, harmony, or attack.
- A figure is not complete until it declares its hand behavior: one-hand line,
  split-hand hocket, contrary hands, hand crossing, or three-deck texture.
- Do not use more than four bars of one unchanged figure. If the motor must
  persist, mutate one axis every phrase.
- Avoid using all families in one piece. Pick a small dialect, then derive hard
  variants from it.
- Every figure must be playable as a gesture. If a pattern is theoretically
  interesting but creates impossible fingering at tempo, rewrite the shape.

## Figure Families

### F01 Tetrachord Run With Leap Seam

Wind source: scale fragments and interval runs.

Shape:

```text
A B C D | C D E F | E F G A | G A B C
```

The identity is four fast stepwise notes followed by a leap to the next entry.
Vary the seam: down a 2nd, up a 3rd, down a 4th, up a 5th, or tritone snap.

Piano use:

- RH alone for first statement.
- Split hands at the leap seam for bigger register jumps.
- LH doubles only the first note of each group as bass punctuation.

Good locations: S2 toccata statement, S5 register torrent.

### F02 Inverted Tetrachord Seams

Wind source: the same run learned in opposite directions.

Shape:

```text
A B C D | F E D C | E F G A | C B A G
```

The leap still separates cells, but direction reverses every group. The figure
becomes less like a scale and more like a zigzag machine.

Piano use:

- RH takes ascending groups, LH takes descending groups.
- Accent the first note of each group to keep the motor readable.

Good locations: S3 mirror fugato, S6 polyrhythmic return.

### F03 Three-Step Plus Leap

Wind source: scale studies that hide an interval at the end of a scalar gesture.

Shape:

```text
C D E G | D E F A | E F G B | F G A C
```

The last note is the bite. Vary the bite by 3rd, 4th, tritone, 6th, or octave.

Piano use:

- RH line with LH low octave on note 4.
- Or note 4 is thrown to the opposite hand in another register.

Good locations: S1 hammer gate, S7 coda.

### F04 Run With Return Hook

Wind source: interrupted or returning scales.

Shape:

```text
C D E F | E D C E | D E F G | F E D F
```

Each cell runs, snaps back, and relaunches. It is useful when a plain scale is
too smooth.

Piano use:

- RH plays the run.
- LH catches the return hook as a lower-register answer.

Good locations: S2 continuation, S6 return.

### F05 Enclosure Run

Wind source: chromatic/diatonic finger patterns and target-note practice.

Shape:

```text
B D C E | C E D F | D F E G | E G F A
```

Each target is approached from below and above, then released upward. It sounds
like fast fingering but functions as line-making.

Piano use:

- Use as RH melody-bearing figuration.
- Put the target note in a stronger dynamic or register.

Good locations: S3 countersubject, S5 high line.

### F06 Chromatic Fence

Wind source: chromatic scale work.

Shape:

```text
C C# D F | D D# E G | E F F# A | F F# G B
```

Three tight chromatic notes hit a wider release. The release can be consonant,
dissonant, or register-displaced.

Piano use:

- Dry articulation in one hand.
- Opposite hand answers with the release note in octaves.

Good locations: S4 vertical lock preparation, S7 hard coda.

### F07 Broken Thirds Ladder

Wind source: scales in thirds.

Shape:

```text
C E D F | E G F A | G B A C | B D C E
```

The line is stepwise in two implied voices: lower voice C-D-E-F, upper voice
E-F-G-A.

Piano use:

- RH alone for bright passagework.
- Split into two voices when used contrapuntally: lower notes in LH thumb,
  upper notes in RH.

Good locations: S3 mirror fugato, S5 torrent.

### F08 Broken Sixths Ladder

Wind source: interval studies in sixths.

Shape:

```text
C A D B | E C F D | G E A F | B G C A
```

This is broader and more dangerous than thirds. It works best when the contour
has one clear target.

Piano use:

- RH takes high note, LH takes low note in hocket.
- Or both notes are rolled into one hand only in slower accents.

Good locations: S5 spatial expansion, S6 contradiction layer.

### F09 Fourths And Tritones

Wind source: fourth/tritone technical requirements.

Shape:

```text
C F D G | E A F B | G C# A D# | B F C F#
```

Use perfect fourths first, then corrupt the pattern with tritones. This creates
obvious harmonic pressure without adding more notes.

Piano use:

- RH plays upper fourths as biting dyads on selected accents.
- LH uses single-note version as low motor.

Good locations: S4 vertical lock, S7 coda.

### F10 Diminished-Seventh Cycle

Wind source: diminished-seventh arpeggio practice.

Shape:

```text
C Eb Gb A | D F Ab B | E G Bb C# | F# A C Eb
```

Symmetrical, bright, and dangerous. Because it can become generic quickly, use it
as a rupture or modulation hinge, not as continuous filler.

Piano use:

- Alternate hands by two notes.
- Drop every fourth note two octaves for a register stab.

Good locations: S4 lock, S5 aftershock.

### F11 Whole-Tone Rail

Wind source: whole-tone scale/arpeggio requirements.

Shape:

```text
C D E F# | G# A# C D | E F# G# A# | C D E F#
```

The absence of half steps gives a floating mechanical color. Use it to change
the harmonic light before returning to the harsher motor.

Piano use:

- RH high rail, LH low repeated tonic or tritone.
- Contrary-motion whole-tone rails in both hands.

Good locations: S5 register torrent, brief S6 color shift.

### F12 Broken Pedal Fan

Wind source: low-note obsession and pedal-point studies.

Shape:

```text
A B A C | A D A E | A F A G | A E A C
```

The anchor is the form. The moving notes create the phrase. This is close to the
user-supplied `A B A C A D...` idea.

Piano use:

- Put `A` in LH or RH thumb and move the other notes around it.
- Shift the anchor by octave every bar: A2, A3, A1, A4.

Good locations: S1 hammer gate, S2 motor, S6 return.

### F13 Broken Pedal With Moving Top

Wind source: pedal point plus top-line control.

Shape:

```text
A B A C | A C A D | A D A E | A F A G
```

The top notes B-C-D-E-F-G form the melody. The anchor keeps the line mechanical.

Piano use:

- Anchor in inner voice, top voice projected.
- LH supplies bass only on beat starts, not every anchor note.

Good locations: S2 statement, S6 inner melody.

### F14 Double Pedal Ladder

Wind source: alternating register/finger anchors.

Shape:

```text
A C A D | B D B E | C E C F | D F D G
```

Both the anchor and the top move. It is a pedal figure becoming counterpoint.

Piano use:

- RH plays top pair, LH plays anchor pair.
- Can become two real voices if stemmed or voiced separately later.

Good locations: S3 mirror fugato, S6 polyrhythmic return.

### F15 Pedal With Chromatic Bite

Wind source: chromatic scale plus pedal.

Shape:

```text
A C A C# | A D A D# | A E A F | A F# A G
```

The anchor stabilizes the figure while chromatic upper notes create pressure.

Piano use:

- Use no pedal or dry pedal; harmonic blur weakens the bite.
- Put chromatic notes in a different register when preparing S4.

Good locations: S4 approach, S7 compression.

### F16 Pedal Around A Gap

Wind source: low-register studies and register control.

Shape:

```text
A2 B3 A2 C4 | A2 D4 A2 E4 | A1 F4 A1 G4
```

Same as a pedal fan, but the register gap is the point.

Piano use:

- LH strikes the low anchor; RH throws the moving notes across middle/high
  registers.
- Keep wrist/arm gesture clean; this is not finger-only passagework.

Good locations: S1 opening territory, S5 expansion.

### F17 Arpeggio Rotation

Wind source: arpeggios and broken chords.

Shape:

```text
C E G C | E G C E | G C E G | C E G C
```

The chord rotates through inversions. The line should still have a top contour,
not just a spun chord.

Piano use:

- Top note climbs first phrase, descends second phrase.
- LH doubles only beat-start basses.

Good locations: S2 statement, S5 torrent.

### F18 Seventh-Chord Rotation

Wind source: seventh arpeggio patterns.

Shape:

```text
C E G Bb | E G Bb C | G Bb C E | Bb C E G
```

More color than a triad; useful for harmonic motion without changing rhythm.

Piano use:

- Revoice each group over a bass line.
- Avoid four bars of unchanged rotation; alter inversion or span every bar.

Good locations: S4 harmonic sentence, S6 return.

### F19 Open-Tenth Sweep

Wind source: arpeggio practice translated into pianistic spacing.

Shape:

```text
C2 G2 E3 C4 | D2 A2 F3 D4 | E2 B2 G3 E4
```

The open gap prevents mud and gives the figure a bass-to-top trajectory.

Piano use:

- LH takes first two notes, RH takes last two notes.
- Or LH rolls all four only when tempo and hand size allow.

Good locations: S5 register torrent, S7 final sweep preparation.

### F20 Chord-Tone Run With Passing Cracks

Wind source: arpeggio plus scalar passing.

Shape:

```text
C D E G | E F G C | G A Bb C | C D E G
```

It reads as harmony but moves like a line. Passing notes make it less like a
default arpeggio.

Piano use:

- RH line, LH bass motion by step.
- Bring out beat-start chord tones as hidden melody.

Good locations: S2 toccata statement, S6 return.

### F21 Alternating-Hand Cascade

Wind source: long fast line translated into piano hand alternation.

Shape:

```text
LH: C2 D2 E2 F2 | RH: G4 A4 B4 C5
LH: B1 C2 D2 E2 | RH: F4 G4 A4 B4
```

The hands do not merely split convenience; the register jump becomes the figure.

Piano use:

- Use as a spatial event, not as filler.
- Change direction halfway through the phrase.

Good locations: S5 torrent.

### F22 Contrary-Motion Cascade

Wind source: scale fluency, inverted at the keyboard.

Shape:

```text
RH: C5 D5 E5 F5 | G5 A5 B5 C6
LH: C3 B2 A2 G2 | F2 E2 D2 C2
```

Both hands run 16ths, but the listener hears one expanding or closing space.

Piano use:

- Strong for arrival into chordal lock.
- Keep dynamic shape unified or it becomes two unrelated scales.

Good locations: S4 approach, S7 coda.

### F23 Hocketed Single Line

Wind source: fast single-line etude translated into two hands.

Shape:

```text
LH C4, RH D4, LH E4, RH F4 | LH G4, RH A4, LH B4, RH C5
```

The line is one melody split between hands. The danger is making it sound like
random keyboard choreography; accents must reveal one line.

Piano use:

- Use for very fast surface with percussive clarity.
- Add octave displacement only after the listener knows the line.

Good locations: S1 motor, S3 fugato, S7 compression.

### F24 Thumb-Melody Rail

Wind source: one line with embedded targets; piano-specific translation.

Shape:

```text
Upper figuration: E G F A | F A G B | G B A C
Thumb melody:     C       | D       | E
```

The thumb or inner voice carries the melody while upper notes flicker around it.

Piano use:

- RH thumb melody with RH 3-5 upper motion, LH bass punctuation.
- This is high-value for S6 because it proves the motor can carry a tune.

Good locations: S6 polyrhythmic return.

### F25 Tenor Melody Under High Glitter

Wind source: register studies and solo-line control.

Shape:

```text
LH tenor: E3 F3 G3 A3
RH halo:  B5 C6 B5 D6 | C6 D6 C6 E6
```

The figure reverses the default: melody below, fast figuration above.

Piano use:

- Mark tenor clearly in later score.
- RH must leave enough space for the tenor to project.

Good locations: S6 return, brief S5 contrast.

### F26 Compound-Melody Zigzag

Wind source: interval runs made into implied counterpoint.

Shape:

```text
C3 G4 D3 A4 | E3 B4 F3 C5 | G3 D5 A3 E5
```

One line implies bass and soprano moving in contrary or parallel paths. This is
one of the best anti-arpeggio figures.

Piano use:

- One hand may not manage it at tempo; split by register when needed.
- Ensure each implied voice moves purposefully when it returns.

Good locations: S3 counterpoint, S6 density maximum.

### F27 3+3+2 Accent Rail

Wind source: articulation studies over an even-note surface.

Shape:

```text
C D E F G A B C
accents: >     >     >
groups:  3     3   2
```

All notes remain 16ths; the complexity is in accent grouping.

Piano use:

- Apply to repeated-note, scalar, or arpeggio figures.
- Later shift to 2+3+3 or 3+2+3 for deformation.

Good locations: global dialect, especially S1 and S7.

### F28 Five-Accent Overlay

Wind source: articulation displacement and modern scale practice.

Shape:

```text
C D E F G | A B C D E | F G A B C
```

The 5-note accent cycle runs across 4/4. It should be used only after the basic
motor is established.

Piano use:

- RH keeps 5-accent line; LH states original 4-square motor.
- This creates S6 rhythmic dissonance without changing tempo.

Good locations: S6 polyrhythmic return.

### F29 One-Note Obsession With Escapes

Wind source: Ferling-style low-note or anchor-note fixation.

Shape:

```text
A A B A | A A C A | A A D A | A E F E
```

The repeated note is not filler. It is a mechanical problem and a formal marker.

Piano use:

- Alternate hands on the repeated note to avoid fatigue.
- Escape notes move by widening intervals across the phrase.

Good locations: S1 hammer gate, S7 hard-cut coda.

### F30 Register-Study Staircase

Wind source: clarinet/flute register studies.

Shape:

```text
C3 D3 E3 F3 | C4 D4 E4 F4 | C5 D5 E5 F5 | C6 D6 E6 F6
```

The figure is not interesting because of pitch material. It is interesting
because register itself becomes form.

Piano use:

- Use as a visible keyboard climb or collapse.
- Each octave should change color, dynamic, or hand allocation.

Good locations: S5 torrent, S7 final compression.

### F31 Side-Slip Cell

Wind source: chromatic transposition of a fixed fingering shape.

Shape:

```text
C D E G | C# D# F G# | D E F# A | Eb F G Bb
```

Same shape, chromatically displaced. Use sparingly: it creates instant pressure
but can sound like an exercise if left unphrased.

Piano use:

- Bass moves contrary to the side-slip.
- Accent only the first or last group note, not every transposition.

Good locations: S4 lock approach.

### F32 Broken-Call Figure

Wind source: etude phrase practice plus articulation interruption.

Shape:

```text
C D E F | rest G A B | C D rest E | F G A rest
```

The 16th surface is broken by rests. This is useful because the piece should not
be a continuous unpunctuated stream.

Piano use:

- One hand interrupts the other before the group completes.
- Can prepare a hard cut before S4 or S7.

Good locations: S3 seams, S4 vacuum, S7 hard cut.

## Section Assignments For The Current Brief

| Section | Core figures | Avoid |
|---|---|---|
| S1 Hammer Gate | F12, F23, F27, F29 | lyrical arpeggio wash |
| S2 Toccata Statement | F01, F03, F17, F20, F27 | four bars of plain scale |
| S3 Mirror Fugato | F02, F07, F14, F23, F26, F32 | parallel-only passagework |
| S4 Vertical Lock | F06, F09, F10, F15, F18, F22, F31 | subtle color change |
| S5 Register Torrent | F08, F16, F19, F21, F22, F30 | stationary middle-register run |
| S6 Polyrhythmic Return | F13, F24, F25, F26, F28 | unreadable total complexity |
| S7 Hard-Cut Coda | F03, F09, F12, F22, F27, F29, F32 | fade, dissolution, aftervoice |

## Composition Checklist

- Choose 5-7 figure families as the actual dialect before writing notes.
- Assign each chosen family a formal role: opening motor, countersubject,
  transition, lock, torrent, return contradiction, or coda claim.
- Write every final figure as note-lists by hand. Do not generate note-lists with
  loops, comprehensions, transposers, or pattern expanders.
- Validate the music by ear: if a figure only reads as "fast notes," it failed.
