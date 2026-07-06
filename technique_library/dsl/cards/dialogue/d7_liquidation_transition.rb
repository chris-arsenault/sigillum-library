production_piece "Technique Card D7_LIQUIDATION_TRANSITION - D7_LIQUIDATION_TRANSITION" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D7_LIQUIDATION_TRANSITION
# cite: composition_method A.8
# behavior: fragment liquidates, sequences up, harmonic rhythm accelerates whole->half->quarter,
#   caesura + pickup into the new key

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "D7_LIQUIDATION_TRANSITION", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "fragment liquidates, sequences up, harmonic rhythm accelerates whole->half->quarter, caesura + pickup into the new key"

      phrase :violin_line, pitch: :intervals do
        anchor "E5"
        intervals "0{mf} +1 -1 -2 +2 | +1 +2 -2 -1 +1 | +2 +2 -2 +2 +2 -2 | +2 +1 -1 +1 +2 -2 | +2 -2 -1 -2 -2 -2 -1 -2 | r -7{p} +2 +2"
        rhythm    "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 5/2 1/2 1/2 1/2"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[A3,C4,E4]{mf} | [A3,D4,F4] | [A3,C4,E4] [B3,D4,F4] | [B3,D4,G4] [C4,E4,G4] | [C4,E4,A4] [B3,D4,G4] [A3,C4,F4] [G3,B3,F4] | r [G3,C4]"
        rhythm_bars "4 | 4 | 2 2 | 2 2 | 1 1 1 1 | 5/2 3/2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{mf} | -7 | +7 +2 | -4 +5 | -7 +2 -2 +2 | r -7"
        rhythm    "4 | 4 | 2 2 | 2 2 | 1 1 1 1 | 5/2 3/2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
