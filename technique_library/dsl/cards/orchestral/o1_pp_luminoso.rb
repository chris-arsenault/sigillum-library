production_piece "Technique Card O1_PP_LUMINOSO - O1_PP_LUMINOSO" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O1_PP_LUMINOSO
# cite: chord_scoring s5 + keyboard_figuration s5
# behavior: one-per-pitch luminous spacing; the pad CONTAINS a moving inner voice (viola weave,
#   suspensions); harp attack-points; flute crown

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
  end

  section :card, "O1_PP_LUMINOSO", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one-per-pitch luminous spacing; the pad CONTAINS a moving inner voice (viola weave, suspensions); harp attack-points; flute crown"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "E6{pp} | D6 | E6 | G6 | F6 E6 | E6"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{pp,txt:con_sord.} | A5 | G5 | C6 B5 | A5 | G5"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{pp,txt:con_sord.} | D5 | E5 | E5 | D5 C5 | D5"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{pp} F4 E4 D4 E4 | F4 E4 D4 C4 | C4 D4 E4 F4 G4 | A4 G4 F4 | F4 E4 D4 E4 D4 | E4 D4 C4 E4"
        rhythm_bars "1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1/2 1/2 1 1 | 2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{pp} | -7 | +7 | -3 | -4 +2 | +5"
        rhythm    "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4 G4 E5 r | F3 C4 A4 r D5 r | C4 G4 E5 r | A3 E4 C5 r G5 r | F3 C4 F4 r G3 D4 B4 r | C3 G3 E4 C5 r"
        rhythm_bars "1/2 1/2 1/2 5/2 | 1/2 1/2 1/2 3/2 1/2 1/2 | 1/2 1/2 1/2 5/2 | 1/2 1/2 1/2 3/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 2"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
