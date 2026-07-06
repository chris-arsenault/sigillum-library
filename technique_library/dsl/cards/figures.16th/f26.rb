production_piece "Technique Card F26 - Compound-Melody Zigzag" do
  meter "3/4"
  key "C"

# category: figures.16th
# card: F26
# title: Compound-Melody Zigzag
# cite: 16th_note_figures:F26
# behavior: one zigzag line implies bass and soprano voices

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F26", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "one zigzag line implies bass and soprano voices"

      phrase :line_line, pitch: :intervals do
        anchor "C3"
        intervals "0 +19 -17 +19 -17 +19 -18 +19 -17 +19 -17 +19"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
