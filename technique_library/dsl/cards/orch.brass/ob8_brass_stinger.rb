production_piece "Technique Card OB8_BRASS_STINGER - OB8_BRASS_STINGER" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 152", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB8_BRASS_STINGER
# cite: orchestration_techniques:brass
# behavior: full-brass off-beat stabs (sff/ff staccatissimo, spread voicing, exact rests)
#   punctuating a steady vln+contrabass pulse; syncopated hits drive against the beat, dry
#   downbeat stinger to close

  roster do
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OB8_BRASS_STINGER", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "full-brass off-beat stabs (sff/ff staccatissimo, spread voicing, exact rests) punctuating a steady vln+contrabass pulse; syncopated hits drive against the beat, dry downbeat stinger to close"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [G5,C6]{txt:sff} r | r [G5,B5]{ff} r [G5,B5]{ff} r | [A5,C6]{ff} r [A5,C6]{ff} r [A5,C6]{ff} r | r [G5,B5]{ff} r [G5,B5]{ff} | r [G5,B5]{ff} r [G5,B5]{ff} r [G5,B5]{ff} r | [G5,C6]{txt:sff} r"
        rhythm_bars "3/2 1/2 2 | 1/2 1/2 3/2 1/2 1 | 1/2 1 1/2 1 1/2 1/2 | 3/2 1/2 3/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 7/2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [C5,E5]{txt:sff} r | r [D5,G5]{ff} r [D5,G5]{ff} r | [F5,A5]{ff} r [F5,A5]{ff} r [F5,A5]{ff} r | r [D5,G5]{ff} r [D5,G5]{ff} | r [D5,G5]{ff} r [D5,G5]{ff} r [D5,G5]{ff} r | [E5,G5]{txt:sff} r"
        rhythm_bars "3/2 1/2 2 | 1/2 1/2 3/2 1/2 1 | 1/2 1 1/2 1 1/2 1/2 | 3/2 1/2 3/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 7/2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [C4,G4]{txt:sff} r | r [B3,D4]{ff} r [B3,D4]{ff} r | [C4,F4]{ff} r [C4,F4]{ff} r [C4,F4]{ff} r | r [B3,D4]{ff} r [B3,D4]{ff} | r [B3,D4]{ff} r [B3,D4]{ff} r [B3,D4]{ff} r | [C4,E4]{txt:sff} r"
        rhythm_bars "3/2 1/2 2 | 1/2 1/2 3/2 1/2 1 | 1/2 1 1/2 1 1/2 1/2 | 3/2 1/2 3/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 7/2"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "r C2{txt:sff} r | r G1{ff} r G1{ff} r | F2{ff} r F2{ff} r F2{ff} r | r G1{ff} r G1{ff} | r G1{ff} r G1{ff} r G1{ff} r | C2{txt:sff} r"
        rhythm_bars "3/2 1/2 2 | 1/2 1/2 3/2 1/2 1 | 1/2 1 1/2 1 1/2 1/2 | 3/2 1/2 3/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 7/2"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{mf} G4 G4 G4 G4 G4 G4 G4 | G4 G4 G4 G4 D4 D4 D4 D4 | A4 A4 A4 A4 A4 A4 A4 A4 | D4 D4 D4 D4 D4 D4 D4 D4 | D4 D4 D4 D4 D4 D4 D4 D4 | E4{f} E4 C4 C4 G4 G4 C5 C5"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{mf} C2 G2 G2 | G1 G1 D2 D2 | F2 F2 C2 C2 | G1 D2 G1 D2 | G1 G1 G1 G1 | C2{f} C2 G1 C2"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
