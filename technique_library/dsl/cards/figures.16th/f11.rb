production_piece "Technique Card F11 - Whole-Tone Rail" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F11
# title: Whole-Tone Rail
# cite: 16th_note_figures:F11
# behavior: whole-tone rail changes harmonic light before returning to harder motor

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F11", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "whole-tone rail changes harmonic light before returning to harder motor"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +2 +2 +2 +2 +2 +2 +2 +2 +2 +2 +2 -10 +2 +2 +2"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
