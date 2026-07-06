production_piece "Technique Card P8_CASCADE_ALTERNATE - P8_CASCADE_ALTERNATE" do
  meter "4/4"
  key "C"

# category: piano
# card: P8_CASCADE_ALTERNATE
# cite: keyboard_figuration s6c
# behavior: hands alternate 16th groups four octaves down (waterfall), turn, ascend, land in
#   octaves

  roster do
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P8_CASCADE_ALTERNATE", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "hands alternate 16th groups four octaves down (waterfall), turn, ascend, land in octaves"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "E6 C6 A5 E5 r E5 C5 A4 E4 r | D4 F4 A4 D5 r D5 F5 A5 D6 r | E6 D6 C6 B5 r A5 G5 F5 E5 r | [A4,E5,A5] [G#4,E5,G#5] [A4,E5,A5]"
        rhythm_bars "1/4 1/4 1/4 1/4 1 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 1/4 1/4 1/4 1/4 1 | 2 1 1"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "r C5 A4 E4 C4 r C4 A3 E3 C3 | r F3 A3 D4 F4 r F4 A4 D5 F5 | r G5 F5 E5 D5 r C5 B4 A4 G#4 | [A1,A2] [E2,E3] [A1,A2]"
        rhythm_bars "1 1/4 1/4 1/4 1/4 1 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 1/4 1 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 1/4 1 1/4 1/4 1/4 1/4 | 2 1 1"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
