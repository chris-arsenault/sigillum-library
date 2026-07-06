production_piece "Technique Card F20 - Chord-Tone Run With Passing Cracks" do
  meter "4/4"
  key "C"

# category: figures.16th
# card: F20
# title: Chord-Tone Run With Passing Cracks
# cite: 16th_note_figures:F20
# behavior: chord tones are cracked open by passing notes so harmony reads as line

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F20", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "chord tones are cracked open by passing notes so harmony reads as line"

      phrase :line_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +2 +2 +3 -3 +1 +2 +5 -5 +2 +1 +2 0 +2 +2 +3"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
