surface_study "32-bar phrase-placement surface", family: :phrase_placement, bars: 1..32 do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"
  parts :clarinet, :solo_violin, :viola, :cello, :harp, :hand_drum

  section :a, "placed call", bars: 1..8
  section :b, "placed answer", bars: 9..16
  section :c, "placed pressure", bars: 17..24
  section :d, "placed afterimage", bars: 25..32

  phrase :call_8, length: "8 bars" do
    pitches "C5 Bb4 A4 F#4 F4 | G4 A4 Bb4 C5 r | D5 C5 Bb4 A4 F#4 | G4 F4 E4 F4 r | C5 D5 E5 F5 r | G5 F5 E5 D5 C5 | Bb4 A4 G4 F#4 F4 | E4 F4 r"
    rhythm "1.5 .25 .25 .5 1 | 1 .5 .5 1 .5 | 1.5 .5 .5 .5 .5 | 1 1 .5 .5 .5 | 1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | 1.5 1 .5"
  end

  phrase :answer_8, length: "8 bars" do
    pitches "A4 G4 F#4 E4 r | C5 Bb4 A4 r | D5 C5 Bb4 A4 r | G4 F#4 E4 F4 r | C5 E5 D5 C5 Bb4 | A4 Bb4 C5 D5 C5 | Bb4 A4 F#4 G4 r | F4 r"
    rhythm ".5 1 .5 .5 1 | 1 .5 1 1 | 1 .5 .5 .5 1 | .5 .5 1 1 .5 | .75 .25 1 .5 1 | .5 .5 .5 .5 1 .5 | .75 .25 .5 1 1 | 2 1.5"
  end

  phrase :pressure_8, length: "8 bars" do
    pitches "C5 D5 E5 F5 r | G5 F5 E5 D5 C5 | C5 Bb4 A4 G4 F#4 F4 | E4 F4 G4 r | A4 C5 D5 E5 r | F5 E5 C5 D5 r | C5 Bb4 G4 A4 r | F#4 F4 r"
    rhythm ".75 .25 1 .5 1 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | .5 .5 1 1 | 1 .5 .5 1 .5 | 1 .5 1 .5 .5 | 1 .5 1 .5 .5 | 1.5 1 1"
  end

  phrase :afterimage_8, length: "8 bars" do
    pitches "C5 r Bb4 A4 r | F#4 F4 r C5 r | Bb4 A4 F#4 r | F4 r | A4 G4 F#4 E4 r | C5 Bb4 A4 r | F#4 E4 F4 r | F4 r"
    rhythm "1 .5 .5 .5 1 | .5 .5 1 .5 1 | .5 .5 .5 2 | 1 2.5 | .5 1 .5 .5 1 | 1 .5 .5 1 | 1 .5 1 1 | 1 2.5"
  end

  phrase :bass_call_8, length: "8 bars" do
    pitches "F2 C3 F2 | Eb3 Bb2 C3 F2 | F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 | F2 C3 F2 | Db2 Ab2 F2 Db2 | C2 G2 C3 Bb2 G2 | F2 C3 E2 F2"
  end

  phrase :bass_pressure_8, length: "8 bars" do
    pitches "F2 C3 F2 E2 F2 C3 | F2 Bb2 C3 F2 | F2 C3 F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 | F2 C3 r F2 | E2 F2 C3 r | Bb2 A2 F2 r | E2 F2 r"
  end

  phrase :bass_afterimage_8, length: "8 bars" do
    pitches "F2 C3 r F2 | E2 F2 C3 r | Bb2 A2 F#2 r | F2 r | A2 G2 F#2 E2 r | C3 Bb2 A2 r | F#2 E2 F2 r | F2 r"
  end

  placement :call_8, part: :clarinet, at: "bar 1 beat 1" do
    role :foreground
    materialized "bars 1-8 exact call phrase"
  end

  placement :answer_8, part: :solo_violin, at: "bar 9 beat 1.5" do
    role :late_answer
    materialized "bars 9-16 exact answer phrase, delayed by half beat"
  end

  placement :pressure_8, part: :clarinet, at: "bar 17 beat 1" do
    role :foreground
    materialized "bars 17-24 exact pressure phrase"
  end

  placement :afterimage_8, part: :clarinet, at: "bar 25 beat 1" do
    role :fragment
    materialized "bars 25-32 exact broken phrase"
  end

  placement :bass_call_8, part: :cello, at: "bar 1 beat 1" do
    role :bass_line
    materialized "bars 1-8 exact bass phrase"
  end

  placement :bass_pressure_8, part: :cello, at: "bar 9 beat 1" do
    role :bass_line
    materialized "bars 9-16 exact bass pressure phrase"
  end

  placement :bass_pressure_8, part: :cello, at: "bar 17 beat 1" do
    role :bass_line
    materialized "bars 17-24 exact bass pressure phrase"
  end

  placement :bass_afterimage_8, part: :cello, at: "bar 25 beat 1" do
    role :bass_line
    materialized "bars 25-32 exact bass afterimage phrase"
  end
end
