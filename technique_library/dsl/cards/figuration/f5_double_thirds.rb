production_piece "Technique Card F5_DOUBLE_THIRDS - F5_DOUBLE_THIRDS" do
  meter "4/4"
  key "C"

# category: figuration
# card: F5_DOUBLE_THIRDS
# cite: keyboard_figuration s6b t6
# behavior: parallel 3rds widening to 6ths at the crest, all stepwise; walking bass

  roster do
    part :violins_div, "Violins (div.)", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "F5_DOUBLE_THIRDS", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "parallel 3rds widening to 6ths at the crest, all stepwise; walking bass"

      phrase :violins_div_line, surface: :split_pitch_rhythm do
        pitch_bars  "[A3,C4] [Bb3,D4] [C4,E4] [D4,F4] [E4,G4] [D4,F4] [C4,E4] [Bb3,D4] [C4,E4] [D4,F4] [C4,E4] [A3,C4] | [C4,E4] [D4,F4] [E4,G4] [F4,A4] [G4,Bb4] [F4,A4] [E4,G4] [D4,F4] [E4,G4] [D4,F4] | [C4,A4] [D4,Bb4] [E4,C5] [F4,D5] [E4,C5] [D4,Bb4] [C4,A4] [Bb3,G4] [C4,A4] [D4,Bb4] | [E4,C5] [D4,Bb4] [C4,A4] [Bb3,G4] [A3,F4] [Bb3,G4] | [G3,E4] [A3,F4] [Bb3,G4] [C4,A4] [D4,Bb4] [C4,A4] [Bb3,G4] [A3,F4] [G3,E4] [A3,F4] [Bb3,G4] [C4,A4] [Bb3,G4] [A3,F4] [G3,E4] [F3,D4] | [A3,F4] [G3,E4] [F3,F4]"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1 1 2"
      end

      placement :violins_div_line, part: :violins_div, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F2"
        intervals "0 -1 -2 -4 | +2 -2 -1 +1 | -1 +1 +2 +2 | +2 +1 +2 -2 | -5 +1 +1 +2 | +1 -5 -7"
        rhythm    "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
