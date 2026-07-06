production_piece "Technique Card F19 - Open-Tenth Sweep" do
  meter "3/4"
  key "C"

# category: figures.16th
# card: F19
# title: Open-Tenth Sweep
# cite: 16th_note_figures:F19
# behavior: open bass-to-top sweep avoids mud and makes register trajectory audible

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F19", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "open bass-to-top sweep avoids mud and makes register trajectory audible"

      phrase :line_line, pitch: :intervals do
        anchor "C2"
        intervals "0 +7 +9 +8 -22 +7 +8 +9 -22 +7 +8 +9"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
