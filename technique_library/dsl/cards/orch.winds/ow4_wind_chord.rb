production_piece "Technique Card OW4_WIND_CHORD - OW4_WIND_CHORD" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 63", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW4_WIND_CHORD
# cite: orchestration_techniques:winds
# behavior: same ii7 wind chord shown two ways - b1-2 SUPERPOSED (Fl/Ob1/Ob2/Cl/Bsn in
#   descending bands, colors striped), b3-4 ENCLOSED (Cl crosses between the oboes so adjacent
#   voices differ in family, colors blend), b5-6 ii7-V7-I; Fl floating lid, apex handed to Ob
#   then reclaimed; Bsn anchors

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe_1, "Oboe 1", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :oboe_2, "Oboe 2", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "OW4_WIND_CHORD", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "same ii7 wind chord shown two ways - b1-2 SUPERPOSED (Fl/Ob1/Ob2/Cl/Bsn in descending bands, colors striped), b3-4 ENCLOSED (Cl crosses between the oboes so adjacent voices differ in family, colors blend), b5-6 ii7-V7-I; Fl floating lid, apex handed to Ob then reclaimed; Bsn anchors"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "C6{mp} C6 | C6 | C6{mf} C6 | C6 | B5{mp} D6 | C6{p}"
        rhythm_bars "2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{mp} A5 | A5 | A5{mf} A5 | A5 | G5{mf} A5 | G5{p}"
        rhythm_bars "2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :oboe_1_line, part: :oboe_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "F5{mp} F5 | F5 | D5{mf} D5 | D5 | F5{mp} F5 | E5{p}"
        rhythm_bars "2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :oboe_2_line, part: :oboe_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp} D5 | D5 | F5{mf} F5 | F5 | D5{mp} D5 | C5{p}"
        rhythm_bars "2 2 | 4 | 2 2 | 4 | 2 2 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mp} D3 | D3 | D3{mf} D3 | D3 | G2{mp} | C3{p}"
        rhythm_bars "2 2 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
