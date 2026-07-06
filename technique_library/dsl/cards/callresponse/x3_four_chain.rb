production_piece "Technique Card X3_FOUR_CHAIN - X3_FOUR_CHAIN" do
  meter "4/4"
  key "C"

# category: callresponse
# card: X3_FOUR_CHAIN
# cite: keyboard_figuration s6g
# behavior: one caller, three repeaters in turn - ornamented / tail-inverted / augmented,
#   entries overlapping a beat; final cycle = 1-beat stagger micro-canon converging on a
#   homorhythmic cadence

  roster do
    part :oboe_call, "Oboe (call)", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet_ornaments, "Clarinet (ornaments)", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn_inverts, "Horn (inverts)", music21: "Horn", family: :brass, description: "Horn"
    part :cello_augments, "Cello (augments)", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "X3_FOUR_CHAIN", bars: 1..10, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..10, texture: :library_card do
      process "one caller, three repeaters in turn - ornamented / tail-inverted / augmented, entries overlapping a beat; final cycle = 1-beat stagger micro-canon converging on a homorhythmic cadence"

      phrase :oboe_call_line, pitch: :intervals do
        anchor "D5"
        intervals "0{mf} +2 +1 -1 -2 -5 | +1 -1 -2 r | r | r | r | r | r +7 +2 +1 | -1 -2 -5 -2 +2 +5 | 0 +2 +1 -1 -2 -1 | [+1] [-1] [+1]"
        rhythm    "3/4 1/4 1 1/2 1/2 1 | 1/2 1/2 1 2 | 4 | 4 | 4 | 4 | 2 3/4 1/4 1 | 1/2 1/2 1 1/2 1/2 1 | 3/4 1/4 1/2 1/2 1 1 | 1 1/2 5/2"
      end

      placement :oboe_call_line, part: :oboe_call, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :clarinet_ornaments_line, pitch: :intervals do
        anchor "D5"
        intervals "r | r 0 -1 +1 +2 +1 -1 -2 | -5 +1 -1 -2 r | r | r | r | r -5 +2 | +1 -1 -2 +7 -2 +2 | -4 +2 +2 -2 -2 -1 | [+1] [-1] [+1]"
        rhythm    "4 | 1 1/2 1/4 1/4 1/4 3/4 1/2 1/2 | 3/4 1/4 1/2 1/2 2 | 4 | 4 | 4 | 3 3/4 1/4 | 1 1/2 1/2 1 1/2 1/2 | 3/4 1/4 1/2 1/2 1 1 | 1 1/2 5/2"
      end

      placement :clarinet_ornaments_line, part: :clarinet_ornaments, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :horn_inverts_line, pitch: :intervals do
        anchor "D4"
        intervals "r | r | r 0 -2 -2 +2 +2 | +5 -2 +2 +2 | r | r | r | r -7 +2 +1 -1 -2 | -5 +1 +2 -3 0 | [0] [0] [+5]"
        rhythm    "4 | 4 | 1 3/4 1/4 1 1/2 1/2 | 1 1/2 1/2 2 | 4 | 4 | 4 | 1 3/4 1/4 1 1/2 1/2 | 1 1/2 1/2 1 1 | 1 1/2 5/2"
      end

      placement :horn_inverts_line, part: :horn_inverts, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :cello_augments_line, pitch: :intervals do
        anchor "D3"
        intervals "r | r | r | r 0 +2 +1 | 0 -1 -2 -5 | +1 -1 -2 | -5 +2 +1 +2 +2 | +5 -2 -2 -1 -2 | -2 +2 +2 0 -7 +7 | [-7] [+7] [-7]"
        rhythm    "4 | 4 | 4 | 1 3/2 1/2 1 | 1 1 1 1 | 1 1 2 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/4 1/4 1/2 1/2 1 1 | 1 1/2 5/2"
      end

      placement :cello_augments_line, part: :cello_augments, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
