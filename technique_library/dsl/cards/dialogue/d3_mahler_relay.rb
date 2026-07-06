production_piece "Technique Card D3_MAHLER_RELAY - D3_MAHLER_RELAY" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D3_MAHLER_RELAY
# cite: dialogue_doubling s4
# behavior: one line handed Ob -> Cl -> Hn mid-phrase, 1-note overlaps at breath points,
#   register-motivated; pizz bass walks

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "D3_MAHLER_RELAY", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one line handed Ob -> Cl -> Hn mid-phrase, 1-note overlaps at breath points, register-motivated; pizz bass walks"

      phrase :oboe_line, pitch: :intervals do
        anchor "D5"
        intervals "0{p} +2 +1 | +2 -2 -1 -2 | -2 r | r | r | r"
        rhythm    "2 1 1 | 3/2 1/2 1 1 | 2 2 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :clarinet_line, pitch: :intervals do
        anchor "C5"
        intervals "r | r | r 0 -2 -1 | -2 +2 +1 -3 | -2 r | r"
        rhythm    "4 | 4 | 1/2 3/2 1 1 | 3/2 1/2 1 1 | 2 2 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :horn_line, pitch: :intervals do
        anchor "F4"
        intervals "r | r | r | r | r 0 -1 -2 | -1 +1 -5 +5"
        rhythm    "4 | 4 | 4 | 4 | 1/2 3/2 1 1 | 3/2 1/2 1 1"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{p,txt:pizz.} r -5 r | +1 r -3 r | +2 r -4 r | +2 r -3 r | +1 r +2 r | +2 -12 +5"
        rhythm    "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
