production_piece "Technique Card K1_NOCTURNE_34 - K1_NOCTURNE_34" do
  meter "4/4"
  key "C"

# category: piano
# card: K1_NOCTURNE_34
# cite: keyboard_figuration s1
# behavior: 3-4 real voices: melody (6ths at return) / winding middle / LH 2-octave sweeps whose
#   bottoms walk a chromatic lament bass

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :middle_voice, "Middle voice", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_sweeps, "LH sweeps", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "K1_NOCTURNE_34", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "3-4 real voices: melody (6ths at return) / winding middle / LH 2-octave sweeps whose bottoms walk a chromatic lament bass"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "r G4 C5 Eb5 | D5 C5 B4 C5 | F5 Eb5 D5 C5 | B4 D5 G4 | r [Eb4,C5] [F4,D5] [G4,Eb5] [F4,D5] | [Eb4,C5] [D4,B4] [Eb4,C5] | [F4,D5] [G4,Eb5] [Ab4,F5] [G4,Eb5] | [F4,D5] [Eb4,C5] [D4,B4] [Eb4,C5]"
        rhythm_bars "1 1 1 1 | 2 1/2 1/2 1 | 3/2 1/2 1 1 | 1 1 2 | 1/2 1/2 1 1 1 | 3/2 1/2 2 | 1 1 3/2 1/2 | 1 1 1 1"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :middle_voice_line, surface: :split_pitch_rhythm do
        pitch_bars  "r C4 D4 Eb4 D4 C4 | B3 C4 D4 Ab3 B3 | C4 D4 Eb4 D4 C4 D4 | D4 B3 C4 D4 Eb4 D4 | C4 D4 Eb4 D4 C4 B3 C4 B3 C4 | Ab3 G3 Ab3 B3 C4 D4 Eb4 D4 | D4 Eb4 D4 C4 D4 Eb4 F4 Eb4 D4 C4 B3 D4 | C4 B3 G3"
        rhythm_bars "1/2 1/2 1 1/2 1/2 1 | 1 1/2 1/2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 1 1/2 1/2 1/2 1/2 1 | 1/4 1/4 1/4 1/4 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1 1 2"
      end

      placement :middle_voice_line, part: :middle_voice, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_sweeps_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2 G2 Eb3 G3 C4 G3 Eb3 G2 | B1 G2 D3 F3 G3 F3 D3 G2 | Ab1 Eb2 C3 Eb3 Ab3 Eb3 C3 Eb2 | G1 D2 B2 F3 G3 F3 B2 D2 | F1 C2 Ab2 C3 F3 C3 Ab2 C2 | Ab1 Eb2 C3 Ab3 C4 Ab3 Eb3 C3 | G1 F2 B2 D3 G3 B3 D4 B3 | C2 G2 C3 Eb3 G3 Eb3 C3 G2"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :lh_sweeps_line, part: :lh_sweeps, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
