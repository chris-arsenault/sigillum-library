production_piece "Technique Card L2_FIXED_APEX - L2_FIXED_APEX" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "C"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L2_FIXED_APEX
# cite: etude_pitch_devices device 4 ; Bach b6-7
# behavior: THE FIXED APEX: four slide cells all reach the SAME top note while their launch
#   points fall by step and third - so the cell's span widens (3rd, 4th, 5th, 6th) and the
#   tension grows though the ceiling never moves. The apex only releases when it becomes a
#   long note and descends. From Bach b6-7 (three slides to the same A5 from launches
#   falling by thirds, spans m3 -> dim5 -> m7).

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
  end

  section :card, "L2_FIXED_APEX", bars: 1..4, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..4, texture: :library_card do
      process "four slide cells to one apex from falling launches - the span widens while the ceiling holds; the apex becomes the long note and releases"

      phrase :l2_fixed_apex, surface: :absolute do
        events %q{
          E5:.5{mf,slur(} F5:.5 G5:.5{slur)} C5:.5{stacc} D5:.5{slur(} F5:.5 G5:.5{slur)} B4:.5{stacc} |
          C5:.5{slur(} F5:.5 G5:.5{slur)} A4:.5{stacc} B4:.5{slur(} F5:.5 G5:.5{slur)} G4:.5{stacc} |
          G5:1{ten} F5:.5{stacc} E5:.5{stacc} D5:.5{slur(} C5:.5 D5:.5{slur)} B4:.5{stacc} |
          E5:.5{slur(} D5:.5{slur)} B4:.5{stacc} G4:.5{stacc} C5:2{ten}
        }
      end

      placement :l2_fixed_apex, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
