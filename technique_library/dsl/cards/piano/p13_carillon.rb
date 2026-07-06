production_piece "Technique Card P13_CARILLON - P13_CARILLON" do
  meter "4/4"
  key "C"

# category: piano
# card: P13_CARILLON
# cite: keyboard_figuration s6c
# behavior: ONE repeated bell pitch above everything (subdivision varies, pitch never moves);
#   melody in the middle; slow bass line

  roster do
    part :bell, "Bell", music21: "Piano", family: :keyboard, description: "Piano"
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :bass, "Bass", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P13_CARILLON", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "ONE repeated bell pitch above everything (subdivision varies, pitch never moves); melody in the middle; slow bass line"

      phrase :bell_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{p,txt:l.v._sempre} D6 D6 | D6 D6 D6 D6 D6 D6 D6 | D6 D6 D6 D6 D6 D6 D6 D6 | D6 D6 D6 D6 D6 | D6 D6 D6 D6 D6 | D6 D6"
        rhythm_bars "1 1 2 | 1/2 1/2 1/4 1/4 1/2 1 1 | 1/4 1/4 1/4 1/4 1 1/2 1/2 1 | 3/4 1/4 1/2 1/2 2 | 1 1 1/2 1/2 1 | 2 2"
      end

      placement :bell_line, part: :bell, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4 A4 G4 | E4 F#4 G4 | A4 C5 B4 | A4 G4 F#4 E4 | D4 G4 B4 A4 | G4"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 2 1 1 | 1 1 3/2 1/2 | 1 1 1 1 | 4"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G2 F#2 | E2 Eb2 | D2 C2 | D2 D3 C3 A2 | B1 C2 D2 | G1 G2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 1 1 1 1 | 2 1 1 | 2 2"
      end

      placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
