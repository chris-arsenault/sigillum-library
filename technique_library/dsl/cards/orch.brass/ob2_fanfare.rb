production_piece "Technique Card OB2_FANFARE - OB2_FANFARE" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 80", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB2_FANFARE
# cite: orchestration_techniques:brass
# behavior: fanfare idiom: triadic harmonic-series calls in heroic dotted rhythm on I-V; tpts
#   1-3 lead, horns answer the call an octave below then double, tbn+tuba+timp hammer root/5th
#   on strong beats; ff Maestoso

  roster do
    part :trumpet_1, "Trumpet 1", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_2, "Trumpet 2", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_3, "Trumpet 3", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :horn_3, "Horn 3", music21: "Horn", family: :brass, description: "Horn"
    part :horn_4, "Horn 4", music21: "Horn", family: :brass, description: "Horn"
    part :trombone_1, "Trombone 1", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_2, "Trombone 2", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_3, "Trombone 3", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "OB2_FANFARE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "fanfare idiom: triadic harmonic-series calls in heroic dotted rhythm on I-V; tpts 1-3 lead, horns answer the call an octave below then double, tbn+tuba+timp hammer root/5th on strong beats; ff Maestoso"

      phrase :trumpet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{ff,marc} F#5 A5 D6 | A5{marc} C#6 E6 D6 | D6{txt:dim.} C#6 | B5 A5 | D5{ff,marc} F#5 A5 D6 | D6{txt:dim.} r r"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :trumpet_1_line, part: :trumpet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{ff,marc} D5 F#5 A5 | E5{marc} A5 C#6 A5 | A5{txt:dim.} A5 | G5 F#5 | A4{ff,marc} D5 F#5 A5 | A5{txt:dim.} r r"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :trumpet_2_line, part: :trumpet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#4{ff,marc} A4 D5 F#5 | C#5{marc} E5 A5 F#5 | F#5{txt:dim.} E5 | D5 D5 | F#4{ff,marc} A4 D5 F#5 | F#5{txt:dim.} r r"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :trumpet_3_line, part: :trumpet_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{f} A4 | A4 E5 | D4{f,marc} F#4 A4 D5 | A4{marc} C#5 E5 A4 | D4{ff,marc} F#4 A4 D5 | D5{txt:dim.} r r"
        rhythm_bars "2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{f} F#4 | F#4 C#5 | A3{f,marc} D4 F#4 A4 | E4{marc} A4 C#5 E4 | A3{ff,marc} D4 F#4 A4 | A4{txt:dim.} r r"
        rhythm_bars "2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#3{f} D4 | D4 A4 | F#3{f,marc} A3 D4 F#4 | C#4{marc} E4 A4 C#4 | F#3{ff,marc} A3 D4 F#4 | F#4{txt:dim.} r r"
        rhythm_bars "2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :horn_3_line, part: :horn_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_4_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{f} A3 | A3 A3 | D3{f,marc} A3 D4 F#4 | A3{marc} A3 A4 A4 | D3{ff,marc} A3 D4 F#4 | D4{txt:dim.} r r"
        rhythm_bars "2 2 | 2 2 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 2"
      end

      placement :horn_4_line, part: :horn_4, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{f,marc} r A3{marc} r | E4{marc} r E4{marc} r | A3{marc} r A3{marc} r | A3{marc} r A3{marc} r | A3{ff,marc} r A3{marc} r | A3{txt:dim.} r r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{f,marc} r D3{marc} r | A3{marc} r A3{marc} r | D3{marc} r D3{marc} r | D3{marc} r D3{marc} r | D3{ff,marc} r D3{marc} r | D3{txt:dim.} r r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{f,marc} r A2{marc} r | A2{marc} r E3{marc} r | D2{marc} r A2{marc} r | D2{marc} r A2{marc} r | D2{ff,marc} r A2{marc} r | D2{txt:dim.} r r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :trombone_3_line, part: :trombone_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "D1{f,marc} r A1{marc} r | A1{marc} r A1{marc} r | D1{marc} r A1{marc} r | D1{marc} r A1{marc} r | D1{ff,marc} r A1{marc} r | D1{txt:dim.} r r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{f,marc} r A2{marc} r | A2{marc} r A2{marc} r | D2{marc} r D2 D2 r | A2{marc} r A2 A2 r | D2{ff} D2 A2 A2 D2{txt:roll} A2 | D2{ff,txt:roll} r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1/2 1/2 1 | 1 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 2 2"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
