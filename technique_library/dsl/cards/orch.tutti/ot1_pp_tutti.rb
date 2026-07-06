production_piece "Technique Card OT1_PP_TUTTI - OT1_PP_TUTTI" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT1_PP_TUTTI
# cite: orchestration_techniques:tutti
# behavior: full-orchestra soft tutti: pp luminous mass, every register filled open-low/pyramid;
#   plagal I-IV-V-I with a real internal swell (pp->mf->pp); viola weave moves inside, Fl+Vn1
#   melody floats on top; harp gilds, Cb thins to niente

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
  end

  section :card, "OT1_PP_TUTTI", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "full-orchestra soft tutti: pp luminous mass, every register filled open-low/pyramid; plagal I-IV-V-I with a real internal swell (pp->mf->pp); viola weave moves inside, Fl+Vn1 melody floats on top; harp gilds, Cb thins to niente"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{pp} | C6 A5 | Bb5{mp} | D6 C6 | D6{mf} C6 | C6{mp} A5 | A5{pp} | A5{ppp}"
        rhythm_bars "4 | 2 2 | 4 | 2 2 | 3 1 | 2 2 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | F4{mp} | F4 | G4{mf} | F4{mp} | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{pp} | C5 | D5{mp} | D5 | Eb5{mf} E5 | E5{mp} C5 | C5{pp} | C5{ppp}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 2 2 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp} | F4 | F4{mp} | F4 | G4{mf} G4 | E4{mp} F4 | C4{pp} | C4{ppp}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 2 2 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{pp,txt:sul_tasto} | C5 A4 | Bb4{mp} | D5 C5 | D5{mf} C5 | C5{mp} A4 | A4{pp} | A4{ppp}"
        rhythm_bars "4 | 2 2 | 4 | 2 2 | 3 1 | 2 2 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp,txt:sul_tasto} | F4 | F4{mp} | F4 | G4{mf} | G4{mp} F4 | F4{pp} | F4{ppp}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp} G4 A4 G4 | F4 E4 F4 | G4{mp} A4 Bb4 A4 | G4 F4 G4 | A4{mf} Bb4 C5 Bb4 | Bb4{mp} A4 G4 A4 | G4{pp} F4 E4 | F4{ppp} F4"
        rhythm_bars "1 1 1 1 | 2 1 1 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F3"
        intervals "0{pp} | 0 | -7{mp} | 0 | 0{mf} +2 | 0{mp} 0 | +5{pp} | 0{ppp}"
        rhythm    "4 | 4 | 4 | 4 | 2 2 | 2 2 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "F2{pp,txt:arco} | F2 | Bb1{mp} | Bb1 | Bb1{mf} C2 | C2{mp} | F2{pp} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "F3{pp} C4 F4 A4 C5 r | A4 C5 G5 r | Bb2{mp} F3 Bb3 D4 F4 r | D4 F4 C5 r | C3{mf} G3 C4 E4 G4 r | G4{mp} C5 E5 r | F3{pp} C4 F4 A4 C5 r | F4{ppp} A4 C5 r"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 3/2 | 1/2 1/2 1/2 5/2 | 1/2 1/2 1/2 1/2 1/2 3/2 | 1/2 1/2 1/2 5/2 | 1/2 1/2 1/2 1/2 1/2 3/2 | 1/2 1/2 1/2 5/2 | 1/2 1/2 1/2 1/2 1/2 3/2 | 1/2 1/2 1/2 5/2"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
