production_piece "Technique Card V7_CELL_RESIZE - V7_CELL_RESIZE" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "D"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: variation
# card: V7_CELL_RESIZE
# cite: etude_pitch_devices ; Kietzer m2
# behavior: THE SAME CELL AT THREE SIZES: a rise-and-turn cell stated at half-bar size, compressed
#   to beat size (sequenced up the scale), then dilated to a full bar in quarters - the
#   final dilation reads as arrival weight, the compression as urgency, with no new pitch
#   material anywhere. From Kietzer m2 (the cell at half-bar AND beat size in one bar) and
#   the augmentation practice in the etudes' codas.

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind
  end

  section :card, "V7_CELL_RESIZE", bars: 1..4, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..4, texture: :library_card do
      process "half-bar cells, then the cell compressed to beats and sequenced up, then dilated to a full bar of quarters, then the seal"

      phrase :v7_cell_resize, surface: :absolute do
        events %q{
          D5:.5{mf} F#5:.5 A5:.5 F#5:.5 E5:.5 G5:.5 B5:.5 G5:.5 |
          D5:.25 F#5:.25 A5:.25 F#5:.25 E5:.25 G5:.25 B5:.25 G5:.25 F#5:.25 A5:.25 C#6:.25 A5:.25 G5:.25 B5:.25 D6:.25 B5:.25 |
          D6:1{ten} F#5:1 A5:1 F#5:1 |
          G5:.5{slur(} E5:.5{slur)} C#5:.5{stacc} E5:.5{stacc} D5:2{ten}
        }
      end

      placement :v7_cell_resize, part: :flute, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
