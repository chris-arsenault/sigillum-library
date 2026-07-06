production_piece "Technique Card O6_STRATA_LATTICE - O6_STRATA_LATTICE" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O6_STRATA_LATTICE
# cite: orchestral_rhythm s2/s5 + E7
# behavior: melody / 16th figuration / off-beat horn pad / bass line / sparse punctuation; union
#   continuous; EVERY layer turns the dial at b5

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :horns, "Horns", music21: "Horn", family: :brass, description: "Horn"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "O6_STRATA_LATTICE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "melody / 16th figuration / off-beat horn pad / bass line / sparse punctuation; union continuous; EVERY layer turns the dial at b5"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mf} A5 G5 | A5 G5 E5 | C5 D5 E5 | E5 D5 B4 | A4 C5 E5 A5 | G5 E5 G5 | A5 E5 C5 | B4 D5 A4"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 2 1 1 | 1 1 2 | 1 1 1 1 | 3/2 1/2 2 | 2 1 1 | 1 1 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3 C4 E4 C4 A3 C4 E4 C4 A3 C4 E4 C4 B3 D4 E4 D4 | A3 C4 E4 C4 A3 C4 F4 C4 A3 C4 E4 C4 G3 B3 E4 B3 | A3 C4 E4 C4 F3 A3 D4 A3 G3 B3 E4 B3 A3 C4 E4 C4 | G3 B3 E4 B3 G3 B3 D4 B3 E3 G#3 B3 G#3 E3 G#3 D4 B3 | E4 C4 A3 C4 E4 C4 A3 C4 F4 D4 A3 D4 E4 C4 A3 C4 | E4 C4 A3 C4 F4 C4 A3 C4 G4 E4 B3 E4 E4 B3 G#3 B3 | A3 E4 C4 E4 A3 F4 D4 F4 G3 E4 B3 E4 A3 E4 C4 E4 | G#3 B3 E4 B3 G#3 B3 E4 D4 C4 A3 E4 C4 A3 C4 A3 E3"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horns_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [C4,E4] r [C4,E4] r [C4,E4] r [C4,E4] | r [C4,E4] r [C4,E4] r [C4,E4] r [C4,E4] | r [C4,E4] r [C4,E4] r [C4,E4] r [C4,E4] | r [C4,E4] r [C4,E4] r [C4,E4] r [C4,E4] | r [C4,E4] [C4,E4] r r [D4,F4] [D4,F4] r | r [C4,E4] [C4,E4] r r [B3,E4] [B3,E4] r | r [C4,E4] r [D4,F4] r [C4,E4] r [B3,D4] | r [B3,E4] [B3,E4] r [A3,C4] r [A3,C4]"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1"
      end

      placement :horns_line, part: :horns, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A1"
        intervals "0 +12 -2 -2 | -1 0 +1 +2 -3 | -7 +12 -2 -2 -3 | +5 -12 +9 0 -2 | -5 +7 +5 -5 +1 -3 | +2 0 +1 0 +2 0 -3 | -7 +8 +2 -3 | -7 +7 +5 -5"
        rhythm    "1 1 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1 1 1 1 | 1 1 3/2 1/2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{p} r | r | r | r | A2 r | r | r | r A2 A2 A2"
        rhythm_bars "1 3 | 4 | 4 | 4 | 1 3 | 4 | 4 | 2 1/2 1/2 1"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
