production_piece "Technique Card F4_NEIGHBOR_OSCILLATION - F4_NEIGHBOR_OSCILLATION" do
  meter "4/4"
  key "C"

# category: figuration
# card: F4_NEIGHBOR_OSCILLATION
# cite: keyboard_figuration s6b t5
# behavior: rocking 2nds + murky broken octaves + trill-as-texture at the peak; motion circles,
#   never spells

  roster do
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
  end

  section :card, "F4_NEIGHBOR_OSCILLATION", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "rocking 2nds + murky broken octaves + trill-as-texture at the peak; motion circles, never spells"

      phrase :violin_ii_line, pitch: :intervals do
        anchor "A3"
        intervals "0 +1 -1 +1 -1 +1 -1 +1 | -1 +1 -1 +1 -3 +2 -2 +2 | -4 +2 -2 +2 -3 +1 -1 +1 | +4 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 | 0 +2 -2 +2 -2 +2 -2 +2 +1 +1 -1 +1 -1 +1 -1 +1 | 0 -1 +1"
        rhythm    "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/2 3"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0 +12 -12 +12 -12 +12 -12 +12 | -12 +12 -12 +12 -14 +12 -12 +12 | -14 +12 -12 +12 -13 +12 -12 +12 | -7 +12 -12 +12 -12 +12 -12 +12 | -19 +12 -12 +12 -10 +12 -12 +12 | -7"
        rhythm    "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :flute_line, pitch: :intervals do
        anchor "F5"
        intervals "r | r | r | 0 +2 -2 +2 -2 +2 -2 +2 -2 +2 -2 +2 -2 +2 -2 +2 | -3 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 | 0 -1 -2"
        rhythm    "4 | 4 | 4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/2 3"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
