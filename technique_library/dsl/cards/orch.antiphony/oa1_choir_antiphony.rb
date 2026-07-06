production_piece "Technique Card OA1_CHOIR_ANTIPHONY - OA1_CHOIR_ANTIPHONY" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 126", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA1_CHOIR_ANTIPHONY
# cite: orchestration_techniques:antiphony
# behavior: full self-sufficient family choirs trade complete harmonized phrases antiphonally:
#   WIND choir (mf, bright) states, BRASS choir (f, broad) answers, winds vary; half-beat
#   dovetail at each seam; terraced dynamics; converge on a tutti V-I at b6, each choir keeping
#   its register stratum; Allegro

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
  end

  section :card, "OA1_CHOIR_ANTIPHONY", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "full self-sufficient family choirs trade complete harmonized phrases antiphonally: WIND choir (mf, bright) states, BRASS choir (f, broad) answers, winds vary; half-beat dovetail at each seam; terraced dynamics; converge on a tutti V-I at b6, each choir keeping its register stratum; Allegro"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{mf} C6 E6 D6 C6 E6 D6 | E6 D6 C6 B5 C6 D6 | r F6{mf} E6 | D6 C6 A5 C6 D6 E6 F6 r | D6{mf} E6"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 3 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 9/2 | 1 3"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mf} G5 C6 B5 G5 C6 B5 | G5 B5 G5 D5 E5 D5 | r A5{mf} G5 | F5 E5 F5 A5 B5 G5 A5 r | D5{mf} C6"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 3 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 9/2 | 1 3"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{mf} E5 G5 G5 E5 G5 G5 | C5 D5 D5 D5 G4 G4 | r C5{mf} C5 | A4 A4 C5 F5 F5 C5 C5 r | G4{mf} G5"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 3 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 9/2 | 1 3"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3{mf} C3 E3 G3 | C3 B2 D3 G2 | r F3{mf} F3 | C3 F3 F3 D3 D3 C3 C3 r | G2{mf} C3"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 3 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 9/2 | 1 3"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r G4{f} | C5{f} E5 G5 F5 E5 G5 F5 r D5{f} | F5{f} A5 G5 F5 A5 G5 A5 r | G5{f} G5"
        rhythm_bars "15/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 4 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 3"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r E4{f} | E4{f} G4 C5 C5 G4 C5 C5 r F4{f} | A4{f} F4 F4 A4 F4 A4 F4 r | D5{f} E5"
        rhythm_bars "15/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 4 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 3"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r C3{f} | C3{f} C3 G3 G3 G3 G3 C3 r D3{f} | D3{f} D3 D3 D3 G2 G2 G2 r | G2{f} C3"
        rhythm_bars "15/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 4 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 3"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
