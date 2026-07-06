# Figure Grammar: How the Etudes Stay Ordered AND Alive (Selected Studies)

How three rhythmically simple etudes avoid both scale-noodling (motion without
repetition) and block-writing (repetition without motion) at the figure/phrase level.
Measured with the sounding projections (`figure_timeline`, `bar_profile`,
`recurrence_map`); the note-level pitch devices are in `etude_pitch_devices.md`, and
the composer-decision distillation is `../craft/phrasing_variation_line.md` (the
primary document). Per-piece reviews: `/home/dev/repos/etudes/reviews/`.

The two failure modes these pieces avoid, named precisely:

- **Noodling = motion without repetition.** Notes travel but nothing returns, so the ear
  has no structure to hold.
- **Block writing = repetition without motion.** Something returns verbatim in slabs, so
  the ear has structure but no journey.

All three pieces live on the same solution: **repetition WITH a vector** — a tiny cell
vocabulary that returns constantly, but never twice in the same setting, with the changes
rationed to one or two parameters per return.

## Measured first: the anti-block numbers

Classifying every bar by rhythm-class + contour + register-width and scanning for runs:

| | rhythm classes | longest identical-figure run | longest same-rhythm run | what changes inside the same-rhythm runs |
|---|---|---|---|---|
| Bach | 12 | **2 bars** | 6 | figure class rotates almost every bar |
| Kietzer | 14 | 4 (the m36-39 plateau — see below) | 9 | contour, harmonic station, register plane per 1-2 bars |
| Wiedemann | 5 | 7 (the coda descent — see below) | 12 | cell content, direction, register band, harmony per 1-2 bars |

No piece contains eight consecutive bars doing the same thing. The Bach changes its
figure-type essentially EVERY bar. Where longer same-rhythm stretches exist, the
differentiation moves down a level — which is the whole trick.

## Bach: a refrain-bar spine with varying travel between

The gait bar (quarter, eighth-pair, quarter, quarter — the bourree's signature rhythm)
appears TEN times: bars 2, 4, 8, 10, 18, 28, 30, 34, 38, 42. Two facts make it a spine and
not a block:

1. **Ten appearances, ten different pitch settings** — tonic answer (m2), tonic cadence
   shape (m4), dominant (m8, 10), V-of-A (m18), cadential (m28), then four minor-mode
   recastings (m30, 34, 38, 42). Same rhythm, same articulation profile (portato quarters),
   never the same notes.
2. **Irregular return spacing — 2, 4, 2, 8, 10, 2, 4, 4, 4 bars** — and never twice in a
   row. Between spine bars sit 1-3 bars of running/sequence material that always differs
   (the slide cells of m6-7, the compound-melody descent m23-27, the sigh chains m22-25).

So the ear gets a recurring "home bar" at unpredictable but frequent intervals — order —
while everything between it travels — interest. The phrase machinery seals the seams:
the three quarter-note cadence bars (m9, 17, 45 — the identical descending-octave shape at
three pitch levels) each carry THE NEXT PHRASE'S PICKUP inside them (m9 beat 4: G#5-A5
into strain B; m17: F#5-G#5; m45: E5-F5). Every arrival is simultaneously a departure;
there is no dead bar to escape from, which is why nothing ever needs an "abrupt
transition." And the recurrence projection adds the structural rhyme the ear only
half-notices: bars 6-8 return down a fifth at 26-28 — the approach to the V cadence and
the approach to the tonic PAC are the same three bars at the two key levels.

## Kietzer: one cell, every parameter rotated except its identity

The slur-2+repeat cell is in nearly every bar, but track what changes bar to bar through
the opening: m2 states it twice (half-bar size on E, then octave-leap size to E6); m3
answers a STEP up (G#->A) and closes with the piece's cadence-bar shape (8 sixteenths +
quarter + rest); m4 changes the cell's head to a six-note arpeggio plunge and relocates
the repetition plane two octaves down (D4); m5 moves it to D#/F# and hands off mid-bar to
an arpeggio pickup. Four consecutive bars: same cell, four different sizes/planes/joins.

The repetition contract is explicit: A' restates bars 2-4 VERBATIM at 14-16 — long enough
to be unmistakable — then bends at 17 (same station as m5, new departure track), and even
inside the verbatim repeat there is one designed difference (m16's final pair slurred
where m4's was tongued: articulation as the only variable). Repetition earns recognition;
divergence spends it.

Two micro-mechanisms worth stealing outright:

- **Echo by subtraction (m21-22):** m22 repeats m21 literally MINUS ITS DOWNBEAT — the
  echo enters an eighth late, so even a literal repeat has a new metric face.
- **Acceleration inside a plateau (m36-39):** the one four-bar "same figure" stretch in
  the piece — and it halves its harmonic unit midway: m36/37 change G->F# per half-bar,
  m38/39 per beat. What looks like the piece's only block is a written-in accelerando.

Order-wise, the piece also rations its ONE atypical bar perfectly: the only dotted figure
(the anacrusis motto) exists solely to launch A and A'; the only long note before the end
(m7's dotted quarter) crowns one phrase; the only cross-bar slur welds the m42 feint to
the m43 seal. Single-use events mark form; the recurring cell carries everything else.

## Wiedemann: one rhythm, and every OTHER dimension rotates per bar

The most radical case: bars 1-19 and 29-36 share one 6-eighth rhythm class, and the piece
still moves bar by bar because the bar is a COMPOUND unit — turn cell (x) plus arpeggio
tail (z) — and the content rotates:

- m1-5: x on F# (twice), x on B, x on D with the tail inverted, x ON THE LEADING TONE
  (E# with double-sharp neighbor) — five bars, five settings of the same half-bar pair.
- m9-11: two simultaneous ascents at different rates (stepwise lower halves, accented
  arpeggio peaks B-D-F#) — sequence up a step per bar.
- m20-23: consecutive bars are different VOICES — m20 spans E3->F#5 (26 semitones inside
  one bar), m21 answers treble-to-bass, m22 sits high, m23 plunges from C6: the register
  dialogue makes bar-to-bar contrast out of pure pitch placement while the rhythm never
  changes.
- m29-32: strict 1-bar harmonic oscillation — pcs {E,G,B} / {C,Eb,F#,A,B} / {E,G,B} /
  {C,F#,G,A}: tonic bar, dominant-color bar, alternating. Harmony changes every bar even
  though figure and rhythm do not.
- m33-36: the varied return changes THREE things at once against the same cell — harmony
  (a one-bar-per-station circle of fifths with the piece's only G-natural), added accents,
  and slurs displaced across the barline (same notes-per-slur, new metric phase).

The two long same-rhythm stretches are both vectored, not static: the staccato ladders
(37-48) alternate ladder-bar / hit-bar / spill-bar in 1-2 bar units with the f/p echo
pairs stepping DOWN a register each time (F#6 -> D4 -> C4 hits), and the coda's six
identical-rhythm bars (57-62) drop an octave every two bars under a written accelerando —
the same 3-quarter bar, but the floor falls out of it in stages.

## The synthesis: six transferable laws

1. **Build a spine cell and re-set it, never re-stamp it.** Ten gait bars, ten settings;
   every Kietzer cell return at a new size/plane; every Wiedemann turn at a new station.
   Change exactly one or two parameters per return (pitch level, direction, register,
   size, articulation, metric phase) — enough sameness to be the thing, enough difference
   to be going somewhere.
2. **The unit of contrast is the bar (or half-bar); the unit of order is the phrase and
   strain.** Change something small every bar; change the big things (mode, articulation
   regime, register policy) only at section scale — and never both at once. Rhythmic
   simplicity is what MAKES per-bar variation legible.
3. **Sequence is the motor.** Nearly every repetition sits at a new pitch level with a
   consistent step. Sequence is simultaneously repetition (contour+rhythm preserved) and
   motion (harmonic vector) — the exact antidote to both failure modes at once.
4. **Elide every seam.** Cadence bars carry the next phrase's pickup inside them; phrase
   ends overlap section starts (Kietzer m19 ends its phrase on beats 1-2 and launches the
   plunge in the same bar). Nothing stops, so nothing has to restart.
5. **Even literal repeats carry one designed difference** — subtraction (echo minus its
   downbeat), articulation-only variants, displaced slur phase. Verbatim is a rhetorical
   act with a budget: three bars maximum in these pieces, then divergence.
6. **Plateaus must accelerate or descend.** The only same-figure runs longer than two bars
   either halve their harmonic unit midway (Kietzer 36-39) or ratchet register/tempo
   (Wiedemann coda) — insistence with a vector, never a held pattern waiting for the next
   block.

Checked against the sounding projections, and the checks are now native DSL calls:
`figure_timeline` produces the anti-block table (per-bar rhythm-class + contour + width,
longest-run stats), `bar_profile --bars 2,4,8,18,42` prints the spine settings side by
side (comma-list bar selection), `recurrence_map` shows the returns and sequences,
`adjacency_profile` the engine constancy, `articulation_map` the section-scale regime
changes, `peak_axes` the rationed one-shots. The one-sentence version ("hold one dimension constant, rotate another per bar") is an
INDEX ENTRY, not the analysis — the actual order-makers are pitch/interval devices, and
they are catalogued note-by-note in `etude_pitch_devices.md`: semitone-integrity
enforcement via accidentals, region-entry by planted leading tones, widening-interval
intensification, fixed-point-plus-moving-point writing inside one line, the arpeggio
subversion menu, and cadence tails as motif seeds.
