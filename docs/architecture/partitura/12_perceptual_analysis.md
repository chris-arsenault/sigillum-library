# Perceptual score analysis

The six perceptual views estimate texture from sounding events, instrument
spectra, dynamics and decay. They identify passages to read in the ensemble;
they do not establish what a particular recording or performer will sound like.

Run each view with `partitura view SOURCE.rb VIEW`, optionally `--bars A-B`.
`masking_report` also accepts `--part ID`. Reports go to stdout; keep temporary
captures outside consumer export directories. Record the source revision and
passage judgments in the consumer's review document.

| View | What is calculated | How to use it |
|---|---|---|
| `spectrum_grid` | Summed modeled partial amplitudes in frequency bands at quarter-length/4 intervals | Locate persistent band crowding and changes in spectral occupancy. |
| `masking_report` | Best fundamental-band attack energy share per part/bar, with octave/unison reinforcement | Investigate shares below 28%, especially below 15%; inspect every relevant entrance and sustain before deciding a line is buried. A clear attack can hide weaker attacks in the same bar. |
| `roughness_profile` | Pairwise partial beating normalized by the active amplitude sum | Locate exposed collisions, then read their preparation, resolution and harmonic job. The 0-9 display clips large values. |
| `beat_salience` | Squared fundamental attack amplitudes, compared with each bar's active beat grouping | Distinguish pulse support from pickups, syncopation, recitative and deliberate scene cuts. All flagged bars are listed. |
| `binding_check` | Off-beat entries after a gap, compared with nearby held calls and concurrent attacks | Read the proposed relationship; register/time thresholds do not recognize every melodic relay or intentional solitary entry. |
| `ringing_grid` | Attack, sustain and modeled decay per part, including let-ring tails | Check whether resonance overlaps the next gesture and whether gaps actually clear. |

## Dynamics and timing contract

`PerceptualDynamics` owns a per-part level timeline independently of the older
`peak_axes` dynamic-point list. Scoped controls apply to named parts, families or
all parts. Local dynamics win at the same offset and persist through following
notes and rests. Marks on tie continuations also affect the timeline. Accents,
marcato and `sfz` affect the attack without becoming persistent dynamic levels;
`fp` uses an f attack and p as the following level.

Control and inline hairpins interpolate to explicit dynamic marks inside their
span. Without a target, a complete hairpin moves six model dB. The endpoint
persists until another mark; a later explicit mark resets it. Overlapping
hairpins use the most recently started active span, never a sum of all previous
hairpins. Sustained sounds follow the timeline while sounding. A plucked sound
keeps its attack level and decays; later dynamic marks do not restrike it.

`PerceptualTiming` integrates explicit tempo marks in quarter-note units, including
dotted beat units and changes during a ringing tail. This matches MIDI's explicit
tempo timeline. Text-only ritardando/accelerando and a-tempo instructions do not
invent a curve. Supply explicit tempo targets when the model needs those changes.
Beat grouping uses the active bar's meter and beat pattern, not the opening meter.

## Model limits

The fixed instrument spectra and dynamic-to-dB table are approximations, not
calibrated SPL. The model does not simulate room acoustics, a sample library,
vocal vowels, detailed bowing/pizzicato/tremolo spectra, harp roll/glissando
realization, pedal mechanics or sympathetic string interactions. Let-ring decay
has a modeled floor and cap; it is not a measurement of the instrument's release.
The binding model reads held notes, not every possible remembered melodic call.
The regular grid may miss shorter intervening events.

Use these views alongside exported notation and MIDI inspection. MIDI velocities
are not model dB, and MIDI does not realize all the score's expressive controls.
When an analysis is required, a runtime failure is a blocker to report and repair;
do not silently substitute a different check or declare the pass complete.
