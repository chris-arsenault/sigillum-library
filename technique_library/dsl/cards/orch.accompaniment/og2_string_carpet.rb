production_piece "Technique Card OG2_STRING_CARPET - OG2_STRING_CARPET" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 66", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG2_STRING_CARPET
# cite: orchestration_techniques:accompaniment
# behavior: sustained divisi string bed under a clear oboe melody; Vn2+Va animate inside with
#   neighbor motion + 4-3/suspension chains while Vn1/Vc move by common-tone (a breathing
#   carpet, not a dead pad); Cb pizz l.v. the floor; one <> swell at the V; oboe mf floats
#   clear, bed p/pp

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OG2_STRING_CARPET", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "sustained divisi string bed under a clear oboe melody; Vn2+Va animate inside with neighbor motion + 4-3/suspension chains while Vn1/Vc move by common-tone (a breathing carpet, not a dead pad); Cb pizz l.v. the floor; one <> swell at the V; oboe mf floats clear, bed p/pp"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mf,txt:cantabile_sopra_il_tappeto} F5 G5 | E5 F5 | A5{txt:cresc.} G5 F5 | F5{mp} A5 G5 | F5{mf,txt:cresc.} E5 | E5{txt:dim.} D5 C5 | D5{mp} F5 | E5{p,txt:morendo}"
        rhythm_bars "2 1 1 | 3 1 | 2 1 1 | 2 1 1 | 2 2 | 2 1 1 | 2 2 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{p,txt:sostenuto_senza_accento,cresc(} | C5{cresc)} | C5{p,cresc(} | C5 D5{cresc)} | D5{p,txt:cresc.} | C5{txt:dim.} | C5 D5{p} | C5{pp,txt:niente}"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 4 | 2 2 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{p} A4 | A4 | A4 G4 | A4 | B4{txt:cresc.} A4 | G4{txt:dim.} | A4 B4{p} | G4{pp}"
        rhythm_bars "2 2 | 4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{p} D4 E4 | E4 C4 | F4 E4 | F4 E4 D4 | D4{txt:cresc.} G3 | E4{txt:dim.} D4 C4 | D4 D4 | E4{pp}"
        rhythm_bars "2 1 1 | 2 2 | 2 2 | 1 1 2 | 2 2 | 2 1 1 | 2 2 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{p} | -3 | -4 | +9 | -7{txt:cresc.} +7 | -2{txt:dim.} | -7 +2 | +5{pp}"
        rhythm    "4 | 4 | 4 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{pp,txt:pizz._l.v.} r | A1{pp} r | F1{pp} r | D2{pp} r | G1{pp} r | C2{pp} r | D2{pp} r G1 r | C2{pp} r"
        rhythm_bars "1 3 | 1 3 | 1 3 | 1 3 | 1 3 | 1 3 | 1 1 1 1 | 1 3"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
