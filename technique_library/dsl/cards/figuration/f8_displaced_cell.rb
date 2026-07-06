production_piece "Technique Card F8_DISPLACED_CELL - F8_DISPLACED_CELL" do
  meter "4/4"
  key "C"

# category: figuration
# card: F8_DISPLACED_CELL
# cite: keyboard_figuration s6b t8
# behavior: non-chordal melodic cell, length/accent shifted each repetition; second desk offset
#   by half a cell - interplay without chords

  roster do
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "F8_DISPLACED_CELL", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "non-chordal melodic cell, length/accent shifted each repetition; second desk offset by half a cell - interplay without chords"

      phrase :viola_line, pitch: :intervals do
        anchor "E3"
        intervals "0{mf} +1 -3 +2 0 +1 -3 | +2 0 +1 -3 +2 0 +1 | -3 +2 0 +1 -3 | +2 +1 +2 -3 +1 -3 +2 | 0 +1 -3 +2 0 +1 +2 +2 | -4 -1 -2 +2"
        rhythm    "1/2 1/2 1/2 1 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 3/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violin_ii_line, pitch: :intervals do
        anchor "B3"
        intervals "r 0 +1 -3 +2 | 0 0 +1 -3 +2 +1 -3 | +2 0 +1 -3 +2 | +1 -1 +1 +2 -3 +1 -3 | +2 +1 +2 -3 +1 -3 +2 | +1 -1 -2 +2 0"
        rhythm    "2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 3/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "E2"
        intervals "0{p} | 0 | -2 | +2 +1 | -3 +2 | 0 -5 +5"
        rhythm    "4 | 4 | 4 | 2 2 | 2 2 | 5/2 1/2 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
