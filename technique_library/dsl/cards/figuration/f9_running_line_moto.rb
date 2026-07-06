production_piece "Technique Card F9_RUNNING_LINE_MOTO - F9_RUNNING_LINE_MOTO" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 88", at: "bar 1 beat 1"
  end

# category: figuration
# card: F9_RUNNING_LINE_MOTO
# cite: running_counterpoint
# behavior: a single moto-perpetuo / toccata 16th line that is a real MELODY -- chord-tone
#   framework + passing/neighbor connectors, compound-melody register-alternation, a sequence,
#   ONE leapt-to apex (C6), a destination cadence; LH a moving bass line

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F9_RUNNING_LINE_MOTO", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "a single moto-perpetuo / toccata 16th line that is a real MELODY -- chord-tone framework + passing/neighbor connectors, compound-melody register-alternation, a sequence, ONE leapt-to apex (C6), a destination cadence; LH a moving bass line"

      phrase :piano_rh_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +4 -9 +10 -1 -9 +14 -2 -2 -1 -2 -2 +2 +2 +1 +2 | +2 -2 -2 -1 -2 +3 -1 +3 -2 -1 -2 -2 -1 +3 -2 +4 | +1 -8 +10 -10 +12 -9 +7 -7 +5 +2 +2 +2 -2 -2 -2 -1 | +8 -1 -2 -2 -2 +4 -2 +4 -2 -2 -2 -1 -2 +3 -1 +3 | -2 -1 -2 -2 -1 +3 -2 +4 -2 -2 -1 -2 -2 +4 -2 +3 | -1 +3 +3 -3 +2 +3 -8 +3 -2 -1 +3 -2 0{ten}"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :piano_lh_line, pitch: :intervals do
        anchor "C3"
        intervals "0 0 | +4 -7 | -4 +12 | -10 +12 | -10 +5 | -7 +5"
        rhythm    "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
