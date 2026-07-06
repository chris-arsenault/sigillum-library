production_piece "Technique Card EL1_GRIEF_SENTENCE - EL1_GRIEF_SENTENCE" do
  meter "4/4"
  key "C"

# category: elegy
# card: EL1_GRIEF_SENTENCE
# cite: keyboard_figuration s6d/s6e (elegy fabric)
# behavior: bell tolls as events; speech mixes dotted leans, triplet rises, one 16th grief-run,
#   mid-bar breaths; LH = bell/sweep/bass-line by turns; b8 simplicity NAMED (the breath)

  roster do
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :mid, "Mid", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "EL1_GRIEF_SENTENCE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "bell tolls as events; speech mixes dotted leans, triplet rises, one 16th grief-run, mid-bar breaths; LH = bell/sweep/bass-line by turns; b8 simplicity NAMED (the breath)"

      phrase :rh_line, pitch: :intervals do
        anchor "F4"
        intervals "r 0 -2 -2 -1 +1 +2 | +2 +1 -1 -2 -2 -1 | +1 +2 +2 +1 -1 -2 -2 -1 +1 r | r +7 -2 -1 | [0,+12] [+1,+13] [-1,+11] [-2,+10] [-2,+10] [+2,+14] | [+10,+13]{txt:l.v.} +2 -2 -1 | +1 -1 -2 -2 -2 -1 | r -4{ppp}"
        rhythm    "3/2 3/4 1/4 1/3 1/3 1/3 1/2 | 3/2 1/4 1/4 3/4 1/4 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 3/2 1/2 | 1 3/4 1/4 2 | 1 1/2 1/2 3/4 1/4 1 | 2 1/4 3/4 1 | 3/4 1/4 1/3 1/3 1/3 2 | 2 2"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :mid_line, pitch: :intervals do
        anchor "Ab3"
        intervals "r 0 -2 -1 | r +3 +2 -2 -2 -1 | r +5 -2 -2 -1 | -2 +2 +1 r | +2 -2 -1 | r +3 -2 -1 +1 | -1 r -2 -2 | r"
        rhythm    "5/2 1/2 1/2 1/2 | 1 1/3 1/3 1/3 1 1 | 2 3/4 1/4 1/2 1/2 | 1 1/2 1/2 2 | 2 1 1 | 1 1/3 1/3 1/3 2 | 1 1/2 1/2 2 | 4"
      end

      placement :mid_line, part: :mid, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :lh_line, pitch: :intervals do
        anchor "Db1"
        intervals "[0,+7,+12]{txt:l.v.} +19 +5 +4 +3 | -22 +7 r +1 -1 -2 -2 | -7 +7 +5 +4 +3 | -17 +12 -5 -3 +1 | -12 +7 +9 +3 +5 +4 +3 -3 | [-28,-21,-16]{txt:l.v.} +9 -2 | -2 +2 -7 | [0,+7]{txt:l.v.}"
        rhythm    "2 1/3 1/3 1/3 1 | 1 1/2 1/2 3/4 1/4 1/2 1/2 | 1 1/3 1/3 1/3 2 | 3/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 2 1 1 | 3/2 1/2 2 | 4"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
