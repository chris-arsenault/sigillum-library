production_piece "Technique Card OT5_ADDITIVE_TUTTI - OT5_ADDITIVE_TUTTI" do
  meter "2/4"
  key "C"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT5_ADDITIVE_TUTTI
# cite: orchestration_techniques:tutti
# behavior: additive/terraced entry to tutti: fixed 2-bar cell over I-V ostinato, 4 passes
#   accreting family-by-family (b1-2 strings alone p / b3-4 strings complete mp / b5-6 +winds mf
#   / b7-8 +brass ff) - each entrance one dynamic louder + one register wider, melody re-doubled
#   every step, crown lands on a prepared bed

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT5_ADDITIVE_TUTTI", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "additive/terraced entry to tutti: fixed 2-bar cell over I-V ostinato, 4 passes accreting family-by-family (b1-2 strings alone p / b3-4 strings complete mp / b5-6 +winds mf / b7-8 +brass ff) - each entrance one dynamic louder + one register wider, melody re-doubled every step, crown lands on a prepared bed"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | G6{mf} A6 G6 E6 | C7 D7 E7 | G6{ff} A6 G6 E6 | C7 D7 E7"
        rhythm_bars "2 | 2 | 2 | 2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | G5{mf} A5 G5 E5 | C6 D6 E6 | G5{ff} A5 G5 E5 | C6 D6 E6"
        rhythm_bars "2 | 2 | 2 | 2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | [E4,G4]{mf} [D4,G4] | [E4,G4] [D4,B4] | [E4,G4]{ff} [D4,G4] | [E4,G4] [D4,B4]"
        rhythm_bars "2 | 2 | 2 | 2 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | C3{mf} B2 | C3 B2 | C3{ff} B2 | C3 B2"
        rhythm_bars "2 | 2 | 2 | 2 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | [C4,E4]{ff} [D4,G4] | [C4,E4] [D4,G4]"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2 | 1 1 | 1 1"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | G5{ff} A5 G5 E5 | C6 D6 E6"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | [G3,C4]{ff} [G3,D4] | [G3,C4] [G3,D4]"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2 | 1 1 | 1 1"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | C1{ff} G1 | C1 G1"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2 | 1 1 | 1 1"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{p} A4 G4 E4 | C5 D5 E5 | G4{mp} A4 G4 E4 | C5 D5 E5 | G5{mf} A5 G5 E5 | C6 D6 E6 | G5{ff} A5 G5 E5 | C6 D6 E6"
        rhythm_bars "1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G4{mp} A4 G4 E4 | C5 D5 E5 | G4{mf} A4 G4 E4 | C5 D5 E5 | G4{ff} A4 G4 E4 | C5 D5 E5"
        rhythm_bars "2 | 2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | [E4,G4]{mp} [D4,G4] | [E4,G4] [D4,B3] | [E4,G4]{mf} [D4,G4] | [E4,G4] [D4,B3] | [E4,G4]{ff} [D4,G4] | [E4,G4] [D4,B3]"
        rhythm_bars "2 | 2 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{p} -5 | +5 -5 | +5{mp} -5 | +5 -5 | +5{mf} -5 | +5 -5 | +5{ff} -5 | +5 -5"
        rhythm    "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | C2{mp} G1 | C2 G1 | C2{mf} G1 | C2 G1 | C2{ff} G1 | C2 G1"
        rhythm_bars "2 | 2 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
