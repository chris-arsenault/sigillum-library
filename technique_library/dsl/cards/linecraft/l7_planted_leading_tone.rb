production_piece "Technique Card L7_PLANTED_LEADING_TONE - L7_PLANTED_LEADING_TONE" do
  meter "2/4", beat_pattern: [1, 1]
  key "C"

  tempo do
    mark "quarter = 108", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L7_PLANTED_LEADING_TONE
# cite: etude_pitch_devices device 2 ; Bach b6/b11
# behavior: REGION-ENTRY BY PLANTED LEADING TONE: the new key's tension note appears INSIDE the
#   familiar figure before the region arrives - one F sharp inside the C-major motif, and
#   two bars later the music is in G; then one F natural inside the G-major form brings it
#   home. The accidental is a door handle, not color. From Bach (D#5 planted at b6 before
#   the E cadence; E#5 inside an A-major run at b11 before the f#-minor episode).

  roster do
    part :violin, "Violin", music21: "Violin", family: :string
  end

  section :card, "L7_PLANTED_LEADING_TONE", bars: 1..7, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..7, texture: :library_card do
      process "the motif twice in C; the third statement swaps ONE note for F sharp; the motif arrives in G; one F natural inside the G form; home"

      phrase :l7_planted_leading_tone, surface: :absolute do
        events %q{
          C5:.5{mf,ten} E5:.25{stacc} D5:.25{stacc} C5:.5 G4:.5{stacc} |
          C5:.5{ten} E5:.25{stacc} D5:.25{stacc} C5:.5 G4:.5{stacc} |
          C5:.5{ten} E5:.25{stacc} D5:.25{stacc} C5:.5 F#4:.5{accent} |
          G4:.5{ten} B4:.25{stacc} A4:.25{stacc} G4:.5 D5:.5{stacc} |
          G4:.5{ten} B4:.25{stacc} A4:.25{stacc} B4:.5 F4:.5{accent} |
          E4:.5{slur(} G4:.25 F4:.25 E4:.5{slur)} C5:1{ten}
        }
      end

      placement :l7_planted_leading_tone, part: :violin, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
