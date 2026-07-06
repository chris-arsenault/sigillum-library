production_piece "Technique Card O2_BRASS_CHORALE - O2_BRASS_CHORALE" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O2_BRASS_CHORALE
# cite: chord_scoring s3/s6
# behavior: interlocked hns+tbns; a suspension at EVERY change, rotating through the choir; tuba
#   doubles the bass line, not roots

  roster do
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :trombone_1, "Trombone 1", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_2, "Trombone 2", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
  end

  section :card, "O2_BRASS_CHORALE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "interlocked hns+tbns; a suspension at EVERY change, rotating through the choir; tuba doubles the bass line, not roots"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{p} | F4 Eb4 | Eb4 D4 | Eb4 | F4 G4 | F4"
        rhythm_bars "4 | 1 3 | 2 2 | 4 | 2 2 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{p} | C4 | Bb3 | C4 Bb3 A3 | Bb3 C4 | D4"
        rhythm_bars "4 | 4 | 4 | 2 1 1 | 2 2 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb3{p} | A3 | G3 | G3 F3 | F3 | F3 Eb3 D3"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 1 1 2"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "F3{p} | F3 Eb3 | Eb3 | C3 | D3 Eb3 | Bb2"
        rhythm_bars "4 | 2 2 | 4 | 4 | 2 2 | 4"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb1{p} Bb2 | F2 F1 | Eb2 Eb3 D3 | C2 C3 | D2 Eb2 F2 | Bb1"
        rhythm_bars "2 2 | 2 2 | 2 1 1 | 2 2 | 2 1 1 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
