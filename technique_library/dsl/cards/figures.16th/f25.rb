production_piece "Technique Card F25 - Tenor Melody Under High Glitter" do
  meter "4/4"
  key "E"

# category: figures.16th
# card: F25
# title: Tenor Melody Under High Glitter
# cite: 16th_note_figures:F25
# behavior: tenor melody projects below fast high figuration

  roster do
    part :lh_tenor, "LH tenor", music21: "Piano", family: :keyboard, description: "Piano"
    part :rh_halo, "RH halo", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F25", bars: 1..1, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..1, texture: :library_card do
      process "tenor melody projects below fast high figuration"

      phrase :lh_tenor_line, surface: :split_pitch_rhythm do
        pitch_bars  "E3 F3 G3 A3"
        rhythm_bars "1 1 1 1"
      end

      placement :lh_tenor_line, part: :lh_tenor, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :rh_halo_line, surface: :split_pitch_rhythm do
        pitch_bars  "B5 C6 B5 D6 C6 D6 C6 E6 r r r r r r r r"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :rh_halo_line, part: :rh_halo, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
