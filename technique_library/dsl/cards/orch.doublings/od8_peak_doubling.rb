production_piece "Technique Card OD8_PEAK_DOUBLING - OD8_PEAK_DOUBLING" do
  meter "3/4"
  key "G"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD8_PEAK_DOUBLING
# cite: orchestration_techniques:doublings
# behavior: Vn1 carries a lyric mp arch alone (b1-4); at the b5 phrase-peak Fl blooms in an 8ve
#   above + Vn2 a 3rd below to crown the climax, then both withdraw on the b6 resolution -
#   selective reinforcement = the crescendo; soft undoubled harmony throughout

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet_1, "Clarinet 1", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :clarinet_2, "Clarinet 2", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD8_PEAK_DOUBLING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "Vn1 carries a lyric mp arch alone (b1-4); at the b5 phrase-peak Fl blooms in an 8ve above + Vn2 a 3rd below to crown the climax, then both withdraw on the b6 resolution - selective reinforcement = the crescendo; soft undoubled harmony throughout"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | B6{txt:f_bloom} A6 F#6 | r"
        rhythm_bars "3 | 3 | 3 | 3 | 3/2 1/2 1 | 3"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{p} | E4 | E4 | E4 | D4{mp} | D4{txt:p_dim.}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3"
      end

      placement :clarinet_1_line, part: :clarinet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{p} | G3 | G3 | C4 | A3{mp} | B3{txt:p_dim.}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3"
      end

      placement :clarinet_2_line, part: :clarinet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{p} | B3 | C3 | A3 | A3{mp} | G3{txt:p_dim.}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{txt:mp_espr.} G5 F#5 | E5 D5 B4 | C5 E5 G5 | F#5{txt:cresc.} A5 G5 | B5{f} A5 F#5 | G5{txt:mp_dim.} D5 G5"
        rhythm_bars "1 1 1 | 3/2 1/2 1 | 1 1 1 | 1 1 1 | 3/2 1/2 1 | 3/2 1/2 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | G5{txt:f_bloom} F#5 D5 | r"
        rhythm_bars "3 | 3 | 3 | 3 | 3/2 1/2 1 | 3"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{p} | B3 | C4 | C4 | A3{mp} | B3{txt:p_dim.}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G3"
        intervals "0{p} | 0 | -3 | +5 | -3{mp} | +1{txt:p_dim.}"
        rhythm    "3 | 3 | 3 | 3 | 3 | 3"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G2{p} | E2 | C2 | A2 | D2{mp} | G2{txt:p_dim.}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
