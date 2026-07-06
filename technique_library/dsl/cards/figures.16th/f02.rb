production_piece "Technique Card F02 - Inverted Tetrachord Seams" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F02
# title: Inverted Tetrachord Seams
# cite: 16th_note_figures:F02
# behavior: tetrachord groups reverse direction at the seams

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F02", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "tetrachord groups reverse direction at the seams"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +2 +1 +2 +3 -1 -2 -2 +4 +1 +2 +2 +3 -1 -2 -2"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
