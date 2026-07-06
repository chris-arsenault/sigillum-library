production_piece "Technique Card F05 - Enclosure Run" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F05
# title: Enclosure Run
# cite: 16th_note_figures:F05
# behavior: target notes are approached by below/above enclosures then released upward

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F05", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "target notes are approached by below/above enclosures then released upward"

      phrase :line_line, pitch: :intervals do
        anchor "B4"
        intervals "0 +3 -2 +4 -4 +4 -2 +3 -3 +3 -1 +3 -3 +3 -2 +4"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
