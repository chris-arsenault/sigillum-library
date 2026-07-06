production_piece "Technique Card D6_REGROUP_CADENCE - D6_REGROUP_CADENCE" do
  meter "4/4"
  key "C"

# category: dialogue
# card: D6_REGROUP_CADENCE
# cite: orchestral_rhythm s4
# behavior: last two bars regroup 8ths 3+3+2 into the cadence; accompaniment re-voices ON the
#   regrouped accents

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "D6_REGROUP_CADENCE", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "last two bars regroup 8ths 3+3+2 into the cadence; accompaniment re-voices ON the regrouped accents"

      phrase :violin_line, pitch: :intervals do
        anchor "B4"
        intervals "0{mf} +1 +2 +2 -2 -2 -1 -2 | -2 +2 +2 +1 +2 -2 -1 | 0 +1 +2 +2 -2 -2 +2 -2 | -1 +1 +2 -2 -1 -2 -2"
        rhythm    "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D4,G4] [E4,G4] [D4,F#4] [C4,E4] | [D4,F#4] [C4,E4] [B3,D4] [C4,E4] | [D4,G4] [E4,A4] [D4,F#4] | [C4,E4] [D4,F#4] [B3,D4]"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 3/2 3/2 1 | 3/2 3/2 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0 -3 -2 -2 | -1 +1 +2 0 | +5 -7 +2 | +2 -2 -7"
        rhythm    "1 1 1 1 | 1 1 1 1 | 3/2 3/2 1 | 3/2 3/2 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
