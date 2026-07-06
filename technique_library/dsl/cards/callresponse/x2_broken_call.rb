production_piece "Technique Card X2_BROKEN_CALL - X2_BROKEN_CALL" do
  meter "4/4"
  key "C"

# category: callresponse
# card: X2_BROKEN_CALL
# cite: keyboard_figuration s6g
# behavior: the response interrupts BEFORE the call ends; the restart is interrupted earlier;
#   the third time the response PRE-EMPTS and roles flip; they finish each other's last phrase.
#   Bass walks the whole argument

  roster do
    part :horn_caller, "Horn (caller)", music21: "Horn", family: :brass, description: "Horn"
    part :flute_responder, "Flute (responder)", music21: "Flute", family: :woodwind, description: "Flute"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "X2_BROKEN_CALL", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the response interrupts BEFORE the call ends; the restart is interrupted earlier; the third time the response PRE-EMPTS and roles flip; they finish each other's last phrase. Bass walks the whole argument"

      phrase :horn_caller_line, pitch: :intervals do
        anchor "E4"
        intervals "0{mf} +1 -1 +5 +2 | +1 -1 -2 r | -5 +1 -1 +5 +3 | r -1 r | r | r | r -2 -2 -2 -1 | -2 +2 +1 r +4"
        rhythm    "1/2 1/2 1 3/2 1/2 | 1 1/2 1/2 2 | 1/2 1/2 1 1 1 | 1/2 1/2 3 | 4 | 4 | 1 1 3/4 1/4 1 | 1 1/2 1/2 1 1"
      end

      placement :horn_caller_line, part: :horn_caller, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :flute_responder_line, pitch: :intervals do
        anchor "A5"
        intervals "r | r 0 -2 -2 -1 | r | r 0 +1 -1 -2 -2 | r | +4 +1 -1 +5 -2 | -2 r | r -6 +1 -3"
        rhythm    "4 | 2 3/4 1/4 1/2 1/2 | 4 | 1 1/3 1/3 1/3 1 1 | 4 | 1/2 1/2 1 3/2 1/2 | 1 3 | 2 1/2 1/2 1"
      end

      placement :flute_responder_line, part: :flute_responder, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{p} +7 -7 -2 -2 | -1 +12 -2 -2 -1 | -2 +2 +1 +4 -2 -2 +5 -1 -2 -2 -1 -2 -2 | +9 -2 -2 -1 -7 +1 +2 +1 | +1 -2 -2 -1 +1 +2 +2 +2 +1 +2 +2 +1 -1 | -14 +12 -2 -1 +5 | -7 +2 +1 +2 +2 | -11 -1 +5 -5"
        rhythm    "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1/2 1/4 1/4 1/2 1/4 1/4 1/2 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 3/4 1/4 1 1 | 1/2 1/4 1/4 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/4 1/4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 3/2 1/2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
