production_piece "Technique Card CS6_CHORALE - CS6_CHORALE" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 60", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: CS6_CHORALE
# cite: strings
# behavior: SATB hymn with MOVEMENT: walking-quarter bass + soprano melody w/ passing 8ths over
#   held inner harmony; cadences. F-major adagio idiom (not D-Phryg)

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "CS6_CHORALE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "SATB hymn with MOVEMENT: walking-quarter bass + soprano melody w/ passing 8ths over held inner harmony; cadences. F-major adagio idiom (not D-Phryg)"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} C5 D5 F5 | F5 C5 G5 F5 E5 | F5 D5 D5 Bb4 | E5 D5 C5 | C5 A4 C5 E5 | D5 F5 D5 C5 Bb4 | C5 A4 G4 Bb4 | C5 Bb4 A4 F4"
        rhythm_bars "1 1 1 1 | 1 1 1/2 1/2 1 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 1 1 1/2 1/2 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5 C5 D5 C5 | C5 Bb4 G4 A4 | A4 Bb4 A4 Bb4 A4 | G4 G4 | C5 Bb4 A4 C5 | D5 C5 Bb4 Bb4 | C5 Bb4 A4 Bb4 | G4 A4 A4"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1/2 1/2 1 1 | 2 2 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4 A4 A4 G4 | A4 G4 E4 F4 | A4 G4 G4 F4 | E4 E4 | A4 G4 F4 E4 | F4 F4 G4 G4 | A4 G4 F4 G4 | E4 D4 C4"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 2 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F2"
        intervals "0 +4 +1 +4 | -9 +4 +3 +4 | -2 -5 -2 +7 | -2 -5 +5 | -7 +4 0 +3 | -2 +4 -7 +3 | -5 +4 +3 -2 | +2 0 -7 0"
        rhythm    "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
