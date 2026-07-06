production_piece "Technique Card PH4_SKELETON_MELODY - PH4_SKELETON_MELODY" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "G"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: phrasing
# card: PH4_SKELETON_MELODY
# cite: phrasing_variation_line s4 ; Kietzer m2-13 downbeats ; Wiedemann b9-11
# behavior: THE SKELETON IS THE MELODY; the filler is one-voice harmony. Bars 1-4 state the
#   skeleton BARE as a slow tune (it must sing on its own: do-re | mi-sol | la-sol | re-do,
#   cresting at the long note). Bars 5-12 realize THE SAME TUNE in flowing eighths: each
#   skeleton note lands on its downbeat, the crown keeps its long value (b9), and every
#   filler note is chord-or-neighbor so the ear files it as harmony and keeps following the
#   skeleton. THE WORKING TEST: extract the downbeats + accents + long notes (bar_profile
#   shows them first per bar) - if that skeleton is not a tune on its own, the line is
#   noodling regardless of what the fast notes spell. From Kietzer's downbeat tune cresting
#   at its only long note, Wiedemann 9-11's two-voice skeleton.

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "solo line, lesson: the singable skeleton"
  end

  section :card, "PH4_SKELETON_MELODY", bars: 1..12, type: :technique_card do
    journey "auditionable phrasing-lesson specimen for composing new material"
    destination "the lesson is audible in the line without reading the prose"

    span bars: 1..4, texture: :skeleton_bare do
      process "the skeleton alone, sung slow: it is already a complete tune with a crown"

      phrase :ph4_bare, surface: :absolute do
        events %q{
          G4:2{p,ten} A4:1 |
          B4:2{ten} D5:1 |
          E5:2{ten} D5:1 |
          A4:2{ten} G4:1
        }
      end

      placement :ph4_bare, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "phrasing specimen"
    end

    span bars: 5..12, texture: :skeleton_realized do
      process "the same tune realized in eighths: skeleton notes on downbeats, filler = chord and neighbors, the crown keeps its length"

      phrase :ph4_realized, surface: :absolute do
        events %q{
          G4:.5{mf} B4:.5{stacc} D5:.5{stacc} B4:.5{stacc} G4:.5{stacc} F#4:.5{stacc} |
          A4:.5 C5:.5{stacc} E5:.5{stacc} C5:.5{stacc} A4:.5{stacc} G4:.5{stacc} |
          B4:.5 D5:.5{slur(} G5:.5 F#5:.5{slur)} E5:.5{stacc} D5:.5{stacc} |
          D5:.5 E5:.5{slur(,cresc(} C5:.5 D5:.5{slur)} B4:.5 D5:.5{cresc)} |
          E5:2{f,ten} D5:.5{stacc} C5:.5{stacc} |
          D5:.5 B4:.5{stacc} G5:.5{accent} D5:.5{stacc} C5:.5{stacc} B4:.5{stacc} |
          A4:.5 C5:.5{stacc} F#4:.5{stacc} A4:.5{stacc} D5:.5{stacc} C5:.5{stacc} |
          G4:2.5{ten} r:.5
        }
      end

      placement :ph4_realized, part: :clarinet, at: "bar 5 beat 1", role: :subject, realization: "phrasing specimen"
    end

  end
end
