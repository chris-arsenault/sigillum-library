production_piece "Technique Card K4_MUSIC_BOX - K4_MUSIC_BOX" do
  meter "4/4"
  key "C"

# category: piano
# card: K4_MUSIC_BOX
# cite: keyboard_figuration s4
# behavior: three event-classes in one color: varying 16th cell / offbeat sympathetic inner
#   voice / l.v. chime bass

  roster do
    part :cell, "Cell", music21: "Celesta", family: :keyboard, description: "Celesta"
    part :inner, "Inner", music21: "Celesta", family: :keyboard, description: "Celesta"
    part :chime, "Chime", music21: "Celesta", family: :keyboard, description: "Celesta"
  end

  section :card, "K4_MUSIC_BOX", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "three event-classes in one color: varying 16th cell / offbeat sympathetic inner voice / l.v. chime bass"

      phrase :cell_line, pitch: :intervals do
        anchor "A5"
        intervals "0 +4 +3 -3 -2 +3 -1 -4 r | 0 +4 +3 -3 -2 +3 +2 +2 r | -9 +4 +3 -3 -2 -3 +1 +2 r | -5 +3 +5 -5 -1 +3 +5 -5 r | -2 +4 +3 +5 -3 -4 -3 -3 r | +1 +4 +3 +5{txt:l.v.}"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 1/4 1/4 1/2 3"
      end

      placement :cell_line, part: :cell, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :inner_line, surface: :split_pitch_rhythm do
        pitch_bars  "r r E5 F#5 E5 | r r F#5 G#5 A5 | r r E5 D5 C#5 | r r D5 E5 G#5 | r F#5 E5 C#5 E5 | r C#5 E5 C#6{txt:l.v.}"
        rhythm_bars "2 1/2 1/2 1/2 1/2 | 2 1/2 1/2 1/2 1/2 | 2 1/2 1/2 1/2 1/2 | 2 1/2 1/2 1/2 1/2 | 2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 2"
      end

      placement :inner_line, part: :inner, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :chime_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{txt:l.v.} E4 | A3 E4 | F#3 C#4 | D3 E4 | A3 E4 | A2{txt:l.v.}"
        rhythm_bars "5/2 3/2 | 5/2 3/2 | 5/2 3/2 | 5/2 3/2 | 5/2 3/2 | 4"
      end

      placement :chime_line, part: :chime, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
