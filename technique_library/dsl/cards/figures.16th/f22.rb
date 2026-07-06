production_piece "Technique Card F22 - Contrary-Motion Cascade" do
  meter "2/4"
  key "C"

# category: figures.16th
# card: F22
# title: Contrary-Motion Cascade
# cite: 16th_note_figures:F22
# behavior: two hands run 16ths in contrary motion so space expands or contracts

  roster do
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F22", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "two hands run 16ths in contrary motion so space expands or contracts"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5 D5 E5 F5 G5 A5 B5 C6"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3 B2 A2 G2 F2 E2 D2 C2"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
