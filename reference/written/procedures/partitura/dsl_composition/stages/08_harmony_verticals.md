# Stage 8 - Harmony, Accidentals, And Verticals

Inspect verticals as music:

- Same-letter chromatic conflicts such as G/G#, E/Eb, B/Bb, and F/F# are suspects.
- Cross-relations can be intentional, but the surrounding harmony must make them sound intentional.
- A leading tone should point somewhere.
- A mixture tone should belong to local color or be isolated as an event.
- A dissonance should have placement, weight, and release.
- Chords should obey register and spacing logic from `chord_scoring.md`, adjusted for the forces.
- Held notes across harmony changes are suspensions or common tones; if neither, revoice or release.

Use:

```bash
partitura view SOURCE.rb exposed_clashes --bars START-END
partitura view SOURCE.rb verticals --bars START-END
partitura view SOURCE.rb implied_harmony --bars START-END
partitura view SOURCE.rb harmony_check --bars START-END
# secondary (declared intent): harmony_with_melody; raw data: transport
```

`implied_harmony` reports per-bar chord candidates from the sounding pitches. When the span
declares a per-bar chord track (`chords "b17:Am b18:E7"`), `harmony_check` performs the
declared-vs-sounding diff mechanically: read its match/review/MISMATCH lines as a worklist and
decide musically whether the notes or the declaration is wrong.

If the note is right but the support is wrong, move the harmony around it. If the support is right but
the note sounds like an artifact, respell or change the note.

