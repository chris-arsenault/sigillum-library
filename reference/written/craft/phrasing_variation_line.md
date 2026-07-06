# Phrasing, Variation, and Line — Composer Lessons (Selected Studies)

The working answers to the questions a composer holds while writing: how much
repetition, what kind of surprise, where the breath goes, how a fast line carries a
melody. Distilled from the three Selected Studies clarinet etudes (Bach Bourree BWV
1009 arr. / Kietzer / Wiedemann); the bar-cited per-piece reviews live in the etudes
repo (`/home/dev/repos/etudes/reviews/`). Cards cite this file as
`phrasing_variation_line:sN`. Auditionable specimens: `dsl:phrasing/PH1..PH8`,
`dsl:variation/V1..V7`, `dsl:linecraft/L1..L9`.

## 1. The repetition budget

- **State a new idea exactly twice.** Wiedemann bars 1-2 identical, then move; 13-14
  identical at the octave, then move. The coda "repeats" 57-58 change one note.
- **Three identical bars only to re-establish after a long absence** (Kietzer's reprise
  14-16 restates 2-4 verbatim after ten bars away - and still changes one articulation).
- **Adjacent identical bars beyond two: never.** Bach's single literal bar-repeat
  (31 = 49) is separated by eighteen bars, where it lands as a rhyme, not a repeat.
- **Within a bar: six or seven strikes of one note maximum**, then the line must move
  (Kietzer's planes). The one 4-bar near-ostinato (36-39) halves its rate of change
  midway - insistence is allowed only if something inside it speeds up or descends.
- Distance repetition may be literal (rhyme). Sequential repetition must change by the
  second or third statement. Different budgets for the two kinds - do not conflate them.

## 2. Subversion: mostly pleasant, rarely dissonant

The interest in these pieces comes overwhelmingly from CONSONANT surprise - subverting
where/which-direction, not which-pitch:

- Answer the same clause downward instead of up (Wiedemann b4 - every note a chord tone).
- Repeat a bar minus its downbeat, so the echo enters late (Kietzer 21-22 - zero
  dissonance, pure timing surprise).
- Keep an exact return and change only its exit (Wiedemann 19: bars 13-18 are literal,
  the last bar plunges instead of settling).
- Start the arpeggio off the expected note; dip one step in the middle of a climb; let a
  chord-outline dissolve into steps halfway (Wiedemann 24-25).
- Put the peak earlier than expected, or answer a high hit with the register floor.

Dissonant subversions are RATIONED - roughly one per section - and are always leaning
notes resolving within a beat or two (the recurring flat-nine in Wiedemann at 5, 21, 30
always resolves down by half-step immediately). Spice, never diet. Personal note for
this repo's composing: my instinct reaches for the dissonant subversion first; these
pieces prove the opposite ordering is what stays pleasant over three minutes.

## 3. Where the long note goes

Every long note in these pieces does THREE jobs at once:

- **Reward** - it is the phrase's expressive peak (Kietzer's only long note before the
  final bar is the melodic crown C#6 at b7: hold the high note, singer logic).
- **Breath** - the clarinetist recovers there (Wiedemann's three dotted-quarters at 8,
  20, 28 are the only recovery points in 36 bars; Bach's fermata and dotted-halves sit
  at the double bars).
- **Pivot** - the music changes figure or register out of it (Wiedemann b20: the long
  low tonic is simultaneously a phrase floor AND the launchpad of the arpeggio flight).

Never park a long note mid-phrase as mere rest. If a spot exists only so the player can
breathe, the piece will sound like it stopped; make the breathing spot an arrival or a
springboard and nobody notices the physiology.

## 4. The skeleton IS the melody (one-voice harmony)

The downbeats + accents + long notes form a singable slow tune; the fast notes between
serve as the chord. Verified by extraction:

- Kietzer downbeat skeleton, bars 2-13: F#5 G#5 B5 D#5 A5 **C#6(long)** ... F#5 C#5 B5
  A5 - a real melody that climbs to the held peak and walks back down. The hammered
  sixteenths under it are one-voice accompaniment.
- Wiedemann 9-11: two skeleton lines at once - the accents sing a rising arpeggio
  (B-D-F#) while the bar-heads sing a rising scale (E#-F#-G#) - a slow duet hidden
  inside plain eighths.
- Bach 26-27: the repeated top pair C#-D is a sustained melody note (sustain by
  repetition) while the low entries walk a bass under it.

**The working test: play only the downbeats, accents, and long notes. If that skeleton
is not a tune on its own, the line is noodling - regardless of what the fast notes
spell.** Converse rule: keep the filler inside the chord and its neighbors so the ear
files it as harmony and keeps following the skeleton; when filler goes chromatic, it is
announcing something (a new region), briefly.

## 5. A run is spent, not written

What keeps fast lines from being scales:

- Every run has a TARGET: it lands on a skeleton note (the next downbeat/accent), not
  wherever it ran out of bar.
- Runs bend within 5-6 notes: a direction change, a gap, an early exit, a leap out.
- Unbent scales are EVENTS with formal jobs, used 1-2 times per piece: Bach's octave
  downstroke exists exactly twice as the rhyme binding two strains; Kietzer's two-octave
  scale is the discharge of the loudest moment. Spend scales like top notes.

## 6. Phrase lengths breathe, form stays square

Strains and sections are square (8/16/20 bars); the phrases INSIDE them run 3-5-7 bars
and elide - cadence bars carry the next phrase's pickup in their last beat (Bach 9, 17,
45), phrase-ends overlap section-starts inside one bar (Kietzer 19). The listener gets
the security of the square form and the pull of never actually stopping. Square form +
breathing phrases; not the reverse.

## The order of operations these pieces imply

1. Write the skeleton tune (downbeats/accents/longs) so it sings alone and crests at a
   long note a player wants to hold.
2. Choose the motif cell and its repetition budget (2x state, move on the 3rd).
3. Fill toward the skeleton with chord-and-neighbor motion; bend every run onto a target.
4. Plan the subversions as consonant surprises of placement/direction; ration the
   dissonant ones to one per section, each resolving immediately.
5. Put every long note where reward, breath, and pivot coincide.
6. Let phrases elide across the square form.

The theory catalogue describes WHAT results; this list is the order a person decides
things in. Each numbered lesson above now has an auditionable DSL specimen:
dsl:phrasing/PH1..PH8, dsl:variation/V1..V7, dsl:linecraft/L1..L9
(sigillum technique_library/dsl/cards/phrasing/). For this repo's composing: import THIS list into span passes, not the device
names - the devices are already over-supplied in my writing and "generally not pleasant";
the phrasing, the variation/similarity budget, and the singable skeleton are what's
under-supplied.
