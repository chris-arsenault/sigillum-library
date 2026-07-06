surface_study "32-bar split pitch/rhythm surface", family: :split_pitch_rhythm, bars: 1..32 do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"
  parts :clarinet, :solo_violin, :viola, :cello, :harp, :hand_drum

  section :a, "call contour", bars: 1..8
  section :b, "answer contour", bars: 9..16
  section :c, "pressure contour", bars: 17..24
  section :d, "afterimage contour", bars: 25..32

  phrase :foreground_32 do
    pitch_bars %q{
      C5 Bb4 A4 F#4 F4 | G4 A4 Bb4 C5 r | D5 C5 Bb4 A4 F#4 | G4 F4 E4 F4 r |
      C5 D5 E5 F5 r | G5 F5 E5 D5 C5 | Bb4 A4 G4 F#4 F4 | E4 F4 r |
      A4 G4 F#4 E4 r | C5 Bb4 A4 r | D5 C5 Bb4 A4 r | G4 F#4 E4 F4 r |
      C5 E5 D5 C5 Bb4 | A4 Bb4 C5 D5 C5 | Bb4 A4 F#4 G4 r | F4 r |
      C5 D5 E5 F5 r | G5 F5 E5 D5 C5 | C5 Bb4 A4 G4 F#4 F4 | E4 F4 G4 r |
      A4 C5 D5 E5 r | F5 E5 C5 D5 r | C5 Bb4 G4 A4 r | F#4 F4 r |
      C5 r Bb4 A4 r | F#4 F4 r C5 r | Bb4 A4 F#4 r | F4 r |
      A4 G4 F#4 E4 r | C5 Bb4 A4 r | F#4 E4 F4 r | F4 r
    }
    rhythm_bars %q{
      1.5 .25 .25 .5 1 | 1 .5 .5 1 .5 | 1.5 .5 .5 .5 .5 | 1 1 .5 .5 .5 |
      1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | 1.5 1 .5 |
      .5 1 .5 .5 1 | 1 .5 1 1 | 1 .5 .5 .5 1 | .5 .5 1 1 .5 |
      .75 .25 1 .5 1 | .5 .5 .5 .5 1 .5 | .75 .25 .5 1 1 | 2 1.5 |
      .75 .25 1 .5 1 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | .5 .5 1 1 |
      1 .5 .5 1 .5 | 1 .5 1 .5 .5 | 1 .5 1 .5 .5 | 1.5 1 1 |
      1 .5 .5 .5 1 | .5 .5 1 .5 1 | .5 .5 .5 2 | 1 2.5 |
      .5 1 .5 .5 1 | 1 .5 .5 1 | 1 .5 1 1 | 1 2.5
    }
    phrase_boundaries "1-8 sentence, 9-16 answer, 17-24 pressure, 25-32 afterimage"
  end

  phrase :cello_32 do
    pitch_bars %q{
      F2 C3 F2 | Eb3 Bb2 C3 F2 | F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 |
      F2 C3 F2 | Db2 Ab2 F2 Db2 | C2 G2 C3 Bb2 G2 | F2 C3 E2 F2 |
      F2 C3 F2 E2 F2 C3 | F2 Bb2 C3 F2 | F2 C3 F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 |
      F2 C3 r F2 | E2 F2 C3 r | Bb2 A2 F2 r | E2 F2 r |
      F2 C3 F2 E2 F2 C3 | F2 Bb2 C3 F2 | F2 C3 F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 |
      F2 C3 F2 | D3 C3 Bb2 A2 | Bb2 A2 G2 F#2 | E2 F2 r |
      F2 C3 r F2 | E2 F2 C3 r | Bb2 A2 F#2 r | F2 r |
      A2 G2 F#2 E2 r | C3 Bb2 A2 r | F#2 E2 F2 r | F2 r
    }
    rhythm_bars %q{
      1.5 1 1 | 1 .5 .5 1 .5 | 1 .5 .5 1 .5 | 1 1 .5 .5 |
      2 .5 1 | 1 1 .5 1 | 1 .5 .5 1 .5 | .5 .5 1 1 |
      1 .5 .5 .5 .5 .5 | 1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 1 |
      1.5 .5 .5 1 | .5 .5 .5 2 | .5 .5 .5 2 | .5 .5 2.5 |
      1 .5 .5 .5 .5 .5 | 1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 1 |
      1 .5 2 | 1 .5 .5 1.5 | .5 .5 .5 2 | 1 1 1.5 |
      1 .5 2 | .5 .5 1 1 | .5 .5 .5 2 | .5 .5 2.5 |
      .5 1 .5 .5 1 | 1 .5 .5 1 | 1 .5 1 1 | 1 2.5
    }
  end

  line :clarinet, role: :foreground, bars: 1..8 do
    phrase :foreground_32
    uses "pitch_bars and rhythm_bars bars 1-8"
  end

  line :solo_violin, role: :answer, bars: 9..16 do
    phrase :foreground_32
    uses "pitch_bars and rhythm_bars bars 9-16"
    entry_offset ".5"
  end

  line :clarinet, role: :foreground, bars: 17..24 do
    phrase :foreground_32
    uses "pitch_bars and rhythm_bars bars 17-24"
  end

  line :clarinet, role: :fragment, bars: 25..32 do
    phrase :foreground_32
    uses "pitch_bars and rhythm_bars bars 25-32"
  end

  line :cello, role: :bass_line, bars: 1..32 do
    phrase :cello_32
  end
end
