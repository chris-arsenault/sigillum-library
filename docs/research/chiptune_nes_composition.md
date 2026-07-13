# Chiptune / NES (2A03) Composition Research

Reusable research notes behind the `dsl:chip` technique-card shelf. Scope: writing
music for the NES 2A03 sound hardware (or renderers that imitate it) using the
Partitura production surface plus a 4-voice channel convention.

## The instrument

The Ricoh 2A03 exposes five channels; four matter for melodic writing:

| Channel  | Waveform            | Musical duty                                    |
| -------- | ------------------- | ----------------------------------------------- |
| Pulse 1  | Square, 4 duty steps| Lead melody                                     |
| Pulse 2  | Square, 4 duty steps| Harmony, counterline, echo, or arpeggio engine  |
| Triangle | Fixed-volume triangle| Bass; doubles as kick/tom drum                 |
| Noise    | Pseudo-random noise | Drum kit: kick/snare/hat by length and period   |
| DPCM     | 1-bit delta samples | Sampled drums/bass (out of scope for our cards) |

Hard limits that shape all writing: three pitched voices total, one noise voice,
no volume control on triangle, and every texture is monophonic per channel.

## Partitura channel convention (used by all `dsl:chip` cards)

Roster order maps one-to-one onto renderer voices, so the cards keep a fixed
roster shape:

1. `:pulse1` — `music21: "Clarinet"` (odd-harmonic spectrum, closest orchestral
   analogue to a 50% square), lead register C4–C6.
2. `:pulse2` — `music21: "Oboe"` (nasal, analogous to a narrow 12.5–25% duty),
   written below or around the lead.
3. `:triangle` — `music21: "Violoncello"`, sounding-pitch bass, register C2–C4.
4. `:noise` — `music21: "Percussion"`, `family: :percussion` (exports on MIDI
   channel 10). Drum vocabulary is written as GM pitches: kick `C2` (36), snare
   `D2` (38), closed hat `F#2` (42), open hat `A#2` (46).

## Core techniques (each has a card)

1. **Pulse echo** (`CT1_PULSE_ECHO_LEAD`) — Pulse 2 restates Pulse 1's line
   delayed by a beat (or half-beat) and one dynamic softer: faux delay/reverb on
   hardware with none. Signature of Tim Follin's NES work.
2. **Harmonic compression by arpeggio** (`CT2_ARP_COMPRESSION`) — one channel
   rapidly iterates the chord tones ("super-fast arpeggio"), stating full
   harmony with a single voice and freeing the other channels for melody and
   bass. The defining PSG idiom.
3. **Famichord voicing** (`CT3_FAMICHORD_VOICING`) — Linus Akesson's name for
   the maj7/m7 omit-5 three-note chord that fits the three pitched channels.
   Kondo's related insight: square waves are harmonically rich, so wide
   intervals read as bigger chords — "three channels sound like five."
4. **Triangle dual duty** (`CT4_TRIANGLE_BASS_DRUM`) — the triangle walks the
   bass and interleaves short low drops that read as kick/tom hits, so the
   bass line carries the drums (Follin, *Silver Surfer*).
5. **Noise drum kit** (`CT5_NOISE_DRUMKIT`) — one noise channel plays the whole
   kit: long low burst = kick, mid burst on backbeats = snare, short ticks =
   hats; fills every fourth bar articulate the loop.
6. **Two-pulse ensemble counterpoint** (`CT6_TWO_PULSE_COUNTERPOINT`) — Kondo's
   *Super Mario Bros.* three-part writing: lead + counterline in 6ths/10ths
   trading call-and-response over a walking triangle bass.
7. **Hurry-up transform** (`CT7_HURRYUP_TRANSFORM`) — NES games signal danger
   with a discrete faster/darker variant of the same song (SMB time warning,
   Tetris stack pressure), not continuous tempo automation: tempo up ~25%,
   mode flattened to minor, subdivision doubled, noise busier.
8. **Boss engine** (`CT8_BOSS_ENGINE`) — boss loops are short (~30 s) and
   hectic: invariant driving bass ostinato, an unchanging riff cell as the
   rhythmic subject, a roller-coaster lead with wide leaps, urgency in every
   bar (Mega Man 2 Wily-stage archetype).

## Loop craft for game states

- Keep loops seamless: end on the dominant or a fill that resolves into bar 1.
- Menu/interlude tunes sit sparser (2–3 voices, no noise or brushes only) so
  the assault themes gain impact by contrast.
- Danger music that shares material with the normal theme makes the state
  switch legible to the player — it is the same place, hotter.

## Sources

- Ludomusicology, "Compositional Strategies for Programmable Sound Generators
  with Limited Polyphony" —
  <https://www.ludomusicology.org/2015/07/16/compositional-strategies-for-programmable-sound-generators-with-limited-polyphony/>
  (ensemble method, harmonic compression, famichord, Follin channel sharing).
- Koji Kondo 2001 composer interview — <https://shmuplations.com/kojikondo/>
  (wide-interval voicing on square waves).
- Ozzed, "How to make 8-bit Music" — <https://ozzed.net/how-to-make-8-bit-music.shtml>
  (duty cycles, arpeggio effect, channel duties).
- DDRKirby(ISQ), "NES Chiptunes in Unlock Everything" —
  <https://ddrkirby.com/articles/nes-chiptunes-unlock-everything/nes-chiptunes-unlock-everything.html>
  (practical 2A03 arrangement limits).
- NESDev forum, "Examples of Game Logic Modulating Music?" —
  <https://forums.nesdev.org/viewtopic.php?t=24195> (discrete faster variants
  for hurry-up states).
