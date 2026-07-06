production_piece "Technique Card OD7_MELODY_RELIEF - OD7_MELODY_RELIEF" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD7_MELODY_RELIEF
# cite: orchestration_techniques:doublings
# behavior: one sweeping D-major tune stated in THREE octaves (top Fl+Vn1, mid Ob+Vn2 strongest,
#   low Vc+Bsn); inner harmony Va+Cl repeated-8th chord tones voiced in the gap band A4-D5
#   between the octaves, Hn pad below, Cb floor, Tpt+Timp surge at b5-6 - the melody stands in
#   relief against its own background

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD7_MELODY_RELIEF", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one sweeping D-major tune stated in THREE octaves (top Fl+Vn1, mid Ob+Vn2 strongest, low Vc+Bsn); inner harmony Va+Cl repeated-8th chord tones voiced in the gap band A4-D5 between the octaves, Hn pad below, Cb floor, Tpt+Timp surge at b5-6 - the melody stands in relief against its own background"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{f} F#6 A6 | A6 B6 A6 F#6 | B6 A6 F#6 E6 | G6 F#6 E6 | E6 F#6 G6 A6 | A6{txt:cresc} D7{ff}"
        rhythm_bars "1 1 2 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{f} F#5 A5 | A5 B5 A5 F#5 | B5 A5 F#5 E5 | G5 F#5 E5 | E5 F#5 G5 A5 | A5{txt:cresc} D6{ff}"
        rhythm_bars "1 1 2 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp} D5 D5 D5 D5 D5 D5 D5 | C#5 C#5 C#5 C#5 C#5 C#5 C#5 C#5 | D5 D5 D5 D5 D5 D5 D5 D5 | D5 D5 D5 D5 D5 D5 D5 D5 | B4 B4 B4 B4 B4 B4 B4 B4 | C#5{txt:cresc} C#5 C#5 C#5 D5 D5 D5 D5"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{f} F#4 A4 | A4 B4 A4 F#4 | B4 A4 F#4 E4 | G4 F#4 E4 | E4 F#4 G4 A4 | A4{txt:cresc} D5{ff}"
        rhythm_bars "1 1 2 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#3{mp} E3 | E3 C#3 | D3 B2 | D3 G2 | B2 E3 | C#3{txt:cresc} F#3"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | E5{mf} F#5 G5 A5 | A5{txt:cresc} D6{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 2 2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} r | A1 r | r | r | r | A1{txt:cresc} D2{ff}"
        rhythm_bars "2 2 | 2 2 | 4 | 4 | 4 | 2 2"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{f} F#6 A6 | A6 B6 A6 F#6 | B6 A6 F#6 E6 | G6 F#6 E6 | E6 F#6 G6 A6 | A6{txt:cresc} D7{ff}"
        rhythm_bars "1 1 2 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{f} F#5 A5 | A5 B5 A5 F#5 | B5 A5 F#5 E5 | G5 F#5 E5 | E5 F#5 G5 A5 | A5{txt:cresc} D6{ff}"
        rhythm_bars "1 1 2 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} A4 A4 A4 A4 A4 A4 A4 | A4 A4 A4 A4 A4 A4 A4 A4 | B4 B4 B4 B4 B4 B4 B4 B4 | B4 B4 B4 B4 B4 B4 B4 B4 | G4 G4 G4 G4 G4 G4 G4 G4 | A4{txt:cresc} A4 A4 A4 A4 A4 A4 A4"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D4"
        intervals "0{f} +4 +3 | 0 +2 -2 -3 | +5 -2 -3 -2 | +3 -1 -2 | 0 +2 +1 +2 | 0{txt:cresc} +5{ff}"
        rhythm    "1 1 2 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} A2 | A2 E2 | B2 F#2 | G2 D2 | E2 A2 | A2{txt:cresc} D2{ff}"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
