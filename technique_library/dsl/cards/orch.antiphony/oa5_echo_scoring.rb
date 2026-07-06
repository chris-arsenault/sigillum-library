production_piece "Technique Card OA5_ECHO_SCORING - OA5_ECHO_SCORING" do
  meter "4/4"
  key "G"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA5_ECHO_SCORING
# cite: orchestration_techniques:antiphony
# behavior: a phrase stated f (Fl+Ob+unmuted Vn1) is echoed at IDENTICAL pitch/rhythm p in
#   muted/lighter color (Cl+muted Vn2), then a pp 2nd echo (muted Horn pair), then a ppp dying
#   wisp of the phrase-tail - only dynamic+color change, each pass fainter; soft pad holds
#   harmony; Andante grazioso

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OA5_ECHO_SCORING", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a phrase stated f (Fl+Ob+unmuted Vn1) is echoed at IDENTICAL pitch/rhythm p in muted/lighter color (Cl+muted Vn2), then a pp 2nd echo (muted Horn pair), then a ppp dying wisp of the phrase-tail - only dynamic+color change, each pass fainter; soft pad holds harmony; Andante grazioso"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "B5{f} D6 G6 F#6 E6 | D6 E6 F#6 A6 D6 | r | r | r | r | r | r"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4{f} D5 G5 F#5 E5 | D5 E5 F#5 A5 D5 | r | r | r | r | r | r"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{f} D4 G4 F#4 E4 | D4 E4 F#4 A4 D4 | r | r | r | r | r | r"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | B4{p} D5 G5 F#5 E5 | D5 E5 F#5 A5 D5 | r | r | r | r"
        rhythm_bars "4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | B3{p} D4 G4 F#4 E4 | D4 E4 F#4 A4 D4 | r | r | r | r"
        rhythm_bars "4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | B3{pp} D4 G4 F#4 E4 | D4 E4 F#4 A4 D4 | B3{ppp} A3 G3 | r"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 2 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | G3{pp} B3 D4 D4 C4 | B3 C4 D4 F#3 B3 | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 4 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mp} | D4 | D4{p} | D4 | D4{pp} | D4 | D4{ppp} | B3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "B3"
        intervals "0{mp} | -2 | +2{p} | -2 | +2{pp} | -2 | +2{ppp} | -4"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{mp} | A3 | G3{p} | A3 | G3{pp} | A3 | A3{ppp} | G3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G2{mp} | D2 | G2{p} | D2 | G2{pp} | D2 | D2{ppp} | G2"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
