production_piece "Technique Card F29 - One-Note Obsession With Escapes" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F29
# title: One-Note Obsession With Escapes
# cite: 16th_note_figures:F29
# behavior: repeated anchor note becomes formal marker while escape intervals widen

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F29", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "repeated anchor note becomes formal marker while escape intervals widen"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 0 +2 -2 0 0 +3 -3 0 0 +5 -5 0 +7 +1 -1"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
