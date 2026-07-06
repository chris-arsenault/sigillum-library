production_piece "Technique Card OB7_LOW_BRASS_FLOOR - OB7_LOW_BRASS_FLOOR" do
  meter "4/4"
  key "B-"

  tempo do
    mark "quarter = 48", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB7_LOW_BRASS_FLOOR
# cite: orchestration_techniques:brass
# behavior: low-brass weight FLOOR: tuba (sub-woofer) sustains a B- pedal under bass-tbn 5th +
#   open tbn octaves (b1-4), then a slow octave-doubled descending bass line (root-7th-6th-5th);
#   a sparse horn frame moves I-IV-V-I above; octaves & open 5ths only, no thirds below the
#   staff; tuba resolves alone ppp; Grave

  roster do
    part :trombone_1, "Trombone 1", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_2, "Trombone 2", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_3, "Trombone 3", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
  end

  section :card, "OB7_LOW_BRASS_FLOOR", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "low-brass weight FLOOR: tuba (sub-woofer) sustains a B- pedal under bass-tbn 5th + open tbn octaves (b1-4), then a slow octave-doubled descending bass line (root-7th-6th-5th); a sparse horn frame moves I-IV-V-I above; octaves & open 5ths only, no thirds below the staff; tuba resolves alone ppp; Grave"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "F3{f} | F3 | F3 | F3 | Bb3 | Bb3 | F3 | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb2{f} | Bb2 | Bb2 | Bb2 | F3 | F3 Eb3 | C3 | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "F2{f} | F2 | F2 | F2 | Bb2 | Ab2 G2 | F2 | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :trombone_3_line, part: :trombone_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb1{f} | Bb1 | Bb1 | Bb1 | Bb1 | Ab1 G1 | F1 | Bb1{ppp}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mp} | Eb4 F4 | F4 | D4 | F4 | Eb4 D4 | C4 | D4{pp}"
        rhythm_bars "4 | 2 2 | 4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
