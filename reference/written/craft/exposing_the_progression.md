# Exposing the progression — writing a single line you can hear the chords through

**The acceptance test (the user's bar): mute the accompaniment — you must still hear the chord
progression from the melody ALONE.** A line that needs its chords to carry the harmony has failed.
This is the defining craft of our melody-library cards. It is made objective by
reading the card's DSL projection with `production_view CARD.rb harmony_with_melody`:
the chord the line implies must match the intended progression bar by bar.

This document is the synthesis of four research surveys — read them for the depth and the citations:
`surveys/implied_harmony_single_line.md` (Baroque compound melody / implied polyphony),
`surveys/jazz_outlining_changes.md` (guide tones / playing the changes),
`surveys/melodic_harmonic_implication_theory.md` (common-practice + Schenkerian implication),
`surveys/harmonic_ambiguity_failure_modes.md` (why lines fail and how to fix them). It builds on
`melody_theory_foundations.md` §3 and `melody_progression_exemplars.md`.

---

## The one principle everything reduces to

The ear reads the chord from the **prominent positions** — the strong beat, the long note, the
lowest note, the leap-target, the contour peak. Every scale degree fits three triads (a `C` is root
of C, 3rd of Am, 5th of F), so the *note* never picks the chord — its *position and role* do.

> **Spend the prominent positions on the chord's DISCRIMINATING tones — root, 3rd, 7th.
> Keep the SHARED tones — 5ths and common tones — as weak-beat connective tissue.**

The 3rd fixes major vs minor. The 7th fixes dominant vs major vs minor. The root names the chord.
The 5th and the held-across common tone name *nothing* — they are the ambiguity. A progression-
exposing line is the exact opposite of a reharmonizable one: reharmonization works *because* a line
leans on shared/ambiguous tones; exposure works because it leans on discriminating ones.

## The process (compose in this order)

1. **Commit the progression and its harmonic rhythm first** — which chord on which bar/beat. The ear
   re-asks "which chord now?" at the rate the harmony changes; changes land on strong beats / downbeats.
2. **Supply an implied bass.** A solo line has no literal bass, so drop the chord **root into the low
   register on the structural beat** — the lowest strong-beat pitch is heard as the bass and fixes the
   chord. (The cadential 6/4 proves the bass rules: tonic pitches over a `^5` bass are heard as V.)
3. **Build it as compound melody.** Alternate a low "bass" strand (the roots) with an upper strand
   (3rds/melody), separated by leaps wide enough that the ear streams them as two voices — **a leap
   beyond a 4th (≈ a 6th–10th is ideal), at a brisk-enough tempo, with an out-and-back contour.**
   Arpeggiating a chord's members across its slot *is* the chord, to the ear (Bach BWV 1007: `G2 D3
   B3 A3 B3 D3` = bass G + inner 5th D + upper 3rd B = one bar of I).
4. **Mark every change on its downbeat** — the new low root + the new chord's diagnostic tone (its 3rd,
   or, for a falling-fifth move, the **guide-tone slip**: the 7th of the old chord resolves down a step
   to the 3rd of the new — `Dm7 F/C → G7 B/F → Cmaj7 E/B`, the engine of ii–V–I and of any descending-
   fifths cycle).
5. **State the 3rd, prominently, every chord** — quality is otherwise undefined. Add the 7th for
   dominants. For secondary chords (ii/iii/vi) sound ≥2 members including the root; primary chords
   (I/IV/V) the ear defaults to, so one well-placed root carries them.
6. **NCTs live only on weak beats and resolve by step before the next strong beat.** A passing/
   neighbor/appoggiatura tone adds surface life without changing the implied chord — *if* it is light
   and resolves. An accented or long NCT on a strong beat reads as structural and implies a chord you
   didn't want.
7. **Cadence with the welded soprano formulas** — `^7→^1` (the leading tone, the single strongest V→I
   cue) or `^2→^1` onto `^1` for a PAC; `^4→^3` projects V⁷→I; hang on `^2`/`^7` for a half cadence.

## The five failure modes (each is a way to fail the test) and the fix

1. **Common-tone camping** — holding/repeating a pitch shared across the bar's chords (the line names
   none of them). *Fix:* move onto each chord's unique tone; demote the shared pitch to a weak beat.
   *(This is what sank the recolor draft — one C# held over F#m·D·A·E read as vi·ii·I·ii.)*
2. **Withholding the root** — only 5ths/3rds on strong beats, identity left to guess. *Fix:* sound the
   root once per chord low and on the beat, or guarantee the 3rd+7th guide-tone pair. Never let the 5th
   be the only prominent tone. *(This is what sank the mislead draft — root withheld to the last note,
   so the analyzer heard the whole thing in the wrong key.)*
3. **NCT overload on strong beats** — accented passing/appoggiatura tones bury the skeleton. *Fix:*
   keep NCTs weak-beat and resolving; ensure the chord tone is present and prominent.
4. **Static pitch/register** — no leaps/extremes, so the streaming and leap-target cues never fire and
   everything defaults to a tonic pedal. *Fix:* arpeggiate each chord as a gesture; put distinctive
   tones at the peaks and leap-targets.
5. **Avoiding the 3rd** — root+5th only (power-chord/quartal/sus): major-vs-minor undefined. *Fix:*
   sound the 3rd prominently; expose the dominant's 3rd as the leading tone at cadences.

## Misleads are legal — but LOCAL and RESOLVING

The downbeat is the root *by default*; a deliberate mislead (a 5th or 7th on the downbeat) is a fine
spice, but it must **resolve to the chord tone within the bar** so the chord still lands — never a
permanent fog. A card whose whole identity is hiding the harmony fails this test by construction; that
is not what these cards teach.

## The gate — run it, read the weak bars, fix them

```
partitura/bin/production_view technique_library/dsl/cards/melody/mel2_desc_fifths.rb harmony_with_melody
```

Read the line alone, the harmony readout, and the exported audition. **A card passes when the intended
progression is audible in at least (nbars - 1) bars** — one bar of slack for a deliberate, resolving
mislead. Each weak bar must be fixed by landing that chord's **root, low, on the downbeat** and
**stating its 3rd** somewhere prominent in the bar. Iterate until it passes. The ear is still the
final verdict — but a card that fails the gate has not earned an audition.
