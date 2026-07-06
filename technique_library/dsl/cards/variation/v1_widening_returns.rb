production_piece "Technique Card V1_WIDENING_RETURNS - V1_WIDENING_RETURNS" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "D"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: variation
# card: V1_WIDENING_RETURNS
# cite: etude_pitch_devices device 3 ; Wiedemann b9-11
# behavior: WIDENING-INTERVAL INTENSIFICATION: the same clause returns four times and the ONLY
#   escalation is its characteristic leap growing - 3rd, 4th, 5th, 6th - while the stepwise
#   foot climbs one degree per bar. Written-in intensification with zero added notes, zero
#   added dynamics: the interval IS the crescendo. From Wiedemann b9-11 (accent leaps
#   3rd->4th->5th), Bach b6-7 (slide spans m3->dim5->m7), Kietzer's plane transfers.

  roster do
    part :violin, "Violin", music21: "Violin", family: :string
  end

  section :card, "V1_WIDENING_RETURNS", bars: 1..6, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..6, texture: :library_card do
      process "the same rise-and-leap clause four times; the foot climbs a step per bar and the leap to the accent widens 3rd-4th-5th-6th; then release and seal"

      phrase :v1_widening_returns, surface: :absolute do
        events %q{
          D4:.5{mf} E4:.5 F#4:.5 A4:.5{accent} G4:.5 F#4:.5 |
          E4:.5 F#4:.5 G4:.5 C5:.5{accent} B4:.5 A4:.5 |
          F#4:.5 G4:.5 A4:.5 E5:.5{accent} D5:.5 C#5:.5 |
          G4:.5{cresc(} A4:.5 B4:.5 G5:.5{accent,cresc)} F#5:.5 E5:.5 |
          F#5:.5{slur(} E5:.5 D5:.5{slur)} C#5:.5{stacc} B4:.5{stacc} A4:.5{stacc} |
          D5:2.5{ten} r:.5
        }
      end

      placement :v1_widening_returns, part: :violin, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
