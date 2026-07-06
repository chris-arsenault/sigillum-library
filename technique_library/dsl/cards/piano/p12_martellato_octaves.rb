production_piece "Technique Card P12_MARTELLATO_OCTAVES - P12_MARTELLATO_OCTAVES" do
  meter "4/4"
  key "C"

# category: piano
# card: P12_MARTELLATO_OCTAVES
# cite: keyboard_figuration s6c
# behavior: alternating-hand octave hammering, accent MIGRATES each bar; chromatic climb; dotted
#   snap close

  roster do
    part :rh_8ves, "RH 8ves", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_8ves, "LH 8ves", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P12_MARTELLATO_OCTAVES", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "alternating-hand octave hammering, accent MIGRATES each bar; chromatic climb; dotted snap close"

      phrase :rh_8ves_line, surface: :split_pitch_rhythm do
        pitch_bars  "[E4,E5]{f} r [E4,E5] r [E4,E5] r [E4,E5] r | r [G4,G5] r [G4,G5] r [G4,G5] r [G4,G5] | [A4,A5] r [Bb4,Bb5] r [B4,B5] r [C5,C6] r [C#5,C#6] r [D5,D6] r [Eb5,Eb6] r [E5,E6] r | [B4,B5] [B4,B5] [E5,E6] [B4,E5,B5]"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 3/4 1/4 2 1"
      end

      placement :rh_8ves_line, part: :rh_8ves, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_8ves_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [E2,E3] r [E2,E3] r [E2,E3] r [E2,E3] | [G2,G3] r [G2,G3] r [G2,G3] r [G2,G3] r | r [A2,A3] r [Bb2,Bb3] r [B2,B3] r [C3,C4] r [C#3,C#4] r [D3,D4] r [Eb3,Eb4] r [E3,E4] | [B1,B2] [B1,B2] [E2,E3] [E1,E2]"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 3/4 1/4 2 1"
      end

      placement :lh_8ves_line, part: :lh_8ves, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
