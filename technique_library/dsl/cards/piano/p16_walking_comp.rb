production_piece "Technique Card P16_WALKING_COMP - P16_WALKING_COMP" do
  meter "4/4"
  key "C"

# category: piano
# card: P16_WALKING_COMP
# cite: keyboard_figuration s6c
# behavior: piano-trio-in-one: true walking bass with chromatic approaches / syncopated rootless
#   comp (charleston placements vary per bar) / sparse behind-the-beat melody

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :comp, "Comp", music21: "Piano", family: :keyboard, description: "Piano"
    part :walking_bass, "Walking bass", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P16_WALKING_COMP", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "piano-trio-in-one: true walking bass with chromatic approaches / syncopated rootless comp (charleston placements vary per bar) / sparse behind-the-beat melody"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "r F5 E5 Eb5 D5 | r C5 B4 C#5 D5 | A4 r G4 A4 | Bb4 A4 G4 A4 G4 F4 | r E4 G4 A4 B4 C5 D5 | C#5 D5 r A4"
        rhythm_bars "2 1/2 1/4 1/4 1 | 3/2 1 1/4 1/4 1 | 5/2 1/2 1/2 1/2 | 1 1/2 1 1/4 1/4 1 | 1/2 1/2 1/4 1/4 1 1/2 1 | 1/2 2 1/2 1"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :comp_line, surface: :split_pitch_rhythm do
        pitch_bars  "[F3,A3,C4] r [F3,A3,C4] [F3,A3,C4] r | r [F3,B3,E4] r [F3,B3] r | [E3,G3,B3] r r [E3,A3,C#4] | r [F3,A3,D4] [F3,A3,D4] r [E3,G3,C4] r | [F3,A3,C4] [F3,B3,E4] r [E3,A3] | r [F3,A3,D4] [E3,G3,C#4] [F3,A3,D4]"
        rhythm_bars "1 1/2 3/4 1/4 3/2 | 1/2 1 1 1/2 1 | 1 1 1/2 3/2 | 1/4 1/4 1 1 1/2 1 | 3/2 1 1/2 1 | 1/2 1 1 3/2"
      end

      placement :comp_line, part: :comp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :walking_bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2 F2 A2 C3 | B2 G2 F2 D2 | E2 G2 B2 C#3 | D3 C3 Bb2 A2 | G2 G#2 A2 B2 | C#3 A2 D2 D2 A1"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1/2 1/2"
      end

      placement :walking_bass_line, part: :walking_bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
