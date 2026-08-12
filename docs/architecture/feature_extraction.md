# Melody Feature Extraction

`Partitura::Production::MelodyAnalysis` derives per-note and segment-level observations
from the compiled production model. It supports composition reading and external analysis
without introducing another score representation or requiring hand-authored labels.

## Inputs And Selection

The analyzer reads production timed events for a requested part and bar range. If no part
is supplied, it chooses a melody line heuristically and says which part or parts were
selected in the rendered output. Pass `--part` when the intended line is known.

It uses the declared score key when available and also reports its estimated key. Harmony
windows are built from the surrounding texture with the selected melody removed so one
chromatic melody note does not redefine its own accompaniment.

## Per-Note Observations

Each analyzed melody note carries:

| Group | Fields |
|---|---|
| Tonal | scale degree, chromatic flag, octave |
| Harmony | Roman label, inversion, chord/non-chord role |
| Figuration | local figure type and sequence state |
| Motif | detected relationship to earlier cells |
| Metric | bar, beat strength, onset, and duration |

The segment summary reports contour, contour archetype, apex position, range, and style
statistics. Motif, figuration, chord-role, and automatic melody selection are heuristic;
their output is an attention aid, not ground truth.

## Readouts

```bash
partitura/bin/partitura view SOURCE.rb melody_analysis --part PART
partitura/bin/partitura view SOURCE.rb melody_report --part PART
```

- `melody_analysis` renders the per-note feature stream.
- `melody_report` groups the same evidence into neutral observations and explicit
  `judge:` questions. It does not return a pass/fail musical score.

Ruby callers may use:

```ruby
facts = Partitura.production_melody_analysis(piece, part: :flute, bars: 1..8)

analysis = Partitura::Production::MelodyAnalysis.for_piece(
  piece,
  part: :flute,
  bars: 1..8
)
analysis.render_analysis
analysis.render_report
```

The public convenience method returns the analysis as a hash. Construct the analyzer directly
only when a rendered report is required.

## Interpretation Boundary

Exact score facts such as authored onset, duration, part, and pitch remain distinguishable
from heuristics such as estimated key, figuration, motif relationship, and non-chord-tone
classification. Downstream systems must preserve that distinction.

The analyzer does not produce ground-truth labels, a quality judgment, or a new
canonical score. Consumers may derive their own interpretations from its versioned
output, but those interpretations remain outside Partitura.

## Implementation And Tests

- implementation: `partitura/lib/partitura/production/melody_analysis.rb` and
  `partitura/lib/partitura/production/melody_analysis/`;
- readout registration: `partitura/lib/partitura/production/readout.rb`;
- behavioral coverage: `partitura/test/test_production_surface_model_analysis.rb` and
  `partitura/test/test_production_harmony_track.rb`.
