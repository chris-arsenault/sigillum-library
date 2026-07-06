production_piece "Technique Card F30 - Register-Study Staircase" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F30
# title: Register-Study Staircase
# cite: 16th_note_figures:F30
# behavior: register itself becomes the formal event

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F30", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "register itself becomes the formal event"

      phrase :line_line, pitch: :intervals do
        anchor "C3"
        intervals "0 +2 +2 +1 +7 +2 +2 +1 +7 +2 +2 +1 +7 +2 +2 +1"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
