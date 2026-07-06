production_piece "Technique Card P5_LILT_AND_SNAP - P5_LILT_AND_SNAP" do
  meter "4/4"
  key "C"

# category: piano
# card: P5_LILT_AND_SNAP
# cite: keyboard_figuration s6c
# behavior: long-short LILT rocking accompaniment, melody floating; SCOTCH SNAP at every phrase
#   end; the lilt subdivides at b5

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :lilt, "Lilt", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P5_LILT_AND_SNAP", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "long-short LILT rocking accompaniment, melody floating; SCOTCH SNAP at every phrase end; the lilt subdivides at b5"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4{p} A4 G4 | F#4 G4 A4 G4 E4 | G4 B4 C5 | B4 A4 B4 A4 F#4 | E5 D5 B4 | A4 G4 F#4 E4"
        rhythm_bars "3 1/2 1/2 | 3/2 1/2 1/4 3/4 1 | 2 1 1 | 3/2 1/2 1/4 3/4 1 | 2 1 1 | 1/4 3/4 1 2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lilt_line, surface: :split_pitch_rhythm do
        pitch_bars  "E2 [G3,B3] B2 [G3,B3] | D2 [F#3,A3] B1 [F#3,A3] | C2 [G3,C4] G2 [G3,B3] | D2 [F#3,B3] D3 [F#3,A3] | C2 [G3,C4] G2 [G3,C4] A2 [F#3,A3] B2 [F#3,A3] | E2 [G3,B3] E2 E1"
        rhythm_bars "3/2 1/2 3/2 1/2 | 3/2 1/2 3/2 1/2 | 3/2 1/2 3/2 1/2 | 3/2 1/2 3/2 1/2 | 3/4 1/4 3/4 1/4 3/4 1/4 3/4 1/4 | 3/2 1/2 1 1"
      end

      placement :lilt_line, part: :lilt, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
