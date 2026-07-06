production_piece "Technique Card PH6_ELIDED_PHRASES - PH6_ELIDED_PHRASES" do
  meter "2/4", beat_pattern: [1, 1]
  key "G"

  tempo do
    mark "quarter = 108", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH6_ELIDED_PHRASES
# cite: phrasing_variation_line s6 ; Bach m9/m17/m45 ; Kietzer m19
# behavior: SQUARE FORM, BREATHING PHRASES. Two eight-bar strains (square), but no phrase ever
#   just stops: the b4 cadence bar carries the NEXT phrase's pickup in its second beat; the
#   b8 strain cadence carries strain two's pickup; at b12 one phrase ENDS mid-bar and the
#   next STARTS mid-bar (overlap inside one bar). The listener gets the security of the
#   square form and the pull of never actually stopping - arrivals are simultaneously
#   departures, so no seam ever needs an abrupt transition. From Bach's cadence bars
#   (m9/17/45 all carry pickups) and Kietzer m19's phrase-end/section-start overlap.

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "solo line, lesson: elide every seam"
  end

  section :card, "PH6_ELIDED_PHRASES", bars: 1..16, type: :technique_card do
    journey "auditionable phrasing-lesson specimen for composing new material"
    destination "the lesson is audible in the line without reading the prose"

    span bars: 1..8, texture: :strain_one do
      process "first strain: 4+4 with the cadence bars carrying the pickups of what follows"

      phrase :ph6_strain1, surface: :absolute do
        events %q{
          G4:.5{mf,ten} A4:.25{stacc} B4:.25{stacc} D5:.5 B4:.5{stacc} |
          C5:.5{ten} B4:.25{stacc} A4:.25{stacc} B4:.5 G4:.5{stacc} |
          E5:.5{ten} D5:.25{stacc} C5:.25{stacc} B4:.5 A4:.5{stacc} |
          G4:1{ten} B4:.5{p,stacc} C5:.5{stacc} |
          D5:.5{mf,ten} E5:.25{stacc} F#5:.25{stacc} G5:.5 E5:.5{stacc} |
          D5:.5{ten} C5:.25{stacc} B4:.25{stacc} C5:.5 A4:.5{stacc} |
          B4:.5{ten} G4:.25{stacc} A4:.25{stacc} B4:.25{stacc} C5:.25{stacc} D5:.5 |
          G4:1{ten} D5:.5{p,stacc} G5:.5{stacc}
        }
      end

      placement :ph6_strain1, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 9..16, texture: :strain_two do
      process "second strain launched by the cadence-borne pickup; b12 overlaps phrase-end and phrase-start inside one bar"

      phrase :ph6_strain2, surface: :absolute do
        events %q{
          A5:.5{mf,ten} G5:.25{stacc} F#5:.25{stacc} E5:.5 D5:.5{stacc} |
          E5:.5{ten} F#5:.25{stacc} G5:.25{stacc} F#5:.5 D5:.5{stacc} |
          C5:.5{ten} D5:.25{stacc} E5:.25{stacc} D5:.5 B4:.5{stacc} |
          A4:.5 G4:.5{ten} B4:.5{p,stacc} D5:.5{stacc} |
          G5:.5{mf,ten} F#5:.25{stacc} E5:.25{stacc} D5:.5 E5:.5{stacc} |
          C5:.5{ten} E5:.25{stacc} D5:.25{stacc} C5:.5 A4:.5{stacc} |
          B4:.5{ten} D5:.25{stacc} C5:.25{stacc} B4:.25{stacc} A4:.25{stacc} G4:.5 |
          G4:1.5{ten} r:.5
        }
      end

      placement :ph6_strain2, part: :clarinet, at: "bar 9 beat 1", role: :subject, realization: "phrasing specimen"
    end

  end
end
