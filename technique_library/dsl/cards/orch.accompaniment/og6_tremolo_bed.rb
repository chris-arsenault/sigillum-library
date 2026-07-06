production_piece "Technique Card OG6_TREMOLO_BED - OG6_TREMOLO_BED" do
  meter "4/4"
  key "c"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG6_TREMOLO_BED
# cite: orchestration_techniques:accompaniment
# behavior: agitated un-measured string tremolo bed (Vn1/Vn2/Va, Vc the fifth) trembling
#   i-bVI-iv-V-V-i under a rising clarinet; bed swells pp->f bar by bar (the crescendo engine),
#   poco sul pont. at the V for dread, timp roll reinforces; Cb bowed-sustains the root (no
#   muddy low trem); at the climax horn doubles the clarinet; b6 the tremble cedes to a
#   sustained tonic as the line resolves

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "OG6_TREMOLO_BED", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "agitated un-measured string tremolo bed (Vn1/Vn2/Va, Vc the fifth) trembling i-bVI-iv-V-V-i under a rising clarinet; bed swells pp->f bar by bar (the crescendo engine), poco sul pont. at the V for dread, timp roll reinforces; Cb bowed-sustains the root (no muddy low trem); at the climax horn doubles the clarinet; b6 the tremble cedes to a sustained tonic as the line resolves"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{mf,txt:teso_in_crescendo_d_agitazione} Ab4 Bb4 C5 | Eb5 C5 Eb5 | F5 Eb5 C5 | D5{txt:cresc.} F5 Ab5 | G5{f} F5 Ab5 | G5{txt:dim.} C5{mf,txt:risolve}"
        rhythm_bars "1 1 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | G4{f,txt:raddoppia_il_clar._al_culmine} F4 Ab4 | G4{txt:dim.} C4{mf}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 1 1 | 2 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb3{p,txt:sostenuto_lega_l_armonia} | Eb3 | Ab3 | D3{txt:cresc.} | D3{f} | Eb3{txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{pp,trem,txt:tremolo_(non_mis.)_cresc._poco_a_poco,cresc(} | Eb5{trem} | Ab5{trem} | D5{trem} | D5{f,trem,cresc),txt:poco_sul_pont._(orlo_di_paura)} | C5{mf,txt:dim.,txt:ord._trem._cede_a_sostenuto}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb5{pp,trem,cresc(} | C5{trem} | F5{trem} | B4{trem} | B4{f,trem,cresc)} | G4{mf,txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{pp,trem,cresc(} | Ab3{trem} | C4{trem} | G3{trem} | G3{f,trem,cresc)} | Eb4{mf,txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G3"
        intervals "0{pp,trem,cresc(} | -4{trem} | -3{trem} | +2{trem} | 0{f,trem,cresc)} | -2{mf,txt:dim.,txt:ord._sost.}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{pp,txt:arco_sost.} | Ab1 | F1 | G1{txt:cresc.} | G1{f} | C2{txt:dim.,txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G1{pp,trem,txt:rullo_cresc._al_f,cresc(} | G1{trem} | G1{f,trem,cresc)} | C1{mf,txt:tonica_poi_tace} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
