production_piece "Technique Card F27 - 3+3+2 Accent Rail" do
  meter "2/4"
  key "C"

# category: figures.16th
# card: F27
# title: 3+3+2 Accent Rail
# cite: 16th_note_figures:F27
# behavior: even 16ths carry a 3+3+2 accent rail

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F27", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "even 16ths carry a 3+3+2 accent rail"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0{accent} +2 +2 +1{accent} +2 +2 +2{accent} +1"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
