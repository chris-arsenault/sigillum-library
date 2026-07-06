production_piece "Technique Card CS4_RECITATIVE - CS4_RECITATIVE" do
  meter "4/4"
  key "d"

  tempo do
    mark "quarter = 50", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: CS4_RECITATIVE
# cite: strings
# behavior: one voice declaims (reciting tones, held stresses, breaths, a leap outburst); the
#   trio punctuates with sparse chords in the gaps. D-minor largo recit idiom

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "CS4_RECITATIVE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "one voice declaims (reciting tones, held stresses, breaths, a leap outburst); the trio punctuates with sparse chords in the gaps. D-minor largo recit idiom"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mf,txt:recit._declamato} A4 A4 Bb4 A4 F4 E4 | r A4 A4 G4 F4 E4 D4 | r D4 E4 F4 G4 A4 Bb4 | D5{f,txt:appassionato} C#5 D5 A4 | r F4 F4 E4 F4 E4 D4 | A4 Bb4 A4 G4 F4 E4 | r D4 E4 F4 E4 D4 C#4 D4 | E4 F4 E4 D4"
        rhythm_bars "1/2 1/4 1/4 1/2 1/2 1 1 | 1/2 1/4 1/4 1/2 1/2 1/2 3/2 | 1 1/4 1/4 1/2 1/2 1/2 1 | 2 1/2 1/2 1 | 1 1/2 1/4 1/4 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/4 1/4 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 5/2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{pp} r | Bb4 r A4 | C#5 r | F4 | A4 r | Bb4 C#5 | r C#5 | A4"
        rhythm_bars "2 2 | 3/2 1 3/2 | 1 3 | 4 | 1 3 | 2 2 | 2 2 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp} r | G4 r F4 | E4 r | D4 | F4 r | G4 E4 | r E4 | F4"
        rhythm_bars "2 2 | 3/2 1 3/2 | 1 3 | 4 | 1 3 | 2 2 | 2 2 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0{pp} r | +5 r -5 | +7 r | +1 | -8 r | +5 +2 | r 0 | -7"
        rhythm    "2 2 | 3/2 1 3/2 | 1 3 | 4 | 1 3 | 2 2 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
