production_piece "Technique Card FM2_ROMANCE_FABRIC - FM2_ROMANCE_FABRIC" do
  meter "4/4"
  key "C"

# category: forms
# card: FM2_ROMANCE_FABRIC
# cite: keyboard_figuration s6d (romance / planed-9th fabric)
# behavior: melody slot on the M1 pickup cell; piano answers in IV's dialect (pickup replies,
#   one scalar current, one toll at the crest); viola = the suspension color; walking cello

  roster do
    part :violin_slot, "Violin (slot)", music21: "Violin", family: :string, description: "Violin"
    part :piano, "Piano", music21: "Piano", family: :keyboard, description: "Piano"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FM2_ROMANCE_FABRIC", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "melody slot on the M1 pickup cell; piano answers in IV's dialect (pickup replies, one scalar current, one toll at the crest); viola = the suspension color; walking cello"

      phrase :violin_slot_line, pitch: :intervals do
        anchor "F4"
        intervals "0{p} 0 +5 -1 +1 | +2 +2 -2 +2 | +1 0 +4 -2 -2 | -1 -2 -2 +2 | -7 0 +5 +4 +3 | -2 -1 -2 -2 | -1 +1 +2 +2 | -2 -2 -1 +1"
        rhythm    "1/2 1/2 3/2 1/2 1 | 1 3/2 1/2 1 | 1/2 1/2 3/2 1/2 1 | 1 3/4 1/4 2 | 1/2 1/2 1 1 1 | 3/2 1/2 1 1 | 1 1/2 1/2 2 | 1 3/4 1/4 2"
      end

      placement :violin_slot_line, part: :violin_slot, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :piano_line, pitch: :intervals do
        anchor "F4"
        intervals "r 0 0 -7 | r +7 -2 -1 +1 +2 +2 +2 -2 | r -9 +2 +2 +1 +2 -2 -1 | -2 +2 +1 +2 +2 +1 -1 -2 -2 -1 -2 +2 | [-4,+3]{txt:l.v.} r +4 +3 | r +2 0 +5 -2 | r -5 -2 -1 -2 -2 +2 +2 +1 | -1 -2 -2 0"
        rhythm    "5/2 1/4 1/4 1 | 1 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/2 | 2 1/4 1/4 1/4 1/4 1/2 1/4 1/4 | 1/2 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 | 2 1 1/2 1/2 | 3/2 1/4 1/4 1 1 | 2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1 1/2 1/2 2"
      end

      placement :piano_line, part: :piano, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, pitch: :intervals do
        anchor "F4"
        intervals "r | 0 -2 | 0 -1 -4 | +2 +2 +1 0 | -1 +3 | -2 -1 -2 | 0 +2 +3 | 0 -2 -1"
        rhythm    "4 | 2 2 | 3/2 3/2 1 | 1 1/2 1/2 2 | 2 2 | 1 2 1 | 2 1 1 | 3/2 1/2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "Bb2"
        intervals "0{p} +2 +2 +3 +2 | -12 +3 +4 +3 -2 | 0 -5 -7 +4 +3 | -5 +12 -2 -3 -2 -1 | +1 -5 +9 -4 | -3 +2 +1 +4 -2 | +3 -1 -2 -2 -5 | 0 +12 -5 -2"
        rhythm    "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1/2 1/2 | 3/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
