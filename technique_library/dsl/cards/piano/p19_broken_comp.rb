production_piece "Technique Card P19_BROKEN_COMP - P19_BROKEN_COMP" do
  meter "4/4"
  key "C"

# category: piano
# card: P19_BROKEN_COMP
# cite: keyboard_figuration s6d
# behavior: the comp speaks in mixed rhythm: 8th chords + 16th double-strikes + rests INSIDE the
#   gesture + dotted snaps + 16th pickups; bass hits live in the RH's rests

  roster do
    part :rh_comp, "RH comp", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_bass, "LH bass", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P19_BROKEN_COMP", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "the comp speaks in mixed rhythm: 8th chords + 16th double-strikes + rests INSIDE the gesture + dotted snaps + 16th pickups; bass hits live in the RH's rests"

      phrase :rh_comp_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D4,F4] [D4,F4] [D4,F4] r [C4,E4] [D4,F4] [C4,E4] [A3,D4] | r [F4,A4] [F4,A4] r [E4,G4] [F4,A4] [G4,Bb4] [F4,A4] r [E4,G4] [D4,F4] | [D4,G4] r [D4,G4] [C#4,G4] [D4,A4] r [C#4,E4] [D4,F4] [E4,G4] [C#4,E4] | [D4,F4,A4] [D4,F4,A4] r [C4,E4,A4] [Bb3,D4,G4] [A3,C#4,G4] [A3,D4,F4]"
        rhythm_bars "1/2 1/4 1/4 1/2 1/2 3/4 1/4 1 | 1/4 1/4 1/2 1/2 1/4 1/4 3/4 1/4 1/2 1/4 1/4 | 1/2 1/4 1/4 1/2 1/2 1/2 1/4 1/4 1/2 1/2 | 3/4 1/4 1/2 1/2 1/2 1/2 1"
      end

      placement :rh_comp_line, part: :rh_comp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2 r A2 D3 r C3 r Bb2 A2 | Bb2 r F2 Bb1 r C3 Bb2 r G2 A2 | G2 r A2 r A1 Bb1 B1 C#2 D2 E2 | D2 D3 C3 Bb2 G2 A2 D2"
        rhythm_bars "1/2 1/2 1/4 1/4 1/2 1/2 3/4 1/4 1/2 | 1/2 1/4 1/4 1/2 1/2 1/4 1/4 3/4 1/4 1/2 | 1/2 1/2 1/2 1/4 1/4 1/2 1/2 1/4 1/4 1/2 | 3/4 1/4 1/2 1/2 1/2 1/2 1"
      end

      placement :lh_bass_line, part: :lh_bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
