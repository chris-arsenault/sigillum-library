production_piece "Technique Card P14_HAZE_PLANING - P14_HAZE_PLANING" do
  meter "4/4"
  key "C"

# category: piano
# card: P14_HAZE_PLANING
# cite: keyboard_figuration s6c
# behavior: parallel maj9 chords drifting una corda (the blur is the harmony); melody floats OUT
#   of the haze; dissolves upward

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :planing_rh, "Planing RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :planing_lh, "Planing LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P14_HAZE_PLANING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "parallel maj9 chords drifting una corda (the blur is the harmony); melody floats OUT of the haze; dissolves upward"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r G5 A5 B5 | A5 F#5 D5 | E5 F#5 G5 | r A5 B5 D6 | E6{txt:l.v.}"
        rhythm_bars "4 | 1 3/2 1/2 1 | 2 1 1 | 3/2 1/2 2 | 1 1 1 1 | 4"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :planing_rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D4,F#4,A4,E5]{pp,txt:una_corda} [C4,E4,G4,D5] | [Bb3,D4,F4,C5] [C4,E4,G4,D5] | [D4,F#4,A4,E5] [E4,G4,B4,F#5] | [C4,E4,G4,D5] [Bb3,D4,F4,C5] | [D4,F#4,A4,E5] [E4,G4,B4,F#5] [G4,B4,D5,A5] | [A4,C#5,E5,B5]"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 3/2 3/2 1 | 4"
      end

      placement :planing_rh_line, part: :planing_rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :planing_lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D2,A2] [C2,G2] | [Bb1,F2] [C2,G2] | [D2,A2] [E2,B2] | [C2,G2] [Bb1,F2] | [D2,A2] [E2,B2] [G2,D3] | [A2,E3]"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 3/2 3/2 1 | 4"
      end

      placement :planing_lh_line, part: :planing_lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
