production_piece "Technique Card F31 - Side-Slip Cell" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F31
# title: Side-Slip Cell
# cite: 16th_note_figures:F31
# behavior: fixed cell shape side-slips chromatically

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F31", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "fixed cell shape side-slips chromatically"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +2 +2 +3 -6 +2 +2 +3 -6 +2 +2 +3 -6 +2 +2 +3"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
