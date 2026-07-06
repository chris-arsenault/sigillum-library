production_piece "Technique Card O7_SYNC_CHORDS - O7_SYNC_CHORDS" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O7_SYNC_CHORDS
# cite: orchestral_rhythm s1C
# behavior: chords only off-beat over an on-beat bass LINE; tied variant blurs the barline in
#   bars 5-6

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "O7_SYNC_CHORDS", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "chords only off-beat over an on-beat bass LINE; tied variant blurs the barline in bars 5-6"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{p} G5 F5 | Eb5 D5 D5 | C5 Eb5 G5 | F#5 G5 A5 | Bb5 A5 G5 | F#5 G5 G5"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 2 1 1 | 1 1 2 | 2 1 1 | 3/2 1/2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [Bb3,D4] r [Bb3,D4] r [Bb3,D4] r [C4,Eb4] | r [C4,Eb4] r [Bb3,D4] r [Bb3,D4] r [A3,D4] | r [A3,C4] r [A3,C4] r [Bb3,Eb4] r [Bb3,Eb4] | r [A3,D4] r [Bb3,D4] r [C4,D4] r [C4,F#4] | r [Bb3,D4] [Bb3,D4] [Bb3,Eb4] [Bb3,Eb4] | [A3,D4] [A3,C4] [Bb3,D4] [Bb3,D4]"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1 1 1 1/2 | 1 1 3/2 1/2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{p} -2 -2 -1 | -2 +2 +5 -2 -2 -1 | -2 +12 -2 -1 | -7 +1 +3 -4 | +5 0 +5 +1 | +1 -12 +5 -5"
        rhythm    "1 1 1 1 | 1 1 1/2 1/2 1/2 1/2 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 3/2 1/2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
