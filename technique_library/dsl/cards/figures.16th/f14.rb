production_piece "Technique Card F14 - Double Pedal Ladder" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F14
# title: Double Pedal Ladder
# cite: 16th_note_figures:F14
# behavior: anchor and top both move; pedal figure becomes counterpoint

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F14", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "anchor and top both move; pedal figure becomes counterpoint"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +3 -3 +5 -3 +3 -3 +5 -4 +4 -4 +5 -3 +3 -3 +5"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
