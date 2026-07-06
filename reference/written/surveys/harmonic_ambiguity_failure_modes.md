# Harmonic Ambiguity vs. Determinacy in a Melodic Line

*What stops a listener from hearing a progression from the line alone — the note-level failure modes, their fixes, and how the craft is taught.*

---

## 0. The core claim

A single melodic line carries harmony inside it. The ear groups the notes and **audiates an implied progression** — even with no chords sounding ([My Music Theory, *Implied Harmony*](https://mymusictheory.com/composition/implied-harmony/); [Offtonic 9.7](https://offtonic.com/theory/book/9-7.html)). Whether that implied progression is **one definite thing** or **a fog of possibilities** is a property the composer controls at the note level.

The lever is *which pitches land on metrically/agogically strong positions and what scale-degree role they play in the intended chord.* The standard reading rules (Offtonic, the aural-skills pedagogy below):

- **Metrical strength is primary** — downbeats and strong beats are read as chord tones; quick weak-beat notes are read as embellishments.
- **Duration** — longer notes are heard as harmonic arrivals; fast notes fill between them.
- **Extreme points** — the highest/lowest notes of a gesture, and the targets of leaps, are heard as chord tones ("if you have melodic skips or extreme points, those notes are likely in the triad").

A **determinate** line spends its strong/long/extreme positions on pitches that name exactly one chord. An **ambiguous** line spends them on pitches that several chords share — so the line names none of them. Reharmonization theory is the mirror image of this and proves the point (§7).

The unifying diagnostic: **count how many plausible chords fit the strong-beat note.** Determinacy = 1; ambiguity = many.

---

## 1. Failure mode: COMMON-TONE CAMPING

**What it is.** The line holds or repeats a single pitch (or a pair of pitches) across a span where the harmony is supposed to move. If that pitch is a member of every chord underneath, the line confirms none of them — it merely floats above the changes.

**Why it fails.** A pitch only *names* a chord by being a distinctive member of it. A pitch shared by several candidate chords carries no discriminating information. Holding `C` across a span that should read `C – Am – F` says nothing: `C` is the root of C, the 3rd of Am, and the 5th of F — true of all three at once ([Reharmonization principle, The Jazz Piano Site / Piano With Jonny](https://pianowithjonny.com/piano-lessons/extreme-reharmonization-techniques-play-any-note-with-any-chord/)). The MTO axis-progression study shows the same mechanism at the *tonal-center* scale: when the only melodic tones present are `C` and `E`, the listener cannot decide between A-minor (Aeolian `i`) and C-major (`I`), because both triads contain `C` and `E` ([Richards, MTO 23.3](https://mtosmt.org/issues/mto.17.23.3/mto.17.23.3.richards.html)). Common tones are exactly the pitches that *resist* disambiguation.

**The pedagogy's name for the benign version.** When a held/repeated pitch IS a chord tone of the new chord, theory calls it a **pedal** or **anticipation/suspension carryover** — fine as decoration, fatal as the *only* strong-beat content ([Open Music Theory, *Embellishing Tones*](https://viva.pressbooks.pub/openmusictheory/chapter/embellishing-tones/)).

**Fix.** On each chord's strong beat, move off the common tone onto a pitch the *next* chord does **not** share — ideally that chord's 3rd (quality, §5) or root (identity, §2). Let the common tone become the connective weak-beat material instead of the structural anchor.

- *Ambiguous (camping):* over `C | Am | F | G`, melody = `C – C – C – C` (whole notes). Implies nothing; reads as a single static drone.
- *Determinate:* over the same changes, melody strong beats = `E – C – A – B` → `E` (3rd of C, rules out Am/F as I), `C` (♭3 of Am, rules out C major), `A` (3rd of F), `B` (3rd of G, the leading tone — locks G as V). Same register, same rhythm; now each bar names its chord.

---

## 2. Failure mode: WITHHOLDING THE ROOT

**What it is.** Strong beats land only on 5ths, 3rds, or 7ths of the intended chord; the root never appears in a structurally prominent spot.

**Why it fails.** The root is the strongest single identifier of a chord's *identity* (as distinct from its quality, §5). My Music Theory states it directly: "To imply a secondary chord, it is often necessary to use **more than one note** from the required chord, and to ensure that **the root of the chord is used**" ([*Implied Harmony*](https://mymusictheory.com/composition/implied-harmony/)). Without the root in the line, the listener must supply it by inference, and inference is exactly what admits competing readings. A prominent `G` could be root of G, 5th of C, 3rd of E♭, 7th of A — its identity is open until something pins it.

**Important nuance — the root is not always required, IF the 3rd+7th are present.** Jazz guide-tone theory shows a line of **3rds and 7ths alone** lets a listener hear the whole progression with no roots and no bass, *because the 3rd+7th together are unique to one chord quality on one root* ([Learn Jazz Standards, *Guide Tones*](https://www.learnjazzstandards.com/blog/learning-jazz/jazz-theory/use-guide-tones-navigate-chord-changes/)). So the real rule is: **the strong-beat pitches must collectively be unique to the target chord.** Root alone does this cheaply; 3rd+7th do it elegantly; 5th alone never does (the 5th is the *most* shared interval — Cmaj7, Cm7, C7 all share root AND 5th).

**Fix.** Put the root on a strong beat at least once per chord (cheap, robust), OR guarantee the 3rd *and* 7th both appear prominently (elegant, root-free). Never let the 5th be the only prominent tone.

- *Ambiguous (root withheld, only 5ths/3rds):* over `Dm7 | G7 | Cmaj7`, line = `A – D – G` (5th of Dm7, 5th of G7, 5th of C). All three are 5ths → reads as a vague suspended haze; could be almost any progression on those roots.
- *Determinate (guide tones, no root, no bass):* `F–C` over Dm7 (♭3, ♭7) → `B–F` over G7 (3rd, ♭7) → `E–B` over Cmaj7 (3rd, 7th). The 7th of each chord resolves by step into the 3rd of the next (`C→B`, `F→E`) — the ear hears `ii–V–I` unambiguously with zero roots played ([Learn Jazz Standards](https://www.learnjazzstandards.com/blog/learning-jazz/jazz-theory/use-guide-tones-navigate-chord-changes/)).

---

## 3. Failure mode: NON-CHORD-TONE OVERLOAD on strong beats

**What it is.** The metrically strong positions are occupied by embellishing tones (passing, neighbor, appoggiatura, suspension) instead of chord tones, so the structural skeleton the ear latches onto is *dissonant against the intended harmony*.

**Why it fails.** The reading rule is that strong beats = chord tones. An **accented** embellishing tone (one on a strong beat) "creates noticeable dissonance against the harmony" ([Open Music Theory, *Embellishing Tones*](https://viva.pressbooks.pub/openmusictheory/chapter/embellishing-tones/)). One accented NCT resolving cleanly is expressive; a *pile* of them means the listener's chord-detector is sampling the wrong notes at the wrong moments and infers the wrong (or no) chord. The structural tones get buried under decoration. The aural-skills text frames it as the structural-vs-embellishing distinction: "structural notes require a chord change, while embellishing tones do not" — if your strong beats are all embellishing tones, the harmonic skeleton is invisible ([Foundations of Aural Skills](https://uen.pressbooks.pub/auralskills/chapter/improvising-a-chordal-accompaniment-to-a-melody/)).

**Fix.** Keep NCTs to the canonical figure — chord tone → NCT → chord tone, with the NCT *prepared and resolved* — and keep them mostly on weak beats. When you do put an accented NCT on a downbeat (appoggiatura, suspension), make sure it resolves by step to the chord tone *within the same harmony* so the chord still registers. The chord tone must be present and prominent, even if delayed.

- *Ambiguous (NCT overload):* over `C` (target), line on the four strong beats = `D – F – B – D` (9th, 11th/4th, maj7, 9th) with chord tones only glanced on the offbeats. The downbeats spell a `D`-rooted or suspended sonority; the ear hears anything but C major.
- *Determinate (NCT as decoration):* over `C`, strong beats = `E – G – C – E`, with `D` and `F` as passing/neighbor tones on the weak parts of beats. Same notes present; now `C–E–G` is the skeleton and `D`,`F` are heard as embellishment of it.

---

## 4. Failure mode: STATIC PITCH / REGISTER (no melodic profile)

**What it is.** The line sits on one or two pitches in one register with no leaps, no contour, no agogic accents — closely related to camping (§1) but about *shape* rather than shared membership.

**Why it fails.** Two of the three reading cues — **extreme points** and **leap targets** — never fire, because there are no extremes and no leaps. The ear has nothing to flag as "this is structurally a chord tone." Offtonic: "if you have melodic skips or extreme points in a melody, those notes are likely in the triad" — a flat line offers the detector no skips and no extremes to use ([Offtonic 9.7](https://offtonic.com/theory/book/9-7.html)). A repeated single note also defaults to being heard as the **tonic** regardless of the intended harmony ([My Music Theory](https://mymusictheory.com/composition/implied-harmony/)), so a static line tends to collapse every chord toward "tonic pedal."

**Fix.** Give each chord a *gesture* that arpeggiates into it: leap to the root or 3rd, place the chord's distinctive tone at the contour's peak or trough so the extreme-point rule tags it. Vary register across the progression so each chord owns a distinct melodic event. (This is the "outline the triad" exercise of §6.)

- *Ambiguous (static):* over `C | F | G | C`, line = `E – F – D – E`, all within a third, no leaps. Reads as wandering, harmonically inert.
- *Determinate (profiled):* `G–E–C` (arpeggiate C down) | `A–C–F` (leap up to F's root, peak on A=3rd) | `D–B–G` (G triad, leading tone `B` exposed) | `C` (resolve). Each chord is its own arpeggiated gesture; extremes and leap targets are all chord tones.

---

## 5. Failure mode: AVOIDING THE 3rd (quality left undefined)

**What it is.** The line gives roots and 5ths (or quartal/suspended shapes) but never the 3rd, so the listener can hear *that a chord is present and on which root* but not *whether it is major or minor*.

**Why it fails.** The 3rd is the single pitch that determines chord quality; the 7th then refines it (dominant vs. major-7 vs. minor-7). "The 3rd tells you whether a chord is major or minor, and the 7th tells you whether it's dominant, major-7, or minor-7" ([guide-tones consensus, TJPS / Learn Jazz Standards](https://www.learnjazzstandards.com/blog/learning-jazz/jazz-theory/use-guide-tones-navigate-chord-changes/)). Root + 5th alone (a "power chord" / open fifth) is **deliberately mode-neutral**: Beyond Music Theory notes that "chords built by fourths, fifths or suspended chords" are ambiguous "by the lack of the third in relation to the root … the composer is free to use major and/or minor modes on top" ([*Harmonic Ambiguity*](https://www.beyondmusictheory.org/harmonic-ambiguity/)). The MTO axis study shows the same at tonal scale: the major-mode-bias vs. first-chord-rule conflict in `Am–F–C–G` survives *because* the shared diatonic collection lets both a major and an Aeolian reading stand until a 3rd-bearing melodic emphasis tips it ([Richards, MTO 23.3](https://mtosmt.org/issues/mto.17.23.3/mto.17.23.3.richards.html)).

**Fix.** Sound the 3rd of each chord on a prominent beat — this is the cheapest determinacy upgrade per note. For dominant function, expose the 3rd as a **leading tone** (the 3rd of V is `7̂` of the key) to lock the V→I pull. Add the 7th when you need to distinguish dom7 from maj7/min7.

- *Ambiguous (no 3rds):* over `C | Am`, line = `C – G | A – E` (root+5th of C, root+5th of Am). Both bars are bare open fifths; you can't hear major-vs-minor, and `C–G` vs `A–E` barely differ in color.
- *Determinate (3rds exposed):* `E – G | C – A` → `E` (major 3rd ⇒ C is major) then `C` (the ♭3 of Am ⇒ minor). One pitch per bar flips it from undefined to defined.

---

## 6. The pedagogy: "write a melody that implies/outlines a GIVEN progression"

This is a standard composition/aural-skills exercise. The taught procedure, synthesized from the sources:

**A. Reduce the chords to their tones, then arpeggiate.**
The entry-level drill: "start making melodies by playing **arpeggios** of the chords" over the given progression, then thin the arpeggios into a single line, keeping the tones that fell on strong beats ([EDMProd, *Advanced Melodies*](https://www.edmprod.com/advanced-melodies-chord-tones-motifs/)). This guarantees every structural note is a chord tone of the chord under it.

**B. Chord tone on every strong beat ("when a new chord hits, a chord tone plays with it").**
The non-negotiable rule: beats 1 and 3 of 4/4 carry chord tones; NCTs live on weak beats and must resolve to chord tones ([EDMProd](https://www.edmprod.com/advanced-melodies-chord-tones-motifs/); [Secrets of Songwriting](https://www.secretsofsongwriting.com/2020/05/21/adding-chords-to-a-melody-focus-on-the-strong-beats/)).

**C. Use more than one tone per chord, and include the root (or 3rd+7th).**
Per My Music Theory's implied-harmony rules: one note rarely implies a chord; use a chord-defining pair, and make sure the root is among the prominent notes for a secondary/non-tonic chord ([*Implied Harmony*](https://mymusictheory.com/composition/implied-harmony/)).

**D. Expose the 3rd for quality and the leading tone for cadences.**
Put the 3rd of each chord somewhere prominent; place the dominant's 3rd (the key's `7̂`) before tonic to nail the cadence ([guide-tone pedagogy](https://www.learnjazzstandards.com/blog/learning-jazz/jazz-theory/use-guide-tones-navigate-chord-changes/)).

**E. The mirror exercise (harmonize a given melody) teaches the same map backward.**
The Foundations of Aural Skills checklist ([here](https://uen.pressbooks.pub/auralskills/chapter/improvising-a-chordal-accompaniment-to-a-melody/)):
1. Sing the melody in solfège; find phrase structure.
2. Separate **structural tones** (force a chord change) from **embellishing tones** (don't).
3. Set the cadences first; place the predominant (ii/IV) before V.
4. Default the opening to I; harmonize interiors only where a strong-beat note conflicts with the held chord.
5. Use the **scale-degree → chord** map:

   | scale degree on strong beat | primary chord | alternatives |
   |---|---|---|
   | 1̂ | I | vi |
   | 2̂ | V | ii |
   | 3̂ | I | vi |
   | 4̂ | IV | V⁷ (as the 7th), ii |
   | 5̂ | I or V | — |
   | 6̂ | IV | ii, vi |
   | 7̂ | V | vii° |

   *Worked example — "Twinkle, Twinkle":* m.1 `1̂ 1̂ 5̂ 5̂` → I (all fit tonic); m.2 strong-beat `6̂` clashes with I → IV (contains `la`); strong-beat `4̂` → V⁷ pulling back to I ([Foundations of Aural Skills](https://uen.pressbooks.pub/auralskills/chapter/improvising-a-chordal-accompaniment-to-a-melody/)).

   *Disambiguation note:* `2̂` can be V or ii — its *function* (arrival vs. passing) decides, which is exactly the strong-beat / duration test ([Offtonic 9.7](https://offtonic.com/theory/book/9-7.html)).

**F. The verification checklist (to test your own line):**
For each chord in the given progression, ask of the line above it —
- Is there a chord tone on the strong beat? (else §3)
- Does the line move *off* the previous chord's notes? (else §1)
- Is the root present, or the 3rd+7th pair? (else §2)
- Is the 3rd sounded somewhere prominent? (else §5)
- Is there a leap/extreme tagging a chord tone? (else §4)
- **Count the chords that fit the strong beat — is it exactly one?**

---

## 7. The flip side: REHARMONIZATION proves the rule

Reharmonization keeps the melody and changes the chords. It works **precisely because** a melody note is ambiguous — it can be reinterpreted as a different scale degree of a different chord ([Piano With Jonny, *Play Any Note With Any Chord*](https://pianowithjonny.com/piano-lessons/extreme-reharmonization-techniques-play-any-note-with-any-chord/); [TJPS reharmonization](https://www.thejazzpianosite.com/jazz-piano-lessons/jazz-reharmonization/how-to-reharmonize-a-song/)). A single `C` can be harmonized as:

| `C` is the… | chord |
|---|---|
| root | C, Cm, C7, Cm7 |
| 3rd | A♭maj, Am(♭? — A with C as ♭3), A7 |
| 5th | F, Fm, F7 |
| 7th | D7, Dm7♭5 |
| 9th | B♭maj, B♭7 |
| ♯5 / 13th | E-based chords |
| 11th | G, Gm |

A **dominant chord can host up to 11 different melody notes**; a plain major triad only 7 — versatility scales with ambiguity ([Piano With Jonny](https://pianowithjonny.com/piano-lessons/extreme-reharmonization-techniques-play-any-note-with-any-chord/)).

**The decisive corollary for composition:** the property that makes a line *reharmonizable* is identical to the property that makes it *fail to project one progression*. They are the same fact viewed from two ends.

> "An ambiguous melodic line — one without strong harmonic anchors — remains flexible for reharmonization. A determined line featuring unique intervals becomes harder to recolor without losing its character." ([Piano With Jonny](https://pianowithjonny.com/piano-lessons/extreme-reharmonization-techniques-play-any-note-with-any-chord/))

Therefore a **progression-exposing line must be the deliberate opposite of a reharmonizable one**: it must spend its strong/long/extreme positions on the pitches that are *unique* to the intended chord (root, 3rd, 7th — the discriminating tones), and keep the shared tones (5ths, common tones) as weak-beat connective tissue. Maximize the *uniqueness* of each strong-beat pitch to its chord, and the progression becomes audible from the line alone; maximize *sharedness*, and you have written something that any number of chords will fit — which is the same as writing nothing about the harmony at all.

---

## 8. Summary table — failure mode → mechanism → fix

| Failure mode | Note-level mechanism | Fix |
|---|---|---|
| **Common-tone camping** | Strong beats hold a pitch shared by all candidate chords → discriminates none | Move onto each chord's *unique* tone (3rd/root); demote the common tone to weak beats |
| **Withholding the root** | Strong beats are only 5ths/3rds → identity left to inference | Sound the root once per chord, OR guarantee 3rd+7th together; never let the 5th be the only prominent tone |
| **NCT overload on strong beats** | Accented dissonances bury the chord skeleton | Prepare/resolve NCTs; keep them on weak beats; ensure the chord tone is present and prominent |
| **Static pitch/register** | No leaps/extremes → reading cues never fire; defaults to tonic pedal | Arpeggiate each chord as a gesture; put distinctive tones at peaks/leap targets; vary register |
| **Avoiding the 3rd** | Root+5th only → quality (major/minor) undefined | Sound the 3rd prominently per chord; expose V's 3rd as leading tone for cadences; add 7th to fix dom/maj/min |

**One-line synthesis:** *Determinacy = spending strong/long/extreme positions on the pitches unique to the intended chord (root, 3rd, 7th). Ambiguity = spending them on shared pitches (5ths, common tones). The chord-fit count on the strong beat — one vs. many — is the test, and reharmonization is the proof.*

---

### Sources

- Beyond Music Theory — *Harmonic Ambiguity*: https://www.beyondmusictheory.org/harmonic-ambiguity/
- My Music Theory — *Implied Harmony*: https://mymusictheory.com/composition/implied-harmony/
- Offtonic Theory §9.7 — *Reading Harmonies*: https://offtonic.com/theory/book/9-7.html
- Richards, *Tonal Ambiguity in Popular Music's Axis Progressions*, MTO 23.3: https://mtosmt.org/issues/mto.17.23.3/mto.17.23.3.richards.html
- Open Music Theory — *Embellishing Tones*: https://viva.pressbooks.pub/openmusictheory/chapter/embellishing-tones/
- Foundations of Aural Skills — *Improvising a Chordal Accompaniment to a Melody*: https://uen.pressbooks.pub/auralskills/chapter/improvising-a-chordal-accompaniment-to-a-melody/
- Learn Jazz Standards — *Use Guide Tones to Navigate Chord Changes*: https://www.learnjazzstandards.com/blog/learning-jazz/jazz-theory/use-guide-tones-navigate-chord-changes/
- Piano With Jonny — *Extreme Reharmonization: Play Any Note With Any Chord*: https://pianowithjonny.com/piano-lessons/extreme-reharmonization-techniques-play-any-note-with-any-chord/
- The Jazz Piano Site — *How to Reharmonize a Song*: https://www.thejazzpianosite.com/jazz-piano-lessons/jazz-reharmonization/how-to-reharmonize-a-song/
- EDMProd — *Advanced Melodies: Chord Tones, Motifs*: https://www.edmprod.com/advanced-melodies-chord-tones-motifs/
- The Essential Secrets of Songwriting — *Adding Chords to a Melody: Focus on the Strong Beats*: https://www.secretsofsongwriting.com/2020/05/21/adding-chords-to-a-melody-focus-on-the-strong-beats/
