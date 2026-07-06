production_piece "Technique Card OD2_UNISON_BLEND - OD2_UNISON_BLEND" do
  meter "4/4"
  key "G"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD2_UNISON_BLEND
# cite: orchestration_techniques:doublings
# behavior: one lyric line carried by Vn1 in TRUE unison (same pitch, not octave) with shifting
#   mixed timbres - 2 Cl (warm) -> Ob (reedy) -> 2 Fl (bright) - fusing into a new composite
#   color that recolors mid-phrase; light harmony below, no octave doubling anywhere

  roster do
    part :flute_1, "Flute 1", music21: "Flute", family: :woodwind, description: "Flute"
    part :flute_2, "Flute 2", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet_1, "Clarinet 1", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :clarinet_2, "Clarinet 2", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD2_UNISON_BLEND", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one lyric line carried by Vn1 in TRUE unison (same pitch, not octave) with shifting mixed timbres - 2 Cl (warm) -> Ob (reedy) -> 2 Fl (bright) - fusing into a new composite color that recolors mid-phrase; light harmony below, no octave doubling anywhere"

      phrase :flute_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | B4{mp} D5 F#5 A5 | G5 D5 G5"
        rhythm_bars "4 | 4 | 4 | 4 | 3/2 1/2 1 1 | 2 1 1"
      end

      placement :flute_1_line, part: :flute_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | B4{mp} D5 F#5 A5 | G5 D5 G5"
        rhythm_bars "4 | 4 | 4 | 4 | 3/2 1/2 1 1 | 2 1 1"
      end

      placement :flute_2_line, part: :flute_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | E5{mp} D5 C5 B4 | A4 C5 B4 A4 | r | r"
        rhythm_bars "4 | 4 | 1 1 3/2 1/2 | 1 1 1 1 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp} G5 F#5 E5 | D5 B4 C5 D5 | r | r | r | r"
        rhythm_bars "1 1 1 1 | 3/2 1/2 1 1 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_1_line, part: :clarinet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp} G5 F#5 E5 | D5 B4 C5 D5 | r | r | r | r"
        rhythm_bars "1 1 1 1 | 3/2 1/2 1 1 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_2_line, part: :clarinet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{p} | E4 | G4 | E4 | D4 F#4 | D4"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{txt:mp_espr.} G5 F#5 E5 | D5 B4 C5 D5 | E5 D5 C5 B4 | A4 C5 B4 A4 | B4 D5 F#5 A5 | G5 D5 G5"
        rhythm_bars "1 1 1 1 | 3/2 1/2 1 1 | 1 1 3/2 1/2 | 1 1 1 1 | 3/2 1/2 1 1 | 2 1 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4{p} | B4 | G4 | E4 | F#4 A4 | B4"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{p} | G4 | E4 | C4 | D4 F#4 | G4"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G3"
        intervals "0{p} | -3 | -4 | +9 | -7 +7 | -2"
        rhythm    "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G2{p} D3 | E2 B2 | C3 G2 | A2 E2 | D2 A2 | G2 D3"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
