# FUGUE CONSTRUCTION (survey, source-cited)

The technique: **a fugue is a contrapuntal procedure poured into a ternary key-shape — a subject
answered at the fifth by every voice in turn, developed by modulating episodes and middle entries,
and driven home by devices (stretto, inversion, augmentation, pedal) whose interest must be
cumulative.** The form is not a fixed mold: Prout opens his middle/final-section chapter by warning
that beyond the exposition "we are left to a very great extent free to do what we please," and the
only reliable skeleton is the three-section key plan. Everything else in this survey is the
craft that fills that freedom. Pitches scientific, middle C = C4.

Primary sources: Ebenezer Prout, *Fugue* (1891), chapters 3 (the answer), 7 (episodes), 8
(stretto), 9 (middle and final sections), read at Wikisource; teoria.com and the Puget Sound
*Music Theory for the 21st-Century Classroom* fugue-analysis chapter for the exposition frame;
Britannica and Wikipedia for double-fugue taxonomy; Gettysburg/Ithaca counterpoint resources for
invertible-counterpoint interval behavior; IMSLP/LA Phil/Journal of Mathematics and Music for the
BWV 577 gigue-fugue facts. Full list at the end.

This survey is BOTH the source the `dsl:fugue` cards are composed from AND a durable library
reference. The repo had no fugue form research before it; the cards cite it as
`fugue_construction:<section>`.

## 0. THE SKELETON — TERNARY KEY-FORM, NOT A TEMPLATE

Prout §291-293: every fugue, "however much variety there may be in the details, is in its main
outlines constructed in the same general form... Ternary or Three-part form."

- **First section** = exposition (+ counter-exposition if any) and anything after it that stays in
  tonic/dominant. Boundary rule, stated exactly: "The first section of a fugue extends as far as
  the end of the last entry of the subject or answer in the original keys of tonic and dominant."
- **Middle section** "begins with the commencement of the first episode which modulates to any
  other key than that of tonic or dominant." It holds the middle entries (isolated or in groups)
  connected by episodes.
- **Final section** "always begins with the last return of the original key." From Prout's Rule V:
  "it is imperative that all the voices be engaged, though it is not necessary that all should
  have subject or answer. If, however, the fugue contains stretti, it is best that all the voices
  take part in the final stretto, which should also be the closest." Then coda.

Proportions are free — Prout analyzes WTC fugues where the first section is two-thirds of the
piece and calls it "very unusual"; a "fair average" (WTC no. 21) runs first section ~17 bars,
middle ~24, final ~7. The middle section may hold one entry or five-plus groups. **The composer's
judgment of proportion is the rule; the section boundaries are the law.**

## 1. SUBJECT DESIGN

What the sources agree a working subject needs:

- **A head and a tail that survive fragmentation.** Episodes are built from "inversions of the
  head or tail of the subject" sequenced (Hansen, Prout ch. 7); analysis practice (Puget Sound)
  reads episodes as "motivic head and tail extractions." A subject whose head is rhythmically
  unmistakable and whose tail yields a sequence model is pre-paying for the whole middle section.
- **Clear implied harmony**, because the answer's correctness and every middle-entry support
  depend on it. Prout determines where subjects end by their implied dominant-seventh chords
  (ch. 3, Handel example).
- **Length is free but consequential.** BWV 577's subject is among Bach's longest (64 tones, per
  the Journal of Mathematics and Music subject-features study) and its "four clear sections, each
  musically distinct" is exactly what makes "a colourful fugue that dances along through a number
  of episodes" possible (Hyperion). Long subject = rich episode quarry + late answer entries;
  short subject = tight strettos and fast expositions. Choose per the piece's job.
- **If the fugue will use stretto, design the subject for it FIRST.** Prout §254, the most
  practical single rule in the book: "The best and easiest way of so designing it is, to write it
  in the first instance as a canon in the fourth or fifth at the shortest distance at which it is
  intended ultimately to be introduced," then complete the subject, then find the longer-distance
  strettos by experiment. Subjects that work in close stretto "can also be employed at longer
  distances." Retrofitting stretto onto an unplanned subject yields the weaker kind: "though it is
  quite possible to introduce later entries at a shorter distance than two bars, these will not be
  so effective, nor flow so naturally as if the subject had been written with this object in view."

## 2. THE ANSWER — REAL VS TONAL, THE ACTUAL RULES

Prout ch. 3, deduced "from the works of the great masters themselves," not from older textbooks:

- Subject in tonic → answer in dominant; subject in dominant → answer in tonic. "If the subject
  begin in the tonic and modulate to the dominant, the answer will begin in the dominant and
  modulate to the tonic, and vice versa."
- **Real answer** = exact transposition. Allowed for "every subject in which there is no
  modulation to the dominant, either expressed or implied," EXCEPT (a) when the subject begins on
  the tonic and leaps to the dominant (directly or via the third), or (b) when a prominent
  dominant note sits at or very near the head. In those cases the answer is normally **tonal**.
- **The tonal adjustment**: dominant harmony is answered by tonic harmony. A prominent early
  dominant note is transposed up a FOURTH to the tonic (not up a fifth to the supertonic), so the
  fugue's key is not undermined (teoria; Britannica). Prout's example: a third G→B in the subject
  answered by a second D→E. After the adjustment, the rest transposes normally.
- **Licenses**: "it is always allowed either to lengthen or shorten the first or last note of the
  answer." Semitone alterations near the end of an answer are "frequently to be met with." A
  suspension may delay the answer's last note.
- **Minor-key rule**: "if a minor subject modulates to the dominant, it is always to the dominant
  MINOR — never the major," and the same holds when the answer makes the first modulation.
- **Subdominant answers** exist as an extension of dominant-answered-by-tonic: when the subject
  itself gives prominence to dominant harmony (e.g. opens on a dominant-seventh arpeggio), the
  answer may come in the subdominant "to carry out the important principle that dominant harmony
  should be answered by tonic." More common in minor than major.
- **In a close fugue** (exposition already in stretto), keep one tonality: "we do not put the
  answer in the key of the dominant, but simply transpose the subject a fourth or fifth without
  leaving the key" (Prout §279 ff.), otherwise "we shall have the music in two keys at the same
  time."
- Entry timing: when the subject begins on an accented note, the answer usually enters ON the
  subject's last note; a **codetta** (link) may separate subject end from answer entry, and its
  material joins the episode quarry.

## 3. COUNTERSUBJECT AND INVERTIBLE COUNTERPOINT

- A countersubject is the answer's counterpoint IF it recurs with later subject statements;
  otherwise it is just free counterpoint (Puget Sound; teoria). The counterpoint accompanying the
  answer sits in the answer's key — "were it otherwise... the music would be in two keys at once"
  (Prout ch. 3).
- **The countersubject must be invertible against the subject** — it will appear above and below.
  Double counterpoint at the octave is the working default. Interval behavior under octave
  inversion (unison↔octave, 2nd↔7th, 3rd↔6th, 4th↔5th):
  - **The perfect fifth inverts to a perfect fourth**, so in invertible writing the fifth must be
    treated as a dissonance — prepared/resolved like a non-harmonic tone (Gettysburg; the
    fifths-are-fine-fourths-are-not asymmetry is the core trap).
  - **Avoid parallel fourths**: they invert to parallel fifths.
  - Thirds and sixths swap; both stay imperfect consonances — they are the safe currency.
- At the tenth: every imperfect consonance pairs with a perfect one — parallel thirds become
  octaves, parallel sixths become fifths, so NO parallel imperfect consonances at all. At the
  twelfth: the sixth becomes a seventh and must be treated as a dissonance. (Ithaca/Gettysburg.)
  Octave inversion is the default contract; tenth/twelfth are special effects with harsher rules.
- **Complementary rhythm is the countersubject's job**: move where the subject holds, hold where
  it moves (this repo's `complementary_rhythm.md` survey and the F10 running-counterpoint card
  state the same law from the texture side).
- If the fugue's plan is stretto-heavy, Prout repeatedly notes the alternative: **write no regular
  countersubject at all** ("As we intend to combine the theme with itself in stretto as much as we
  can, we will write no countersubject"), since the subject-against-itself combinations occupy the
  space a countersubject would.
- A countersubject "begun by one voice and completed by another" is a legitimate middle-section
  device (Prout ch. 8).

## 4. EXPOSITION ASSEMBLY

- Voices enter one at a time — subject, answer, subject, answer (4-voice) or subject, answer,
  subject (3-voice) — until all have stated the theme once; the exposition ends when the last
  entry ends (teoria; Puget Sound).
- The first voice continues against the answer (countersubject or free counterpoint); a codetta
  may bridge entries, "built from material in the subject and counter-subject."
- After the exposition, an **additional entry** (one voice restating the theme) or a full
  **counter-exposition** (voices swap subject/answer roles: "the voices which before had the
  subject now have the answer," Prout §207) may extend the first section — both stay in
  tonic/dominant.
- The whole exposition "oscillates between the keys of the tonic and dominant" (Prout §293); no
  other keys belong in it.
- Entry approach discipline (Prout ch. 9, from the D-major analysis): "nearly all the entries of
  the subject are preceded by a rest"; where a rest cannot be managed, "the next best thing is to
  approach the entry by a leap." A voice re-entering after a silence "should enter with the
  subject, or with some decided feature of the counterpoint... and not drop in, as it were,
  incidentally, and without anything particular to say."

## 5. EPISODES

Prout ch. 7, the concrete rules:

- **Material**: episodes are "formed, either wholly or in part, from material already met with,
  either in the subject, countersubject, or codetta." Fresh matter is allowed but "care must be
  taken that the new matter is in keeping with what has preceded."
- **The engine is sequence**: "Construct your episodes sequentially. Sequences not only furnish a
  very easy and simple means of modulation, but they combine variety of detail with unity of
  design in a degree which perhaps no other artistic device can attain." Irregular imitation
  spacing inside the sequence is fine.
- **Episodes do the modulating.** Moving key inside an episode is better than deforming subject
  entries to modulate — it prevents "more or less important changes in the form of the subject
  itself" (and Prout's model fugue plans decide the target key of each episode in advance).
- **Every episode must differ from its predecessors**: "A mere transposition of one episode into a
  different key will be invariably weak and bad if no modification be made." The approved cheap
  transformation: invert the counterpoint and swap the material between parts — variety plus
  unity. His WTC analyses show each successive episode presenting "the last part of the subject in
  fresh combinations."
- **Thin the texture**: three- or two-part writing in episodes of a four-part fugue furnishes
  "relief and contrast." (Both first and second episodes of his model four-voice fugue are for
  three voices only.)
- **Length**: typically 2-3 bars, occasionally 14-28; "the composer's feeling of proportion and
  balance must be his guide."

## 6. MIDDLE SECTION — KEY SCHEME AND ENTRY RULES

Prout ch. 9 distills Bach's practice into numbered rules (§324-327):

1. Keep within nearly-related keys; an unrelated-key entry is possible only "if such key be
   naturally introduced, and not... 'pulled in by the hair of its head.'"
2. Middle entries are **isolated** (one voice) or in **groups** (two or more in succession). In a
   group, entries should be at the fourth, fifth, or octave apart — except in close stretto.
3. **No two successive groups of entries should have the same order of voices.**
4. **No two groups should be in the same key, nor should the same voice have subject or answer
   twice in succession** (Bach breaks this occasionally; two-part fugues are exempt by necessity).
5. Not all voices need take part in a group of middle entries.
6. The number of groups is free — "from one or two to five or six, or even more."

The old theorists' default key itineraries (Prout quoting Cherubini-era practice, confirmed
against Bach with the caveat that Bach modulates further when he wants):

- **Major fugue**: dominant → relative minor (vi) → subdominant major → supertonic minor →
  mediant minor → back to dominant → tonic conclusion. A temporary tonic-minor inflection is
  allowed "only for a few moments," to set up a dominant suspension before re-attacking major.
- **Minor fugue**: relative major (III) → dominant minor → submediant major (VI) → subdominant
  minor → VII major → return to principal key.

Also: a middle entry in the tonic is possible; it belongs to the middle section if further
modulation follows, but "when an entry of the subject in the tonic is not followed by any entry in
another key (except possibly the dominant), this tonic entry indicates the beginning of the final
section." Fugues heavy in stretto show "a much greater prevalence of the original keys, and less
modulation." Full cadences "should in all cases be sparingly used" and every one "must always be a
point of departure for some new entry" — of the subject or at least an important counterpoint
figure. Plan the itinerary before composing: do not "start on our journey like Abraham, not
knowing whither we go, and trusting to luck to come out somewhere."

## 7. STRETTO

Prout ch. 8, the rules that matter:

- **Definition**: entries of subject/answer "follow one another at a shorter distance of time than
  in the first exposition."
- **The completion rule (§252)**: "one voice in a stretto may discontinue the subject as soon as
  another voice enters with it, but the last voice that enters should complete the subject."
  Earlier voices break off into free counterpoint; incomplete entries are normal, the LAST one is
  not.
- **Cumulative interest (§251)**: with several stretti, "the later stretti either in more parts or
  at a shorter distance of entry, or both, than the earlier ones." His model D-major analysis
  escalates: first stretto at half a bar early, then regular-interval strettos, then one at a
  crotchet's distance, then a stretto where all three voices complete the subject, and finally the
  stretto maestrale — each "an advance upon the preceding."
- **Free interval and theme choice**: stretto entries may be at any interval, and "we are allowed
  in a stretto of a tonal fugue to employ either subject or answer, as may be more convenient."
  Per arsin et thesin (entry displaced to the weak half of the bar) is standard equipment. Slight
  modifications of the subject "are always permissible in a close stretto."
- **Key discipline**: "the old masters rarely go beyond tonic and dominant keys in a very close
  stretto" (modulating strettos exist but are the loose kind).
- **Stretto maestrale**: every voice carries the subject COMPLETE — a canon at short distance for
  all voices. The crowning version; Prout's final-section model runs one maestrale led by the
  treble, then a second over a pedal with the voice order REVERSED, bass leading.
- **Finding strettos**: design the subject as a canon first (§254, see section 1), then find the
  workable longer distances "by experiment — trying to fit the answer against the subject, or the
  subject against itself, at all possible intervals and distances of entry." A good subject may
  yield "at least forty or fifty stretti."
- Stretto can compound with **augmentation/diminution**: subject imitated by its own augmentation
  at half a bar's distance; diminution strettos likewise (his Bach organ-fugue extracts).
- A **close fugue** opens already in stretto (answer entering "very often immediately after its
  commencement" of the subject); then the answer stays in the tonic key (see section 2).

## 8. FINAL SECTION, PEDAL, CODA

- Begins at the last return of the tonic; **all voices engaged**; if the fugue has strettos, the
  final stretto is the closest and uses all voices (Prout Rule V, §327). Many Bach fugues instead
  close with a single final entry plus coda — both are legitimate; stretto-rich fugues take the
  first path.
- **Pedal point belongs here**: "When a pedal point (either dominant or tonic) is met with in a
  fugue, it is almost always in the final section... the student, if he wishes to use a pedal
  point, had better reserve it for the final section." Dominant pedal first, tonic pedal after, is
  the common order; "it is very common also to find close stretti built above them," and the
  pedal is "sometimes in this case an additional voice."
- **Coda** = "a passage added at the end... to bring it to a satisfactory conclusion"; Prout's
  model coda ornaments a dominant pedal. **Adding voices near the final cadence is sanctioned
  practice**: sixteen of the forty-eight WTC fugues add parts, "mostly in approaching the final
  cadence."

## 9. DOUBLE FUGUE — TWO SUBJECTS

Two constructions (Britannica; Wikipedia; earsense):

1. **Simultaneous**: the second subject enters WITH the first from the exposition onward (Mozart
   Requiem Kyrie; the fugue of Bach's Passacaglia BWV 582). Result behaves like subject +
   obligatory countersubject.
2. **Separate expositions**: "more often, in a double fugue the composer gives the two subjects
   separate complete expositions, first one and then the other, and eventually brings the two
   subjects together" (Britannica; example WTC II no. 18). The second exposition normally brings a
   change of key/character; the combination is the formal event the whole design points at.

"The essence of the double fugue depends on the INDEPENDENCE of the subjects as well as their
successful COMBINATION in counterpoint" (Britannica). Practical consequences:

- The two subjects must contrast in rhythm/value-class strongly enough to be told apart when
  combined — which is the same requirement as subject-vs-countersubject complementary rhythm,
  raised to thematic rank.
- The combination must be composed in invertible counterpoint (section 3 rules) and **verified
  before the expositions are finalized** — the combination is engineering, not luck. Write the
  combined pairing first, the way section 1's stretto rule writes the canon first; then unspool
  each subject's own exposition from material proven to combine.
- Middle-section economy changes: with two expositions to place, episodes and middle-entry groups
  are fewer; the "development" budget is partly spent on the second exposition and the
  fragment-interplay before the combination.

## 10. THE GIGUE-FUGUE DIALECT

- The gigue is the Baroque suite's fugal dance: gigues "are invariably written in fugal style,"
  the intellectual climax of the suite (Music of the Baroque glossary; Vaia). Meter 3/8 or a
  compound derivative — 6/8, 6/4, 9/8, 12/8; the French gigue moderate in 6/4 or 6/8, the Italian
  giga faster, in 12/8 (Britannica; Wikipedia).
- **Binary-gigue counterpoint convention**: each strain opens imitatively; the SECOND strain
  conventionally opens with new thematic treatment — most famously the first subject INVERTED, in
  some gigues a new subject that is then combined with or set beneath a restatement of the first
  (Wikipedia/Vaia descriptions of the keyboard-suite gigue). The gigue thus normalized
  inversion-as-second-exposition and two-theme combination inside a dance — a double-fugue design
  in miniature, danced.
- **BWV 577 ("Gigue" Fugue, G major, 12/8)** is the free-standing model: one of Bach's longest
  subjects (64 tones), "wide intervals and four clear sections, each musically distinct," the
  greatest range of any Bach fugue subject, "designed for convenient performance on the pedal,"
  and a fugue that "dances along through a number of episodes" (IMSLP; Hyperion; the
  subject-features study). The lesson: in a dance fugue the subject can be LONG and sectional
  because the dance lilt carries the ear through it, and the episodes inherit dance energy rather
  than becoming dry sequence work.
- Compound-meter counterpoint mechanics: the lilt (quarter-eighth within the dotted beat) and the
  running-eighth stream are the two native value classes; hemiola (regrouping eighths in twos
  across dotted beats) is the standard episode/drive spice. Complementary rhythm in a gigue fugue
  = one voice in lilt against another in the running stream.

## 11. WHAT THE CARDS TAKE (dsl:fugue shelf)

- `FG1_EXPOSITION` — subject/tonal-answer/countersubject exposition assembly (sections 2, 3, 4).
- `FG2_EPISODE_SEQUENCE` — tail-fragment sequence episode, modulating, inverted-and-swapped on
  return (section 5).
- `FG3_STRETTO` — canon-designed subject at tightening distances, last voice complete (section 7).
- `FG4_DOUBLE_COMBINATION` — two contrasted subjects, separate statements, then combined and
  swapped in invertible counterpoint at the octave (sections 3, 9).
- `FG5_AUGMENTATION_PEDAL` — final-section behavior: dominant pedal, subject in augmentation
  under/over faster counterpoint, coda seal (section 8).
- `FG6_GIGUE_FUGUE` — the compound-meter dance-fugue dialect: lilt subject, running countersubject,
  hemiola episode (section 10).

## SOURCES

- Ebenezer Prout, *Fugue* (1891): [Chapter 3 (the answer)](https://en.wikisource.org/wiki/Fugue_(Prout)/Chapter_3),
  [Chapter 7 (episodes)](https://en.wikisource.org/wiki/Fugue_(Prout)/Chapter_7),
  [Chapter 8 (stretto)](https://en.wikisource.org/wiki/Fugue_(Prout)/Chapter_8),
  [Chapter 9 (middle and final sections)](https://en.wikisource.org/wiki/Fugue_(Prout)/Chapter_9)
- [teoria.com, "The Fugue"](https://www.teoria.com/en/tutorials/forms/contrapuntal/04-fugue.php)
- [Puget Sound, *Music Theory for the 21st-Century Classroom*, 30.8 Fugue Analysis](https://musictheory.pugetsound.edu/mt21c/FugueAnalysis.html)
- [Britannica, "Fugue: Elements of the fugue"](https://www.britannica.com/art/fugue/Elements-of-the-fugue) and
  ["Varieties of the fugue"](https://www.britannica.com/art/fugue/Varieties-of-the-fugue);
  [Britannica, "Double fugue"](https://www.britannica.com/art/double-fugue)
- [Wikipedia, "Fugue"](https://en.wikipedia.org/wiki/Fugue); [earsense, "double fugue"](https://www.earsense.org/Earsense/WTC/Vocabulary/doublefugue.html)
- [Gettysburg Counterpoint Resources, "Double Counterpoint at the Octave"](https://musictheory.sites.gettysburg.edu/uncategorized/double-counterpoint-at-the-octave/);
  [Ithaca College, "Double (Invertible) Counterpoint"](https://musictech.ithaca.edu/MusicTech/ICTheory/OnlineText/Form/Unit%20I/InvCpt/DblCpt.html)
- [Wikipedia, "Gigue"](https://en.wikipedia.org/wiki/Gigue); [Britannica, "Gigue"](https://www.britannica.com/art/gigue);
  [Music of the Baroque, "A Baroque Glossary"](https://www.baroque.org/baroque/terms);
  [Vaia, "Bach Gigue — Form & Analysis"](https://www.vaia.com/en-us/explanations/music/musical-forms/gigue/)
- [IMSLP, Fugue in G major, BWV 577](https://imslp.org/wiki/Fugue_in_G_major,_BWV_577_(Bach,_Johann_Sebastian));
  [Hyperion Records, Gigue Fugue in G major BWV 577](https://www.hyperion-records.co.uk/dw.asp?dc=W6161_GBAJY9721112);
  [LA Phil, "Fugue in G 'à la gigue', BWV 577"](https://www.laphil.com/musicdb/pieces/1851/fugue-in-g-a-la-gigue-bwv-577);
  [Journal of Mathematics and Music, "On features of fugue subjects"](https://www.tandfonline.com/doi/full/10.1080/17459737.2019.1610193)
