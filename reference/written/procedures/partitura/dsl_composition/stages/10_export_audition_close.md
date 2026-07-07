# Stage 10 - Export, Audition, And Close The New Source

Run:

```bash
ruby -c SOURCE.rb
partitura/bin/production_view SOURCE.rb compile
partitura/bin/production_view SOURCE.rb peak_axes
partitura/bin/production_view SOURCE.rb rhythm_profile
partitura/bin/production_view SOURCE.rb articulation_map
partitura/bin/production_view SOURCE.rb breath_map
partitura/bin/production_view SOURCE.rb exposed_clashes
partitura/bin/production_view SOURCE.rb controls
# secondary (declared intent): structure, roles, material_map
partitura/bin/production_export SOURCE.rb OUT_DIR --stem STEM
for test_file in partitura/test/test_*.rb; do ruby "$test_file" || exit $?; done
git diff --check
```

After export, audition the result by score, MIDI, audio, or the best available rendering for the
project. Listen/read for weak spans, inert accompaniment, bad pacing, unreadable verticals,
unidiomatic writing, unclear returns, accidental artifacts, and over-mechanical interleaving. If any
appear, return to the relevant stage and revise the source.

The first successful export never closes the procedure by itself. Complete at least one post-export
revision cycle:

1. Inspect the exported score/playback and focused projections as music, not only as data.
2. Record concrete findings by bar, part, and musical problem.
3. Revise the DSL source itself.
4. Re-run compile, focused projections, export, and any affected tests.
5. Repeat while the audit still finds material weaknesses.

If the post-export audit finds no change needed, document why in musical terms, tied to specific
sections and roles. Do not use "no obvious compiler issue" or "mechanically valid" as a musical
verdict.

Clean up only what belongs to this new composition: scratch transport JSON, temporary analysis files,
draft render artifacts, and outdated local status notes. Keep research and brief material that helps
future work continue.


## Exit Criteria

The new composition pass is complete only when:

- The source is a readable `production_piece`.
- The fresh attention passes were run separately and recorded, even if by the same agent.
- The form contract is audible in the score.
- The form contract includes phrase-grain events and material input/output commitments appropriate to
  the piece's scale.
- The form contract names a journey curve with section state-change jobs, not only a destination label.
- Research commitments changed actual musical decisions.
- Primary materials or engines are explicit and return audibly.
- Primary materials and accompaniment rhythms use duration, rests, and beat placement as musical
  functions, not bar-filling.
- Bass, accompaniment, counterlines, and pads have positive musical jobs.
- Span pass notes account for realized events, produced outputs, divergences, and revisions.
- The closeout includes a musical review of bar/beat failure modes in substantial spans.
- Technique-library influence has been adapted into the piece's own notes.
- Flow is interleaved below the section level where the form needs it.
- The closeout explicitly addresses whether any unchanged texture block escapes by abrupt transition,
  and any retained block behavior is defended as a musical event.
- Rests, tacets, holes, or silence are either used as musical events or consciously withheld for a
  stated reason.
- Accidentals and verticals are accountable.
- The merge pass checked seams, journey, plan adherence, carry-forward, divergences, and unused
  commitments.
- The capstone local-causality pass was run after merge fixes.
- The idiom and performability audit for every force has either passed or caused source revisions.
- The verdict loops and whole-piece revision pass musical judgment, not only compiler checks.
- Exported score/playback has been auditioned after the first successful export.
- At least one post-export musical audit and revision/no-change cycle has been completed and recorded.
- Any discovered weaknesses were revised in source and re-exported.
- The DSL source compiles and exports.

Do not describe the result as a draft in the closeout. If it is still a draft, the procedure is not
finished.
