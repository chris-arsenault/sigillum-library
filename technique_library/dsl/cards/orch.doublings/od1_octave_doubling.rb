production_piece "Technique Card OD1_OCTAVE_DOUBLING - OD1_OCTAVE_DOUBLING" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD1_OCTAVE_DOUBLING
# cite: orchestration_techniques:doublings
# behavior: one broad tune octave-doubled across three registers (Vn1+Fl top / Vn2+Va+Ob core /
#   Vc+Cl+Bsn low), identical rhythm/phrasing, over a simple root bass (Cb +Cbsn sub-octave at
#   cadence) - the octave-lock makes one strong projected line, crescendo to a ff peak

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :contrabassoon, "Contrabassoon", music21: "Contrabassoon", family: :woodwind, description: "Contrabassoon"
  end

  section :card, "OD1_OCTAVE_DOUBLING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one broad tune octave-doubled across three registers (Vn1+Fl top / Vn2+Va+Ob core / Vc+Cl+Bsn low), identical rhythm/phrasing, over a simple root bass (Cb +Cbsn sub-octave at cadence) - the octave-lock makes one strong projected line, crescendo to a ff peak"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{f} F#5 A5 D6 | C#6 D6 B5 | A5 B5 C#6 E6 | D6 C#6 B5 | A5{cresc(} B5 C#6 D6{cresc)} | E6{ff} D6"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{f} F#5 A5 D6 | C#6 D6 B5 | A5 B5 C#6 E6 | D6 C#6 B5 | A5{cresc(} B5 C#6 D6{cresc)} | E6{ff} D6"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{f} F#4 A4 D5 | C#5 D5 B4 | A4 B4 C#5 E5 | D5 C#5 B4 | A4{cresc(} B4 C#5 D5{cresc)} | E5{ff} D5"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{f} F#4 A4 D5 | C#5 D5 B4 | A4 B4 C#5 E5 | D5 C#5 B4 | A4{cresc(} B4 C#5 D5{cresc)} | E5{ff} D5"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{f} F#4 A4 D5 | C#5 D5 B4 | A4 B4 C#5 E5 | D5 C#5 B4 | A4{cresc(} B4 C#5 D5{cresc)} | E5{ff} D5"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{f} +4 +3 +5 | -1 +1 -3 | -2 +2 +2 +3 | -2 -1 -2 | -2{cresc(} +2 +2 +1{cresc)} | +2{ff} -2"
        rhythm    "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{f} F#3 A3 D4 | C#4 D4 B3 | A3 B3 C#4 E4 | D4 C#4 B3 | A3{cresc(} B3 C#4 D4{cresc)} | E4{ff} D4"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{f} F#3 A3 D4 | C#4 D4 B3 | A3 B3 C#4 E4 | D4 C#4 B3 | A3{cresc(} B3 C#4 D4{cresc)} | E4{ff} D4"
        rhythm_bars "3/2 1/2 1 1 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1 | 1 1 1 1 | 2 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{f} A1 | G2 G2 | A2 E2 | B2 F#2 | E2 A2 | A2 D2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | A1{ff} A1 | A1 D2"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 2 2"
      end

      placement :contrabassoon_line, part: :contrabassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
