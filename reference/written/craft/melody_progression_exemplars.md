# Melody → Progression: corpus exemplars (proof that a single line exposes its chords)

Companion to `melody_theory_foundations.md` §3 and the `MELODY_CRAFT_DOCTRINE.md`
"HARMONY IS PART OF THE LINE" lesson. These are real VGM melodies, analysed note-by-note
(`python3 -m tools.analyze_score <mid>` — it labels each melody note with the chord it implies
and whether it's a chord-tone `ct:` or non-chord-tone `nct:`). They demonstrate the craft we'd
been skipping: **the strong-beat / long notes spell a committed progression; the rest decorate.**
Use the analyzer the same way to verify any line we write or rewrite.

The single tell to read in each table: `ct:R` / `ct:5` / `ct:3` / `ct:7` = a chord tone (root /
5th / 3rd / 7th of the implied chord); `nct:passing` / `nct:appog` / `nct:neighbor` / `nct:escape`
/ `nct:antic` = a decoration that resolves. **Chord tones sit on the strong beats; NCTs sit on the
weak parts and resolve by step.** That is the whole mechanism.

---

## 1. Gold Saucer (FF7, Uematsu) — G major — the bright diatonic engine
The user's reference case. A nimble single line whose strong beats outline **I – IM7 – ii7 – I**
(the festive I–vi–IV–V-family pull, here with maj7/9 color), the runs purely connective:

| beat | note | implied chord | role |
|---|---|---|---|
| b2.0 (downbeat) | D | **I** | ct:5 |
| b2.5 | G | I | ct:R (the root, leapt to) |
| b3.0 | F# | IM7 | ct:7 (the maj7 color on the beat) |
| b3.75 | A | IM7 | **nct:passing** |
| b4.0 | B | IM7 | ct:3 |
| b5.0 (downbeat) | A | **ii7** | ct:R (chord changes; new root on the beat) |
| b5.75 | E | IM7 | **nct:appog** (the one expressive lean) |
| b7.0 (downbeat) | D | **I** | ct:5 |

**Lesson:** every downbeat lands a chord tone of the chord *change*; the fast notes between are
passing/appoggiatura. The tune "travels" because the SAME shape re-lands over I → ii7 → I — the
harmony moves under a simple line. This is exactly the I–V–vi–IV recolor engine.

## 2. Tifa's Theme (FF7) — F major — the lyric line where NCTs ARE the expression
A slow cantabile melody over **V7 → I → (iv mixture)**. The notes that *feel* like the emotion are
literally the non-chord tones leaning onto chord tones:

| beat | note | implied chord | role |
|---|---|---|---|
| b69.0 | A | **V** | nct:appog (leans → resolves) |
| b69.5 | G | V | ct:5 |
| b72.5 (downbeat) | C | **I** | ct:5 (chord arrives on the strong beat) |
| b73.0 | A | I | ct:3 |
| b73.5 | G | I | nct:neighbor |
| b74.5 | C# | I→iv | nct:antic (chromatic anticipation of the iv mixture) |
| b76.5 | — | **iv** (B♭m mixture) | the borrowed-chord color |

**Lesson:** a lyric melody's weight comes from prepared dissonances (appoggiatura, anticipation,
neighbor) resolving onto chord tones — §5/§8.7. The chord tones anchor the strong beats; the
leans live on the weak parts. Stripping the NCTs would leave a bare but correct V–I outline.

## 3. Final Fantasy 1 "Chaos" (boss) — E Aeolian — the modal descent
A modal villain line outlining **i – ♭VII – VI** (the Aeolian drop), strong beats on root/5th, the
descent filled with passing/escape tones:

| beat | note | implied chord | role |
|---|---|---|---|
| b0.0 | E | **i** | ct:R |
| b2.0 | B | i | ct:5 |
| b4.0 (downbeat) | A | **♭VII** | ct:5 (chord change on the beat) |
| b5.0 | G | ♭VII | nct:passing |
| b7.0 | E | ♭VII | nct:escape |
| b10.0 | E | **VI** | ct:3 |

**Lesson:** modal progressions expose the same way — the descending-tetrachord roots (i–♭VII–VI…)
are landed on strong beats; the line is *built on* a committed modal progression, not floating.

---

## What this means for writing a theme
All three lines were *written to a progression* — the strong beats are never accidental. A theme
written harmony-pending has strong beats that don't reliably spell anything; that is the
diagnosable cause of "flat." The fix (foundations §3, melody-first order): assign the theme the
progression it should expose, then conform the strong-beat skeleton to it and decorate with NCTs.
Verify with `tools.analyze_score` — the readout should show chord tones on the strong beats and
NCTs resolving on the weak parts, exactly like these exemplars.
