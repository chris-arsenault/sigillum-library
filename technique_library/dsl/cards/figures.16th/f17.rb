production_piece "Technique Card F17 - Arpeggio Rotation" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F17
# title: Arpeggio Rotation
# cite: 16th_note_figures:F17
# behavior: chord rotates through inversions while preserving a contour

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F17", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "chord rotates through inversions while preserving a contour"

      phrase :line_line, pitch: :intervals do
        anchor "C4"
        intervals "0 +4 +3 +5 -8 +3 +5 +4 -9 +5 +4 +3 -7 +4 +3 +5"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
