production_piece "Technique Card L8_SIGNATURE_DISSONANCE - L8_SIGNATURE_DISSONANCE" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "e"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L8_SIGNATURE_DISSONANCE
# cite: etude_pitch_devices device 7 ; Wiedemann b5/b21/b30
# behavior: A SIGNATURE DISSONANCE AS A CHARACTER: one altered note (C natural leaning on B - the
#   flat nine of the dominant) appears exactly three times at formal points, at rising
#   octaves, ALWAYS resolving the same way (down a semitone). A recurring dissonance
#   treated consistently stops being an accident and becomes the piece's face. From
#   Wiedemann's D-natural-over-C# at b5, b21, b30, always resolving down.

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
  end

  section :card, "L8_SIGNATURE_DISSONANCE", bars: 1..8, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..8, texture: :library_card do
      process "the leaning C-natural three times at rising octaves, each resolving down to B the same way - the dissonance becomes the face of the piece"

      phrase :l8_signature_dissonance, surface: :absolute do
        events %q{
          E4:1{mp,ten} G4:.5{stacc} B4:1 A4:.5{stacc} |
          C5:1{accent,ten} B4:.5 G4:1 E4:.5{stacc} |
          F#4:.5{slur(} G4:.5 A4:.5{slur)} B4:.5{stacc} A4:.5{stacc} F#4:.5{stacc} |
          C5:1{accent,ten} B4:.5 F#4:1 D#4:.5{stacc} |
          E4:.5{slur(} G4:.5 B4:.5{slur)} E5:.5{stacc} G5:.5{stacc} F#5:.5{stacc} |
          C6:1{accent,ten} B5:.5 G5:1 E5:.5{stacc} |
          B4:.5{slur(} D#5:.5 F#5:.5{slur)} A4:.5{stacc} G4:.5{stacc} F#4:.5{stacc} |
          E4:2.5{ten} r:.5
        }
      end

      placement :l8_signature_dissonance, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
