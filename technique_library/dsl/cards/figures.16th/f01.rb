production_piece "Technique Card F01 - Tetrachord Run With Leap Seam" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F01
# title: Tetrachord Run With Leap Seam
# cite: 16th_note_figures:F01
# behavior: four stepwise 16ths followed by a leap seam to the next entry

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F01", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "four stepwise 16ths followed by a leap seam to the next entry"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +2 +1 +2 -2 +2 +2 +1 -1 +1 +2 +2 -2 +2 +2 +1"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
