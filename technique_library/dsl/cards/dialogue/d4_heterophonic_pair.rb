production_piece "Technique Card D4_HETEROPHONIC_PAIR - D4_HETEROPHONIC_PAIR" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D4_HETEROPHONIC_PAIR
# cite: dialogue_doubling s8
# behavior: same line plain (horn) + ornamented (solo violin) simultaneously; structural tones
#   synchronized; open-5th drone

  roster do
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :solo_violin, "Solo Violin", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "D4_HETEROPHONIC_PAIR", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "same line plain (horn) + ornamented (solo violin) simultaneously; structural tones synchronized; open-5th drone"

      phrase :horn_line, pitch: :intervals do
        anchor "A4"
        intervals "0{p} +1 -1 | -2 -2 | -2 -1 | +3 +2 +2 | +1 -1 -2 | -5"
        rhythm    "2 1 1 | 2 2 | 2 2 | 2 1 1 | 2 1 1 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :solo_violin_line, pitch: :intervals do
        anchor "A4"
        intervals "0{p} +1 -1 -1 +1 +1 +2 -2 -1 | -2 +2 -2 -2 -1 +1 | -2 +2 -2 -1 0 -1 +1 | +3 +2 -2 +2 0 +2 +1 | 0 +2 -2 -1 0 -2 -1 | -4 +1 -1 -1 +1 0"
        rhythm    "1 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 1/4 1/4 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 2 1/4 1/4 1/4 1/4 1"
      end

      placement :solo_violin_line, part: :solo_violin, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D2,A2]{pp} | [D2,A2]{pp} | [D2,A2]{pp} | [D2,A2]{pp} | [D2,A2]{pp} | [D2,A2]"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
