production_piece "Technique Card F10 - Diminished-Seventh Cycle" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F10
# title: Diminished-Seventh Cycle
# cite: 16th_note_figures:F10
# behavior: symmetrical diminished-seventh cycle for rupture or modulation hinge

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F10", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "symmetrical diminished-seventh cycle for rupture or modulation hinge"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +3 +3 +3 -7 +3 +3 +3 -7 +3 +3 +3 -7 +3 +3 +3"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
