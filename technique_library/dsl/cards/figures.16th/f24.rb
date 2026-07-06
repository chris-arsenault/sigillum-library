production_piece "Technique Card F24 - Thumb-Melody Rail" do
  meter "3/4"
  key "C"

# category: figures.16th
# card: F24
# title: Thumb-Melody Rail
# cite: 16th_note_figures:F24
# behavior: thumb melody is embedded under upper flicker

  roster do
    part :upper_figuration, "Upper figuration", music21: "Piano", family: :keyboard, description: "Piano"
    part :thumb_melody, "Thumb melody", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F24", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "thumb melody is embedded under upper flicker"

      phrase :upper_figuration_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5 G5 F5 A5 F5 A5 G5 B5 G5 B5 A5 C6"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :upper_figuration_line, part: :upper_figuration, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :thumb_melody_line, pitch: :degrees do
        key_context "C4"
        degrees "1 r r r 2 r r r 3 r r r"
        rhythm  "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :thumb_melody_line, part: :thumb_melody, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
