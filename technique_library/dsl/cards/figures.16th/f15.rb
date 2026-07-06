production_piece "Technique Card F15 - Pedal With Chromatic Bite" do
  meter "4/4"
  key "A"

# category: figures.16th
# card: F15
# title: Pedal With Chromatic Bite
# cite: 16th_note_figures:F15
# behavior: pedal anchor stabilizes chromatic upper-note pressure

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F15", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "pedal anchor stabilizes chromatic upper-note pressure"

      phrase :line_line, pitch: :intervals do
        anchor "A4"
        intervals "0 +3 -3 +4 -4 +5 -5 +6 -6 +7 -7 +8 -8 +9 -9 +10"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
