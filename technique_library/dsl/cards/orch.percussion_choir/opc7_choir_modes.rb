production_piece "Technique Card OPC7_CHOIR_MODES - OPC7_CHOIR_MODES" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 76", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC7_CHOIR_MODES
# cite: orchestration_techniques:percussion_choir
# behavior: wordless legato 'ah' vocalise (SATB, soft, floating over a sul-tasto string/wind
#   halo) contrasted against a marked syllabic declaimed passage (SATB, hard marc attacks,
#   driven by timp + low strings)

  roster do
    part :soprano, "Soprano", music21: "Soprano", family: :voice, description: "Soprano"
    part :alto, "Alto", music21: "Alto", family: :voice, description: "Alto"
    part :tenor, "Tenor", music21: "Tenor", family: :voice, description: "Tenor"
    part :bass, "Bass", music21: "Bass", family: :voice, description: "Bass"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "OPC7_CHOIR_MODES", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "wordless legato 'ah' vocalise (SATB, soft, floating over a sul-tasto string/wind halo) contrasted against a marked syllabic declaimed passage (SATB, hard marc attacks, driven by timp + low strings)"

      phrase :soprano_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{pp,txt:VOCALISE_-_wordless_ah_legato_floating,txt:cresc.} | E5{p,txt:dim.} | F5{pp,txt:cresc.} | D5{p,txt:niente_into_the_declamation,txt:dim.} | G5{f,marc,txt:DECLAIMED_-_syllabic_hard_attacks} G5{marc} A5{marc} G5{marc} | F5{f,marc} F5{marc} E5{marc} D5{marc} | E5{ff,marc} E5{marc} D5{marc} C5{marc} | C5{ff,marc,txt:final_declaimed_stroke} C5{marc}"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1/2 1/2 2 | 1 1 1 1 | 2 2"
      end

      placement :soprano_line, part: :soprano, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :alto_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{pp,txt:ah,txt:cresc.} | C5{p,txt:dim.} | C5{pp,txt:cresc.} | B4{p,txt:dim.} | E5{f,marc,txt:syllabic} E5{marc} E5{marc} D5{marc} | C5{f,marc} C5{marc} C5{marc} B4{marc} | C5{ff,marc} C5{marc} B4{marc} G4{marc} | G4{ff,marc} G4{marc}"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1/2 1/2 2 | 1 1 1 1 | 2 2"
      end

      placement :alto_line, part: :alto, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tenor_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{pp,txt:ah,txt:cresc.} | A4{p,txt:dim.} | A4{pp,txt:cresc.} | G4{p,txt:dim.} | C4{f,marc,txt:syllabic} C4{marc} C4{marc} B3{marc} | A3{f,marc} A3{marc} G3{marc} G3{marc} | G3{ff,marc} G3{marc} G3{marc} E3{marc} | E3{ff,marc} E3{marc}"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1/2 1/2 2 | 1 1 1 1 | 2 2"
      end

      placement :tenor_line, part: :tenor, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{pp,txt:ah_open_spacing_root,txt:cresc.} | A2{p,txt:dim.} | F2{pp,txt:cresc.} | G2{p,txt:dim.} | C3{f,marc,txt:syllabic_hard_consonant-style_attack} C3{marc} A2{marc} G2{marc} | F2{f,marc} F2{marc} E2{marc} G2{marc} | C3{ff,marc} G2{marc} G2{marc} G2{marc} | C3{ff,marc} C3{marc}"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1/2 1/2 2 | 1 1 1 1 | 2 2"
      end

      placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{pp,txt:soft_halo_over_the_vocalise,txt:cresc.} | E5{p,txt:dim.} | A5{pp,txt:cresc.} | B4{p,txt:morendo,txt:dim.} | r{txt:tacet_-_declamation_carried_by_choir+low_orch} | r | G5{f,marc,txt:bright_doubling_on_the_choral_peaks} G5{marc} | G5{ff,marc} E5{marc}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 2 2 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{pp,txt:inner_halo,txt:cresc.} | C4{p,txt:dim.} | F4{pp,txt:cresc.} | D4{p,txt:dim.} | r{txt:tacet} | r | E4{f,marc} D4{marc} | E4{ff,marc} C4{marc}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 2 2 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{ppp,txt:sul_tasto_soft_string_pedal_under_the_ah,txt:cresc.} | C5{pp,txt:dim.} | C5{ppp,txt:cresc.} | B4{pp,txt:dim.} | E5{f,marc,txt:ord._-_rhythmic_punch_with_the_declamation} E5{marc} G5{marc} E5{marc} | F5{f,marc} r D5{marc} | E5{ff,marc} r C5{marc} r | C5{ff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{ppp,txt:sul_tasto_pedal,txt:cresc.} | A3{pp,txt:dim.} | A3{ppp,txt:cresc.} | G3{pp,txt:dim.} | C4{f,marc,txt:ord._chordal_punch} C4{marc} C4{marc} B3{marc} | A3{f,marc} r G3{marc} | G3{ff,marc} r G3{marc} r | G3{ff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{ppp,txt:arco_sustained_floor_under_the_vocalise,txt:cresc.} | -3{pp,txt:dim.} | -4{ppp,txt:cresc.} | +2{pp,txt:dim.} | +5{f,marc,txt:doubles_choral_bass_-_driving} 0{marc} -3{marc} -2{marc} | -2{f,marc} r +2{marc} | +5{ff,marc} r -5{marc} r | +5{ff,marc} r"
        rhythm    "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:tacet_under_the_vocalise} | r | r | r | C2{f,marc,txt:timp_C+G_-_rhythmic_engine_for_the_declamation} r G2{marc} r | C2{f,marc} r G2{marc} | C2{ff,marc} r G2{marc} r | C2{ff,marc,txt:final_stroke} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
