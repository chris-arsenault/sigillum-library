production_piece "Technique Card FM5_LISTENERS_MURMUR - FM5_LISTENERS_MURMUR" do
  meter "4/4"
  key "C"

# category: forms
# card: FM5_LISTENERS_MURMUR
# cite: keyboard_figuration s6g (fixed-response drama)
# behavior: the call transforms freely; the listeners' murmur is RHYTHMICALLY IDENTICAL each
#   time but its color darkens (3rds -> minor -> the m2 shadow) - and the fourth time IT FAILS
#   TO COME; the teller finishes alone

  roster do
    part :oboe_teller, "Oboe (teller)", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :viola_murmur, "Viola (murmur)", music21: "Viola", family: :string, description: "Viola"
    part :violoncello_murmur_line, "Violoncello (murmur+line)", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FM5_LISTENERS_MURMUR", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the call transforms freely; the listeners' murmur is RHYTHMICALLY IDENTICAL each time but its color darkens (3rds -> minor -> the m2 shadow) - and the fourth time IT FAILS TO COME; the teller finishes alone"

      phrase :oboe_teller_line, pitch: :intervals do
        anchor "F4"
        intervals "0{p} 0 +5 -1 +1 | r | -5 +2 +5 -2 +4 -2 | r | +2 +1 -1 -2 -2 +2 +2 +1 | r | +2 -2 -1 -2 -2 -1 | +1 +2 -2 0"
        rhythm    "1/2 1/2 3/2 1/2 1 | 4 | 1/2 1/2 3/2 1/2 1/2 1/2 | 4 | 3/4 1/4 1/2 1/2 1/3 1/3 1/3 1 | 4 | 1 1/2 1/2 3/4 1/4 1 | 3/2 1/4 1/4 2"
      end

      placement :oboe_teller_line, part: :oboe_teller, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_murmur_line, pitch: :intervals do
        anchor "D4"
        intervals "r | r 0 0 +1 -1 | r | r -1 0 +2 -2 | r | r -1 0 +1 -1 | r | r"
        rhythm    "4 | 1/2 1/2 3/4 1/4 2 | 4 | 1/2 1/2 3/4 1/4 2 | 4 | 1/2 1/2 3/4 1/4 2 | 4 | 4"
      end

      placement :viola_murmur_line, part: :viola_murmur, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_murmur_line_line, pitch: :intervals do
        anchor "Bb2"
        intervals "0{pp} +7 -3 | r -4 0 +7 -7 | +5 +2 -8 | r +1 0 +8 -8 | -3 +2 +1 | r -1 0 +6 -6 | -4 +12 -2 -1 -2 | -2 -5 -7"
        rhythm    "2 1 1 | 1/2 1/2 3/4 1/4 2 | 2 1 1 | 1/2 1/2 3/4 1/4 2 | 2 1 1 | 1/2 1/2 3/4 1/4 2 | 2 1/2 1/2 1/2 1/2 | 1 1 2"
      end

      placement :violoncello_murmur_line_line, part: :violoncello_murmur_line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
