# How a Melody Implies Harmony — Common-Practice & Schenkerian Theory

A survey of the note-level theory of **harmonic implication**: which melodic features make a
chord progression *hearable* (determinate) from the line alone, and how to deliberately make a
single line project — or avoid — a given progression. Sourced from Open Music Theory,
Aldwell & Schachter, Laitz, Kostka & Payne, Comprehensive Musicianship, and introductory
Schenkerian literature.

---

## 0. The core claim

When we hear a melody we do not hear neutral pitches — the mind *audiates* the harmony the line
outlines, grouping successive tones into chords "after the fact." A melody is therefore never
harmonically neutral; it is **harmonically charged**. The composer's leverage is that the line's
own features (which pitch, on which beat, in which register, at what rate) decide *how
determinate* that charge is — from a single hearable progression (Bach) to deliberate openness
(plainchant).

The whole theory reduces to one question asked tone by tone: **"Is this note a chord tone, and
if so, of which chord — and is it acting as root, third, or fifth?"** Everything below is the
machinery for answering that.

---

## 1. The raw ambiguity: every scale degree fits three triads

The starting fact (Comprehensive Musicianship, §11.1; OMT harmonization): a single melody note is
*intrinsically ambiguous* because **each scale degree can be the root, the third, or the fifth of
a diatonic triad.** So every note has three default homes.

Algorithm to list them: start with the triad rooted on that degree, then step down a third twice.

Worked example in E♭ major, opening note `G` (= scale-degree `^3`):

| Role of `G` | Triad | Roman numeral |
|---|---|---|
| Root  | G–B♭–D | **iii** |
| Third | E♭–G–B♭ | **I** |
| Fifth | C–E♭–G | **vi** |

So `^3` alone could mean I, iii, or vi. The note does not pick the chord. **Context picks the
chord**, and "context" is exactly the set of disambiguating features in §§2–6 below. The
compositional process (§7) is a *narrowing* operation: list the three candidates per note, then
eliminate using meter, harmonic rhythm, cadence, and voice leading.

A useful inversion of this fact: scale degrees `^1, ^3, ^5` are all members of I; `^5, ^7, ^2` of
V; `^4, ^6, ^1` of IV. Five of the seven degrees are covered by I and V together (My Music
Theory), which is why **I and V alone establish a key** and why the two shared/overlap degrees
(`^5` and `^1`) are the perennial ambiguous pivots.

---

## 2. Metric weight: strong beats carry the harmony

The first disambiguator is meter. The governing rule (Kostka & Payne; OMT; Comprehensive
Musicianship):

> **Chord changes occur on strong beats; chord tones fall on strong beats; non-chord tones fall
> on weak beats.**

So when reading a line for its implied harmony you weight the **strong-beat / longer / metrically
accented** pitches as the structural (chord-defining) tones, and treat weak-beat stepwise pitches
as embellishments that *decorate* but do not change the chord:

- **Passing tone (PT):** approached and left by step in one direction; fills a third between two
  chord tones. Usually weak-beat (unaccented); when on a strong beat it is an *accented* PT — it
  sounds like the chord changed but resolves to reveal it didn't.
- **Neighbor tone (NT):** steps away from a chord tone and back. Weak-beat decoration.
- **Suspension, appoggiatura, anticipation, escape tone:** the remaining standard non-chord
  tones; each is defined by its approach/resolution, all parsed *against* the strong-beat chord.

Concrete reading: a melodic figure `C–D–E` over a held C-major harmony is heard as
**root–(passing)–third of I**, not as three chords, because the `D` (`^2`) is weak and stepwise.
The same three notes as quarter notes at a slow harmonic rhythm could instead be heard as
**I – V – I** (C=I, D=root of V's `^2`… ) — which one wins is decided by §3 (rate) and §6
(cadential expectation). This is the central craft lever: *the same pitches project different
progressions depending on which ones you place on the strong beats.*

**To make a line project chord X on a given beat: put a chord tone of X — ideally its root or
third — on the strong beat, and confine X's non-members to weak, stepwise positions.**

---

## 3. Harmonic rhythm: align structural pitches with the changes

**Harmonic rhythm** = the rate at which the chords change. It is an independent rhythmic layer,
usually slower than the surface rhythm, and it is what tells the ear *how often* to re-ask the
"which chord?" question.

Key facts (Wikipedia/Kostka & Payne; My Music Theory):

- Harmony changes **more often on downbeats than upbeats, on strong beats than weak.**
- **Tempo gates resolution of detail:** at a fast tempo, surface notes are absorbed as
  decoration of one slow chord; at a slow tempo, "a new chord on each beat" becomes plausible, so
  each beat's note is read as structural (My Music Theory).
- Harmonic rhythm typically **accelerates toward a cadence**, and the final cadence chords sit on
  metrically stronger positions than what precedes them.

Implication for projecting a progression from a line: the composer must make the melody's
*structural-tone rhythm* line up with the intended chord-change rate. If you want
"one chord per bar," only one pitch per bar can read as the chord tone (placed on the downbeat),
and the rest must be unambiguous decoration. If the structural tones change every beat, the ear
infers a fast harmonic rhythm and hears more chords. **A mismatch — structural-looking tones
arriving faster than the intended changes — makes the harmony sound under-determined or "wrong."**

---

## 4. The bass / root as the harmony-defining voice

Harmony is generated from the bottom. The bass is "the harmonic generator or foundation" of
Western tonal music; in any chord the bass note is the single strongest cue to the chord's
identity and function, because **the bass note's overtone series radiates upward over the chord.**

- In **root position**, the bass *is* the root; this is the most acoustically stable arrangement
  because the bass reinforces the chord's fundamental — the chord's identity is unambiguous and
  conclusive (OMT, Inversion & Figured Bass).
- In **first inversion** (third in bass), the chord is softer, lighter, "passing/melodic," less
  conclusive.
- The **cadential 6/4** is the clearest proof that the bass rules: a tonic triad's notes
  (`^1 ^3 ^5`) placed over a `^5` bass are *not* heard as tonic at all but as a dissonant
  dominant ornament — the `^5` in the bass "exerts its overtone series over the sounding notes,"
  forcing a V reading and a pull to resolution. The same pitch-classes mean a different chord
  purely because of which note is lowest.

**Why this matters for a single melodic line:** a pure melody has no literal bass — so to project
a *determinate* progression (especially root-position, cadentially strong harmony) the line must
**supply an implied bass.** It does this by:

1. **Putting the intended root in the lowest register at the structural moment.** The lowest
   strong-beat pitch of a passage tends to be heard as the implied bass/root, fixing the chord.
2. **Compound melody / implied counterpoint** (§5) — splitting the line by register so a lower
   strand functions as the bass voice.

A melody that keeps its roots on top and never descends to put a root low will sound harmonically
"floating"; a melody that periodically dips to the chord's root in the low register reads as
firmly rooted. **The lowest strong-beat root is what fixes the chord** — this is the single most
important lever for determinacy.

---

## 5. Compound melody: how one line projects a bass and inner voices

The mechanism by which an unaccompanied line implies a *full* harmony (not just a chord-per-beat
sketch) is **compound melody / implied polyphony** — supremely demonstrated in Bach's solo violin
(Sonatas & Partitas) and cello suites, written without continuo.

How it works at the note level:

- A line that looks like one strand is actually **two-to-four voices interleaved in time** — the
  voices "usually alternate with each other instead of being played simultaneously" (Sonatas &
  Partitas). The ear reassembles them into chords retroactively.
- The trigger is **register separation by leap:** "larger intervals within what otherwise is a
  stepwise line may suggest the presence of a second melody, or of rudimentary structures for
  harmonic and bass support." A stepwise upper strand plus periodic low leaps = an upper voice
  plus an implied bass.
- **Arpeggiation:** "harmonies are formed by a succession of arpeggiated notes — one at a time —
  and our listening mind connects them into chords." An arpeggio `C–E–G–C` *is* a C-major chord to
  the ear even though only one note sounds at a time; changing the arpeggiated set (`G–B–D–G`)
  *is* the chord change.
- **Multiple stops as anchors:** where Bach does write a literal chord (double/triple stop), it
  acts as a "vertical snapshot" confirming the harmonic network the single-line passages imply.

So the recipe for a self-harmonizing melody: alternate a **stable upper strand** (carrying the
melodic `^3/^5/^1` chord tones) with **lower pivot notes that spell the bass/root of each chord**,
and let arpeggiation through a chord's members occupy the span of that chord's harmonic-rhythm
slot. The leaps must be wide enough that the ear segregates the two registral streams.

---

## 6. Cadence in one line: ^2–^1, ^7–^1, ^4–^3 over an implied V–I

Cadences are the most *determinate* harmonic events, and they are routinely audible **from the
melody alone** because a small set of soprano scale-degree motions are idiomatically welded to
V–I:

- **`^2 → ^1`** (e.g. `D → C` in C major): the line's `^2` is the chord-fifth/third of V
  resolving to the root of I. Heard as **V–I authentic cadence.**
- **`^7 → ^1`** (`B → C`): the **leading tone** resolving up by semitone to tonic. The leading
  tone "almost always goes up a half step to the root, and when this happens the implied
  progression is V–I." This is the single most determinate melodic cue in tonal music — `^7→^1`
  alone strongly projects V–I.
- **`^4 → ^3`** (`F → E`): the dominant-seventh's chordal seventh resolving down by step to the
  third of I. Projects **V⁷–I** and, crucially, the `E` (`^3`) fixes the tonic as **major**
  (an `E♭`/`^♭3` would make it minor — see §below on quality).
- A **PAC** (perfect authentic cadence) is heard when the soprano lands on **`^1` over (implied)
  root-position tonic**; ending on `^3` or `^5` over I gives the weaker **IAC** (imperfect
  authentic). Ending the phrase on **`^2` or `^7` (on V)** with no resolution projects a **half
  cadence** — the line "hangs" on dominant, creating the expectation of an answering phrase.

So a phrase that simply descends `… D – C` on its final strong beats *cadences* — the ear supplies
the V–I even with no chord present. The structural-tone descent `^3–^2–^1` (or `^5–^4–^3–^2–^1`)
is heard as **tonic-prolongation → dominant → tonic** purely from the line. This is precisely the
Schenkerian fundamental line (§8).

**Tonic vs dominant projection in a single tone:** `^1` and `^3` (and `^5` weakly) project tonic
repose; `^7`, `^2`, `^4` project dominant tension (they are the active tendency tones — `^7↑^1`,
`^4↓^3`, `^2↓^1`). A line projects "now we are on the dominant" simply by sitting on/emphasizing
`^2`/`^7`/`^4`, and "now we have arrived home" by resolving them to `^1`/`^3`.

---

## 7. Which degrees on which beats establish I vs V vs IV vs vi — and major vs minor

Putting §§1–6 together, the **default strong-beat reading** (in a major key) is:

| Strong-beat melody degree | Default implied chord | Why / how to confirm |
|---|---|---|
| `^1` | **I** (root) | Tonic; most stable. Also third of vi, fifth of IV — confirm with bass/context. |
| `^3` | **I** (third) | Tonic; the `^3` is what makes I *major*. Also root of iii, fifth of vi. |
| `^5` | **I or V** | The ambiguous pivot: fifth of I vs root of V. **Defaults to V** "because it is the root of that chord" (My Music Theory) unless surrounded by tonic. |
| `^7` | **V** (third / leading tone) | Strongly V — the leading tone. Almost never anything else. |
| `^2` | **V** (fifth) | V; resolves `→^1`. Also root of ii. |
| `^4` | **V⁷ or IV** | Chordal 7th of V⁷ (resolves `↓^3`) or root of IV. |
| `^6` | **IV or vi** | Root of vi, third of IV. Needs more notes to disambiguate. |

Two structural rules sit on top of the table:

- **The third of the chord fixes major vs minor quality.** Root and fifth are shared between a
  major and minor triad on the same root; only the **third** distinguishes them. So whether a
  melody projects I or i depends on whether it touches `^3` (major) or `^♭3` (minor); whether it
  projects V (functional, with leading tone) vs v depends on `^7` vs `^♭7`. A line that *avoids*
  the third leaves the quality open (a deliberately ambiguous "power-chord"/open-fifth effect).

- **Primary vs secondary chords need different evidence.** I, IV, V are *primary* — the ear's
  defaults; a single well-placed root suffices. To make the line project a *secondary* chord
  (ii, iii, vi), "it is often necessary to use **more than one note** from the required chord, and
  to ensure that the **root** of the chord is used" (My Music Theory). A lone `^6` won't reliably
  say "vi"; `^6` plus `^1` plus a low `^6` root will.

### The process — making a line project a chosen progression

1. **Fix the target progression and its harmonic rhythm** (which chord on which beat/bar).
2. **For each chord slot, place a chord tone of that chord on the slot's strong beat** — prefer
   the **root or third** (third also nails the quality). Use the table above in reverse.
3. **Supply the implied bass:** at structural moments, drop the chord's **root into the lowest
   register** of the line (compound melody), so the lowest strong-beat pitch reads as that root.
   For root-position strength, keep roots low at the changes.
4. **For secondary chords, spell more of the chord** (≥2 members incl. the root) within the slot.
5. **Decorate freely on weak beats** with PT/NT/suspensions — these add surface life without
   changing the implied chord, *as long as they resolve before the next strong beat.*
6. **Cadence with the welded soprano formulas:** `^7→^1` or `^2→^1` (land on `^1` for a PAC) for
   closure; leave the phrase on `^2`/`^7` for a half cadence.
7. **Check the harmonic-rhythm match:** ensure no weak-beat decoration is heavy/long enough to
   read as a structural tone and imply an unwanted extra change.

This is exactly the textbook *narrowing* procedure run forward: instead of listing candidates and
eliminating, you *choose* the surviving candidate and arrange the line so the eliminating cues
(meter, register, cadence) all point at it.

---

## 8. The Schenkerian frame: the Ursatz as the deep harmonic skeleton of a line

Schenker formalizes all of the above into the **Ursatz (fundamental structure)** — a two-voice
contrapuntal skeleton that every tonal piece elaborates, and which is, in effect, *the harmony a
good melodic line is built to project.*

- **Urlinie (fundamental line):** a **stepwise descent from a tonic-triad tone to `^1`** — the
  upper voice. Permitted forms: **`^3–^2–^1`**, **`^5–^4–^3–^2–^1`**, (rarely) `^8…^1`. "There are
  no tonal spaces other than 1–3, 3–5, and 5–8" — i.e. the line travels within the tonic triad.
  Notice these *are* the cadential descents of §6 written large.
- **Bassbrechung (bass arpeggiation):** the lower voice arpeggiates the tonic triad **I – V – I**
  (up to the fifth-divider and back). This is the deep harmonic progression.
- **They are inseparable:** "Neither the fundamental line nor the bass arpeggiation can stand
  alone." The Urlinie supplies the *melodic/horizontal* dimension, the Bassbrechung the
  *harmonic/vertical* dimension — together they are the minimal complete tonal statement.
- **`^2` over the dominant:** the structural `^2` of the Urlinie is supported by the bass
  fifth-divider (`^5`) — "together they form the germ of a dominant chord." This is why a melody
  pausing on `^2` projects "we are on V." When the line reaches `^2`/V and *restarts* the descent,
  that is an **interruption** (`^3–^2 ‖ ^3–^2–^1`) — the deep form of antecedent–consequent
  phrasing (a half cadence answered by a PAC).

The practical payoff: a melody projects a determinate tonal progression to the degree that its
**structural tones trace an Urlinie** (a triadic stepwise descent to `^1`) while its **registral
low points trace the I–V–I bass arpeggiation.** Hierarchy matters — the structural tones are the
ones left after stripping the embellishments (§2), and *those* are what carry the harmony. A
line whose deep structure is `^3–^2–^1` over implied `I–V–I` will sound tonally complete and
purposeful even unaccompanied; a line with no such skeleton will sound aimless.

---

## 9. Deliberately *avoiding* harmonic implication: modal/folk/plainchant

The same theory, read in reverse, says how to write a line that does **not** project a fixed
functional progression — the goal of plainchant, much folk melody, and a freely floating cadenza:

- **Use modes, not major/minor** — plainchant and modal folk tunes "use modes instead of
  major/minor scales" and "intentionally avoid the functional harmony" of tonal music. The modal
  collections weaken the tendency-tone pulls.
- **Avoid the leading tone.** No `^7→^1` semitone (Dorian, Mixolydian, Aeolian have a *whole*
  step `^♭7–^1`) removes the single strongest V–I cue (§6), so the line never *commits* to a
  dominant. This is why a Mixolydian tune sounds "un-cadenced" / suspended even when it lands on
  its final.
- **Avoid emphasizing roots in a low structural register / avoid the I–V–I arpeggiation** — no
  implied bass means no fixed chord (§4). Keep the line in one register so no compound-melody bass
  emerges (§5).
- **Don't align structural tones to a regular harmonic rhythm** — free, prose-like rhythm (chant)
  gives the ear no periodic "change the chord now" signal (§3), so it stops trying to parse
  chords. Accompanying such melodies later means *imposing* a harmony the line did not request —
  "two distinct elements that can destroy one another."
- **Avoid or de-emphasize the third** to leave major/minor quality open (§7).

In short: determinacy and openness are the same dial. Strong-beat roots in a low register, a
leading-tone cadence, and a regular harmonic rhythm aligned to an Urlinie/I–V–I skeleton →
maximally hearable progression. Modal collections, no leading tone, single register, free rhythm,
suppressed thirds → deliberately harmony-free line.

---

## Sources

- [Introduction to Harmony, Cadences, and Phrase Endings — Open Music Theory](https://viva.pressbooks.pub/openmusictheorycopy/chapter/intro-to-harmony/)
- [Inversion and Figured Bass — Open Music Theory](https://viva.pressbooks.pub/openmusictheorycopy/chapter/inversion-and-figured-bass/)
- [Glossary — Open Music Theory](https://viva.pressbooks.pub/openmusictheorycopy/back-matter/glossary/)
- [Implied Harmony — My Music Theory](https://mymusictheory.com/composition/implied-harmony/)
- [Introduction to Harmonizing a Melody — Comprehensive Musicianship (Iowa State)](https://iastate.pressbooks.pub/comprehensivemusicianship/chapter/11-1-introduction-to-harmonizing-a-melody-theory-exercises/)
- [Harmonizing a Melody With Non-Chord Tones — Comprehensive Musicianship](https://iastate.pressbooks.pub/comprehensivemusicianship/chapter/11-5-harmonizing-a-melody-with-non-chord-tones-tutorial/)
- [Harmonic Rhythm: Tutorial — Comprehensive Musicianship](https://iastate.pressbooks.pub/comprehensivemusicianship/chapter/6-4-harmonic-rhythm-tutorial/)
- [Harmonic rhythm — Wikipedia](https://en.wikipedia.org/wiki/Harmonic_rhythm)
- [Fundamental structure (Ursatz) — Wikipedia](https://en.wikipedia.org/wiki/Fundamental_structure)
- [Schenkerian analysis — Wikipedia](https://en.wikipedia.org/wiki/Schenkerian_analysis)
- [Nonharmonic Tones — Fundamentals, Function, and Form](https://milnepublishing.geneseo.edu/fundamentals-function-form/chapter/15-nonharmonic-tones/)
- [The polyphonic nature of Bach's Solo Violin Sonatas and Partitas — The Strad](https://www.thestrad.com/playing-hub/the-polyphonic-nature-of-bachs-solo-violin-sonatas-and-partitas-more-than-meets-the-eye-and-the-ear/20011.article)
- [Notation and Compound Melody — Bach Sonatas and Partitas](http://www.sonatasandpartitas.com/articles/?id=41)
- [Bach, The Cello Suites — Earsense (implied polyphony / arpeggiated harmony)](https://www.earsense.org/article/Bach-The-Cello-Suites/)
- [Mode — Plainchant, Medieval, Gregorian — Britannica](https://www.britannica.com/art/mode-music/Plainchant)
- [Harmony before the common-practice period — Britannica](https://www.britannica.com/art/harmony-music/Harmony-before-the-common-practice-period)

Standard print references corroborating the above (not fetched, cited as canon): Aldwell &
Schachter, *Harmony and Voice Leading*; Steven Laitz, *The Complete Musician*; Kostka & Payne,
*Tonal Harmony*; Allen Cadwallader & David Gagné, *Analysis of Tonal Music: A Schenkerian
Approach*.
