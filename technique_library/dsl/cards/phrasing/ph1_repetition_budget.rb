production_piece "Technique Card PH1_REPETITION_BUDGET - PH1_REPETITION_BUDGET" do
  meter "2/4", beat_pattern: [1, 1]
  key "C"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH1_REPETITION_BUDGET
# cite: phrasing_variation_line s1 ; Kietzer 2-4=14-16 ; Bach m31=m49
# behavior: THE REPETITION BUDGET, all three regimes audible in ten bars. A catchy one-bar motif
#   is stated TWICE exactly (b1-2), then MOVED on the third statement (b3 up a step, b4 onto
#   the dominant): sequential repetition changes by the third statement. Contrast material
#   (b5-6), then the hammered-plane cap: six strikes of one note maximum before the line
#   must move (b7). Then the DISTANT regime: b9 restates b1 LITERALLY after eight bars away,
#   where it lands as a rhyme, not a repeat. Verify with recurrence_map: the exact-repeat
#   group {1,2,9} shows both budgets in one line - the adjacent pair and the distant rhyme.
#   From the Selected Studies etudes: Wiedemann 1-2/13-14, Kietzer 14-16 and its planes,
#   Bach 31=49.

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "solo line, lesson: how much repetition"
  end

  section :card, "PH1_REPETITION_BUDGET", bars: 1..10, type: :technique_card do
    journey "auditionable phrasing-lesson specimen for composing new material"
    destination "the lesson is audible in the line without reading the prose"

    span bars: 1..4, texture: :statement_budget do
      process "motif stated twice exactly, moved up a step on the third statement, onto the dominant on the fourth"

      phrase :ph1_statement, surface: :absolute do
        events %q{
          C5:.5{mf,ten} E5:.25{stacc} D5:.25{stacc} C5:.5 G4:.5{stacc} |
          C5:.5{ten} E5:.25{stacc} D5:.25{stacc} C5:.5 G4:.5{stacc} |
          D5:.5{ten} F5:.25{stacc} E5:.25{stacc} D5:.5 A4:.5{stacc} |
          B4:.5{ten} D5:.25{stacc} C5:.25{stacc} B4:.5 G4:.5{stacc}
        }
      end

      placement :ph1_statement, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 5..8, texture: :contrast_and_cap do
      process "contrast figure for distance, then the hammered-plane cap: six strikes then the plane MUST move"

      phrase :ph1_contrast, surface: :absolute do
        events %q{
          E5:.25{p,slur(} F5:.25 G5:.25 E5:.25{slur)} F5:.25{slur(} E5:.25 D5:.25 B4:.25{slur)} |
          C5:.25{slur(} D5:.25 E5:.25 C5:.25{slur)} D5:.25{slur(} C5:.25 B4:.25 G4:.25{slur)} |
          G5:.25{mf,stacc} G5:.25{stacc} G5:.25{stacc} G5:.25{stacc} G5:.25{stacc} G5:.25{stacc} A5:.25{stacc} B5:.25{stacc} |
          C6:.5{ten} B5:.25{stacc} A5:.25{stacc} G5:.5 F5:.5{stacc}
        }
      end

      placement :ph1_contrast, part: :clarinet, at: "bar 5 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 9..10, texture: :distant_rhyme do
      process "the literal return after eight bars away: a rhyme, not a repeat; then the seal"

      phrase :ph1_rhyme, surface: :absolute do
        events %q{
          C5:.5{mf,ten} E5:.25{stacc} D5:.25{stacc} C5:.5 G4:.5{stacc} |
          C5:.5 G4:.25{stacc} B4:.25{stacc} C5:1{ten}
        }
      end

      placement :ph1_rhyme, part: :clarinet, at: "bar 9 beat 1", role: :subject, realization: "phrasing specimen"
    end

  end
end
