production_piece "Technique Card OG8_SWALLOWING_BG - OG8_SWALLOWING_BG" do
  meter "4/4"
  key "cm"

  tempo do
    mark "quarter = 80", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG8_SWALLOWING_BG
# cite: orchestration_techniques:accompaniment
# behavior: figure/ground inversion: a clear horn theme over a transparent pp bed is
#   progressively swallowed as the background accretes family-by-family (inner motion b2 ->
#   tremolo+winds b4 -> swelling horns b5 -> brass+pulse b6 -> timp roll+cymbal peak b7),
#   migrating up in register and crescendoing pp->ff until the mass rises over the tune and
#   absorbs it into its own octave-doublings

  roster do
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn_2_3, "Horn 2/3", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :cymbals, "Cymbals", music21: "Cymbals", family: :percussion, description: "Cymbals"
  end

  section :card, "OG8_SWALLOWING_BG", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "figure/ground inversion: a clear horn theme over a transparent pp bed is progressively swallowed as the background accretes family-by-family (inner motion b2 -> tremolo+winds b4 -> swelling horns b5 -> brass+pulse b6 -> timp roll+cymbal peak b7), migrating up in register and crescendoing pp->ff until the mass rises over the tune and absorbs it into its own octave-doublings"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{mp,txt:cantabile_il_tema} C5 | Eb5 D5 C5 | Eb5{mf} F5 Eb5 | D5 C5 Ab4 | Bb4{f} D5 F5 | G5 F5 D5 | E5{ff,txt:il_tema_sommerso} G5 | C6"
        rhythm_bars "2 2 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 2 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | D5{mp,txt:raddoppia_il_tema} C5 Ab4 | Bb4{mf} D5 F5 | G5{f} F5 D5 | E6{ff} G6 | C6"
        rhythm_bars "4 | 4 | 4 | 2 1 1 | 2 1 1 | 2 1 1 | 2 2 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{pp,txt:sost._trasparente} | G5 | Ab5{p,txt:cresc.} | Ab5 | G5{mf,txt:cresc.,trem} | G5{f,trem} | G5{ff,trem} | G5{ff,trem}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | Eb5{p,txt:moto_interno} D5 | C5{mp} Eb5 Ab4 C5 | F5{mp} Eb5 C5 Ab4 | D5{mf,trem} | D5{f,trem} | E5{ff,trem} | E5{ff,trem}"
        rhythm_bars "4 | 2 2 | 1 1 1 1 | 1 1 1 1 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | Eb4{p,txt:moto_interno} F4 | Ab4{mp} F4 | D4{mf,txt:pulsante} D4 G4 G4 | G4{f} G4 B4 B4 | C5{ff} C5 E5 E5 | C5 E5 G5 C5"
        rhythm_bars "4 | 4 | 2 2 | 2 2 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | [Ab4,C5]{mp,txt:sostenuto,txt:cresc.} | [B4,D5]{mf,txt:cresc.} | [B4,D5]{f} | [C5,E5]{ff} | [C5,E5]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | [G3,D4]{mf,txt:cresc._gonfiando,txt:cresc.} | [G3,D4]{f,txt:cresc.} | [G3,C4]{ff} | [G3,C4]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_2_3_line, part: :horn_2_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | [D5,G5]{f,txt:squillante,txt:cresc.} | [E5,G5]{ff} | [E5,C6]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | [G2,D3]{f,txt:cresc.} | [C3,G3]{ff} | [C3,G3]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C4"
        intervals "0{pp,txt:sost.} | 0 | -4{p,txt:cresc.} | -3{mp} | +9{mf,txt:pulsante} 0 -7 0 | 0{f} 0 +7 0 | -2{ff} 0 -5 0 | +9 0 -4 0"
        rhythm    "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{pp,txt:sost.} | C2 | Ab1{p} | F2{mp} | G1{mf,txt:cresc.,txt:cresc.} | G1{f,txt:cresc.} | C2{ff} | C2{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | C2{ff,txt:rullo,trem} | C2{ff,trem}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :cymbals_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | C5{ff,txt:piatti_l.v.} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :cymbals_line, part: :cymbals, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
