# TECHNIQUE LIBRARY - index, spec, workflow

User mandate: "if you need cards to keep you in the right complexity space, then we
need to produce a whole library of cards from orchestral voicing to piano voicing, to
cross instrument call and response, to rhythmic interplay between voices and beyond."

## Canonical layout

This top-level library is reusable across works. The symphony may use it, but it
is not owned by the symphony.

- `technique_library/INDEX.md` - this index, spec, workflow, and reference list.
- `technique_library/dsl/README.md` - production-DSL card source rules.
- `technique_library/dsl/cards/` - authoritative auditionable `production_piece`
  card specimens.
- `technique_library/16th_note_figures.md` - prose catalogue for
  `dsl:figures.16th/F01` through `dsl:figures.16th/F32`.
- `technique_library/handpan_idiom.md` - handpan idiom catalogue: Ding,
  tonefield, touch-pattern, resonance, D Kurd layout, and anti-flute failure
  modes.

For new production-DSL work, cite `technique_library/dsl/README.md`, use the
`dsl:<category>/<id>` reference form, and read auditionable card specimens from
`technique_library/dsl/cards/`. The old `reference/music/` package is only a
legacy pointer. New DSL briefs and score comments should not cite Python module
paths as their authority.

## Card-writing procedure (BINDING)
Every card is composed via `reference/written/procedures/card_writing_procedure.md`: one idea per agent ->
EXTERNAL RESEARCH -> a knowledge-file survey (not distilled) -> read the FULL craft (pitch/voice-
leading, voicing, rhythm, figuration, orchestration + the card spec) -> write -> analyze -> repeat.
Research-driven and NEUTRAL across craft dimensions; grounded in real sources, composed at the
P-card complexity bar. (No pre-baked single-axis checklist -- what matters comes from the research.)

## Finding cards for DSL work
The card specimens are `production_piece` files under
`technique_library/dsl/cards/`; the index is
`technique_library/dsl/cards/INDEX.md`. `tools/lib.rb` remains the search front
door by category/facet and now reports the DSL specimen path for matching cards.
The per-card prose further down is illustrative and may lag the DSL source index
(e.g. the old `keyboard` shelf is now merged into `piano`, and voicing has its
own `voicing` shelf). Older `tc_*.musicxml/.mid` filenames are superseded by
exporting the card's `.rb` source through the production DSL exporter.
Two denormalized search axes, one term:
- **category** (the shelf, routed by instrument/role): `piano · voicing · chamberstrings · orchestral ·
  dialogue · figuration · elegy · callresponse · forms`
- **facet** (a small general vocabulary derived from each card's `behavior`, no tag store):
  ROLE `lead comp counter bass` · INTEREST `rhythm voicing color figuration` · CHARACTER `tender
  tension grief` · ENSEMBLE `section`.
`ruby tools/lib.rb <term>` lists matches and their DSL specimen paths;
`... show <NAME>` prints the card metadata plus DSL specimen path; `... terms`
lists valid terms. Composing agents are handed a few terms and pull on demand.
For DSL work, cite the pull as `dsl:<category>/<id>` and read the `.rb` source
when the auditionable specimen, representation, or technique behavior matters.

## The card spec

A card = a LOCKED 4-8 bar note-level specimen of one texture, composed at full craft:
- name, category, annex citation (ornamentation-f section);
- scoring (roles, not fixed instruments — re-scorable within the role classes);
- BEHAVIOR description (what it does; E9: behavior, never provenance);
- parameterization: transposable (tp), re-scorable, harmonic slots marked — the card
  carries a chord-slot skeleton so it can be re-fitted to any progression of the
  same rhythm class;
- MACHINE NUMBERS (texture_diag metrics): each card ships with measured vocab,
  voices, attacks/bar, span — and must beat the floors that the broken movements
  failed (vocab >=3/16-equivalent, internal variation between its own bars,
  union-surface continuity).

## Workflow (the theme-card pipeline, extended to every layer)

compose -> machine-measure -> PER-CARD AUDITION RENDER -> USER approves/rejects
per card -> LOCK approved audition specimens in `technique_library/dsl/cards/`
-> later work may compose from those models or escalate a new card for audition.
Audition renders are PER CARD: use `partitura/bin/production_export` on the
card's `.rb` source to write MusicXML/MIDI. G17 (FIGURATION gate) is calibrated against the locked
cards' numbers.

## 16th-note piano figure catalogue

`technique_library/16th_note_figures.md` collects fast figure families for
high-complexity solo-piano and etude work. The corresponding auditionable DSL
specimens are `dsl:figures.16th/F01` through `dsl:figures.16th/F32`; final score
material still has to be composed for the piece itself.

## Handpan idiom catalogue

`technique_library/handpan_idiom.md` collects research-backed handpan writing
guidance. It treats handpan material as touch-pattern plus resonance: Ding,
tonefields, left/right path, slaps/taks/ghosts, muted strokes, harmonics,
finger rolls, and exact scale layout. It should be read before composing or
reviewing any handpan part; concrete handpan cards should become auditionable
DSL specimens.

Reference sources for the 16th-note figure catalogue:

- Taffanel/Gaubert, *17 Grands exercices journaliers de mecanisme*, IMSLP:
  https://imslp.org/wiki/17_Grands_exercices_journaliers_de_m%C3%A9canisme_%28Taffanel%2C_Paul%29
- Andersen, *24 Etudes for Flute*, Op. 15, IMSLP:
  https://imslp.org/wiki/24_Etudes_for_Flute%2C_Op.15_%28Andersen%2C_Joachim%29
- Analysis of Andersen Op. 15 technical topics:
  https://files.eric.ed.gov/fulltext/EJ1291570.pdf
- Ferling, *48 Studies for Oboe*, Op. 31, IMSLP:
  https://imslp.org/wiki/48_Studies_for_Oboe%2C_Op.31_%28Ferling%2C_Franz_Wilhelm%29
- IDRS Ferling narrative, including arpeggios, chromatic scales, intervals,
  toccata, cross-string virtuosity, and pedal points:
  https://www.idrs.org/scores/Ferling/Narrative.html
- Klose clarinet method index, MakeMusic:
  https://search.makemusic.com/p/celebrated-method-for-the-clarinet-26832/interactive
- UNT clarinet technique requirements:
  https://music.unt.edu/woodwinds/clarinet/files/technique_requirements_for_clarinet.pdf

## Card catalog (illustrative prose; the DSL card sources are authoritative)

CATEGORY K — KEYBOARD FIGURATION (keyboard_figuration s1-s4)
- K1 NOCTURNE_34: 8 bars. Melody / sluggish bass-line / WINDING MIDDLE VOICE (+tenor
  at the return). LH sweep crest = slow inner melody; middle voice marks pulse.
- K2 BELL_ELEGY: 8 bars. Rachmaninoff LH: continuous triplet arpeggi spanning 2+
  octaves, crest follows phrase; melody plain then in octaves; bell TOLL event at the
  phrase peak (fundamental + high m3 partial, decays).
- K3 CONCERTANTE_HALO: 6 bars. Piano accompanies another voice (melody slot marked):
  RH filigree above, LH bass-line + tenor; union-surface continuous, melody never
  doubled in its own octave.
- K4 MUSIC_BOX: 6 bars. High register, sparse BUT layered: ostinato cell + inner
  sympathetic voice + bass chime — three events classes, not one.
- K5 CHORDAL_CLIMAX: 4 bars. Both hands chordal: melody in octaves + inner doubling,
  LH leaping bass octaves + afterbeats; one written rubato spread.
- K6 CADENZA_BURST: 4 bars. Written-out quasi-cadenza: anchor -> unmeasured-feel run
  -> chordal landing (Scheherazade recipe on keyboard, ornamentation s2).

CATEGORY O — ORCHESTRAL VOICING & ACCOMPANIMENT (chord_scoring; composition_method A.4-A.5; keyboard_figuration s5)
- O1 PP_LUMINOSO: 6 bars. One-per-pitch luminous spacing + harp doubling + a moving
  inner voice (the pad that is not a pad).
- O2 BRASS_CHORALE: 6 bars. Interlocked hns+tbns, suspensions chained at every
  change (chord_scoring s6: re-attack + re-voice; suspension in ONE audible color).
- O3 FFF_PYRAMID: 4 bars. The chord_scoring tutti recipe realized: every section internally
  complete, seams overlapped, 3 octaves of melody, timp+cym at the peak only.
- O4 BASS_AS_LINE: 8 bars. The composition_method A.4 law as a specimen: walking low strings under a
  sustained upper texture — passing tones, anticipations, register event at the
  phrase boundary. (The anti-ROOTQ card.)
- O5 INNER_AGITATION: 8 bars. Brahms law: outer voices hold, inner voices animate in
  8ths (neighbor motives, exchanges, one suspension chain per 2 bars).
- O6 STRATA_LATTICE: 8 bars. Three jobs + punctuation: 16th figuration / off-beat
  reattack pad / bass line / sparse downbeat punctuation. Union = continuous 16ths;
  NO layer plays it all; each layer varies at bar 5 (the dial turns).
- O7 SYNC_CHORDS: 6 bars. Brahms syncopated-chord field (chords off-beat only) over
  an on-beat bass LINE, tied variant in bars 5-6 blurring the barline.

CATEGORY D — DIALOGUE, INTERPLAY, TRANSITIONS (dialogue_doubling; orchestral_rhythm s3-s4; composition_method A.8)
- D1 GAP_FILL_PAIR: 8 bars. Melody with built-in long notes; ONE consistent answerer
  (different family+register) fills every gap, exits before the melody moves.
- D2 ANTIPHONAL_COMPRESSION: 8 bars. Two choirs trade 4-bar -> 2-bar -> 1-bar ->
  half-bar stretto -> tutti convergence (the antiphonal climax engine).
- D3 MAHLER_RELAY: 6 bars. One line handed across three colors mid-phrase, 1-2 note
  overlaps at each joint, handoffs at breath points.
- D4 HETEROPHONIC_PAIR: 6 bars. Same line plain (sustained color) + ornamented
  (florid solo color) simultaneously; structural tones synchronized.
- D5 TWO_V_THREE: 6 bars. Melody triplets over duple accompaniment, then swapped
  (the trademark cross-rhythm patch, dosed).
- D6 HEMIOLA_CADENCE: 4 bars. 3/4 regrouped 2+2+2 into the cadence, accompaniment
  re-voiced at the hemiola.
- D7 LIQUIDATION_TRANSITION: 6 bars. Theme fragment liquidated -> sequence ->
  harmonic acceleration -> caesura + pickup (the composed seam).
- D8 COMPOSED_DECAY: 6 bars. The ending law: fragments dissolving THROUGH the
  orchestra (relay downward, each entry shorter), not a held chord. (The anti-"pads
  die niente" card.)

CATEGORY F — FIGURATION BEYOND ARPEGGIOS (keyboard_figuration s6b; added after the user:
"are you aware of things other than arpeggios?" — batch 1 had defaulted 7/8 motion
layers to chord-spelling; the taxonomy now RATIONS broken-chord to <=1/3 of a
movement's figuration layers, and adjacent sections never reuse a type in a role)
- F1 REPEATED_PULSE: repeated-chord hammering, dynamics carry the phrase, pulse
  subdivides q->8th->triplet; bass is a line. (type 2)
- F2 COMPOUND_MELODY: one viola line implying three voices by voice-leading; no
  chord ever spelled. (type 3 — the true anti-arpeggio)
- F3 SCALAR_CURRENT: stepwise currents connecting chord tones; parallel-3rd cadence.
  (type 4)
- F4 NEIGHBOR_OSCILLATION: rocking 2nds + murky octaves + trill-as-texture; motion
  circles, never spells. (type 5)
- F5 DOUBLE_THIRDS: parallel 3rds widening to 6ths at the crest, stepwise. (type 6)
- F6 TOCCATA_ALTERNATION: one pitch traded between desks in 16ths, accents
  displaced per bar; off-grid bass stabs. (type 2/idiom)
- F7 CHORDAL_RHYTHMIC: dactyl-spondee cell on full chords, re-voiced every bar —
  the rhythm IS the figure. (type 7)
- F8 DISPLACED_CELL: non-chordal melodic cell, length/accent shifted each
  repetition, second desk offset half a cell. (type 8)
Audition: tc_figuration.musicxml/.mid.

CATEGORY P — PIANO TECHNIQUE UNIVERSE (keyboard_figuration s6c; user: "focus only on getting the
piano right for now... missing an entire universe of techniques")
- P1 STRUM_ROLLED: written-out strums (streams staggered 32nds so all notes ring),
  long-short-short-up strum rhythm; melody above.
- P2 SYNCOPATED_COMP: off-beat chords w/ ties + anticipations over an on-beat bass
  groove; melody rides the syncopation.
- P3 TRIPLET_CURRENT: triplet weave under duple melody; b4-5 hands SWAP meters
  (2-against-3 in one player).
- P4 DOTTED_PROCESSION: overture sharp-dots, DOUBLE-dots at the return, Scotch snap
  closes; bass octaves dotted but a line.
- P5 LILT_AND_SNAP: long-short lilt rocking; reverse-dot snaps at phrase ends; the
  lilt subdivides at b5.
- P6 PROCLAMATION_BREAK: 2 bars cantabile -> ABRUPT ff unison proclamation ->
  silence -> the lyric resumes pp una corda (the requested gesture).
- P7 CROSSHAND_SWEEP: one 4-octave gesture passed LH->RH; LH crosses OVER (m.s.
  sopra) to strike bells (LH span measured 42 semitones).
- P8 CASCADE_ALTERNATE: alternating-hand 16th waterfall down 4 octaves, turn, ascend.
- P9 TENOR_MELODY: the song in the LH tenor, bass by downbeat leaps, RH off-beat
  halo + sparkle answers.
- P10 THUMB_MELODY: melody in the MIDDLE deck; oscillation halo above; bass below.
- P11 TREMOLO_ORCHESTRAL: measured both-hand tremolo under octave melody, cresc.
- P12 MARTELLATO_OCTAVES: alternating-hand octave hammering, migrating accents.
- P13 CARILLON: one repeated bell pitch above a moving world.
- P14 HAZE_PLANING: parallel maj9 planing una corda; melody floats out of the blur.
- P15 JAZZ_COMP_WANDER: the comping hand cycles STATES — root / 3-5 dyad /
  connecting 3-4-5 run / full 1-3-5 stack (the user's exact shape) — syncopated,
  guide tones voice-led across changes; the melody WANDERS (off-grid entries,
  chromatic approaches, register drift).
- P16 WALKING_COMP: piano-trio-in-one — true walking bass w/ chromatic approaches /
  syncopated rootless comp (charleston placements vary) / sparse behind-the-beat
  melody.
- P17 RHYTHMIC_SENTENCE: every phrase traverses value classes (triplet -> dotted ->
  16th run -> arrival), the sentence passes BETWEEN hands; no uniform-value bars.
  Measured: 0% bar-rhythm repetition in all three voices, 5 value classes.
- P18 THREE_PART_CONVERSATION: interruption / borrowed-and-bent tail notes /
  harmonic anticipation / ROLE INVERSION (bass takes the question augmented while
  the treble comps) / hocket / suspension resolved across voices.
- P19 BROKEN_COMP: the comp speaks mixed rhythm — 8th chords, 16th double-strikes,
  rests INSIDE the gesture, dotted snaps, 16th pickups; bass lives in the RH rests.
Audition: tc_piano.musicxml/.mid (normalized to 3 piano staves).

CATEGORY ELEGY — grief & slow-fabric techniques (keyboard_figuration s6d/s6e; P17-19 = the
complexity bar, applied as JUDGMENT per keyboard_figuration s6e). Mode-neutral examples.
- EL1 GRIEF_SENTENCE (8b): the elegy fabric — bell tolls as events; speech mixes dotted
  leans, triplet rises, a 16th grief-run, mid-bar breaths; LH = bell/sweep/bass-line by
  turns; b8 simplicity NAMED (the breath). 0% bar-rhythm repetition.
- EL2 FLICKER_AND_CUT (6b): an interruption/cut fabric — a lead voice speaks in cells with
  rests; a second voice flickers in those rests (never held against it); a dissonance names
  itself in ONE strike-instant -> the texture CUTS -> silence -> the lead restarts alone in
  pure tonic. Dissonance = an event with a release, not a state. (A card may carry dramaturgic
  dissonance; the movement that deploys one must express AND resolve it.)
- EL3 CONCERTANTE_ELEGY (8b): the concertante fabric — string melody with real gaps; piano
  answers in SENTENCES (dotted reply -> triplet current -> bell at the peak -> 16th descent);
  viola agitates in cells; walking cello. 4.5 mean voices, 83% union.

CATEGORY X — CALL & RESPONSE ARCHITECTURES (keyboard_figuration s6g; user: "raga style... 8/8 then
4/4, 2/2, 1/1, half/half, followed by a strong unison line ending. or broken call
and response, or four instrument call and repeat" — dialogue as FORM; form-cards
may exceed 8 bars)
- X1 SAWAL_HALVING (17b): 4/4 -> 2/2 -> 1/1 -> half/half -> STRONG UNISON ending
  (head-cell driven into the final, all four in octaves). Call liquidates at every
  halving; the response inverts the tail and owns its cadence; NOTHING parrots.
  Measured: 0% bar-rhythm repetition in all four voices.
- X2 BROKEN_CALL (8b): response interrupts before the call ends; the restart is
  interrupted earlier; the third response PRE-EMPTS and the roles flip; they finish
  each other's final phrase. Walking bass underwrites the whole argument.
- X3 FOUR_CHAIN (10b): caller + three repeaters in turn, each repeat COLORED
  (ornamented / tail-inverted / augmented), overlapping a beat; final cycle =
  1-beat stagger micro-canon -> homorhythmic cadence.
Audition: tc_callresponse.musicxml/.mid.

CATEGORY FORMS — narrator & duet form techniques (general dialogue / frame / duet forms;
mode-neutral).
- FM1 DUET_CONVERSATION (8b): piano asks with a real rest; violin answers borrowing and
  bending the tail; viola interjects mid-answer; agreement in 6ths; the piano closes alone.
- FM2 ROMANCE_FABRIC (8b): a melody slot over planed 9ths; piano answers (one current, one
  toll at the crest); viola = the suspension color; walking cello. 3.6 mean voices.
- FM3 FRAME_BREATH (6b): a modal drone that breathes — harp 5th broken irregularly
  (machine-verified: NO bar repeats), register lifts at breaths, one b2 answer to the modal
  lean; cello dyad with inner motion per 2 bars.
- FM4 TELLER_AND_TALE (10b): a narrator form — narration vs ENACTMENT: the ensemble
  dramatizes the teller's gesture instead of answering it; the second enactment overlaps the
  narration (the tale getting ahead); the frame reasserts alone.
- FM5 LISTENERS_MURMUR (8b; fixed-response drama): the call transforms; the murmur is
  rhythmically IDENTICAL each time (machine: 100% rhythm-identity = the form) while its color
  darkens — and the fourth time it fails to come.
NOTE (E8 rev): keyboard_figuration s6g is now an OPEN FIELD, not a list — harvested palette
(trading/cutting, halving, broken, chain, leader/congregation, coro-pregon
inversion, qawwali heat-escalation, organum vertical dialogue, kotekan interlock,
concertino/ripieno, responsorial/antiphonal, second-line) + the standing
instruction that each movement INVENTS its own forms from its dramaturgy. X1-X3
are three entries in the field, not its definition.
DEFERRED to the II run: the orchestral idiom set (string divisi/trem/pizz textures,
wind breath-phrase fills, brass weight rhetoric, tutti assembly/release) — the
library grows one movement ahead, not four.

CATEGORY CS — CHAMBER STRINGS (4-voice string quartet; reference/written/surveys/string_techniques.md
"CHAMBER 4-VOICE FILTER"). USER-APPROVED + locked as production-DSL card
sources under `technique_library/dsl/cards/chamberstrings/` (the FIRST locked
cards). Each technique is re-cast in the idiom where it commonly LIVES — so the library teaches the
technique, not one movement's style — and re-fits to D-Phrygian for M4 (Storyteller) at threading.
Roles = Vn1/Vn2/Va/Vc; each card carries its own key/meter/tempo, so it auditions PER-CARD
(via the production DSL exporter, which honors each card's own ts/tempo -- not the old 4/4 union render).
- CS1 ROLE_ROTATION (8b, A minor andante): the melody passes Vn1->Va->Vc; the others stratified
  (sustained inner / off-beat pulse / walking bass). Quartet slow-movement idiom.
- CS2 PIZZ_UNDER_ARCO (8b, D major 6/8): one arco line over 3 pizz (oom-bass / pah-pah / counter-
  pluck sparkle). Serenade/romance idiom.
- CS3 CONVERSATIONAL (8b, E minor 3/4 vivace): a snappy cell (16th flicks + dotted-8th accent)
  tossed Vn1->Va->Vn2->Vc with witty silences, hocket, stretto. Quartet scherzo idiom.
- CS4 RECITATIVE (8b, D minor largo): one voice declaims (reciting tones, breaths, a leap outburst);
  trio punctuates with sparse chords in the gaps. Instrumental recitativo-accompagnato idiom.
- CS5 BARIOLAGE_MORPH (6b, C minor allegro): viola open-G bariolage 16th motor + syncopated cello
  riff engine + sul-pont->ord->tasto morph + biting motif. Film/contemporary tension idiom.
- CS6 CHORALE (8b, F major adagio): SATB hymn with MOVEMENT — walking-quarter bass + soprano w/
  passing 8ths over held inner harmony, cadences. Tonal hymn idiom (not the exotic Phrygian).
Auditions: tc_cs1_role_rotation.* ... tc_cs6_chorale.* (one file per card).

## PV — Piano Voicing (category `piano`; theory ref the piano-voicing survey) — HAND-COMPOSED
Built after the Movement IV C audition exposed bad piano voicing (low close 4-note clumps in block
half-notes with a low 4th in the bass). NOT engine-generated — a voicing-generator function stamps
the same shape and IS the bland-repetition failure; every chord here is hand-voiced. Each card
DEMONSTRATES one voicing mechanic IN LIVING RHYTHM (orchestral_rhythm/melody_primacy/MELODY_CRAFT: rhythm is theory — no
held-chord recitals/60BPM dirges; mixed values, syncopation, interlock, complementary rhythm):
- PV1 OPEN_VOICELEAD (8b, F, andante): open voicing & voice-leading — LH open arpeggio
  (root-10th-5th, no low clump), RH a singing top over moving inner voices, guide tones held.
- PV2 INVERSIONS (8b, C, andante): inversions as a voice-leading tool — a descending-bass diatonic
  progression (C–G/B–Am–C/G–Fmaj7–Em7–Dm7–G7–C); inversion choice makes the stepwise bass
  (C-B-A-G-F-E-D) under a singing top. Inversions made visible.
- PV3 VOICING_CATALOG (8b, C): the voicing-type catalog on ONE chord (Cmaj7/C7) — close / drop-2 /
  drop-3 / drop-2&4 / rootless A & B / quartal / upper-structure, each labeled side by side.
- PV4 LOCKED_HANDS (8b, C): Shearing block chords / Barry Harris 6th-diminished — a line harmonized
  with a close 4-note chord under each note (chord tones→C6, passing→B°7), melody 8ve-doubled. Voicing a line.
- PV5 DROP2_MOTION (8b, C): drop-2 in motion — the C6 drop-2 descending cycle (a chord run down its
  inversions, tops E5-C5-A4-G4, the dropped voice walking down in the LH) + a drop-2 ii-V-I.
- PV6 COMP_RHYTHM (8b, C): the same rootless ii-V-I voicings, but the point is RHYTHM — Charleston,
  anticipations, space; a different comp figure each bar, LH bass low / RH voicing mid (clean gap).
Audition: tc_pianovoicing.* (also within tc_piano.*).
(The answer-in-the-gap / complementary-rhythm technique is an ENSEMBLE device, not piano-only — it
lives in the dialogue category as **D9_REINFORCE_CONTRAST** (clarinet lead + piano comp; the complementary-rhythm survey),
audition tc_d9_reinforce_contrast.*. Cousin of D1 GAP_FILL_PAIR.)

## THE DEPLOYMENT LAW (keyboard_figuration s6d — cards vs pieces)
The one-technique-per-card format is EXPOSITION ONLY. In movements, textures mix at
PHRASE level: no card-texture runs more than ~4 consecutive bars unchanged; every
8-bar span shows >= 2 value-class regions and >= 1 mid-bar gesture break; phrases
are rhythmic SENTENCES, not value-blocks. G17 gains the sentence check at lock.
Future (need Dorico-side notation): glissando, sostenuto layers, silent-key
resonance, clusters.

## Library growth law
"...and beyond": any texture needed by a movement that has no locked card = compose
the card FIRST, audition, lock, then thread. The library grows ahead of the music,
never behind it.
