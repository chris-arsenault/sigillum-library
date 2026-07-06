production_piece "Technique Card PH3_LONG_NOTE_TRIPLE_JOB - PH3_LONG_NOTE_TRIPLE_JOB" do
  meter "6/8", beat_pattern: [3, 3]
  key "d"

  tempo do
    mark "dotted-quarter = 60", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH3_LONG_NOTE_TRIPLE_JOB
# cite: phrasing_variation_line s3 ; Wiedemann b20 ; Kietzer m7
# behavior: EVERY LONG NOTE DOES THREE JOBS AT ONCE: reward (the expressive peak), breath (the
#   player recovers), pivot (the music changes figure or register out of it). Three long
#   notes, three placements: b3 the CROWN - the highest note held at the phrase peak,
#   pivoting into the descent (hold the high note, singer logic); b6 the FLOOR - the long
#   low tonic that is simultaneously a phrase floor and the LAUNCHPAD of the arpeggio
#   flight; b9 the SEAL. Never a long note parked mid-phrase as mere rest: if a spot exists
#   only so the player can breathe, the piece sounds like it stopped. From Wiedemann b8/20/28
#   and Kietzer's crown C#6 at m7.

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "solo line, lesson: where the long note goes"
  end

  section :card, "PH3_LONG_NOTE_TRIPLE_JOB", bars: 1..9, type: :technique_card do
    journey "auditionable phrasing-lesson specimen for composing new material"
    destination "the lesson is audible in the line without reading the prose"

    span bars: 1..5, texture: :rise_crown_descent do
      process "two rising bars into the CROWN long note (reward+breath+pivot), then the composed descent"

      phrase :ph3_crown, surface: :absolute do
        events %q{
          D4:.5{p,slur(} E4:.5 F4:.5{slur)} G4:.5{slur(,cresc(} A4:.5 Bb4:.5{slur)} |
          A4:.5{slur(} C5:.5 D5:.5{slur)} E5:.5{slur(} F5:.5 G5:.5{slur),cresc)} |
          A5:1.5{mf,ten} G5:.5{slur(} F5:.5 E5:.5{slur)} |
          F5:.5{slur(} D5:.5 E5:.5{slur)} C#5:.5{stacc} D5:.5{stacc} A4:.5{stacc} |
          F4:.5{slur(} G4:.5 A4:.5{slur)} F4:.5{p,stacc} E4:.5{stacc} D4:.5{stacc}
        }
      end

      placement :ph3_crown, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 6..9, texture: :floor_launch_seal do
      process "the long LOW note as floor and launchpad, the flight it launches, and the final long as arrival"

      phrase :ph3_floor, surface: :absolute do
        events %q{
          D4:1.5{p,ten} A4:.5{mf,slur(} D5:.5 F5:.5{slur)} |
          A5:.5{stacc} F5:.5{stacc} D5:.5{stacc} A4:.5{stacc} C#5:.5{stacc} E5:.5{stacc} |
          D5:.5{slur(} F5:.5 E5:.5{slur)} G4:.5{stacc} A4:.5{stacc} C#5:.5{stacc} |
          D5:2.5{ten} r:.5
        }
      end

      placement :ph3_floor, part: :clarinet, at: "bar 6 beat 1", role: :subject, realization: "phrasing specimen"
    end

  end
end
