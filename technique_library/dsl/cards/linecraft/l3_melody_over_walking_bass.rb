production_piece "Technique Card L3_MELODY_OVER_WALKING_BASS - L3_MELODY_OVER_WALKING_BASS" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "C"

  tempo do
    mark "quarter = 96", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L3_MELODY_OVER_WALKING_BASS
# cite: phrasing_variation_line s4 ; Bach b26-27 ; Kietzer m32-33
# behavior: TWO VOICES IN ONE LINE: register alternation projects a sustained-by-repetition
#   melody note on top while a bass voice WALKS underneath - the top holds its station (E5)
#   as the bass climbs E3-F3-G3-A3, then the melody descends as the bass keeps walking, then
#   both converge. The ear streams two parts from one instrument. From Bach b26-27 (fixed
#   dyad over falling bass entries) and Kietzer m32-33 (chromatic bass walk under the
#   hammered plane).

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
  end

  section :card, "L3_MELODY_OVER_WALKING_BASS", bars: 1..4, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..4, texture: :library_card do
      process "the low voice walks up while the top note holds by repetition; the melody then falls as the bass keeps walking; the voices converge to the cadence"

      phrase :l3_melody_over_walking_bass, surface: :absolute do
        events %q{
          E3:.5{mp} E5:.5{ten} F3:.5 E5:.5 G3:.5 E5:.5 A3:.5 E5:.5 |
          B3:.5 F5:.5{ten} C4:.5 E5:.5 D4:.5 D5:.5 G3:.5 B4:.5 |
          G3:.5 C5:.5{ten} F3:.5 B4:.5 E3:.5 C5:.5 D3:.5 B4:.5 |
          C4:.5{slur(} E4:.5 G4:.5 B4:.5{slur)} C5:2{ten}
        }
      end

      placement :l3_melody_over_walking_bass, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
