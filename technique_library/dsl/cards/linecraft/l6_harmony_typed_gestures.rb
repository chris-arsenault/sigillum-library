production_piece "Technique Card L6_HARMONY_TYPED_GESTURES - L6_HARMONY_TYPED_GESTURES" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "G"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L6_HARMONY_TYPED_GESTURES
# cite: etude_pitch_devices ; Kietzer m27-29
# behavior: HARMONY-TYPED GESTURES: the dominant DISCHARGES as a falling arpeggio through its
#   inversions; the tonic ANSWERS as a rising stepwise scale. The piece's two biggest
#   gesture types are harmonically assigned, so the largest motions carry function even at
#   speed. From Kietzer m27-29 (the two-octave E7 arpeggio down, the two-octave tonic scale
#   up).

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind
  end

  section :card, "L6_HARMONY_TYPED_GESTURES", bars: 1..5, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..5, texture: :library_card do
      process "statement; the dominant falls two octaves in arpeggio; the tonic answers rising in steps; the pair compressed into one bar; seal"

      phrase :l6_harmony_typed_gestures, surface: :absolute do
        events %q{
          G4:1{mf,ten} B4:.5{stacc} A4:.5{stacc} B4:1 D5:1 |
          C6:.5{f,slur(} A5:.5 F#5:.5 D5:.5 C5:.5 A4:.5 F#4:.5 D4:.5{slur)} |
          G4:.5{p,slur(} A4:.5 B4:.5 C5:.5{slur)} D5:.5{slur(} E5:.5 F#5:.5 G5:.5{slur)} |
          C6:.5{slur(} A5:.5 F#5:.5 D5:.5{slur)} E5:.5{slur(} F#5:.5{slur)} G5:1{ten} |
          G5:.5{stacc} D5:.5{stacc} B4:.5{stacc} D5:.5{stacc} G4:2{ten}
        }
      end

      placement :l6_harmony_typed_gestures, part: :oboe, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
