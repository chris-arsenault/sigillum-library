production_piece "Technique Card F04 - Run With Return Hook" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F04
# title: Run With Return Hook
# cite: 16th_note_figures:F04
# behavior: each run snaps back before relaunching

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F04", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "each run snaps back before relaunching"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +2 +2 +1 -1 -2 -2 +4 -2 +2 +1 +2 -2 -1 -2 +3"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
