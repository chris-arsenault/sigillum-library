production_piece "Technique Card F08 - Broken Sixths Ladder" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F08
# title: Broken Sixths Ladder
# cite: 16th_note_figures:F08
# behavior: wide broken sixths create spatial pressure with one clear target

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F08", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "wide broken sixths create spatial pressure with one clear target"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +9 -7 +9 -7 +8 -7 +9 -7 +9 -7 +8 -6 +8 -7 +9"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
