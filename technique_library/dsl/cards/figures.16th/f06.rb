production_piece "Technique Card F06 - Chromatic Fence" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F06
# title: Chromatic Fence
# cite: 16th_note_figures:F06
# behavior: three tight chromatic notes hit a wider release

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F06", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "three tight chromatic notes hit a wider release"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +1 +1 +3 -3 +1 +1 +3 -3 +1 +1 +3 -4 +1 +1 +4"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
