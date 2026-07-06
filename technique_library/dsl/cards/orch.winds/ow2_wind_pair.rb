production_piece "Technique Card OW2_WIND_PAIR - OW2_WIND_PAIR" do
  meter "3/4"
  key "F"

  tempo do
    mark "quarter = 76", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW2_WIND_PAIR
# cite: orchestration_techniques:winds
# behavior: 2 oboes carry a lyric tune in parallel 3rds (b1-4) widening to 6ths at the cadence
#   (b5-6) - one fused harmonized line; 2 clarinets sustain soft tenor harmony, bassoon a quiet
#   bass on beat 1

  roster do
    part :oboe_1, "Oboe 1", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :oboe_2, "Oboe 2", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet_1, "Clarinet 1", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :clarinet_2, "Clarinet 2", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "OW2_WIND_PAIR", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "2 oboes carry a lyric tune in parallel 3rds (b1-4) widening to 6ths at the cadence (b5-6) - one fused harmonized line; 2 clarinets sustain soft tenor harmony, bassoon a quiet bass on beat 1"

      phrase :oboe_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{txt:mp_dolce} C5 F5 | D5{mf} Bb4 | C5 E5 G5 | F5 D5{mp} | Bb4 A4 G4 | C5 r"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 2 1"
      end

      placement :oboe_1_line, part: :oboe_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{txt:mp_dolce} A4 D5 | Bb4{mf} G4 | A4 C5 E5 | D5 Bb4{mp} | D4 C4 Bb3 | E4 r"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 2 1"
      end

      placement :oboe_2_line, part: :oboe_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{p} | D4 | E4 | F4 | D4 | E4 r"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 2 1"
      end

      placement :clarinet_1_line, part: :clarinet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{p} | Bb3 | G3 | A3 | Bb3 | G3 r"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 2 1"
      end

      placement :clarinet_2_line, part: :clarinet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "F2{p} r | Bb2 r | C3 r | D3 r | G2 r | C3 r"
        rhythm_bars "1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
