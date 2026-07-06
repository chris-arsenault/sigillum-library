production_piece "Technique Card L1_REFRAIN_BAR_SPINE - L1_REFRAIN_BAR_SPINE" do
  meter "4/4", beat_pattern: [1, 1, 1, 1]
  key "G"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L1_REFRAIN_BAR_SPINE
# cite: etude_figure_grammar ; Bach gait bars 2/4/8/10/18/28/30/34/38/42
# behavior: THE REFRAIN-BAR SPINE: one signature rhythm bar (quarter, eighth-pair, quarter,
#   quarter) returns at IRREGULAR intervals - bars 1, 3, 6, 10 - in four different pitch
#   settings (tonic, dominant, relative-minor color, cadential), never twice in a row, with
#   1-3 varying travel bars between. Order from the recurring bar, interest from the travel;
#   the spine opens AND closes the card. From the Bach gait bar: ten appearances, ten
#   settings, spacing 2,4,2,8,10,2,4,4,4.

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind
  end

  section :card, "L1_REFRAIN_BAR_SPINE", bars: 1..10, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..10, texture: :library_card do
      process "the signature rhythm bar at 1, 3, 6, 10 in four settings with varying travel bars between - irregular return spacing, spine opens and closes"

      phrase :l1_refrain_bar_spine, surface: :absolute do
        events %q{
          G4:1{mf,ten} B4:.5{stacc} A4:.5{stacc} B4:1 D5:1 |
          E5:.5{slur(} D5:.5 C5:.5{slur)} B4:.5{stacc} A4:.5{slur(} G4:.5 F#4:.5{slur)} A4:.5{stacc} |
          D5:1{ten} F#5:.5{stacc} E5:.5{stacc} F#5:1 A5:1 |
          G5:.5{slur(} F#5:.5 E5:.5{slur)} D5:.5{stacc} C5:.5{slur(} E5:.5 D5:.5{slur)} C5:.5{stacc} |
          B4:.5{slur(} C5:.5 D5:.5{slur)} B4:.5{stacc} G4:.5{slur(} A4:.5 B4:.5{slur)} G4:.5{stacc} |
          E5:1{ten} G5:.5{stacc} F#5:.5{stacc} G5:1 B4:1 |
          C5:.5{slur(} B4:.5 A4:.5{slur)} G4:.5{stacc} F#4:.5{slur(} A4:.5 D5:.5{slur)} C5:.5{stacc} |
          B4:.5{slur(} A4:.5 G4:.5{slur)} B4:.5{stacc} E5:.5{slur(} D5:.5 C5:.5{slur)} E5:.5{stacc} |
          D5:.5{stacc} C5:.5{stacc} B4:.5{stacc} A4:.5{stacc} B4:.5{slur(} C5:.5{slur)} D5:.5{stacc} F#4:.5{stacc} |
          A4:1{ten} C5:.5{stacc} B4:.5{stacc} B4:1 G4:1{ten}
        }
      end

      placement :l1_refrain_bar_spine, part: :oboe, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
