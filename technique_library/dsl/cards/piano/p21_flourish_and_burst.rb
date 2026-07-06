production_piece "Technique Card P21_FLOURISH_AND_BURST - P21_FLOURISH_AND_BURST" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: piano
# card: P21_FLOURISH_AND_BURST
# cite: sixteenth_deployment
# behavior: 16ths as a rationed DEVICE inside a long-value line -- a chromatic 16th anacrusis
#   flourish launching a structural note, a fioritura turn decorating a held tone, an
#   intensification BURST (both hands surge to chromatic 16ths) that erupts then settles

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P21_FLOURISH_AND_BURST", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "16ths as a rationed DEVICE inside a long-value line -- a chromatic 16th anacrusis flourish launching a structural note, a fioritura turn decorating a held tone, an intensification BURST (both hands surge to chromatic 16ths) that erupts then settles"

      phrase :piano_rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4 G4 E4 F#4 G4 G#4 | A4 A4 Bb4 A4 G#4 A4 C5 | D5 C5 A4 | Bb4 B4 C5 C#5 D5 E5 F5 G5 A5 G5 F5 E5 | D5 C5 A4 | A4 G4 F4"
        rhythm_bars "5/2 1/2 1/4 1/4 1/4 1/4 | 2 1/4 1/4 1/4 1/4 1/2 1/2 | 3/2 1/2 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 2 3/2 1/2 | 1 1 2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :piano_lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3 D3 F3 A3 C4 A3 F3 D3 A2 | F2 A2 C3 F3 E3 F3 G3 A3 G#3 A3 Bb3 A3 C4 A3 | Bb2 D3 F3 A3 Bb3 Bb3 A3 G3 E3 Eb3 D3 C3 E3 A3 C4 | G2 A2 Bb2 B2 C3 C#3 D3 E3 F3 G3 A3 Bb3 A3 G3 F3 E3 | D3 A2 F2 D2 A2 Bb2 D3 F3 A3 G3 F3 E3 D3 | A2 E3 F2"
        rhythm_bars "2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/4 1/4 1/2 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1 1 2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
