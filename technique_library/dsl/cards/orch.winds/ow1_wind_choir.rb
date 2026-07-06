production_piece "Technique Card OW1_WIND_CHOIR - OW1_WIND_CHOIR" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW1_WIND_CHOIR
# cite: orchestration_techniques:winds
# behavior: homogeneous Fl/Ob/Cl/Bsn chorale in open spacing; moving inner voices, a 4-3 oboe
#   suspension at the cadence, Fl/Bsn contrary motion; winds alone, balanced by register

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "OW1_WIND_CHOIR", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "homogeneous Fl/Ob/Cl/Bsn chorale in open spacing; moving inner voices, a 4-3 oboe suspension at the cadence, Fl/Bsn contrary motion; winds alone, balanced by register"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "F5{mp} | F5 E5 | F5{mf} | G5 F5 | E5 D5{mp} | C5{p}"
        rhythm_bars "4 | 2 2 | 4 | 2 2 | 2 2 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{mp} | D5 | D5 C5 | Bb4 C5 | C5 Bb4 | Bb4 A4{p}"
        rhythm_bars "4 | 4 | 2 2 | 2 2 | 2 2 | 1 3"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} | A4 Bb4 | Bb4{mf} | D4 D4 | G4 E4{mp} | F4{p}"
        rhythm_bars "4 | 2 2 | 4 | 2 2 | 2 2 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "F3{mp} | D3 | Bb2{mf} | G2 | C3 E3 | F3{p}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
