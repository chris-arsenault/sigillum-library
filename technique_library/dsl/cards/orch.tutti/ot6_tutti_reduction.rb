production_piece "Technique Card OT6_TUTTI_REDUCTION - OT6_TUTTI_REDUCTION" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 66", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT6_TUTTI_REDUCTION
# cite: orchestration_techniques:tutti
# behavior: reverse of accretion: open near-tutti on I, peel one family/layer per bar in a
#   composed decay (crown+edge -> upper 8ve+wind dbls -> bass weight -> chamber core), each cut
#   exposing the layer beneath; dynamic terraces ff->pp, ending revealed on a solo oboe holding
#   the tonic, broadening to settle

  roster do
    part :piccolo, "Piccolo", music21: "Piccolo", family: :woodwind, description: "Piccolo"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :violin_i_upper_8ve, "Violin I (upper 8ve)", music21: "Violin", family: :string, description: "Violin"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT6_TUTTI_REDUCTION", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "reverse of accretion: open near-tutti on I, peel one family/layer per bar in a composed decay (crown+edge -> upper 8ve+wind dbls -> bass weight -> chamber core), each cut exposing the layer beneath; dynamic terraces ff->pp, ending revealed on a solo oboe holding the tonic, broadening to settle"

      phrase :piccolo_line, surface: :split_pitch_rhythm do
        pitch_bars  "G6{ff} E6 | r | r | r | r | r"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4"
      end

      placement :piccolo_line, part: :piccolo, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff} F5 E5 D5 | G5{f} E5 | r | r | r | r"
        rhythm_bars "1 1 1 1 | 2 2 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff} F5 E5 D5 | C5{f} E5 | r | r | r | C5{pp,txt:solo_broaden}"
        rhythm_bars "1 1 1 1 | 2 2 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "[E4,G4]{ff} | [F4,A4]{f} | [D4,G4]{mf} | [C4,G4]{mp} | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{ff} C3 | F2{f} F2 | G2{mf} | r | r | r"
        rhythm_bars "2 2 | 2 2 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{ff} | [C4,F4]{f} | [B3,F4]{mf} | [C4,E4]{mp} | [C4,E4]{p} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff} E5 | r | r | r | r | r"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{ff} [C4,G4] | r | r | r | r | r"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{ff} C2 | r | r | r | r | r"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{ff,trem} C2{trem} | r | r | r | r | r"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_upper_8ve_line, surface: :split_pitch_rhythm do
        pitch_bars  "G6{ff} F6 E6 D6 | G6{f} E6 | r | r | r | r"
        rhythm_bars "1 1 1 1 | 2 2 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_upper_8ve_line, part: :violin_i_upper_8ve, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff} F5 E5 D5 | C5{f} E5 | G5{mf} F5 E5 C5 | D5{mp} E5 | G5{p} E5 D5 | r"
        rhythm_bars "1 1 1 1 | 2 2 | 1 1 1 1 | 2 2 | 2 1 1 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{ff} | [C4,F4]{f} | [B3,D4]{mf} | E4{mp} | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{ff} 0 | -7{f} 0 | +2{mf} | +5{mp} | 0{p} | r"
        rhythm    "2 2 | 2 2 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{ff} C2 | F1{f} F1 | G1{mf} | r | r | r"
        rhythm_bars "2 2 | 2 2 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
