production_piece "Technique Card OA3_FAMILY_RELAY - OA3_FAMILY_RELAY" do
  meter "3/4"
  key "D"

  tempo do
    mark "quarter = 92", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA3_FAMILY_RELAY
# cite: orchestration_techniques:antiphony
# behavior: one compact head-motive relayed family->family->family, register/material identical
#   so only color changes (Klangfarben relay): winds (Ob+Cl 8ve) state it over a soft string
#   pad, brass (2 Hn) answer, strings (Vn1+Vn2) answer with low-wind pad; the motive climbs a
#   3rd on pass 2, then all three families dovetail a soft V-I cadence; Andantino

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OA3_FAMILY_RELAY", bars: 1..7, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..7, texture: :library_card do
      process "one compact head-motive relayed family->family->family, register/material identical so only color changes (Klangfarben relay): winds (Ob+Cl 8ve) state it over a soft string pad, brass (2 Hn) answer, strings (Vn1+Vn2) answer with low-wind pad; the motive climbs a 3rd on pass 2, then all three families dovetail a soft V-I cadence; Andantino"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | A6{mp} A6"
        rhythm_bars "9 | 3 | 3 | 3 | 1 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{mp} B5 D6 C#6 | r | r | C#6{mp} D6 F#6 E6 | r | r | F#6{mp} A6 A6"
        rhythm_bars "1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} B4 D5 C#5 | r | r | C#5{mp} D5 F#5 E5 | r | r | D5{mp} F#5 F#5"
        rhythm_bars "1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D3{pp} | r | r | A2{pp} | A2{mp} D3"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3 | 1 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | A4{mf} B4 D5 C#5 | r | r | C#5{mf} D5 F4 E4 | r | A4{mf} B4 A4"
        rhythm_bars "3 | 1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 1 1 | 3 | 1/2 1/2 2"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | F#4{mf} G4 A4 A4 | r | r | A4{mf} B4 D5 C#5 | r | F#4{mf} G4 F#4"
        rhythm_bars "3 | 1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 1 1 | 3 | 1/2 1/2 2"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A5{mp} B5 D6 C#6 | r | r | C#6{mp} D6 F#6 E6 | A6{mp} B6 A6"
        rhythm_bars "3 | 3 | 1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 1 1 | 1/2 1/2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | F#5{mp} G5 A5 A5 | r | r | A5{mp} B5 D6 C#6 | F#6{mp} G6 F#6"
        rhythm_bars "3 | 3 | 1/2 1/2 1 1 | 3 | 3 | 1/2 1/2 1 1 | 1/2 1/2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{pp} | A4 | r | D5{pp} | D5 | r | A4{mp} A4"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3 | 1 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{pp} | 0 | r | -7{pp} | +2 | r | 0{mp} +5"
        rhythm    "3 | 3 | 3 | 3 | 3 | 3 | 1 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{pp} | D2 | r | G1{pp} | A1 | r | A1{mp} D2"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3 | 1 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
