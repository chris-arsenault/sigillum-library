production_piece "Technique Card D8_COMPOSED_DECAY - D8_COMPOSED_DECAY" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D8_COMPOSED_DECAY
# cite: composition_method A.8
# behavior: fragment relays DOWNWARD through five colors, each entry shorter, terraced dynamics;
#   ends on a single low pizz l.v., not a chord

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "D8_COMPOSED_DECAY", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "fragment relays DOWNWARD through five colors, each entry shorter, terraced dynamics; ends on a single low pizz l.v., not a chord"

      phrase :flute_line, pitch: :intervals do
        anchor "B5"
        intervals "0{p} +1 -1 -2 -2 | r | r | r | r | r"
        rhythm    "1 1/2 1/2 1 1 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :clarinet_line, pitch: :intervals do
        anchor "E5"
        intervals "r | 0{p} +2 -2 -2 r | r | r | r | r"
        rhythm    "4 | 1 1/2 1/2 1 1 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :horn_line, pitch: :intervals do
        anchor "B4"
        intervals "r | r | 0{pp} +1 -1 r | r | r | r"
        rhythm    "4 | 4 | 1 1/2 1/2 2 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "E2"
        intervals "0{pp} | 0 | -4 | -1 +5{pp} +2 -2 | +3 r | r"
        rhythm    "4 | 4 | 4 | 2 1 1/2 1/2 | 1 3 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, pitch: :intervals do
        anchor "E1"
        intervals "r | r | r | r | r 0{ppp} r | 0{ppp,txt:pizz._l.v.} r"
        rhythm    "4 | 4 | 4 | 4 | 2 1 1 | 1 3"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
