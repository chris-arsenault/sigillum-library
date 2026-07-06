production_piece "Technique Card P3_TRIPLET_CURRENT - P3_TRIPLET_CURRENT" do
  meter "4/4"
  key "C"

# category: piano
# card: P3_TRIPLET_CURRENT
# cite: keyboard_figuration s6c
# behavior: continuous triplet weave (non-spelling) under a duple melody; b4-5 the hands SWAP
#   meters (2-against-3 inside one player)

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :triplet_weave, "Triplet weave", music21: "Piano", family: :keyboard, description: "Piano"
    part :bass, "Bass", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P3_TRIPLET_CURRENT", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "continuous triplet weave (non-spelling) under a duple melody; b4-5 the hands SWAP meters (2-against-3 inside one player)"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{p} Eb5 F5 | G5 F5 Eb5 D5 | C5 F5 | D5 Eb5 F5 G5 A5 | Bb5 A5 G5 F5 | Eb5 D5 C5 D5"
        rhythm_bars "2 1 1 | 3/2 1/2 1 1 | 2 2 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :triplet_weave_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4 G4 F4 Eb4 F4 D4 Eb4 F4 Eb4 D4 Eb4 C4 | D4 Eb4 F4 G4 A4 G4 F4 G4 F4 Eb4 D4 Eb4 | Eb4 F4 Eb4 D4 C4 D4 Eb4 F4 G4 A4 G4 F4 | D4 Eb4 F4 Eb4 C4 | D4 F4 Eb4 D4 Eb4 | Eb4 D4 C4 D4 Eb4 F4 D4"
        rhythm_bars "1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1/3 1/3 1/3 1/3 1/3 1/3 2"
      end

      placement :triplet_weave_line, part: :triplet_weave, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb1 F2 D2 Eb2 F2 | Eb2 Bb1 G2 F2 Eb2 | Ab1 Eb2 F2 G2 F2 | Bb1 F2 Bb2 F2 D2 F2 G1 D2 G2 D2 Bb1 D2 | Eb2 Bb2 Eb3 Bb2 G2 Bb2 F2 C3 F3 C3 A2 C3 | Bb1 F2 Bb1"
        rhythm_bars "1 1 1/2 1/2 1 | 1 1 1/2 1/2 1 | 1 1/2 1/2 1 1 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1 1 2"
      end

      placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
