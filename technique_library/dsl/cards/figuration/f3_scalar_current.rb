production_piece "Technique Card F3_SCALAR_CURRENT - F3_SCALAR_CURRENT" do
  meter "4/4"
  key "C"

# category: figuration
# card: F3_SCALAR_CURRENT
# cite: keyboard_figuration s6b t4
# behavior: stepwise currents connecting chord tones; cadence in parallel 3rds; bass in halves

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "F3_SCALAR_CURRENT", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "stepwise currents connecting chord tones; cadence in parallel 3rds; bass in halves"

      phrase :violin_i_line, pitch: :intervals do
        anchor "E4"
        intervals "0 +2 +1 +2 +2 +1 -1 -2 -2 +4 -2 -3 | +1 +2 +2 +1 -1 -2 -2 -1 -2 +2 +1 +4 | +1 -1 -2 -2 -1 -2 -1 +1 +5 -3 +1 | 0 +2 +2 +1 +2 +2 +2 +1 -1 -4 +2 -4 | -1 +1 +2 -2 -1 -2 -2 -1 -2 +3 +4 | [-4,0] [-1,+2] [+1,+5] [+2,+5] [-2,+2] [-1,+2] [-2,+1]"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violin_ii_line, pitch: :intervals do
        anchor "B4"
        intervals "r | r | r | r 0 +1 +2 +2 -2 -2 -1 -2 | -2 +2 +2 +1 -1 -2 -2 -1 -2 +2 +1 | -3 +2 -2 -1 +1"
        rhythm    "4 | 4 | 4 | 2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1 | 1/2 1/2 1/2 1/2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "E2"
        intervals "0{p} -2 | -2 -1 | -2 +5 | -7 +2 +2 | +1 +2 | -3 +5"
        rhythm    "2 2 | 2 2 | 2 2 | 1 1 2 | 2 2 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
