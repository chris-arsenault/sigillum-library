production_piece "Technique Card OD5_COMPOSITE_TIMBRE - OD5_COMPOSITE_TIMBRE" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 58", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD5_COMPOSITE_TIMBRE
# cite: orchestration_techniques:doublings
# behavior: two spectrally-complementary instruments at EXACT unison fuse into a fictitious new
#   color (neither parent): Fl+Cl hollow (b1-4), then Ob+Hn reedy-round (b5-8), over a light
#   undoubled string bed at Adagio so the fusion is audible

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD5_COMPOSITE_TIMBRE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "two spectrally-complementary instruments at EXACT unison fuse into a fictitious new color (neither parent): Fl+Cl hollow (b1-4), then Ob+Hn reedy-round (b5-8), over a light undoubled string bed at Adagio so the fusion is audible"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{txt:p_espr.} G4 A4 G4 E4 | A4 C5 D5 C5 B4 | C5 A4 G4 F4 | D4 G4 F4 E4 | r | r | r | r"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{txt:p_espr.} G4 A4 G4 E4 | A4 C5 D5 C5 B4 | C5 A4 G4 F4 | D4 G4 F4 E4 | r | r | r | r"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | C4{txt:mp_espr.} D4 E4 D4 C4 | D4 F4 G4 F4 E4 | G4 E4 D4 B3 | C4 D4 C4"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | C4{txt:mp_espr.} D4 E4 D4 C4 | D4 F4 G4 F4 E4 | G4 E4 D4 B3 | C4 D4 C4"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{pp} | A3 | A3 | D4 | A3 | A3 | D4 | G3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{pp} | E4 | F4 | B3 | F4 | F4 | B3 | G3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{pp} | A3 | C3 | G3 | C3 | D3 | G3 | C3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C2"
        intervals "0{pp} | +9 | -4 | +2 | -2 | -3 | +5 | -7"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{pp} | A1 | F1 | G1 | F1 | D2 | G1 | C2"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
