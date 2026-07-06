production_piece "Technique Card OT4_ORCH_PYRAMID - OT4_ORCH_PYRAMID" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 54", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT4_ORCH_PYRAMID
# cite: orchestration_techniques:tutti
# behavior: sustained tutti cadence I-V7-V7-I voiced as a bass-heavy weight pyramid: heavy
#   doubled root/fifth octaves low, thirds/fifth closing in the middle, single doubled melody as
#   the lean crown; 7th of V7 kept high, bass broadens to C1 at the final I; equal f - spacing
#   does the work

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT4_ORCH_PYRAMID", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "sustained tutti cadence I-V7-V7-I voiced as a bass-heavy weight pyramid: heavy doubled root/fifth octaves low, thirds/fifth closing in the middle, single doubled melody as the lean crown; 7th of V7 kept high, bass broadens to C1 at the final I; equal f - spacing does the work"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "C6{f} E6 | D6{f} B5 | D6{f} G6 | E6{f} C6"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{f} | F4{f} | F4{f} | E4{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G3,C4]{f} | [G3,B3]{f} | [F4,B3]{f} | [G3,C4]{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{f} | D5{f} | F5{f} | E5{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G3,E3]{f} | [G3,D3]{f} | [G3,D3]{f} | [G3,E3]{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{f} | G2{f} | G2{f} | C3{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{f} | G2{f} | G2{f} | C2{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "C6{f} E6 | D6{f} B5 | D6{f} G6 | E6{f} C6"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{f} | [B3,D4]{f} | [B3,D4]{f} | [C4,E4]{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{f} | +7{f} | 0{f} | -7{f}"
        rhythm    "4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{f} | G1{f} | G1{f} | C1{f}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
