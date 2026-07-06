production_piece "Technique Card D2_ANTIPHONAL_COMPRESSION - D2_ANTIPHONAL_COMPRESSION" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D2_ANTIPHONAL_COMPRESSION
# cite: dialogue_doubling s1
# behavior: two self-sufficient choirs trade 2-bar -> 1-bar -> half-bar stretto -> tutti
#   convergence; dovetailed seams

  roster do
    part :winds, "Winds", music21: "Flute", family: :woodwind, description: "Flute"
    part :brass, "Brass", music21: "Horn", family: :brass, description: "Horn"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "D2_ANTIPHONAL_COMPRESSION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "two self-sufficient choirs trade 2-bar -> 1-bar -> half-bar stretto -> tutti convergence; dovetailed seams"

      phrase :winds_line, surface: :split_pitch_rhythm do
        pitch_bars  "[E5,G5,C6]{f} [F5,A5,C6] [E5,G5,C6] | [D5,F5,B5] [E5,G5,C6] r | r | r | [E5,G5,C6] [F5,A5,D6] r | r | [G5,B5,D6] r [G5,B5,D6] r [A5,C6,F6] [G5,C6,E6] | [G5,C6,E6]"
        rhythm_bars "1 1 2 | 1 2 1 | 4 | 4 | 1 1 2 | 4 | 1/2 1/2 1/2 1/2 1 1 | 4"
      end

      placement :winds_line, part: :winds, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :brass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | [C4,E4,G4]{f} [B3,D4,G4] [C4,E4,G4] | [A3,C4,F4] [B3,D4,G4] r | r [C4,E4,A4] [B3,D4,G4] | r [C4,E4,G4] [D4,F4,A4] r [E4,G4,B4] [D4,G4,B4] | r [E4,G4,C5] r [D4,G4,B4] [E4,A4,C5] [E4,G4,C5] | [E4,G4,C5]"
        rhythm_bars "4 | 4 | 1 1 2 | 1 2 1 | 2 1 1 | 1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 4"
      end

      placement :brass_line, part: :brass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, pitch: :intervals do
        anchor "C2"
        intervals "r | r | r | r | r | r | r 0 +7 -7 | 0{trem}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 2 1/2 1/2 1 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
