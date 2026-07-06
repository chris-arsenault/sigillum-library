production_piece "Technique Card OW8_WIND_PUNCT - OW8_WIND_PUNCT" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW8_WIND_PUNCT
# cite: orchestration_techniques:winds
# behavior: winds punctuate a violin line's beat-3 gaps: Cl+Bsn staccato breath-tags answer the
#   gaps (I, V), full-section off-beat stabs in b3, then a short-short-short-LONG cadential
#   stamp (V-I) and silence; crisp, detached

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "OW8_WIND_PUNCT", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "winds punctuate a violin line's beat-3 gaps: Cl+Bsn staccato breath-tags answer the gaps (I, V), full-section off-beat stabs in b3, then a short-short-short-LONG cadential stamp (V-I) and silence; crisp, detached"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{f} A5 r E5 | F5 D5 r G5 | C5 r | C5 r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 2 2 | 1 3"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r E5{f,stacc} r E5{stacc} r | G5{f,stacc} G5{stacc} G5{stacc} E5{marc} r"
        rhythm_bars "4 | 4 | 3/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1 3/2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r C5{f,stacc} r C5{stacc} r | D5{f,stacc} D5{stacc} D5{stacc} C5{marc} r"
        rhythm_bars "4 | 4 | 3/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1 3/2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r E4{mp,stacc} r | r D4{mp,stacc} r | r G4{f,stacc} r G4{stacc} r | B4{f,stacc} B4{stacc} B4{stacc} G4{marc} r"
        rhythm_bars "2 1/2 3/2 | 2 1/2 3/2 | 3/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1 3/2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r C3{mp,stacc} r | r G2{mp,stacc} r | r C3{f,stacc} r C3{stacc} r | G2{f,stacc} G2{stacc} G2{stacc} C3{marc} r"
        rhythm_bars "2 1/2 3/2 | 2 1/2 3/2 | 3/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1 3/2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
