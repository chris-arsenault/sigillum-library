production_piece "Technique Card D1_GAP_FILL_PAIR - D1_GAP_FILL_PAIR" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D1_GAP_FILL_PAIR
# cite: dialogue_doubling s2
# behavior: melody with built-in gaps; ONE consistent answerer (turn identity, lower register)
#   fills every gap, exits before the melody moves

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
  end

  section :card, "D1_GAP_FILL_PAIR", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "melody with built-in gaps; ONE consistent answerer (turn identity, lower register) fills every gap, exits before the melody moves"

      phrase :oboe_line, pitch: :intervals do
        anchor "F5"
        intervals "0{mf} +2 +2 | +3 -2 | -1 -2 -2 | +2 | +2 +1 +2 | +2 -2 | -2 -1 -2 | -2"
        rhythm    "2 1 1 | 3 1 | 2 1 1 | 4 | 2 1 1 | 3 1 | 3/2 1/2 2 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :clarinet_line, pitch: :intervals do
        anchor "A3"
        intervals "r 0 +1 +2 -2 -1 +1 | r +2 +2 +2 -2 -2 +2 r | r | r +2 +1 +2 -2 -1 -2 -2 | r 0 +2 +2 -2 -2 +2 | r +3 +2 +2 -2 -2 -3 r | r | r -5 +1 +2 -2 -1 -2 -2"
        rhythm    "2 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 1 | 4 | 1 1/4 1/4 1/4 1/4 1/2 1/2 1 | 2 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 1 | 4 | 1 1/4 1/4 1/4 1/4 1/2 1/2 1"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, pitch: :intervals do
        anchor "A3"
        intervals "[0,+3]{p} r | [+1,+5] r | [-1,+2] r | [+1,+7] r | [-1,+2] r | [+1,+5] r | [+2,+6] r | [-3,0]"
        rhythm    "3 1 | 3 1 | 3 1 | 3 1 | 3 1 | 3 1 | 3 1 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
