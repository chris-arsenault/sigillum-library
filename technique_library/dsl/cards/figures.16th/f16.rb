production_piece "Technique Card F16 - Pedal Around A Gap" do
  meter "3/4"
  key "A"

# category: figures.16th
# card: F16
# title: Pedal Around A Gap
# cite: 16th_note_figures:F16
# behavior: low anchor alternates with thrown upper notes across a register gap

  roster do
    part :line, "Line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F16", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "low anchor alternates with thrown upper notes across a register gap"

      phrase :line_line, pitch: :intervals do
        anchor "A2"
        intervals "0 +14 -14 +15 -15 +17 -17 +19 -31 +32 -32 +34"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :line_line, part: :line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
