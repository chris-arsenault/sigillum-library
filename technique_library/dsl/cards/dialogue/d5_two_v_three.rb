production_piece "Technique Card D5_TWO_V_THREE - D5_TWO_V_THREE" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D5_TWO_V_THREE
# cite: orchestral_rhythm s4
# behavior: triplet melody over duple accompaniment, layers SWAP at b4

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "D5_TWO_V_THREE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "triplet melody over duple accompaniment, layers SWAP at b4"

      phrase :flute_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +1 +2 +2 -2 -2 +2 +2 +2 +1 -1 -2 | -2 +2 +2 +1 +2 -2 -1 -4 | +2 +2 +1 +2 -2 -1 +1 | +4 -2 -2 -1 +1 | +2 -2 -1 -2 | -2 +2 +2 +1"
        rhythm    "1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/3 1/3 1/3 1/3 1/3 1/3 1 1 | 1/3 1/3 1/3 1/3 1/3 1/3 2 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, pitch: :intervals do
        anchor "F3"
        intervals "0 +7 -3 +3 -7 +7 -3 +3 | -8 +8 -5 +5 -8 +8 -5 +5 | -7 +9 -4 +4 -9 +7 -3 +3 | -7 +4 +3 -7 +4 +3 -8 +3 +5 -8 +3 +5 | -10 +3 +5 -8 +3 +5 -10 +4 +3 -7 +4 +3 | -2 +4 +3 -12 +4 +3 -2"
        rhythm    "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/3 1/3 1/3 1/3 1/3 1/3 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F2"
        intervals "0{p} -5 | 0 +12 | -14 +2 | +5 -1 -2 -2 | -2 +12 +2 -12 | +5 -5 +5"
        rhythm    "2 2 | 2 2 | 2 2 | 1 1 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
