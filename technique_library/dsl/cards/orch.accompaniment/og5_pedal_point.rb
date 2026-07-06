production_piece "Technique Card OG5_PEDAL_POINT - OG5_PEDAL_POINT" do
  meter "4/4"
  key "cm"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG5_PEDAL_POINT
# cite: orchestration_techniques:accompaniment
# behavior: held dominant pedal G (Cb+Vc bowed, horn glow, timp roll from b.3) while winds+upper
#   strings move iv-bII-vii7/V-V7 rubbing against the unbudging tone; tension cresc p->f to the
#   culmine, harmony agrees at V7, pedal resolves G->C (i) at b.8

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "OG5_PEDAL_POINT", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "held dominant pedal G (Cb+Vc bowed, horn glow, timp roll from b.3) while winds+upper strings move iv-bII-vii7/V-V7 rubbing against the unbudging tone; tension cresc p->f to the culmine, harmony agrees at V7, pedal resolves G->C (i) at b.8"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{mp,txt:cantabile_sopra_il_pedale} Ab4 | Bb4 C5 | Db5{mf,txt:cresc.} C5 Bb4 | Ab4 F5{f,txt:appassionato} | Eb5 D5{txt:cresc.} | F5{f,txt:il_culmine} | Eb5{txt:dim.} D5 | C5{mf,txt:risolto}"
        rhythm_bars "2 2 | 2 2 | 2 1 1 | 2 2 | 2 2 | 4 | 2 2 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb4{p} | Db4 | Db4{txt:cresc.} F4 | Ab4{mf} | Ab4{txt:cresc.} Ab4 | Ab4{f} | F4{txt:dim.} Eb4 | Eb4{mf}"
        rhythm_bars "4 | 4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "Ab3{p} | F3 | F3{txt:cresc.} Ab3 | D4{mf} | D4{txt:cresc.} D4 | D4{f} | Bb3{txt:dim.} G3 | G3{mf}"
        rhythm_bars "4 | 4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{pp,txt:pedale_glow} | G3 | G3{txt:cresc.} | G3 | G3{txt:cresc.} | G3{mf} | G3{txt:dim.} | C3{p}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb5{p} | F5 | F5{txt:cresc.} Ab5 | Ab5{mf} | Ab5{txt:cresc.} Bb5 | B5{f} | D5{txt:dim.} C5 | C5{mf}"
        rhythm_bars "4 | 4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{p} | Db5 | Db5{txt:cresc.} D5 | F5{mf} | F5{txt:cresc.} F5 | F5{f} | Bb4{txt:dim.} G4 | G4{mf}"
        rhythm_bars "4 | 4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "Ab4{p} | F4 | F4{txt:cresc.} F4 | D4{mf} | D4{txt:cresc.} D4 | D4{f} | F4{txt:dim.} Eb4 | Eb4{mf}"
        rhythm_bars "4 | 4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{p,txt:pedale_sostenuto} | 0 | 0{txt:cresc.} | 0 | 0{txt:cresc.} | 0{f} | 0{txt:dim.} | +5{mf,txt:il_pedale_si_scioglie}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G1{p,txt:arco_pedale_(non_muovere_fino_b.8)} | G1 | G1{txt:cresc.} | G1 | G1{txt:cresc.} | G1{f} | G1{txt:dim.} | C2{mf}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G2{pp,txt:roll_cresc._poco_a_poco,trem} | G2{txt:cresc.,trem} | G2{txt:cresc.,trem} | G2{f,trem} | G2{txt:dim.,trem} | C2{mf,trem}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
