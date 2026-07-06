production_piece "Technique Card OD6_SUBOCTAVE_BASS - OD6_SUBOCTAVE_BASS" do
  meter "4/4"
  key "c"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD6_SUBOCTAVE_BASS
# cite: orchestration_techniques:doublings
# behavior: a descending bass line under a sustained tutti chordal texture; at b3 Cb 8vb +
#   Contrabassoon + Tuba enter on the sub-octave (a pure octave below, in unison) to drop the
#   floor for depth, while Vc+Bsn hold the principal octave so every deep note keeps its
#   octave-above clarity doubler - depth WITH definition; octaves only at the bottom, no low
#   thirds

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :contrabassoon, "Contrabassoon", music21: "Contrabassoon", family: :woodwind, description: "Contrabassoon"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
  end

  section :card, "OD6_SUBOCTAVE_BASS", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "a descending bass line under a sustained tutti chordal texture; at b3 Cb 8vb + Contrabassoon + Tuba enter on the sub-octave (a pure octave below, in unison) to drop the floor for depth, while Vc+Bsn hold the principal octave so every deep note keeps its octave-above clarity doubler - depth WITH definition; octaves only at the bottom, no low thirds"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{f} | F5 | Eb5 | Ab4 | G4 | G5{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb5{f} | D5 | C5 | F4 | D5 | Eb5{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{f} | Bb3 | Ab3 | C4 | B3 | C4{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{mf} | F4 | Eb4 | Ab3 | G4 | G4{f}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{mf} | D4 | C4 | F4 | D4 | Eb4{f}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{mf} | Bb2 | Ab2 | F2 | G2 | C3{f}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{f} | -2 | -2 | -3 | +2 -5 | +10{ff}"
        rhythm    "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{f} | Bb2 | Ab2 | F2 | G2 D2 | C3{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | Ab1{mf} | F1 | G1 D1 | C2{f}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | Ab1{mf} | F1 | G1 D1 | C2{f}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :contrabassoon_line, part: :contrabassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | Ab1{mf} | F1 | G1 D1 | C2{f}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
