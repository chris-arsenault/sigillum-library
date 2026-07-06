production_piece "Technique Card F12 - Broken Pedal Fan" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F12
# title: Broken Pedal Fan
# cite: 16th_note_figures:F12
# behavior: fixed anchor note alternates with moving fan notes

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F12", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "fixed anchor note alternates with moving fan notes"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +2 -2 +3 -3 +5 -5 +7 -7 +8 -8 +10 -10 +7 -7 +3"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
