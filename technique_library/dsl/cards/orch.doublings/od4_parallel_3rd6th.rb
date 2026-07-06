production_piece "Technique Card OD4_PARALLEL_3RD6TH - OD4_PARALLEL_3RD6TH" do
  meter "3/4"
  key "G"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD4_PARALLEL_3RD6TH
# cite: orchestration_techniques:doublings
# behavior: Flute melody doubled by oboe a strict diatonic 3rd below (b1-4) opening to a 6th
#   below at the cadence (b5-6) as one sweetened harmonized line; Fl2 doubles the tune in unison
#   at the cadence; clarinet/2 horns/bassoon sustain soft chordal harmony; strings pad; Vc+Cb a
#   lilting floor

  roster do
    part :flute_1, "Flute 1", music21: "Flute", family: :woodwind, description: "Flute"
    part :flute_2, "Flute 2", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD4_PARALLEL_3RD6TH", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "Flute melody doubled by oboe a strict diatonic 3rd below (b1-4) opening to a 6th below at the cadence (b5-6) as one sweetened harmonized line; Fl2 doubles the tune in unison at the cadence; clarinet/2 horns/bassoon sustain soft chordal harmony; strings pad; Vc+Cb a lilting floor"

      phrase :flute_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{txt:mp_dolce} E5 G5 | F#5 E5 D5 | E5 F#5 A5 | G5 F#5 E5 | D5{mf} C5 B4 | A4 G4"
        rhythm_bars "1 1 1 | 3/2 1/2 1 | 1 1 1 | 3/2 1/2 1 | 1 1 1 | 2 1"
      end

      placement :flute_1_line, part: :flute_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | D5{mf} C5 B4 | A4 G4"
        rhythm_bars "3 | 3 | 3 | 3 | 1 1 1 | 2 1"
      end

      placement :flute_2_line, part: :flute_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4{txt:mp_dolce} C5 E5 | D5 C5 B4 | C5 D5 F#5 | E5 D5 C5 | F#4{mf} E4 D4 | C4 B3"
        rhythm_bars "1 1 1 | 3/2 1/2 1 | 1 1 1 | 3/2 1/2 1 | 1 1 1 | 2 1"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{p} | C4 | A3 | D4 | A3{mp} A3 | D4"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{p} | A3 | F#3 | B3 | C4{mp} F#3 | G3"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{p} | F#3 | D3 | D3 | A3{mp} C4 | B3"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{p} | E3 | F#3 | G3 | F#3{mp} A3 | G3"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{p} | C4 | F#4 | G4 | F#4{mp} A4 | B3"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{p} | A3 | D4 | D4 | D4{mp} D4 | G3"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{mp} r +7 | -2 r -5 | +7 r -5 | +7 r -5 | -2{mf} +5 -12 | +5 -5"
        rhythm    "1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 2 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G1{p} | C2 | D2 | E2 | A1{mf} D2 | G1"
        rhythm_bars "3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
