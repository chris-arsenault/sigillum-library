production_piece "Technique Card F09 - Fourths And Tritones" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F09
# title: Fourths And Tritones
# cite: 16th_note_figures:F09
# behavior: perfect fourths are corrupted by tritones for harmonic pressure

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F09", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "perfect fourths are corrupted by tritones for harmonic pressure"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +5 -3 +5 -3 +5 -4 +6 -4 +6 -4 +6 -4 +6 -5 +6"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
