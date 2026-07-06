production_piece "Technique Card F13 - Broken Pedal With Moving Top" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F13
# title: Broken Pedal With Moving Top
# cite: 16th_note_figures:F13
# behavior: pedal anchor supports an audible moving top line

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F13", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "pedal anchor supports an audible moving top line"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +2 -2 +3 -3 +3 -3 +5 -5 +5 -5 +7 -7 +8 -8 +10"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
