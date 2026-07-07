production_piece "Technique Card PH8_TERRACED_ECHO - PH8_TERRACED_ECHO" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "D"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH8_TERRACED_ECHO
# cite: etude_pitch_devices ; Bach dynamics m1-52
# behavior: TERRACED ECHO: every forte statement is answered by its piano echo, and the echo
#   always carries one small change (an altered tail, a changed exit) so the repetition
#   obeys the budget while the dynamic terrace does the phrasing. Dynamics become form: the
#   listener hears statement/answer architecture without a single new figure. From the Bach
#   Bourree's f/p scheme (every f statement gets a p echo: m5, 13, 26, 29, 37, 45).

  roster do
    part :violin, "Violin", music21: "Violin", family: :string
  end

  section :card, "PH8_TERRACED_ECHO", bars: 1..9, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..9, texture: :library_card do
      process "forte statement, piano echo with an altered tail; the pair again a third higher, the final echo changing its exit into the close"

      phrase :ph8_terraced_echo, surface: :absolute do
        events %q{
          D5:1{f,ten} F#5:.5{stacc} E5:.5{stacc} F#5:1 A5:1 |
          B5:.5{slur(} A5:.5{slur)} G5:.5{stacc} F#5:.5{stacc} E5:1{ten} A4:1 |
          D5:1{p,ten} F#5:.5{stacc} E5:.5{stacc} F#5:1 A5:1 |
          B5:.5{slur(} A5:.5{slur)} G5:.5{stacc} E5:.5{stacc} D5:1{ten} A4:1 |
          F#5:1{f,ten} A5:.5{stacc} G5:.5{stacc} A5:1 D6:1 |
          E6:.5{slur(} D6:.5{slur)} C#6:.5{stacc} B5:.5{stacc} A5:1{ten} D5:1 |
          F#5:1{p,ten} A5:.5{stacc} G5:.5{stacc} A5:1 D6:1 |
          E6:.5{slur(} D6:.5{slur)} C#6:.5{stacc} A5:.5{stacc} F#5:.5{stacc} E5:.5{stacc} D5:2{ten}
        }
      end

      placement :ph8_terraced_echo, part: :violin, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
