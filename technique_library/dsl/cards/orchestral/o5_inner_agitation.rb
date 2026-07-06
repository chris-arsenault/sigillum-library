production_piece "Technique Card O5_INNER_AGITATION - O5_INNER_AGITATION" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O5_INNER_AGITATION
# cite: keyboard_figuration s5
# behavior: outer voices hold; vn2+va animate in 8ths - neighbor motives, voice exchange,
#   suspension chains at changes

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "O5_INNER_AGITATION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "outer voices hold; vn2+va animate in 8ths - neighbor motives, voice exchange, suspension chains at changes"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{p} | D5 E5 | F5 | E5 | F5 | G5 F5 | E5 | D5"
        rhythm_bars "4 | 2 2 | 4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{p} G4 F4 E4 F4 A4 G4 | A4 Bb4 A4 G4 A4 G4 | A4 G4 F4 G4 A4 Bb4 A4 G4 | G4 A4 Bb4 C5 Bb4 A4 G4 | Bb4 A4 G4 A4 Bb4 C5 D5 C5 Bb4 A4 G4 | C5 Bb4 A4 Bb4 C5 Bb4 A4 G4 | Bb4 A4 G4 A4 Bb4 C5 | C5 Bb4 A4 G4 F4"
        rhythm_bars "1/2 1/2 1/4 1/4 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/4 1/4 1/2 1/2 1 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1 | 1/4 1/4 1/4 1/4 1/2 1/2 1 1 | 1 1/2 1/2 1/2 1/2 1 | 1 1/2 1/2 1 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{p} Bb3 A3 G3 A3 | F3 G3 A3 Bb3 C4 Bb3 C4 | D4 C4 Bb3 C4 D4 C#4 | D4 E4 D4 C#4 D4 E4 D4 | D4 E4 F4 E4 D4 C4 Bb3 C4 D4 E4 D4 | E4 D4 C4 D4 E4 D4 C#4 D4 | C4 Bb3 A3 Bb3 C#4 D4 | D4 C4 Bb3 A3 A3 D4"
        rhythm_bars "1 1/2 1/2 1 1 | 1/2 1/4 1/4 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1 1/4 1/4 1/4 1/4 1 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1 | 1/4 1/4 1/4 1/4 1/2 1/2 1 1 | 1 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0{p} | 0 | -4 | -1 | +1 | -3 | +2 +12 | -7"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
