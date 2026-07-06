production_piece "Technique Card FM3_FRAME_BREATH - FM3_FRAME_BREATH" do
  meter "4/4"
  key "C"

# category: forms
# card: FM3_FRAME_BREATH
# cite: keyboard_figuration s6g (narrator-frame)
# behavior: the drone BREATHES: harp 5th broken irregularly (no bar repeats), register lifts at
#   the melody's breaths, ONE b2 answer to the Hijaz lean; cello dyad with inner motion every 2
#   bars

  roster do
    part :solo_violin_slot, "Solo Violin (slot)", music21: "Violin", family: :string, description: "Violin"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FM3_FRAME_BREATH", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "the drone BREATHES: harp 5th broken irregularly (no bar repeats), register lifts at the melody's breaths, ONE b2 answer to the Hijaz lean; cello dyad with inner motion every 2 bars"

      phrase :solo_violin_slot_line, pitch: :intervals do
        anchor "A4"
        intervals "0{p} +1 -1 -2 -1 -3 | -1 -2 +2 | 0 +1 +3 +1 +2 +1 -1 | -2 -1 -3 -1 | +7 +1 +2 -2 -1 -2 | -2 -1 -2 0"
        rhythm    "1 1/2 1/2 1/2 1/2 1 | 3 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1 2 | 1/2 1/2 1 1/2 1/2 1 | 2 1/2 1/2 1"
      end

      placement :solo_violin_slot_line, part: :solo_violin_slot, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :harp_line, pitch: :intervals do
        anchor "D2"
        intervals "0 +7 +5 r -5 -7 | 0 +7 +5 +7 +5 -5 +5 -5 -7 -5 +5 | r -5 +5 r +7 -7 | -12 +13 -1 -5 +5 +7 +5 -5 -7 | 0 +7 +5 -5 r -12 | -7 +7 +5 +7 -19 +7 +5 -5 -7"
        rhythm    "1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/2 1/2 | 1/2 1/2 1 1 1/2 1/2 | 1 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/4 1/4 1/4 1/4 1 1/2 1/2 1/2 1/2"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D2,A2]{pp} | [D2,A2] [D2,Bb2] [D2,A2] | [D2,A2] | [C2,A2] [D2,A2] | [D2,A2] | [D2,A2] [D2,A2]"
        rhythm_bars "4 | 2 1 1 | 4 | 3/2 5/2 | 4 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
