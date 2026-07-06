production_piece "Technique Card V3_PHASE_DISPLACED_RETURN - V3_PHASE_DISPLACED_RETURN" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "F"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: variation
# card: V3_PHASE_DISPLACED_RETURN
# cite: etude_pitch_devices ; Wiedemann b33-36
# behavior: METRIC-PHASE DISPLACEMENT AS THE VARIATION: the return keeps the same notes and the
#   same notes-per-slur, but the slurs open one beat later and close across the barline -
#   identical material at a new metric phase. The cheapest strong variation there is: zero
#   new pitches, the grouping alone re-lights the cell. From Wiedemann b33-36 (slurs
#   displaced across barlines at the varied return).

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
  end

  section :card, "V3_PHASE_DISPLACED_RETURN", bars: 1..6, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..6, texture: :library_card do
      process "two bars of on-beat three-note slurs; the same notes return with the slurs opening on beat two and closing over the barline; the displaced phase carries into the cadence"

      phrase :v3_phase_displaced_return, surface: :absolute do
        events %q{
          A4:.5{mp,slur(} G4:.5 A4:.5{slur)} C5:.5{slur(} Bb4:.5 D5:.5{slur)} |
          Bb4:.5{slur(} A4:.5 Bb4:.5{slur)} D5:.5{slur(} C5:.5 F5:.5{slur)} |
          A4:.5{ten} G4:.5{slur(} A4:.5 C5:.5{slur)} Bb4:.5{slur(} D5:.5 |
          Bb4:.5{slur)} A4:.5{slur(} Bb4:.5 D5:.5{slur)} C5:.5{slur(} F5:.5 |
          E5:.5{slur)} D5:.5{slur(} C5:.5 Bb4:.5{slur)} G4:.5{stacc} E4:.5{stacc} |
          F4:2.5{ten} r:.5
        }
      end

      placement :v3_phase_displaced_return, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
