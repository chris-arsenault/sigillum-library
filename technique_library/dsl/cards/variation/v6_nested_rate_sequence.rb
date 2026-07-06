production_piece "Technique Card V6_NESTED_RATE_SEQUENCE - V6_NESTED_RATE_SEQUENCE" do
  meter "2/4", beat_pattern: [1, 1]
  key "C"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: variation
# card: V6_NESTED_RATE_SEQUENCE
# cite: etude_pitch_devices ; Kietzer m12 ; Bach m22-25
# behavior: TWO DESCENTS AT DIFFERENT RATES IN ONE LINE: the slurred pairs each fall a STEP
#   (micro) while the pairs' starting notes fall by THIRDS (macro), with tongued risers
#   between - so the line descends at two speeds at once and the ear can follow either.
#   From Kietzer m12 (pairs fall a step, starts fall by thirds) and Bach m22-25 (the sigh
#   braid whose net descent is built from ascents).

  roster do
    part :violin, "Violin", music21: "Violin", family: :string
  end

  section :card, "V6_NESTED_RATE_SEQUENCE", bars: 1..5, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..5, texture: :library_card do
      process "slurred pairs falling a step while their starts fall by thirds, tongued risers between; the two descent rates converge at the cadence"

      phrase :v6_nested_rate_sequence, surface: :absolute do
        events %q{
          E5:.5{mf,accent,slur(} D5:.5{slur)} B4:.5{stacc} C5:.5{stacc} |
          C5:.5{accent,slur(} B4:.5{slur)} G4:.5{stacc} A4:.5{stacc} |
          A4:.5{accent,slur(} G4:.5{slur)} E4:.5{stacc} F4:.5{stacc} |
          F4:.5{slur(} E4:.5{slur)} D4:.5{stacc} G4:.5{stacc} |
          C5:.5{ten} B4:.25{stacc} D5:.25{stacc} C5:1{ten}
        }
      end

      placement :v6_nested_rate_sequence, part: :violin, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
