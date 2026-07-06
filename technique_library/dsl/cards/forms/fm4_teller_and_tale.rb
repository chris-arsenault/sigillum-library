production_piece "Technique Card FM4_TELLER_AND_TALE - FM4_TELLER_AND_TALE" do
  meter "4/4"
  key "C"

# category: forms
# card: FM4_TELLER_AND_TALE
# cite: keyboard_figuration s6g (narrator-form)
# behavior: narration vs ENACTMENT: the teller's gesture (leap+snap) is DRAMATIZED by the
#   ensemble, not answered; second enactment OVERLAPS the narration (the tale getting ahead of
#   its teller); the frame reasserts alone

  roster do
    part :solo_violin_teller, "Solo Violin (teller)", music21: "Violin", family: :string, description: "Violin"
    part :flute_tale, "Flute (tale)", music21: "Flute", family: :woodwind, description: "Flute"
    part :viola_tale, "Viola (tale)", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FM4_TELLER_AND_TALE", bars: 1..10, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..10, texture: :library_card do
      process "narration vs ENACTMENT: the teller's gesture (leap+snap) is DRAMATIZED by the ensemble, not answered; second enactment OVERLAPS the narration (the tale getting ahead of its teller); the frame reasserts alone"

      phrase :solo_violin_teller_line, pitch: :intervals do
        anchor "A4"
        intervals "0{p,txt:narrando} +1 -1 -2 -1 -3 | -1 +7 +5 -1 +1 | r | r | r | -9 -1 +1 +9 -1 +1 | r -5 +1 -1 | r | r | -7 +1 +3 +1 +2 -7"
        rhythm    "1 1/2 1/2 3/4 1/4 1 | 3/2 1/2 1 1/4 3/4 | 4 | 4 | 4 | 1 1/2 1/2 3/4 1/4 1 | 2 1 1/2 1/2 | 4 | 4 | 1/2 1/2 1/2 1/2 1 1"
      end

      placement :solo_violin_teller_line, part: :solo_violin_teller, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :flute_tale_line, pitch: :intervals do
        anchor "D5"
        intervals "r | r | r 0 +7 +5 +7 -2 +2 -8 +1 0 -5 | +1 -1 -2 -1 -3 -1 | r +7 -7 0 | r | r 0 +7 +5 +7 -2 -5 -5 +5 | 0 -1 +1 -4 -1 -2 | -1 -3 -1 0 | r"
        rhythm    "4 | 4 | 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1 | 3/4 1/4 1/2 1/2 1 1 | 2 3/4 1/4 1 | 4 | 2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 3/4 1/4 1 1/2 1/2 1 | 1 3/4 1/4 2 | 4"
      end

      placement :flute_tale_line, part: :flute_tale, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_tale_line, pitch: :intervals do
        anchor "D4"
        intervals "r | r | 0 0 -5 0 +5 -5 | -2 0 +3 -1 -2 -1 | -3 -1 r | r | r +12 0 -5 | +1 0 -3 +2 0 +5 | +1 -2 +1 -5 | r"
        rhythm    "4 | 4 | 3/4 1/4 3/4 1/4 1 1 | 3/4 1/4 1 3/4 1/4 1 | 1 1 2 | 4 | 2 3/4 1/4 1 | 3/4 1/4 1 3/4 1/4 1 | 1 3/4 5/4 1 | 4"
      end

      placement :viola_tale_line, part: :viola_tale, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "[0,+7]{pp} | [0,+7] | 0 +7 +5 +3 +4 | -14 +3 +4 +1 -6 | -7 +10 -2 -1 | [-7,0] | 0 +15 -2 -1 -1 | +1 -4 -3 +2 | -7 +7 -7 | [0,+7]{pp}"
        rhythm    "4 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 4 | 1 1/2 1/2 1 1 | 1 1/2 1/2 2 | 1 1 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
