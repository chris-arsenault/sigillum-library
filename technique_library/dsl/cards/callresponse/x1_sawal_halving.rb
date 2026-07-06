production_piece "Technique Card X1_SAWAL_HALVING - X1_SAWAL_HALVING" do
  meter "4/4"
  key "C"

# category: callresponse
# card: X1_SAWAL_HALVING
# cite: keyboard_figuration s6g (form-card)
# behavior: 4-bar call (winds in 6ths) / 4-bar response (strings: tail inverted, own raised-6th
#   cadence) -> 2/2 -> 1/1 -> half/half -> STRONG UNISON ending (all four in octaves, head-cell
#   driven into the final). The call liquidates at each halving; nothing parrots

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
  end

  section :card, "X1_SAWAL_HALVING", bars: 1..17, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..17, texture: :library_card do
      process "4-bar call (winds in 6ths) / 4-bar response (strings: tail inverted, own raised-6th cadence) -> 2/2 -> 1/1 -> half/half -> STRONG UNISON ending (all four in octaves, head-cell driven into the final). The call liquidates at each halving; nothing parrots"

      phrase :oboe_line, pitch: :intervals do
        anchor "G4"
        intervals "0{mf} +2 +1 +2 +2 | +2 -2 -2 -2 -1 +1 -3 | +7 -2 -2 -1 -2 -2 | +2 +2 +1 -1 -2 | r | r | r | r | 0 +2 +1 +2 +2 +2 | -2 -2 -2 -3 | r | r | 0 +2 +1 +2 +2 | r | -7 +3 +4 r | -7 0 +3 +2 +2 +2 -2 -2 | -2 +2 -2 -1 -2 +7 -7 r"
        rhythm    "1/2 1/2 3/2 1/2 1 | 1/3 1/3 1/3 3/4 1/4 1 1 | 1 1/2 1/2 3/4 1/4 1 | 1/2 1/2 1/2 1/2 2 | 4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 1/2 1 | 3/4 1/4 1 2 | 4 | 4 | 1/2 1/2 3/4 1/4 2 | 4 | 1/2 1/2 1 2 | 3/4 1/4 1/2 1/2 3/4 1/4 1/2 1/2 | 1/4 1/4 1/4 1/4 1/2 1/2 3/2 1/2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :clarinet_line, pitch: :intervals do
        anchor "Bb3"
        intervals "0{mf} +2 +2 +2 +1 | +2 -2 -1 -2 -2 +2 -4 | +7 -1 -2 -2 -2 -1 | +1 +2 +2 -2 -2 | r | r | r | r | 0 +2 +2 +2 +1 +2 | -2 -1 -2 -4 | r | r | 0 +2 +2 +2 +1 | r | -7 +4 +3 r | -10 0 +3 +2 +2 +2 -2 -2 | -2 +2 -2 -1 -2 +7 -7 r"
        rhythm    "1/2 1/2 3/2 1/2 1 | 1/3 1/3 1/3 3/4 1/4 1 1 | 1 1/2 1/2 3/4 1/4 1 | 1/2 1/2 1/2 1/2 2 | 4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 1/2 1 | 3/4 1/4 1 2 | 4 | 4 | 1/2 1/2 3/4 1/4 2 | 4 | 1/2 1/2 1 2 | 3/4 1/4 1/2 1/2 3/4 1/4 1/2 1/2 | 1/4 1/4 1/4 1/4 1/2 1/2 3/2 1/2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violin_line, pitch: :intervals do
        anchor "D5"
        intervals "r | r | r | r | 0{mf} -2 -2 -1 -2 | -2 +2 +2 +1 +2 +2 | +2 -2 -2 +2 -2 -3 | +1 -1 -2 -1 +1 | r | r | +7 -2 -2 -1 -2 -1 | +1 +2 +1 | r | +4 -2 -2 -1 -2 | r +7 -4 -3 | +12 0 -9 +2 +2 +2 -2 -2 | -2 +2 -2 -1 -2 +7 -7 r"
        rhythm    "4 | 4 | 4 | 4 | 1/2 1/2 3/2 1/2 1 | 1/3 1/3 1/3 3/4 1/4 2 | 1 1/2 1/2 3/4 1/4 1 | 1/2 1/2 1/2 1/2 2 | 4 | 4 | 1/2 1/2 1 1/2 1/2 1 | 3/2 1/2 2 | 4 | 1/2 1/2 3/4 1/4 2 | 2 1/2 1/2 1 | 3/4 1/4 1/2 1/2 3/4 1/4 1/2 1/2 | 1/4 1/4 1/4 1/4 1/2 1/2 3/2 1/2"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, pitch: :intervals do
        anchor "Bb4"
        intervals "r | r | r | r | 0{mf} -1 -2 -2 -1 | -2 +2 +1 +2 +2 +1 | +2 -2 -1 +1 -1 -4 | +2 -2 -1 -2 0 | r | r | +8 -1 -2 -2 -1 -2 | 0 +2 +3 | r | +3 -1 -2 -2 -3 | r +8 -3 -5 | -7 0 +3 +2 +2 +2 -2 -2 | -2 +2 -2 -1 -2 +7 -7 r"
        rhythm    "4 | 4 | 4 | 4 | 1/2 1/2 3/2 1/2 1 | 1/3 1/3 1/3 3/4 1/4 2 | 1 1/2 1/2 3/4 1/4 1 | 1/2 1/2 1/2 1/2 2 | 4 | 4 | 1/2 1/2 1 1/2 1/2 1 | 3/2 1/2 2 | 4 | 1/2 1/2 3/4 1/4 2 | 2 1/2 1/2 1 | 3/4 1/4 1/2 1/2 3/4 1/4 1/2 1/2 | 1/4 1/4 1/4 1/4 1/2 1/2 3/2 1/2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
