production_piece "Technique Card F21 - Alternating-Hand Cascade" do
  meter "2/4"
  key "C"

# category: figures.16th
# card: F21
# title: Alternating-Hand Cascade
# cite: 16th_note_figures:F21
# behavior: register jump and hand alternation become the figure

  roster do
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F21", bars: 1..2, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..2, texture: :library_card do
      process "register jump and hand alternation become the figure"

      phrase :lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2 D2 E2 F2 r r r r | B1 C2 D2 E2 r r r r"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "r r r r G4 A4 B4 C5 | r r r r F4 G4 A4 B4"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
