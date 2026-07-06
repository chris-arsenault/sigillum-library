production_piece "Technique Card OB1_BRASS_CHOIR - OB1_BRASS_CHOIR" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 56", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB1_BRASS_CHOIR
# cite: orchestration_techniques:brass
# behavior: brass-choir blend voicing: tpts top, 4 horns the blend-core middle binding the
#   timbral seams, tbns+tuba open weight; 2 horns per tpt for forte balance; I-vi-IV-V

  roster do
    part :trumpet_1, "Trumpet 1", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_2, "Trumpet 2", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :horn_3, "Horn 3", music21: "Horn", family: :brass, description: "Horn"
    part :horn_4, "Horn 4", music21: "Horn", family: :brass, description: "Horn"
    part :trombone_1, "Trombone 1", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_2, "Trombone 2", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_3, "Trombone 3", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
  end

  section :card, "OB1_BRASS_CHOIR", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "brass-choir blend voicing: tpts top, 4 horns the blend-core middle binding the timbral seams, tbns+tuba open weight; 2 horns per tpt for forte balance; I-vi-IV-V"

      phrase :trumpet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf} E5 | D5 C#5 | D5 B4 | E5"
        rhythm_bars "3 1 | 2 2 | 2 2 | 4"
      end

      placement :trumpet_1_line, part: :trumpet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mf} | B4 | B4 A4 | C#5"
        rhythm_bars "4 | 4 | 2 2 | 4"
      end

      placement :trumpet_2_line, part: :trumpet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{f} G4 | F#4 | G4 | A4"
        rhythm_bars "2 2 | 4 | 4 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#4{f} | D4 | D4 | E4"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mf} | B3 C#4 | B3 | C#4"
        rhythm_bars "4 | 2 2 | 4 | 4"
      end

      placement :horn_3_line, part: :horn_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_4_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{f} | F#3 | G3 | A3"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :horn_4_line, part: :horn_4, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{f} | F#3 | G3 | A3"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{f} | D3 | D3 | E3"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{f} | F#2 | G2 | A2"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :trombone_3_line, part: :trombone_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "D1{f} | B1 | G1 | A1"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
