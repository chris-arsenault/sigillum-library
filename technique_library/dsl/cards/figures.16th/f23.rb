production_piece "Technique Card F23 - Hocketed Single Line" do
  meter "2/4"
  key "C"

# category: figures.16th
# card: F23
# title: Hocketed Single Line
# cite: 16th_note_figures:F23
# behavior: one melody is split between hands by hocket

  roster do
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F23", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "one melody is split between hands by hocket"

      phrase :lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4 r E4 r G4 r B4 r"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "r D4 r F4 r A4 r C5"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
