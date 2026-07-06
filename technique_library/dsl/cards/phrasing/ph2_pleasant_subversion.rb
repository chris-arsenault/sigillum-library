production_piece "Technique Card PH2_PLEASANT_SUBVERSION - PH2_PLEASANT_SUBVERSION" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "F"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH2_PLEASANT_SUBVERSION
# cite: phrasing_variation_line s2 ; Wiedemann b4, b25 ; Kietzer m21-22
# behavior: SUBVERSION IS MOSTLY PLEASANT: surprise of placement and direction with chord tones,
#   not surprise of dissonance. The catalogue in nine bars: b2 answers b1's rising clause
#   DOWNWARD with the same rhythm and only chord tones; b3 is b2's echo MINUS ITS DOWNBEAT
#   (enters a beat late - purely metric surprise, zero dissonance); b5 launches the arpeggio
#   OFF THE ROOT (on the third); b6 dips ONE STEP in the middle of an up-arpeggio; b8
#   restates b1 exactly for two beats then changes only its EXIT (plunge instead of climb).
#   Exactly ONE dissonant subversion in the whole card - the chromatic lean at b7 - and it
#   resolves within half a beat. The ratio is the lesson: consonant surprises everywhere,
#   about one leaning dissonance per section. From Wiedemann b4/b19/b25, Kietzer m21-22.

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "solo line, lesson: what kind of surprise"
  end

  section :card, "PH2_PLEASANT_SUBVERSION", bars: 1..9, type: :technique_card do
    journey "auditionable phrasing-lesson specimen for composing new material"
    destination "the lesson is audible in the line without reading the prose"

    span bars: 1..4, texture: :clause_and_answers do
      process "rising clause, downward answer (chord tones), echo minus its downbeat, half close"

      phrase :ph2_clauses, surface: :absolute do
        events %q{
          F4:1{mf,ten} A4:.5{stacc} C5:1{ten} D5:.5{stacc} |
          C5:1{ten} A4:.5{stacc} F4:1{ten} E4:.5{stacc} |
          r:1 A4:.5{p,stacc} F4:1{ten} G4:.5{stacc} |
          G4:1{ten} E4:.5{stacc} C4:1{ten} C5:.5{stacc}
        }
      end

      placement :ph2_clauses, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 5..8, texture: :arpeggio_subversions do
      process "off-root launch, the mid-climb dip, the one rationed dissonance resolving at once, the exact return with a changed exit"

      phrase :ph2_arps, surface: :absolute do
        events %q{
          A4:.5{mf,slur(} C5:.5 F5:.5{slur)} A5:.5{accent} G5:.5{stacc} F5:.5{stacc} |
          F4:.5{slur(} A4:.5 C5:.5{slur)} Bb4:.5{stacc} D5:.5{stacc} F5:.5{stacc} |
          C5:.5{stacc} E5:.5{stacc} G5:.5{ten} F#5:.5{accent} G5:.5 E5:.5{stacc} |
          F4:1{ten} A4:.5{stacc} D4:1{ten} C4:.5{stacc}
        }
      end

      placement :ph2_arps, part: :clarinet, at: "bar 5 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 9..9, texture: :seal do
      process "close"

      phrase :ph2_close, surface: :absolute do
        events %q{
          G4:.5{p,slur(} E4:.5{slur)} F4:2{ten}
        }
      end

      placement :ph2_close, part: :clarinet, at: "bar 9 beat 1", role: :subject, realization: "phrasing specimen"
    end

  end
end
