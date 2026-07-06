# Texture Craft — the explicit pass stack (research round 2)

Sources: four research reports (ornamentation; orchestral rhythm; chord scoring; dialogue +
doubling), distilled to operational passes. ORDER MATTERS. Passes run AFTER the structural
layer (composition_method sec A steps 1-5: cast, line, counterline, bass, inner motion) and BEFORE gates.
Each pass is applied to a whole movement in one sitting, with its own checklist.

## P1 — ORNAMENTATION PASS (the lead lines become spoken)

Recipes (deterministic edits to an existing melody note N):
- Accented appoggiatura: upper/lower neighbor ON the beat, steals half of N (2/3 if dotted),
  slurred pair, stress on the dissonance. WRITE OUT in real durations. The Mahler device.
- Acciaccatura: slashed grace one step below (or chord-tone leap), pre-beat, slurred. Snap.
- Mordent (written out): N -> 2x32nds (N, neighbor) + remainder. Lower mordent on the b2 in
  Hijaz contexts = the maqam bite at long-note onsets.
- Turn between notes: shave last beat-fraction of N, insert upper-N-lower as triplet/32nds
  gliding to the next note. The Tchaikovsky/Mozart phrase-end curtsy.
- Trill: tr + termination (two 32nds lower-main) into the next note. Cadential trill on
  scale-degree 2 over V. Trill CHAINS / stacked-3rd trills at structural dominants only.
- Slide (Schleifer): 2-3 graces stepwise into N. Portamento: solo strings, max 1-2 per mvt.
- Nachschlag: shave a 16th off a long N's tail, step away, slur to next. The release figure.

Placement (per phrase): peak -> appoggiatura (or trill if held); long-note onsets -> mordent/
acciaccatura/slide; long-note exits -> Nachschlag/turn; cadence -> trill w/ termination;
repeated notes -> grace on 2nd/3rd occurrence; SECOND statements of themes -> ornamented
reprise (never ornament a leitmotif's first statement: ornament = return + intensification).

Density caps: solo lines <=1/bar at climax, 1 per 2-4 bars else (10-15% of onsets);
tutti ~3%, unison snaps/section trills only; never 2 ornament types adjacent; >=1 beat plain
after any ornament. Idiom: fl/cl/solo-vln everything; ob expressive only; brass snaps+rips;
harp NO trills (bisbigliando); timp flams; tutti strings section trills + graces only.

## P2 — ORCHESTRAL RHYTHM PASS (accompaniments get rhythmic identity)

Figure catalogue (8th grid; B=bass, C=chord, .=rest):
- Repeated-chord pulse: even 8ths (anxious) / quarters (processional) / Beethoven-7 dactyl-
  spondee cell. Intensity dial = halves->quarters->8ths->triplets->16ths across a build.
- After-beat family: waltz `B.C.C.`, march `B C B C` (bass on beats, horn chords on &s),
  polonaise 8th+two-16ths cell. Bass and chord NEVER coincide.
- Brahms syncope: chords only on off-8ths `.X.X.X.X` over on-beat bass; tied variant blurs
  the barline.
- String figuration: broken octaves (murky), measured tremolo, rocking 3rds (nocturne),
  swept arpeggio 16ths, 6/8 rocking `Bxx Bxx`.
- Pads: sustain (neutral, keep in weak registers) vs off-beat re-attack pads (energy).
  Switching sustain->offbeat reattack = cheapest excitement upgrade.
- Pizz walking quarters; harp = structural downbeats/rolled chords/sweeps, never dense offbeats.

THE COMPLEMENTARY-RHYTHM LAW (operational): per bar — melody active (>=8ths) => accompaniment
sustains/thins; melody holds/rests => accompaniment moves (figuration, fill, sweep). Union of
all layers approximates a continuous 8th/16th surface; NO single layer plays it all; two
layers may not share both register and value-class. Max 3 independent rhythmic strata +
punctuation; each simultaneous layer gets a DISTINCT value-class.

Homorhythm budget: all-parts-one-rhythm reserved for <10-15% of a movement (hits, climax,
final cadence); approach by synchronizing layers over 2-4 bars (convergence = crescendo),
exit by re-fragmenting. Cross-rhythm dosage: hemiola at cadences; one sustained 2-vs-3 or
displacement patch (8-16 bars) per movement; accent displacement in scherzo/development.

Section profiles: march(B.B. + afterbeat horns + snare cell) / waltz / nocturne(rocking 16ths,
pure grid) / chorale(homorhythm + suspensions ONLY) / scherzo(staccato beat-1 bass, offbeat
stabs, air) / lament(slow ostinato + pp chord pulse) / battle(8th cell bass + measured trem +
brass offbeat reattacks) / festive coda(converge to homorhythm).

## P3 — CHORD VOICING PASS (audit every vertical)

- Low interval limits (bottom note of interval): 2nds >= E3; m3 >= C3; M3 >= Bb2; P4 >= Bb2;
  tritone >= Bb2; P5 >= Bb1; 6ths >= B1/C2; octaves free. Count the IMPLIED root.
  Below C2: octaves (and careful 5ths) only.
- Pyramid: wide low, narrow high (overtone spacing). 8-voice tutti skeleton: R-R-5-R-3-5-R-3
  ascending (3rds only above C4).
- Doubling: root > 5th > 3rd. NEVER leading tone / 7th / altered tone. Mixture chords: double
  root/5th, not the inflected 3rd. ff: multiply root+5th, 3rd <= 2x, near top. pp: one per pitch.
- Family methods: layering (color separation) / interlocking (default tutti blend) /
  enclosure (tame a middle color) / overlap (weld seams: share a pitch at the joint).
  Brass: tpts close on top, tbns close below, HORNS FILL (count horns x2 vs heavy brass).
  WW in pairs; flutes weak below C5; strings sustained=divisi, accented=multi-stop,
  exploit open strings (D major rings).
- Color templates: add9 above C4 next to the 3rd; quartal stacks from C3 up w/ octave frame;
  clusters climax-only, framed by clean octaves; bell chords = attack (hp/pno) fused to
  string sustain, allowed to decay; pp luminous = no 16' bass, one-per-pitch, fl low/cl mid,
  or 6-8 part muted divisi + harp harmonics; brightness = who owns the top + octave doubling
  of the top line (dark: cap below G4, viola/horn top, single buried 3rd).
- Harmonic rhythm: re-attack + re-voice everything at chord changes; held notes across a
  change are DELIBERATE suspensions in an individually audible color, resolved by step in
  the same instrument.

## P4 — DIALOGUE PASS (call and response everywhere stasis occurs)

- Fill rules: every melody note >= 2 beats and every phrase gap >= 1 beat is a fill
  candidate; target >=50% answered. Fill enters only against stasis, exits before the melody
  re-activates. Answerer = different family AND register, lighter weight; 2-3 consistent
  dialogue characters per section (cast them; don't rotate randomly).
- Antiphony: choirs (str/ww/brass) trade harmonically self-sufficient phrases; dovetail seams
  (responder enters on caller's final note); escalate by compression 4->2->1 bars -> tutti
  convergence at the climax. Fanfare convention: call = unison/octaves rhythmic; response =
  harmonized sustained weight.
- Echo axes (pick ONE per echo): dynamic (f->p), register (8va), timbral (new instrument,
  muted brass/harmonics are echo-colors), diminution/truncation (tail only, half values).
  Literal section repeats convert to echoes.
- Mahler relay: lines > 8 bars in one color get handed off mid-phrase; incoming instrument
  overlaps 1-2 notes (cross-fade), hand off at breath points into the new color's sweet spot;
  max two timbres on the line at any instant.
- Heterophony: plain sustained version (strings/horn) + florid ornamented version (solo wind)
  of the SAME line, structural tones synchronized — dialogue and doubling at once; the maqam/
  Debussy device, first-class for M3.

## P5 — STRATEGIC DOUBLING PASS (color as vocabulary, not mass)

- Mixture recipes (use <= 3-4 per movement, consistently, as IDENTITIES):
  fl+ob (round lyric), fl 8va vln (silver A-theme glow), cl+vla (dark velvet), ob+vln (reedy
  pastoral), hn+vc (noble heroic), bsn+vc (tenor cantabile), tpt+ob (ceremonial edge),
  picc+glock 15ma (crystal crown, ff only), cel+hp+fl stacc (music-box sparkle),
  hp+pizz (plucked halo).
- Octave tiers by dynamic: p=1 octave, f=2, ff tutti=3 (no empty-octave sandwiches).
- HIGHLIGHTING: the 8va doubling enters ONLY at the phrase peak (2-4 notes), then leaves.
- Halos: rhythmic shadow (sustains double only structural tones of a moving line);
  attack halo (harp/pizz doubles attack points of legato melody); sparkle halo (glock/cel
  on main beats 8va+).
- When NOT: never double designated solo-color moments (and strip mixtures the bar before a
  solo so the pure color lands); no doubling of fast inner counterpoint; grey-sound scan —
  any 8-bar span where everything is doubled, un-double the least important layer.

## P6 — VARIATION-OF-RETURN PASS
Every restatement differs: ornamented reprise (P1 recipes), re-register, new countermelody,
re-harmonization (H7), echo conversion (P4), or relay re-coloring (P4/P5). Statement
identity = G3/G6 gates.

## P7 — GATE CHECK (verify.py) then present.

## Planned gate extensions
- G8 ornament density on solo lines within caps; G9 complementary-rhythm coverage (union-of-
  attacks continuity + per-layer share); G10 fill-answer rate on long notes (>=50%);
  G11 vertical audit sampling (low-interval-limit violations = 0).

## SUPERSEDED FOR EXECUTION
The applicable runbook is reference/written/procedures/unified_procedure.md; this document remains the recipe annex.

## NOTE
This condensed version lost research fidelity. The binding references are the
VERBATIM annexes ornamentation (ornamentation), orchestral_rhythm (orchestral rhythm), chord_scoring (chord scoring),
dialogue_doubling (dialogue & doubling). reference/written/procedures/unified_procedure.md binds to those, not to this file.
