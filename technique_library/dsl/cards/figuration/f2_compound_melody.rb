production_piece "Technique Card F2_COMPOUND_MELODY - F2_COMPOUND_MELODY" do
  meter "4/4"
  key "C"

# category: figuration
# card: F2_COMPOUND_MELODY
# cite: keyboard_figuration s6b t3
# behavior: ONE line implying three voices (bass descent / stepwise treble / inner pedal); no
#   chord is ever spelled; flute floats above

  roster do
    part :viola_compound, "Viola (compound)", music21: "Viola", family: :string, description: "Viola"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
  end

  section :card, "F2_COMPOUND_MELODY", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "ONE line implying three voices (bass descent / stepwise treble / inner pedal); no chord is ever spelled; flute floats above"

      phrase :viola_compound_line, pitch: :intervals do
        anchor "A2"
        intervals "0 +7 +8 -8 +7 -7 | -9 +9 +7 -7 +8 -8 | -11 +9 +7 -7 +9 -9 | -10 +12 +4 -4 +5 +2 -7 | -11 +9 +9 -9 +10 -10 | -10 +12 +4 +3 -2"
        rhythm    "1/2 1/2 1 1/2 1 1/2 | 1/2 1/2 1 1/2 1 1/2 | 1/2 1/2 1 1/2 1 1/2 | 1/2 1/2 1 1/2 1/2 1/2 1/2 | 1/2 1/2 1 1/2 1 1/2 | 1/2 1/2 3/2 1/2 1"
      end

      placement :viola_compound_line, part: :viola_compound, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :flute_line, pitch: :intervals do
        anchor "E5"
        intervals "r | r | 0{p} +1 -1 | -2 -2 | +2 +2 +1 -3 | -2 -1"
        rhythm    "4 | 4 | 2 1 1 | 2 2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
