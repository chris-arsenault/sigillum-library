# Musical Feature Extraction: architecture & decisions

The durable record for `Sigillum::OrchestralDSL::Production::MelodyAnalysis` -- the subsystem that turns a full multi-part score
into **per-melody-note musical features**, automatically and with no hand-labeling. It is the
front-end for the planned neural (infilling-transformer) theme model: the representation the model
trains on is built from these streams. The Markov generator (`generation/theme_gen/`) is unaffected.

## What it is

A production DSL piece -> timed events -> the melody-carrying part's top line annotated, note by
note, with five feature tiers. Every tier is a windowed, tunable, fully-automatic extractor.

| Tier | Per-note output | Reliability |
| ---- | --------------- | ----------- |
| **tonal** | scale degree (1–7) / chromatic flag / octave | exact |
| **harmony** | functional Roman numeral + inversion; chord position (R/3/5/7) or non-chord-tone type (passing / neighbor / suspension / appoggiatura / escape / anticipation) | good — validated vs music21 on chorales |
| **figuration** | scalar run / arpeggiation / trill / neighbor / leap / step / repeat / sustained; in-sequence flag | heuristic, decent |
| **motif** | transform vs the nearest earlier statement: exact / (real) transpose / inversion / tonal transpose / tonal inversion / retrograde / augmentation / diminution | heuristic; validated on known themes |
| **metric** | bar position, metric strength, duration | exact |

## Decisions

### FE1 — Extract from the full texture, not a bare melody
The corpus files are **full arrangements** (VGM 6–23 tracks, classical/Bach up to 16; we had been
deliberately reducing them to a monophonic skyline). The harmony is *in the data*. So we read the
real vertical sonority — chordify-by-window — instead of inferring a triad from one line. This is
what makes functional Roman numerals, inversions, and non-chord-tone typing genuinely available.

### FE2 — Windowed, tapered, tunable analysis (an STFT for music)
Harmony slides a window (its length **is** the harmonic-rhythm scale) with overlap and a Hann edge
taper, so a sonority straddling a chord change does not muddy a window it only partly overlaps.
Figuration and motif slide note-windows over the melody. Window / hop / taper / penalties /
cell-lengths / thresholds are all in one `Knobs` dataclass (swappable; defaults are the validated
values).

### FE3 — Harmony from the accompaniment (texture minus melody)
A chromatic *melody* note must not rewrite the *chord*. The harmony window is computed over the
texture with the melody line removed, then each melody note is read **against** that harmony. (This
fixed a real failure: a single passing `C#` in a tune was fabricating a borrowed `iv` chord.)

### FE4 — No local-key / modulation feature; segment instead
Corpus evidence: key movement is frequent but a windowed key estimate cannot cleanly separate
modulation from tonicization, so a per-note local-key label would be noisy. Symphony evidence: the
themes are single-key objects and key drama is supplied by **transposing** whole themes at
arrangement time. So we estimate **one global key per analysed segment**, and modulating training
material is cut into single-key spans **upstream** (the windowed-key estimator's reliable use —
coarse segmentation, not per-note labeling). Key changes stay an arrangement operation.

### FE5 — Per-note multi-stream bundle + extractor registry (extensibility)
A note is a point in a high-dimensional musical feature space; the representation is *which streams*
we carry. Each extractor is `annotate(ctx, knobs) -> list[value-per-note]`; the pipeline computes
shared products once (melody, global key, harmony windows, diatonic ordinals) and stores each
stream on the note under the extractor's name. **Adding a tier = a new module + one registry line.**

## Module map

```
partitura/lib/partitura/orchestral_dsl/production/melody_analysis.rb
  MelodyAnalysis     DSL-native feature model over production timed events
  melody_analysis    per-note readout replacing the old analyze_score script
  melody_report      scorecard readout replacing the old melody_report script
```

CLI:

```bash
partitura/bin/production_view SOURCE.rb melody_analysis --part PART
partitura/bin/production_view SOURCE.rb melody_report --part PART
```

Tests: `partitura/test/test_production_surface.rb`.

## Validation done

- **Key**: matches music21's own analysis on the chorale (f# minor).
- **Harmony**: per-note roles agree with music21's chordify/Roman-numeral on the chorale spine;
  the accompaniment fix removed melody-chromatic chord flips on real VGM.
- **Figuration**: stylistic profiles discriminate (chorale = stepwise; VGM lead = angular; Handel
  minuet = balanced + real trills); the rhythm gate separates trills from slow neighbor rocking.
- **Motif**: the M1 bar-5 head restatement is detected as `exact`; S's bar-2 head-down-a-step as
  `tonal-transpose`; a Paganini caprice reads as heavily sequential.

## Known limits (tractable, recorded)

Single global key (no modulation — by design, FE4); window-edge approximations; the NCT and
figuration classifiers are heuristic and will mislabel a fraction; motif cells are fixed lengths
{3,4,5}; the skyline melody extractor is simpler than the corpus voice-scoring one. None are fatal;
each is a knob or a later refinement.

## Downstream (open)

These streams are the inputs to the **representation decision** for the neural model (which streams
are predicted vs conditioned vs used only for segmentation, and how a kernel's pins/anchors express
in the token stream). That decision is deliberately deferred until the extractable surface — now
settled here — was known.
