production_piece "Technique Card O4_BASS_AS_LINE - O4_BASS_AS_LINE" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O4_BASS_AS_LINE
# cite: composition_method A.4
# behavior: the anti-ROOTQ card: walking bass with passing tones, anticipations, register event
#   at b5; viola joins in 10ths at phrase ends; upper texture deliberately simple

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :violins, "Violins", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "O4_BASS_AS_LINE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the anti-ROOTQ card: walking bass with passing tones, anticipations, register event at b5; viola joins in 10ths at phrase ends; upper texture deliberately simple"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{p} | Bb4 | A4 G4 | A4 | C5 | Bb4 A4 | G4 | A4"
        rhythm_bars "4 | 4 | 2 2 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violins_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,F4]{p} | [D4,F4] | [C4,E4] | [C4,F4] [C4,E4] | [E4,G4] | [D4,F4] | [Bb3,E4] [C4,E4] | [C4,F4]"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 4 | 2 2 | 4"
      end

      placement :violins_line, part: :violins, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | C4 Bb3 A3 E3 | A3 G3 F3 E3 E3 | r | r | E4 D4 C4 Bb3 | A3 E3 A3"
        rhythm_bars "4 | 4 | 1 1 1 1 | 1 1/2 1/2 1 1 | 4 | 4 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F2"
        intervals "0{p} +2 +2 +1 0 | 0 -1 -2 -2 -1 | +5 -2 +5 -12 | +5 -1 -2 -2 +12 -2 | -1 +1 +2 +4 +1 | -3 -2 -2 -1 -2 | +5 -2 -1 -2 | -2 -5 +5"
        rhythm    "1 1/2 1/2 1 1 | 1 1 1 1/2 1/2 | 1 1 1 1 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1 | 1 1 1 1/2 1/2 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
