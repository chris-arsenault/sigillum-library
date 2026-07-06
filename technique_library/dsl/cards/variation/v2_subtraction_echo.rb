production_piece "Technique Card V2_SUBTRACTION_ECHO - V2_SUBTRACTION_ECHO" do
  meter "2/4", beat_pattern: [1, 1]
  key "Bb"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: variation
# card: V2_SUBTRACTION_ECHO
# cite: etude_pitch_devices ; Kietzer m21-22
# behavior: VARIATION BY SUBTRACTION: the echo repeats the statement MINUS its head - first minus
#   the downbeat (enters an eighth late), then minus everything but the tail. A literal
#   repeat gains a new metric face by losing a note, and the shrinking chain is a composed
#   diminuendo of content as well as dynamics. From Kietzer m21-22 (the echo minus its
#   downbeat) and the liquidation practice in all three etudes.

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind
  end

  section :card, "V2_SUBTRACTION_ECHO", bars: 1..8, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..8, texture: :library_card do
      process "statement, echo minus its downbeat, echo shrunk to its tail; a link; the same chain at the fifth; the head returns whole to seal"

      phrase :v2_subtraction_echo, surface: :absolute do
        events %q{
          Bb4:.5{f,ten} D5:.25{stacc} C5:.25{stacc} Bb4:.5 F4:.5{stacc} |
          r:.5 D5:.25{p,stacc} C5:.25{stacc} Bb4:.5 F4:.5{stacc} |
          r:1 Bb4:.5{pp} F4:.5{stacc} |
          G4:.5{slur(} A4:.5{slur)} Bb4:.5{stacc} C5:.5{stacc} |
          F5:.5{f,ten} Eb5:.25{stacc} D5:.25{stacc} C5:.5 Bb4:.5{stacc} |
          r:.5 Eb5:.25{p,stacc} D5:.25{stacc} C5:.5 Bb4:.5{stacc} |
          r:1 C5:.5{pp} Bb4:.5{stacc} |
          Bb4:.5{mf,ten} D5:.25{stacc} C5:.25{stacc} Bb4:1{ten}
        }
      end

      placement :v2_subtraction_echo, part: :oboe, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
