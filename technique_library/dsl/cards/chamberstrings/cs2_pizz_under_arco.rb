production_piece "Technique Card CS2_PIZZ_UNDER_ARCO - CS2_PIZZ_UNDER_ARCO" do
  meter "6/8"
  key "D"

  tempo do
    mark "quarter = 96", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: CS2_PIZZ_UNDER_ARCO
# cite: strings
# behavior: one arco line over 3 pizz voices: cello oom-bass, viola off-beat pah-pah, Vn2 high
#   counter-pluck sparkle. D-major 6/8 serenade idiom

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "CS2_PIZZ_UNDER_ARCO", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "one arco line over 3 pizz voices: cello oom-bass, viola off-beat pah-pah, Vn2 high counter-pluck sparkle. D-major 6/8 serenade idiom"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp,txt:arco_dolce} B4 A4 F#4 | G4 A4 B4 A4 | A4 B4 C#5 D5 C#5 B4 | A4 F#4 A4 | D5 C#5 B4 A4 | B4 A4 G4 F#4 | A4 G4 F#4 E4 F#4 G4 | F#4 E4 D4"
        rhythm_bars "1 1/2 1 1/2 | 1 1/2 1 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 3/2 1/2 1 | 1 1/2 1 1/2 | 1 1/2 1 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 3/2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r D5{txt:pizz.} r A4 | r B4 r D5 | r E5 | r D5 r A4 | r F#5 r D5 | r D5 r B4 | r C#5 r E5 | r A4 r D5"
        rhythm_bars "3/2 1/2 1/2 1/2 | 3/2 1/2 1/2 1/2 | 5/2 1/2 | 3/2 1/2 1/2 1/2 | 3/2 1/2 1/2 1/2 | 3/2 1/2 1/2 1/2 | 3/2 1/2 1/2 1/2 | 3/2 1/2 1/2 1/2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r F#3{txt:pizz.} A3 r F#3 A3 | r G3 B3 r G3 B3 | r E3 A3 r E3 A3 | r F#3 A3 r F#3 A3 | r F#3 B3 r F#3 B3 | r G3 B3 r G3 B3 | r G3 C#4 r G3 E4 | r F#3 A3 r A3 r"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0{txt:pizz.} r +7 r | -2 r +7 r | -5 r +7 r | -14 r +7 r | +2 r +7 r | -11 r +2 r | 0 r +7 r | -7 r -7 r"
        rhythm    "1/2 1 1/2 1 | 1/2 1 1/2 1 | 1/2 1 1/2 1 | 1/2 1 1/2 1 | 1/2 1 1/2 1 | 1/2 1 1/2 1 | 1/2 1 1/2 1 | 1/2 1 1/2 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
