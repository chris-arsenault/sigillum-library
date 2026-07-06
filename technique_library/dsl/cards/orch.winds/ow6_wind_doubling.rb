production_piece "Technique Card OW6_WIND_DOUBLING - OW6_WIND_DOUBLING" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 88", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW6_WIND_DOUBLING
# cite: orchestration_techniques:winds
# behavior: doubling regimes set by balance: b1-2 Cl pp submerges into the mf Fl line (blend,
#   only warmed); b3-4 Fl+Cl unison at EQUAL mf fuse to a new hollow hybrid; b5-6 Ob+Cl equal-mf
#   unison = a reedier composite; Bsn soft sustaining bass

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "OW6_WIND_DOUBLING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "doubling regimes set by balance: b1-2 Cl pp submerges into the mf Fl line (blend, only warmed); b3-4 Fl+Cl unison at EQUAL mf fuse to a new hollow hybrid; b5-6 Ob+Cl equal-mf unison = a reedier composite; Bsn soft sustaining bass"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mf} C5 D5 F5 | E5 D5 C5 | G4{mf} Bb4 D5 E5 | F5 E5 D5 C5 | r | r"
        rhythm_bars "1 1 1 1 | 3/2 1/2 2 | 1 1 1 1 | 3/2 1/2 1 1 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | C5{mf} D5 E5 F5 | E5 D5 C5"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{pp} C5 D5 F5 | E5 D5 C5 | G4{mf} Bb4 D5 E5 | F5 E5 D5 C5 | C5{mf} D5 E5 F5 | E5 D5 C5"
        rhythm_bars "1 1 1 1 | 3/2 1/2 2 | 1 1 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "F2{p} | Bb2 | C3 | F2 | F2 G2 | C3{mp} F2"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 2 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
