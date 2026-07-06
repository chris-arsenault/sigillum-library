production_piece "Technique Card PH7_ONE_SHOT_ECONOMY - PH7_ONE_SHOT_ECONOMY" do
  meter "2/4", beat_pattern: [1, 1]
  key "Bb"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH7_ONE_SHOT_ECONOMY
# cite: etude_pitch_devices ; Kietzer anacrusis/m7/m42-43
# behavior: ONE-SHOT ECONOMY: single-use events mark form. In twelve bars of otherwise uniform
#   eighths there is exactly ONE dotted figure (the launch motto, b1), ONE long note (the
#   crown, b6), ONE cross-bar slur (the weld, b9-10), and ONE strong accent (the seal,
#   b12). Because each exists once, each reads as a formal signpost for free. From Kietzer:
#   the only dotted figure launches A and A-prime, the only long note crowns one phrase, the
#   only cross-bar slur welds the feint to the seal.

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind
  end

  section :card, "PH7_ONE_SHOT_ECONOMY", bars: 1..12, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..12, texture: :library_card do
      process "uniform eighths carrying four one-shots: the dotted motto, the long crown, the cross-bar weld, the accented seal - each single use marks a formal point"

      phrase :ph7_one_shot_economy, surface: :absolute do
        events %q{
          Bb4:.75{mf,ten} C5:.25 D5:.5 F5:.5 |
          Eb5:.5 D5:.5 C5:.5 Bb4:.5 |
          D5:.5 F5:.5 Bb5:.5 F5:.5 |
          G5:.5 F5:.5 Eb5:.5 D5:.5 |
          Eb5:.5 G5:.5 F5:.5 Bb4:.5 |
          F5:1.5{ten} Eb5:.5 |
          D5:.5 Bb4:.5 Eb5:.5 C5:.5 |
          D5:.5 F5:.5 Bb4:.5 D5:.5 |
          C5:.5 Eb5:.5 D5:.5 F5:.5{slur(} |
          Bb5:.5{slur)} F5:.5 D5:.5 Bb4:.5 |
          C5:.5 D5:.5 Eb5:.25 D5:.25 C5:.5 |
          Bb4:1.5{marc} r:.5
        }
      end

      placement :ph7_one_shot_economy, part: :flute, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
