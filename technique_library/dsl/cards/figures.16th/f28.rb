production_piece "Technique Card F28 - Five-Accent Overlay" do
  meter "15/16"
  key "C"

# category: figures.16th
# card: F28
# title: Five-Accent Overlay
# cite: 16th_note_figures:F28
# behavior: five-note accent cycle runs across the square motor

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F28", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "five-note accent cycle runs across the square motor"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0{accent} +2 +2 +1 +2 +2{accent} +2 +1 +2 +2 +1{accent} +2 +2 +2 +1"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
