production_piece "Technique Card F07 - Broken Thirds Ladder" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F07
# title: Broken Thirds Ladder
# cite: 16th_note_figures:F07
# behavior: broken thirds imply two stepwise voices

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F07", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "broken thirds imply two stepwise voices"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +4 -2 +3 -1 +3 -2 +4 -2 +4 -2 +3 -1 +3 -2 +4"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
