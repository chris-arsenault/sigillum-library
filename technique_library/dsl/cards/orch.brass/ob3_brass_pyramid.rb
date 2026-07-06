production_piece "Technique Card OB3_BRASS_PYRAMID - OB3_BRASS_PYRAMID" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB3_BRASS_PYRAMID
# cite: orchestration_techniques:brass
# behavior: additive brass pyramid: a D-maj add9 chord assembled bottom-up (tuba root ->
#   trombones -> horns -> trumpets crown), each entering at its own low dynamic and crescendoing
#   into one ff peak, then a top-down release (tuba holds last); the build is the event

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

  section :card, "OB3_BRASS_PYRAMID", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "additive brass pyramid: a D-maj add9 chord assembled bottom-up (tuba root -> trombones -> horns -> trumpets crown), each entering at its own low dynamic and crescendoing into one ff peak, then a top-down release (tuba holds last); the build is the event"

      phrase :trumpet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | F#5{f,txt:cresc} | F#5{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 3 1"
      end

      placement :trumpet_1_line, part: :trumpet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | D5{mf,txt:cresc} | D5{f} | D5{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 3 1"
      end

      placement :trumpet_2_line, part: :trumpet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | A4{mf,txt:cresc} | A4{f} | A4{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 3 1"
      end

      placement :trumpet_3_line, part: :trumpet_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | E4{mp,txt:cresc} | E4{f} | E4 | E4{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 5/2 3/2"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | F#4{mp,txt:cresc} | F#4{f} | F#4 | F#4{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 5/2 3/2"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | D4{p,txt:cresc} | D4{mf} | D4{f} | D4 | D4{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 5/2 3/2"
      end

      placement :horn_3_line, part: :horn_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_4_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | A3{p,txt:cresc} | A3{mf} | A3{f} | A3 | A3{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 5/2 3/2"
      end

      placement :horn_4_line, part: :horn_4, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | F#3{p,txt:cresc} | F#3 | F#3{mf} | F#3{f} | F#3 | F#3{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A2{p,txt:cresc} | A2 | A2{mf} | A2{f} | A2 | A2{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D2{pp,txt:cresc} | D2{p} | D2 | D2{mf} | D2{f} | D2 | D2{ff} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :trombone_3_line, part: :trombone_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "D1{ppp,txt:cresc} | D1{pp} | D1{p} | D1 | D1{mf} | D1{f} | D1 | D1{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | D2{pp,txt:roll} | D2{mp,txt:roll} | D2{mf,txt:roll} | D2{f,txt:roll} | D2{ff,txt:roll} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 3 1"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
