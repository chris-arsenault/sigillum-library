production_piece "Technique Card V5_PLATEAU_ACCELERATION - V5_PLATEAU_ACCELERATION" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "am"

  tempo do
    mark "quarter = 96", at: "bar 1 beat 1"
  end

# category: variation
# card: V5_PLATEAU_ACCELERATION
# cite: phrasing_variation_line s1 ; Kietzer m36-39
# behavior: ACCELERATION INSIDE A PLATEAU: an oscillation figure that looks like a block but
#   halves its unit midway - the neighbor-resolution changes per HALF-BAR for two bars, then
#   per BEAT for two bars, then releases. Insistence is legal only when something inside it
#   speeds up or descends; this is the speeding-up version. From Kietzer m36-39 (harmonic
#   rhythm halving inside the cadential oscillation).

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
  end

  section :card, "V5_PLATEAU_ACCELERATION", bars: 1..5, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..5, texture: :library_card do
      process "the same neighbor-oscillation at half-bar rate twice, then at beat rate twice, then released - a plateau whose interior accelerates"

      phrase :v5_plateau_acceleration, surface: :absolute do
        events %q{
          A4:.5{mp,slur(} G#4:.5{slur)} G#4:.5{stacc} G#4:.5{stacc} A4:.5{slur(} G#4:.5{slur)} G#4:.5{stacc} G#4:.5{stacc} |
          A4:.5{slur(} G#4:.5{slur)} G#4:.5{stacc} G#4:.5{stacc} A4:.5{slur(} G#4:.5{slur)} G#4:.5{stacc} G#4:.5{stacc} |
          A4:.25{slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} A4:.25{slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} A4:.25{slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} A4:.25{slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} |
          A4:.25{cresc(,slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} A4:.25{slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} A4:.25{slur(} G#4:.25{slur)} G#4:.25{stacc} G#4:.25{stacc} A4:.25{slur(} G#4:.25{slur)} A4:.25{stacc} B4:.25{stacc,cresc)} |
          C5:.25{mf,slur(} B4:.25 A4:.25 G#4:.25{slur)} A4:.5{stacc} E4:.5{stacc} A4:2{ten}
        }
      end

      placement :v5_plateau_acceleration, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
