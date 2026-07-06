production_piece "Technique Card FM1_DUET_CONVERSATION - FM1_DUET_CONVERSATION" do
  meter "4/4"
  key "C"

# category: forms
# card: FM1_DUET_CONVERSATION
# cite: keyboard_figuration s6g (duet fabric)
# behavior: piano asks (with a real rest); violin answers BORROWING the piano's tail and bending
#   it; viola interjects mid-answer; third exchange overlaps in 6ths (agreement); piano closes
#   alone

  roster do
    part :piano, "Piano", music21: "Piano", family: :keyboard, description: "Piano"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
  end

  section :card, "FM1_DUET_CONVERSATION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "piano asks (with a real rest); violin answers BORROWING the piano's tail and bending it; viola interjects mid-answer; third exchange overlaps in 6ths (agreement); piano closes alone"

      phrase :piano_line, pitch: :intervals do
        anchor "D5"
        intervals "0{p} -5 +1 +2 +2 | +1 -1 -2 r | r | r -7 +2 +2 | +1 -5 +2 +2 +1 | r | [-8,0] [+1,+10] [-1,+7] [-2,+7] [-2,+7] | +7 -2 -1 0"
        rhythm    "3/2 1/2 1 1/2 1/2 | 3/4 1/4 1 2 | 4 | 2 1/2 1/2 1 | 3/2 1/2 1 1/2 1/2 | 4 | 1 1/2 1/2 1 1 | 1 3/4 1/4 2"
      end

      placement :piano_line, part: :piano, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violin_line, pitch: :intervals do
        anchor "C5"
        intervals "r | r 0 +2 +1 | -1 -2 -2 -1 -2 | -2 r | r | +5 -1 -2 -2 +2 +2 +1 | +7 +2 -2 -2 -1 | r -2 -2 0"
        rhythm    "4 | 2 3/4 1/4 1 | 3/2 1/2 1 1/2 1/2 | 2 2 | 4 | 1 1/2 1/2 1/3 1/3 1/3 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, pitch: :intervals do
        anchor "G3"
        intervals "r | r | r 0 +2 +1 | +2 -2 -1 -2 -2 | +2 +2 +1 +2 | +2 -2 -2 -1 -2 | -2 +2 +2 +1 +2 +2 | +1 +2 -12 +5"
        rhythm    "4 | 4 | 2 3/4 1/4 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1/2 1/2 1 | 1 1/2 1/2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
