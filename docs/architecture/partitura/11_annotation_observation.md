# External Annotation Observation

`annotation-observation` binds supported external analytical annotations to an
immutable `score-observation` document. It is a general Partitura analysis
boundary: callers receive canonical score addresses and factual span features
without adopting the source corpus's parser or creating a second score model.

```bash
partitura/bin/partitura annotation-observation score-observation.json \
  --profile openscore_hauptstimme_v1 \
  --annotation hauptstimme_annotations=annotations.csv \
  --annotation part_relations=part_relations.csv
```

The Ruby API is:

```ruby
Partitura.annotation_observation(
  "score-observation.json",
  profile: "openscore_hauptstimme_v1",
  annotations: [
    { kind: "hauptstimme_annotations", path: "annotations.csv" },
    { kind: "part_relations", path: "part_relations.csv" }
  ]
)
```

## Contract

Schema version 1 records:

- the semantic projector revision used to invalidate stale projections;
- the exact parent `score_observation_digest`;
- exact SHA-256 identities for every annotation source;
- a named, versioned source profile;
- examples with source row provenance, preserved labels, rational score spans,
  canonical part/staff addresses, measure coverage, and boundary event IDs;
- fixed-name numeric features derived from Partitura-observed score facts;
- alignment audits, warnings, per-target counts, and a canonical annotation
  observation digest.

Profiles fail rather than silently dropping a well-formed, in-range semantic
row that cannot be bound. Source defects that cannot support an example—such
as concatenated headers, reversed spans, or repeat-expanded relation tails
outside an unexpanded score—are excluded with row-addressed warning codes.
Ambiguous combined parts may be resolved from span-local score activity, also
with an explicit warning. Failed alignment audits and warning counts remain in
the projection summary so consumers can gate the exact expected state.

Dataset splits, train/evaluation policy, learned transforms, weights, and
metrics remain consumer responsibilities.

## Profiles

`openscore_hauptstimme_v1` binds human Hauptstimme changes and derived
unison/parallel part relations. It emits:

- `prominent_part`;
- `structural_part_relation`;
- adjacent-segment `material_recurrence`;
- measure-grid `seam_boundary` examples.

`s3_v1` binds S3 form, cadence, harmony, orchestral-texture, downbeat, and
measure-count annotations. It emits:

- `form_section`;
- `cadence_type`;
- key-relative `harmonic_function`;
- `orchestral_role`;
- adjacent-phrase `material_recurrence`;
- measure-grid `seam_boundary` examples.

S3 note-event tables and OpenScore melody-score extracts remain reference
artifacts in the corpus manifest. They are not duplicated as learning targets:
the score observation already provides canonical note events.

S3 downbeat, measure-count, and time-signature tables are alignment evidence.
Pickup offsets are translated as one score-wide source-coordinate shift.
Downbeat and meter disagreements are audited; they do not silently move
individual labels to make the source appear clean.

## Interpretation boundary

The numeric features are factual summaries—density, register, pitch-class
distribution, active-part fraction, and left/right boundary deltas. They are
not learned representations and do not express musical quality.

Neither profile creates supervision for coherence, reserve, edit quality, or
candidate-to-original improvement. Those require explicit candidate evidence
and criterion-specific human judgments.
