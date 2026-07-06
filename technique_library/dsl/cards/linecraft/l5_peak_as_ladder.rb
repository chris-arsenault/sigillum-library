production_piece "Technique Card L5_PEAK_AS_LADDER - L5_PEAK_AS_LADDER" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "F"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L5_PEAK_AS_LADDER
# cite: etude_pitch_devices ; Kietzer m11/m18/m19
# behavior: THE PEAK AS PROCESS COMPLETION: the appoggiatura pair climbs a ladder through the
#   form - 2-1, then 4-3, then 6-5 - and the piece's top note is simply the third rung. A
#   summit that completes a motif process can be spent anywhere in the form without
#   breaking anything, because it arrives as logic, not as effort. From Kietzer's F#6: the
#   third rung of B-A (m11), D-C# (m18), F#-E (m19).

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind
  end

  section :card, "L5_PEAK_AS_LADDER", bars: 1..6, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..6, texture: :library_card do
      process "the accented appoggiatura pair climbs 2-1, 4-3, 6-5 across the card; the top note is the ladder completing itself"

      phrase :l5_peak_as_ladder, surface: :absolute do
        events %q{
          C5:.5{mf} F5:.5 G5:.5{accent,slur(} F5:.5{slur)} E5:.5{stacc} C5:.5{stacc} A4:.5{stacc} F4:.5{stacc} |
          G4:.5{slur(} A4:.5 Bb4:.5{slur)} G4:.5{stacc} C5:.5{slur(} D5:.5 E5:.5{slur)} C5:.5{stacc} |
          F4:.5 A4:.5 Bb5:.5{accent,slur(} A5:.5{slur)} F5:.5{stacc} C5:.5{stacc} A4:.5{stacc} C5:.5{stacc} |
          C5:.5{slur(} D5:.5 E5:.5{slur)} F5:.5{stacc} G5:.5{slur(} A5:.5 G5:.5{slur)} F5:.5{stacc} |
          F5:.5 A5:.5 D6:.5{accent,slur(} C6:.5{slur)} A5:.5{stacc} F5:.5{stacc} C5:.5{stacc} A4:.5{stacc} |
          Bb4:.5{slur(} G4:.5{slur)} A4:.25{stacc} G4:.25{stacc} F4:2.5{ten}
        }
      end

      placement :l5_peak_as_ladder, part: :flute, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
