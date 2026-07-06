production_piece "Technique Card F18 - Seventh-Chord Rotation" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F18
# title: Seventh-Chord Rotation
# cite: 16th_note_figures:F18
# behavior: seventh-chord rotation adds color without changing rhythmic engine

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F18", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "seventh-chord rotation adds color without changing rhythmic engine"

      phrase :line_line, pitch: :intervals do
        anchor "C4"
        intervals "0 +4 +3 +3 -6 +3 +3 +2 -5 +3 +2 +4 -6 +2 +4 +3"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
