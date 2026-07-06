production_piece "Technique Card F32 - Broken-Call Figure" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F32
# title: Broken-Call Figure
# cite: 16th_note_figures:F32
# behavior: 16th-note surface is interrupted by rests to make call breaks audible

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F32", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "16th-note surface is interrupted by rests to make call breaks audible"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +2 +2 +1 r +2 +2 +2 +1 +2 r +2 +1 +2 +2 r"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
