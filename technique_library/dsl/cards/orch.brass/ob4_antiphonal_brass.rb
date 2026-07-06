production_piece "Technique Card OB4_ANTIPHONAL_BRASS - OB4_ANTIPHONAL_BRASS" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 66", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB4_ANTIPHONAL_BRASS
# cite: orchestration_techniques:brass
# behavior: two spatially-separated self-sufficient brass choirs trade antiphonally: Choir1
#   (2tpt+2hn, front) proclaims I (f), Choir2 (2tbn+tuba, rear) echoes V dal lontano (mp), they
#   trade 2-beat fragments with a half-beat dovetail over IV->V, then combine into a wide tutti
#   on I (ff)

  roster do
    part :trumpet_1, "Trumpet 1", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_2, "Trumpet 2", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :trombone_1, "Trombone 1", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_2, "Trombone 2", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
  end

  section :card, "OB4_ANTIPHONAL_BRASS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "two spatially-separated self-sufficient brass choirs trade antiphonally: Choir1 (2tpt+2hn, front) proclaims I (f), Choir2 (2tbn+tuba, rear) echoes V dal lontano (mp), they trade 2-beat fragments with a half-beat dovetail over IV->V, then combine into a wide tutti on I (ff)"

      phrase :trumpet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{f} E5 G5 C6 | B5 C6 D6 C6 | r | r | A5 F5 A5 r | G5 D6 B5 r | C6{ff} B5 C6 | G5 E5 C6"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 4 | 4 | 1 1 1/2 3/2 | 1 1 1/2 3/2 | 2 1 1 | 3/2 1/2 2"
      end

      placement :trumpet_1_line, part: :trumpet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{f} C5 E5 G5 | G5 E5 F5 E5 | r | r | F5 C5 F5 r | D5 G5 G5 r | E5{ff} D5 E5 | E5 C5 G5"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 4 | 4 | 1 1 1/2 3/2 | 1 1 1/2 3/2 | 2 1 1 | 3/2 1/2 2"
      end

      placement :trumpet_2_line, part: :trumpet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{f} G4 C5 E5 | D5 E5 G5 G4 | r | r | C5 A4 C5 r | B4 G4 D5 r | G4{ff} G4 G4 | C5 G4 E5"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 4 | 4 | 1 1 1/2 3/2 | 1 1 1/2 3/2 | 2 1 1 | 3/2 1/2 2"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{f} E4 G4 C5 | G4 G4 B4 C5 | r | r | F4 F4 F4 r | G4 B4 G4 r | E4{ff} D4 E4 | G4 E4 C5"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 4 | 4 | 1 1 1/2 3/2 | 1 1 1/2 3/2 | 2 1 1 | 3/2 1/2 2"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D4{mp} B3 D4 G4 | F4 G4 A4 G4 | r C4{mf} A3 | r D4{mf} B3 | E4{ff} D4 E4 | C4 G3 E4"
        rhythm_bars "4 | 4 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 5/2 1/2 1 | 5/2 1/2 1 | 2 1 1 | 3/2 1/2 2"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | B3{mp} G3 B3 D4 | D4 D4 F4 D4 | r A3{mf} F3 | r G3{mf} G3 | C4{ff} B3 C4 | G3 E3 C4"
        rhythm_bars "4 | 4 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 5/2 1/2 1 | 5/2 1/2 1 | 2 1 1 | 3/2 1/2 2"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G2{mp} D2 G2 | D2 G1 G2 | r F2{mf} F2 | r G2{mf} G1 | C2{ff} G1 C2 | G1 G1 C2"
        rhythm_bars "4 | 4 | 2 1 1 | 2 1 1 | 5/2 1/2 1 | 5/2 1/2 1 | 2 1 1 | 3/2 1/2 2"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
