# Research Foundations — Video Game Symphony Project

*Phase 1 of N: research → direction → motif design → movement architecture → section-by-section composition → MIDI rendering → revision passes.*

This document distills research on all stated inspirations (Final Fantasy/VGM, Mahler/Brahms, Star Wars/Williams, Vangelis, Goa/psytrance/Shpongle, Arabian color, Debussy, Bach/Beethoven piano) plus composition technique and MIDI tooling, into actionable material for designing the symphony.

---

## 1. The Video Game Tradition (Final Fantasy / Uematsu / JRPG)

### Uematsu's method
- **Melody first**, harmonize after — themes must survive being stripped to one line.
- Diatonic, Romantic base spiked with **modal mixture** (♭VI, ♭VII7, minor iv, minor v), secondary dominants, deceptive cadences as formal hinges.
- Leitmotif networks across a whole game: a main theme that *alludes* to character themes. Signature intervals as fingerprints (FFVII's **major 7th leap** is recycled score-wide).
- He uses orchestrators (Hamaguchi) — composition and orchestration are separable passes. Good news for our pipeline.

### Key piece analyses (steal list)
| Piece | Technique worth stealing |
|---|---|
| **Prelude** | C major arpeggio climbing ~4 octaves over 16 bars; triads → add9 → add7; parallel-minor dips; variation by adding/removing countermelodies. The "world before the story" texture. |
| **FF Main Theme** | I–vi–I–♭VI7–♭VII7–I; deceptive cadence pivots hope→menace; common-tone modulation E→G on shared B. |
| **Terra's Theme** | Character theme doubling as overworld theme. G minor, lonely flute over snare ostinato. |
| **Aerith's Theme** | Grief = **major key** + suppressed dominant (minor v) + ♭VI(add9) → minor iv, voice-led by common tones. NOT minor key. |
| **To Zanarkand** | E minor with i, iv, v all minor — no dominant function at all. Restraint + grace notes. |
| **One-Winged Angel** | Stravinsky block construction: short violent modules juxtaposed, not developed. Orff-style Latin choir. Rock energy scored for orchestra. |
| **Dancing Mad** | ~17 min, **four movements mapped to the boss fight's four tiers**: dark intro w/ quotes → organ fugue → grotesque scherzo on villain theme → prog finale. The model for a final-boss finale. |
| **Liberi Fatali** | Choral prologue (invented Latin) that seeds the work's master motif into later tracks. |

### Track-type conventions (our movement vocabulary)
- **Battle**: minor (A minor is THE key), 150–190 BPM, churning bass/riff intro, looped A/B cells over constant ostinato. Energy without harmonic arrival ("musicospatial stasis").
- **Victory fanfare**: brass triplet arpeggio burst → relaxed march; functions as a sudden ♭6–♭7–1 terminal cadence.
- **Boss/final boss**: battle + choir/organ + mixed meter + multi-section form + distorted quotations of the game's other motifs.
- **Overworld/exploration**: broad lyrical melody, moderate tempo, long phrases — "endless horizon."
- **Town**: small kitschy ensemble (accordion, music box, mallets), dance topics (waltz/jig), short ternary loops.
- **Death/loss/betrayal**: sparse piano or solo winds; Aerith model (major + mixture) or Zanarkand model (minor, no dominant); music-box timbre for innocence lost.
- **Loop architecture** (Drum Chant study): ≤5 simultaneous voices, ~16-bar theme chunks, ostinato in 8/10 tracks, variation via countermelody add/remove + octave shift + timbre swap, rhythmic breakdown tags, phrase-end prolongations on V or I.

### Concert adaptation: the bar to clear
- **Distant Worlds** = faithful song-length orchestrations (the medley pole — NOT our model).
- **Final Symphony (Valtonen/Wanamo/Hamauzu, 2013)** = the real model: FF themes re-developed into a symphonic poem, a 3-movement piano concerto, and a 41-minute symphony. Key Valtonen techniques:
  - A **3-note villain cell as structural glue**; themes appear *distorted before appearing plainly*.
  - **Vertical stacking**: climax = all the movement's themes sounding simultaneously, then one "moment of clarity" statement of the core motif alone.
  - Dramaturgy of interruption for the romance movement (every build cut off before climax).
- Reviews singled out: it **develops and overlays themes rather than medleying them**. That's our bar.

### Other VGM composers
- **Mitsuda**: ethnic solo instruments over drones; extreme harmonic economy (Xenogears final battle = 2 chords) under rhythmic richness.
- **Kondo**: modular 8-bar cells; ♭VI–♭VII–I triumph cadence; open voicings for clarity; composes from the rhythm of motion.
- **Shimomura** ("Dearly Beloved"): design the main theme maximally simple (4 chords, diatonic) so it survives infinite re-arrangement.
- **Wintory** (Journey): concerto-protagonist logic — one solo instrument = the player, orchestra = the world, single variation arc across the whole work.
- **Tin**: invented/borrowed-language choral text as an Orff-like legitimizing frame.

---

## 2. Symphonic Architecture (Mahler / Brahms / cyclic tradition)

### Mahler
- Symphony as "a world": character movements — **funeral march, Ländler, waltz parody, nocturne, chorale apotheosis**.
- **Mahler 5's plan** (5 movements in 3 parts) is a near-perfect scaffold for us: funeral march → stormy allegro containing a **premature chorale "breakthrough" in the finale's eventual key** (collapses) → huge central scherzo → chamber-scored Adagietto (strings+harp only) → rondo-finale whose coda *fulfills* the chorale.
- **Progressive tonality**: begin and end the *work* in different keys (C♯ minor → D major; C minor → E♭). The finale's tonic must be *earned*, foreshadowed by an earlier breakthrough.
- **Chamber textures inside the huge orchestra** (solo double bass, strings+harp, single winds in dialogue) — the orchestra as a palette of ensembles.
- **Off-stage effects** (distant fanfares): in MIDI = heavy reverb send + low-pass + reduced velocity.
- Codas as second developments/apotheoses — longest sustained tutti confirms the target key.

### Brahms
- **Developing variation** (Schoenberg's term): every continuation derives from the basic motive via interval expansion/contraction, rhythmic shift, inversion, sequence — "nothing is repeated without promoting the development of the music."
- **Symphony 4/i**: entire theme = chain of descending thirds + inversions; all later themes unfold the chain.
- **Symphony 4/iv passacaglia**: 8-bar theme (from Bach Cantata 150), 30 variations + coda, ~10 min, with a hidden 3-part form (build → slow E-major island w/ flute solo & trombone chorale → return and drive). **The most "buildable," MIDI-friendly climactic form available** — clear 8-bar harmonic grid, each variation an independent compositional unit.
- **Mediant (third-based) key relations between movements** instead of dominant relations.

### Cyclic form / thematic transformation toolkit
From Berlioz (idée fixe), Liszt (transformation, double-function form), Franck (cyclic combination), Dvořák 9 (the practical model — finale stacks mvt 1 + Largo + Scherzo themes simultaneously):

1. Rhythmic augmentation (motif → chorale/anthem)
2. Diminution (motif → scherzo figuration/accompaniment)
3. Mode/scale recoloring (minor↔major↔Phrygian↔Lydian)
4. Re-harmonization (same notes, new chords — esp. chromatic mediants)
5. Re-metering (4/4 march → 3/4 Ländler → 6/8 jig)
6. Inversion/retrograde of contour
7. Fragmentation (head cell as ostinato or bass)
8. Timbral re-casting (solo horn → tutti brass → celesta music-box)
9. Contrapuntal combination of two cyclic themes (Franck/Dvořák finale move)
10. Character parody (Berlioz mvt 5: lyric theme → shrill E♭ clarinet jig)

Berlioz proves a theme survives total character assassination: same idée fixe as palpitating lyric, waltz, pastoral, guillotined fragment, and grotesque dance.

### Williams (orchestral side)
- **Main Title**: heroism = rising P4/P5 leaps, triplet pickups, major mode, top-of-stave trumpets, 8-bar antecedent–consequent period.
- **Force theme**: P4 from dominant→tonic + stepwise rise; modal harmony (♭VI–♭VII–i, minor iv); the saga's most transformed motif — transformation is mostly tempo + orchestration + cadence treatment.
- **Imperial March**: villainy formula = all-minor chord vocabulary, **chromatic-mediant root motion with minor quality both sides (G min ↔ E♭ min)**, semitone-displaced "almost-functional" progressions (i–♯iv–♯v–i), low-register brass, persistent downward melodic gravity, accelerating repeated-note accompaniment riff.
- **Action ostinati**: octatonic / stacked-minor-third low-string ostinato in irregular accent groups, brass stabs on chromatic mediants, melody in horns *over* it, inserted 2/4 / 5/8 bars.
- **Leitmotif economy**: 4–8 interval-distinct themes per score, identifiable from 2-note fragments.
- Brass power = rhythmic articulation not sustain; unison horn massing; **save trumpets + cymbals for the final 4–8 bars of a climax**.

### Proportions (for ~35–40 min)
| Slot | Share | Minutes |
|---|---|---|
| Sonata-allegro (I) | 28–33% | 10–12 |
| Slow movement | 25–30% | 9–11 |
| Scherzo/dance | 15–18% | 5.5–7 |
| Finale + coda | 25–30% | 9–11 |

Five-movement plans add a short character movement (march/nocturne/intermezzo, 5–6 min) at position 2 or 4. Standard order fast–slow–dance–finale; honored deviations abound (Mahler 5's arch, Tchaik 6's slow ending).

---

## 3. Electronic & Exotic Palette (Vangelis / Goa / Shpongle / Arabian)

### Vangelis: the soaring recipe
- **CS-80 brass swell**: ~1s slow attack, every note *blooms*. Orchestral translation: brass entering p with 1-beat crescendo per note (sfp-cresc swells).
- **Cavernous shared reverb is structural** — one hall glues all layers (Lexicon 224). Write *for* the long tail: slow harmonic rhythm, space between phrases. In MIDI: one shared hall bus.
- Layer stack: string-machine pad holding triads + bell/Rhodes melody on top + synth-brass swells + huge slow processional percussion.
- Harmony: **Conquest of Paradise = La Folia progression** (Dm–A–Dm–C–F–C–Dm–A); anthem = Dm–C–B♭ over chanting choir. Aeolian ♭VII/♭VI = his "ancient-heroic" color.
- **Soaring formula**: slow/pedal bass + i–♭VII–♭VI descents + melody in long notes a 10th+ above the bass, leaning on suspensions (4–3, 9–8) into each downbeat (Chariots).

### Psytrance / Goa mechanics
- **Rolling bass DNA**: per beat `K-b-b-b` (kick on beat, bass on 16ths 2-3-4), bass = ONE pitch for long stretches (rooted drone), keys E/F/F♯/G. Psytrance ≈ 140–148 BPM, Goa ≈ 135–145.
- **Orchestral translation**: timpani/bass drum = kick; celli+basses spiccato on the `-bbb` 16ths on a single pedal pitch (E or D, open-string resonance); bassoon/bass clarinet doubling for the click; optional honest synth-sub doubling an octave below (Junkie XL: *double, don't alternate*).
- **Acid leads** (303): modal 16th arpeggio cells mutating one note at a time, slides, accents; 3–5 layers an octave apart by climax. Orchestral analogue: E♭ clarinet/oboe figuration with grace-note slides, solo violin portamento, xylophone+piccolo bite — or keep one honest synth lead.
- **Goa harmony is already our bridge**: modal, non-functional, single-scale, rooted bass — and its favorite scales are **Phrygian dominant ("Spanish Phrygian" — explicitly the classic Goa scale), Phrygian, harmonic minor**. Tension via texture accumulation, dropouts (kill the kick 8 bars, slam back), filter sweeps → orchestrate as layering crescendo, tutti dropouts, register expansion. Never modulate to build; accumulate.
- **Shpongle method**: Raja Ram improvises flute ~20 min; Posford edits the best chunks over electronic scaffolding. Translation: a **concertante flute/alto flute with written-out "improvisation"** — breathy, ornamented, modal — floating over beds.

### Arabian color strictly in 12-TET (no microtones — per your constraint)
| Scale | On D | Maqam analogue | Character |
|---|---|---|---|
| **Phrygian dominant** | D–E♭–F♯–G–A–B♭–C | Hijaz | THE sound; aug-2nd ♭2→3 |
| **Double harmonic** | D–E♭–F♯–G–A–B♭–C♯ | Hijaz Kar | two aug-2nds, more intense |
| **Phrygian** | D–E♭–F–G–A–B♭–C | Kurd (*exactly* 12-TET) | darker, brooding |
| **Harmonic minor** | D–E–F–G–A–B♭–C♯ | Nahawand-ish | Goa staple |

(Bayati genuinely needs a half-flat 2nd — no good 12-TET version; use Phrygian/Kurd and don't chase it.)

- **Cadence**: ♭II→I as major triads (E♭→D). Full Andalusian: i–♭VII–♭VI–V — *which is also the La Folia/Vangelis lament bass*. One progression serves both worlds.
- Drones (open 5th pedal), parallel/oblique motion over pedal, melisma; ornament the augmented 2nd (mordents, lower-neighbor grace notes, slides into long notes — portamento replaces microtonal inflection).
- **Rhythms (D=dum low, T=tek high)**: Maqsum 4/4 `D T – T | D – T –`; Baladi `D D – T | D – T –`; Saidi `D T – – | D D T –`; **Malfuf 2/4** (3+3+2 — layers over psy-bass 16ths as built-in cross-rhythm); **Ayyub 2/4** (the trance/ritual one — literally proto-psytrance gallop).
- **Instrument mapping**: oud→harp (près de la table)/pizz celli; ney→alto flute low register; qanun→harp bisbigliando/cimbalom; darbuka→bongos+rim/toms; riq→tambourine; mizmar→oboe/English horn ff.
- **Models done well**: Scheherazade (solo violin+harp narrator frame — perfect template for a recurring storyteller voice), Borodin (melisma + drone + two-theme combination finale), Khachaturian (Sabre Dance's one-bar ostinato = proto-psytrance; modal melody over secundal/quartal pungency, massed unisons).

### Hybrid blend rules (Junkie XL / Toprak / FF7R / NieR)
1. **Frequency separation**: synth owns sub (<60 Hz) + extreme highs; orchestra owns the mids.
2. **Role separation**: electronics take rhythm/grid (kick, psy-bass, arps); orchestra takes melody/harmony/swells; invert occasionally for effect.
3. **Shared reverb space** (Vangelis trick) fuses layers.
4. **Semantic assignment** (Toprak): decide per movement what synths *mean* (the alien/other/machine) vs. orchestra (the human). Declare each movement's palette: orchestral world / hybrid world / electronic world.
5. **Signature timbre as thread** (NieR's wordless voice): one timbre appearing in every movement unifies the work.
6. Write the same theme at 2–3 intensity states (FF7R interactive-layering logic) — useful as a development device.

---

## 4. Composition Technique Toolkit

### Motivic development (all programmatically implementable)
Transposition, sequence (2–3 reps then break, never 4), inversion, retrograde, augmentation/diminution, **fragmentation** (the canonical tension builder), intervallic expansion/contraction (keeps contour+rhythm recognizable while reaching new harmony).

**Beethoven 5 as model**: one 4-note cell (distinct rhythm + distinct interval) saturates four movements as theme, accompaniment, horn call, scherzo rhythm, finale recall. The coda is a **second development**. Rule: build every theme from 1–2 cells of 3–5 notes; derive accompaniments, countermelodies, transitions from the same cells.

### Counterpoint essentials
- Working rules: contrary/oblique motion preferred, no parallel 5ths/8ves, dissonance as passing/neighbor/suspension/appoggiatura, one climax note per line.
- **Invertible counterpoint at the octave**: treat 5ths as dissonances (they invert to 4ths); write theme + countersubject once, reuse in any registration. *Pre-write a countersubject for every theme.*
- **Fugato** (fugal exposition dropped into a movement) is more practical than full fugue. Subject design: under an octave, one striking rhythm, clear do/sol anchor, distinctive head + flowing tail, survives stretto. Tonal answer if subject opens sol–do.
- Canon at the octave over a harmonic ostinato = the cheap reliable canon.

### Harmonic palette
Functional core (reserve real V–I for the biggest arrivals) + extended palette: **chromatic mediants** (the awe progression; common-tone modulation rides the shared note), modal interchange, Neapolitan, augmented sixths (Ger+6 = enharmonic modulation trapdoor), **planing**, quartal harmony, pedal points (dominant pedal = pre-climax device).

### Debussy specifically
- Four scale-worlds — diatonic/modal, pentatonic, whole-tone, acoustic — **slid between, not modulated between**.
- Chords as color objects: parallel 9th/11th chords planed; unresolved dominants; avoided cadences.
- The **arabesque** melody: ornamental curving lines, triplet-vs-duplet fluidity, cascading figuration.
- Key trick to steal: **a fixed melody re-harmonized differently at each return** (Faun's flute line). Pairs beautifully with leitmotif technique — and the term "arabesque" is no accident: it dovetails with the Arabian ornamental register.

### Powerful piano writing
- **Bach**: motoric 16ths + **implied polyphony** (one line alternating registers = 2–4 heard voices). Extremely MIDI-friendly.
- **Beethoven**: doubled octaves both hands, measured tremolo, extreme register contrast, weak-beat sforzandi, subito pp after ff, trills as tension, moto-perpetuo finales over pedals.
- **Rachmaninoff**: melody atop 4–6 note bell-voiced chords, octave-doubled inside the chord, inner countermelodies.
- **Piano-in-symphony precedents**: Saint-Saëns 3 (color halo), Shostakovich 1 (sardonic obbligato), Turangalîla (full protagonist). Three roles: (a) color/halo, (b) motoric rhythm engine, (c) Rachmaninoff protagonist w/ cadenza. A work can graduate the piano a→b→c across movements.

### Form library
- **Sonata form** w/ developmental coda (mvt I default).
- **Passacaglia** (Brahms 4 model): the most modular, buildable, sequencing-friendly form — strong candidate for a major movement.
- **Theme & variations** with a parameter plan; **rondo/sonata-rondo** for finales; **arch form** (ABCBA) for a slow movement; **through-composed scena** unified by leitmotif recall.
- **Pacing**: one global climax at ~70–80% of each movement, 2–3 local peaks, real valleys.
- **Transition recipe**: liquidate old theme to its cell → sequence while modulating → accelerate harmonic rhythm → caesura/dominant arrival.
- **Climax recipe** (reusable function): pedal point + ascending sequence + fragment-shortening + register climb + orchestration stack (strings→winds→horns→trumpets+percussion last) + tempo push.

---

## 5. Pipeline / Tooling (targets: Dorico + VSL; second realization in Ableton)

**Two delivery targets, one composition source:**

- **Composition layer**: music21 (or custom Python model — measures, harmony objects, motif-transform methods), strictly separated from export so movements regenerate independently.
- **Target A — Dorico + VSL (the score)**: primary deliverable is **per-movement MusicXML** (notation-accurate: dynamics, articulations, slurs, tempo/expression text, playing techniques) plus parallel per-movement MIDI. Do **NOT** bake CC1/CC11 curves or timing humanization into this target — Dorico's expression maps + VSL Synchron/MIRx handle dynamics, legato, and humanization from notation far better than baked CC data, and baked curves fight the expression maps. Encode musical intent as *notation*: hairpins, marcato/staccato/tenuto, con sord., sul pont., trills, tremolo measured vs. unmeasured, divisi.
- **Target B — Ableton (the hybrid/electronic production)**: per-role **stem MIDIs on a fixed grid** (minimal rubato; tempo changes as discrete block changes, not curves) so they sit on Ableton's grid for warping/sidechaining: separate files/tracks for kick-pattern, psy-bass line, acid lead, pads, arps, and drum-kit parts (GM drum mapping on ch.10 as lingua franca, easily remapped to any kit). The battle movement (and parts of the boss) can be *scored for kit + electronics natively* in this version — the orchestral psy-bass emulation and the real psy-bass are alternate realizations of the same written material (FF7R-style intensity states).
- **Track budget**: full late-Romantic orchestra at one track per section ≈ 25–30 tracks (winds in 3s split by player where divisi matters, 5 string sections, perc split: timp / cymbals+gong / snare+toms / mallets / hand-perc, harp, piano, celesta, choir SATB) + 4–8 electronic stems. ~35–45 total, comfortably under 64; only split further where real divisi demands it.
- **Tempo**: notated tempo marks + rits/accels in the MusicXML (Dorico interprets these); a separate strict-grid tempo map for the Ableton stems.
- Classic JRPG texture (≤5 real voices + ostinato) renders beautifully even in mockup — lean on it between big tuttis.

---

## 6. Synthesis: Emerging Design Principles

These fall out of the research with unusual convergence — several inspirations turn out to share DNA:

1. **One progression unites three worlds.** The Andalusian/La Folia descent (i–♭VII–♭VI–V) is simultaneously Vangelis's anthem harmony, the Arabian cadential formula, and a Romantic lament bass. It should be one of the work's foundational harmonic objects.
2. **One scale family unites Goa + Arabian + dark-heroic.** Phrygian dominant is the classic Goa scale AND 12-TET Hijaz AND film-villain color. Use a modal axis (Aeolian ↔ Phrygian ↔ Phrygian dominant ↔ double harmonic on a fixed tonic) as the symphony's version of modal mixture.
3. **Psy-bass is just an orchestral ostinato.** `K-bbb` at ~140 BPM on a pedal pitch = timpani + spiccato low strings (+honest synth sub). Khachaturian and Williams already wrote proto-psytrance. The battle movement builds Goa-style: accumulation and dropout, not modulation.
4. **Motif-first, Beethoven/Brahms-engineered.** Design 4–8 interval-distinct leitmotifs (Williams economy), all derivable from one germ cell (Beethoven 5), each with a pre-written invertible countersubject. The 10-technique transformation toolkit + developing variation is the development engine. Distort themes before stating them plainly (Valtonen).
5. **Mahler 5 + progressive tonality as scaffold.** Open dark, end in an earned key a third/semitone away; plant a premature "breakthrough chorale" early that the finale fulfills; one chamber-scored movement for contrast; codas as apotheoses.
6. **The finale is Dancing Mad.** Multi-tier final-boss architecture (dark intro quoting the opening → fugato → grotesque villain scherzo → apotheosis), climaxing in Valtonen vertical stacking (all themes simultaneously → clarity statement), ending with the ♭VI–♭VII–I victory cadence + fanfare triplets as the symphony's final word.
7. **Concertante threads**: piano graduating color→engine→protagonist across movements (Bach/Beethoven/Rachmaninoff registers); a "storyteller" solo voice (Scheherazade violin+harp or Shpongle alto-flute "ney") opening and linking movements. Both also serve as the NieR-style signature timbre.
8. **Per-movement palette declaration** (Toprak): each movement declares orchestral / hybrid / electronic world. Frequency- and role-separate the electronics; one shared hall fuses everything.
9. **Grief is major** (Aerith model): the death/betrayal movement should use major + modal mixture + suppressed dominants, or Zanarkand's all-minor-triad restraint — not generic minor-key sadness.
10. **Build methodically**: forms chosen for modularity (sonata w/ developmental coda, passacaglia, variations, rondo); reusable climax/transition recipes; composition layer separated from rendering layer so everything is regenerable and revisable.

### Provisional movement-type → tradition mapping (to be debated next)
| Game slot | Classical form | Primary palette |
|---|---|---|
| Prelude/Opening | Intro/arpeggio prologue (poss. choral) | Orchestral, FF Prelude texture |
| Exploration/Overworld | Sonata-allegro | Orchestral + Vangelis swells |
| Battle | Scherzo / moto perpetuo | Hybrid (psy-engine + orchestra) |
| Character/Love theme | Slow movement (arch form, Debussy language) | Chamber/orchestral, piano + storyteller solo |
| Death/Betrayal | Funeral march or Aerith-model elegy | Sparse — piano, music box, strings |
| Town/Dance (optional) | Ländler/waltz intermezzo | Small kitschy ensemble |
| Final Boss + Victory | Multi-tier finale (fugato → scherzo → passacaglia/apotheosis) | Everything, vertically stacked |

---

## Appendix: Source Index

**VGM/FF**: Hooper leitmotif study (ResearchGate); USM thesis on Uematsu linear structures; Game Developer "7 Music Theory Lessons from FFVII"; ThinkSpace FFVII chromatic harmony; Drum Chant "JRPG Song Forms"; JSMG "Sounding the Grind"; Laced Records Final Symphony breakdown; Final Fantasy Wiki theme pages; Hooktheory theorytabs; shmuplations Kondo interviews.

**Symphonic**: Film Music Notes (Richards) Imperial March + Main Title analyses; Lehman Star Wars thematic catalogue; Mahler Foundation listening guides; Utah Symphony Mahler 5 guide; Boston Chamber Music Society on developing variation; Wikipedia (Brahms 4, Franck D minor, Dvořák 9, cyclic form, Mahler 5); Open Music Theory orchestration chapters.

**Electronic/exotic**: Reverb Machine Vangelis analysis; MusicTech Blade Runner emulation; Hooktheory Conquest of Paradise; dsokolovskiy/FeelYourSound/DMS psytrance bass tutorials; Melodigging genre profiles; Psynews/Gearspace Goa scale threads; Wikipedia Shpongle + MAPS Posford interview; MaqamWorld iqa'at; Wikipedia Phrygian dominant/double harmonic; ADSR Junkie XL bass layering; ThinkSpace Captain Marvel; Spitfire/Audiokinetic FF7R; PlayStation Blog NieR Okabe interview.

**Technique/tools**: Columbia Basin Beethoven 5 analysis; UCSB invertible counterpoint; Puget Sound fugue analysis; Open Music Theory sonata form; Tymoczko "Scale Networks and Debussy"; Bach Network implied polyphony; Wikipedia Brahms 4 passacaglia, Saint-Saëns 3; music21/pretty_midi/abjad/MusPy docs; ModWheel CC guide; VI-Control threads.

*(Full URLs preserved in the per-agent research transcripts; ask if you want the complete linked bibliography inlined.)*
