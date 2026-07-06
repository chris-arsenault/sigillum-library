production_piece "Technique Card PH5_BENT_RUNS - PH5_BENT_RUNS" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "am"

  tempo do
    mark "quarter = 96", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH5_BENT_RUNS
# cite: phrasing_variation_line s5 ; Bach m31=m49 ; Kietzer m40-41
# behavior: A RUN IS SPENT, NOT WRITTEN. Every run here has a TARGET (it lands on the next
#   skeleton note, not wherever it ran out of bar) and BENDS within five or six notes - a
#   direction change, a leap out, an early exit. The downbeat skeleton climbs A-C-E-A
#   (b1-4) and descends (b5-7) while the sixteenths bend onto each target. Then the one
#   UNBENT scale in the card: the two-octave descent at b8, at the dynamic peak - a formal
#   EVENT spent exactly once, like a reserved top note. Scales are discharge, not texture.
#   From Bach's twice-only octave downstroke (m31/49) and Kietzer's f-release scale
#   (m40-41).

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "solo line, lesson: runs bend onto targets"
  end

  section :card, "PH5_BENT_RUNS", bars: 1..9, type: :technique_card do
    journey "auditionable phrasing-lesson specimen for composing new material"
    destination "the lesson is audible in the line without reading the prose"

    span bars: 1..4, texture: :bent_ascent do
      process "the skeleton climbs A-C-E-A on the downbeats; every 16th run bends within 5-6 notes and lands its target"

      phrase :ph5_ascent, surface: :absolute do
        events %q{
          A4:.5{mp,ten} B4:.25{slur(} C5:.25 D5:.25 E5:.25{slur)} D5:.25{slur(} C5:.25 B4:.25 C5:.25{slur)} D5:.25{slur(} B4:.25{slur)} |
          C5:.5{ten} D5:.25{slur(} E5:.25 F5:.25 E5:.25{slur)} D5:.25{slur(} E5:.25 F5:.25 G5:.25{slur)} F5:.25{slur(} D5:.25{slur)} |
          E5:.5{ten} F5:.25{slur(} G5:.25 A5:.25 G5:.25{slur)} F5:.25{slur(} E5:.25 F5:.25 G5:.25{slur)} A5:.25{slur(} B5:.25{slur)} |
          A5:.5{mf,ten} G5:.25{slur(} F5:.25 E5:.25 F5:.25{slur)} G5:.25{slur(} E5:.25 C5:.25 E5:.25{slur)} A5:.25{slur(} G#5:.25{slur)}
        }
      end

      placement :ph5_ascent, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 5..7, texture: :bent_descent do
      process "the skeleton walks down; runs keep bending onto their targets"

      phrase :ph5_descent, surface: :absolute do
        events %q{
          A5:.5{ten} G5:.25{slur(} F5:.25 E5:.25 D5:.25{slur)} E5:.25{slur(} F5:.25 E5:.25 D5:.25{slur)} C5:.25{slur(} B4:.25{slur)} |
          C5:.5{ten} B4:.25{slur(} A4:.25 G#4:.25 A4:.25{slur)} B4:.25{slur(} C5:.25 D5:.25 C5:.25{slur)} B4:.25{slur(} A4:.25{slur)} |
          E5:.5{ten} D5:.25{slur(} C5:.25 B4:.25 C5:.25{slur)} D5:.25{slur(} B4:.25 G#4:.25 B4:.25{slur)} E5:.5{accent}
        }
      end

      placement :ph5_descent, part: :clarinet, at: "bar 5 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 8..9, texture: :spent_scale do
      process "the one unbent scale: a two-octave descent as the dynamic peak, spent once, then the seal"

      phrase :ph5_scale, surface: :absolute do
        events %q{
          A5:.25{f} G5:.25 F5:.25 E5:.25 D5:.25 C5:.25 B4:.25 A4:.25 G4:.25 F4:.25 E4:.25 D4:.25 C4:.25 B3:.25 A3:.25 A3:.25 |
          A3:.5 E4:.25{stacc} G#4:.25{stacc} A4:2{ten} r:1
        }
      end

      placement :ph5_scale, part: :clarinet, at: "bar 8 beat 1", role: :subject, realization: "phrasing specimen"
    end

  end
end
