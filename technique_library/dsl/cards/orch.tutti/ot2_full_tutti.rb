production_piece "Technique Card OT2_FULL_TUTTI - OT2_FULL_TUTTI" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 60", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT2_FULL_TUTTI
# cite: orchestration_techniques:tutti
# behavior: full-force sustained tutti: melody tripled across 3 octaves + 3 families (Fl top /
#   Ob+Vn1 at pitch / Vn2 8ve, Tpt leaping to crown) so it cuts through; Hn harmonic glue-core,
#   Cl+Va close inner fill, Vc+Cb octaves + Tuba + Timp the pyramid bass; I-IV-V7-vi-IV-I, f ->
#   cresc swell (low brass terrace in b3) -> ff peak

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT2_FULL_TUTTI", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "full-force sustained tutti: melody tripled across 3 octaves + 3 families (Fl top / Ob+Vn1 at pitch / Vn2 8ve, Tpt leaping to crown) so it cuts through; Hn harmonic glue-core, Cl+Va close inner fill, Vc+Cb octaves + Tuba + Timp the pyramid bass; I-IV-V7-vi-IV-I, f -> cresc swell (low brass terrace in b3) -> ff peak"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "G6{f} A6 G6 E6 | F6 G6 A6 F6 | G6 F6 D6 G6 | E6 F6 G6 A6 | A6{ff} G6 F6 G6 | E6 C6"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{f} A5 G5 E5 | F5 G5 A5 F5 | G5 F5 D5 G5 | E5 F5 G5 A5 | A5{ff} G5 F5 G5 | E5 C5"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "[E4,G4]{f} | [F4,A4] | [F4,B4]{txt:cresc} [F4,G4] | [C5,E4] | [F4,A4]{ff} | [E4,G4]"
        rhythm_bars "4 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{f} | [C4,F4] | [B3,D4]{txt:cresc} [B3,F4] | [C4,E4] | [C4,F4]{ff} | [C4,E4]"
        rhythm_bars "4 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{f} A4 G4 E4 | F4 G4 A4 F4 | G5{txt:cresc} F5 D5 G5 | E5 F5 G5 A5 | A5{ff} G5 F5 G5 | E5 C5"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | [G3,B3]{f} [G3,D4] | [A3,E4] | [A3,C4]{ff} | [G3,C4]"
        rhythm_bars "4 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G1{f} | A1 | F1{ff} | C2"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G2{f,trem} | A2{trem} | G2{ff,trem} G2{trem} | C2{trem}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{f} A5 G5 E5 | F5 G5 A5 F5 | G5 F5 D5 G5 | E5 F5 G5 A5 | A5{ff} G5 F5 G5 | E5 C5"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{f} A4 G4 E4 | F4 G4 A4 F4 | G4 F4 D4 G4 | E4 F4 G4 A4 | A4{ff} G4 F4 G4 | E4 C4"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{f} | [C4,F4] | [B3,F4]{txt:cresc} [B3,G4] | [C4,E4] | [C4,F4]{ff} | [C4,G4]"
        rhythm_bars "4 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{f} 0 | -7 0 | +2{txt:cresc} 0 | +2 0 | -4{ff} +2 | +5"
        rhythm    "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{f} C2 | F1 F1 | G1{txt:cresc} G1 | A1 A1 | F1{ff} G1 | C2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
