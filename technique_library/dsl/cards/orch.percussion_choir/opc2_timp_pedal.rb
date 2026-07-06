production_piece "Technique Card OPC2_TIMP_PEDAL - OPC2_TIMP_PEDAL" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 66", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC2_TIMP_PEDAL
# cite: orchestration_techniques:percussion_choir
# behavior: timp D+A as harmonic floor: a measured dominant pedal cell (dactyl -> 8ths, the
#   intensity dial) then a 16th roll pp->ff landing a single tonic stroke; Vc/Cb double the
#   root, horns hold V->I, all cut after the arrival

  roster do
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OPC2_TIMP_PEDAL", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "timp D+A as harmonic floor: a measured dominant pedal cell (dactyl -> 8ths, the intensity dial) then a 16th roll pp->ff landing a single tonic stroke; Vc/Cb double the root, horns hold V->I, all cut after the arrival"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{p,txt:timp._D+A_pedal_on_the_dominant} A2 A2 A2 | A2{mp} A2 A2 A2 | A2{mf} A2 A2 A2 A2 A2 A2 | A2 A2 A2 A2 A2 A2 A2 A2 | A2{pp,txt:roll_16ths_soft_felt_cresc._al_ff,cresc(} A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2{cresc)} | D2{ff,marc,txt:tonic_stroke_wood_then_cut} r"
        rhythm_bars "2 1/2 1/2 1 | 2 1/2 1/2 1 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1 3"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "[A3,C#4,E4]{p,txt:horns_-_V_chord_over_the_pedal} | [A3,C#4,E4]{mp} | [A3,C#4,E4]{mf} | [A3,C#4,E4]{f,cresc(} | [A3,C#4,E4]{cresc)} | [D4,F#4,A4]{ff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{p,txt:double_the_timp_pedal} | 0{mp} | 0{mf} | 0{f,cresc(} | 0 | -7{ff,marc,cresc)} r"
        rhythm    "4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{p} | A1{mp} | A1{mf} | A1{f} | A1 | D2{ff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
