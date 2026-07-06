production_piece "Technique Card P17_RHYTHMIC_SENTENCE - P17_RHYTHMIC_SENTENCE" do
  meter "4/4"
  key "C"

# category: piano
# card: P17_RHYTHMIC_SENTENCE
# cite: keyboard_figuration s6d
# behavior: every phrase traverses value classes (triplet -> dotted -> 16th run -> arrival) and
#   the sentence PASSES BETWEEN HANDS; no uniform-value bars exist

  roster do
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :mid, "Mid", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P17_RHYTHMIC_SENTENCE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "every phrase traverses value classes (triplet -> dotted -> 16th run -> arrival) and the sentence PASSES BETWEEN HANDS; no uniform-value bars exist"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5 F5 E5 D5 C5 B4 C5 D5 E5 F5 E5 D5 C5 | B4 A4 r | C5 B4 C5 D5 E5 F5 G5 A5 G#5 A5 | E5 D5 C5 B4 C5 D5 | E5 r C5 r A4 r B4 r C5 B4 A4 G#4 E4 | A4 B4 C5 B4 A4 A4"
        rhythm_bars "1/3 1/3 1/3 3/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 3/2 1/2 2 | 3/4 1/4 1/3 1/3 1/3 1/4 1/4 1/4 1/4 1 | 2/3 2/3 2/3 3/4 1/4 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/3 1/3 1/3 1/2 1/2 | 3/2 1/4 1/4 3/4 1/4 1"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :mid_line, surface: :split_pitch_rhythm do
        pitch_bars  "r E4 D4 | r E4 F4 E4 D4 E4 C4 | r A3 B3 r C4 D4 E4 F4 | C4 B3 A3 G#3 A3 | r E4 r E4 r C4 r D4 A3 B3 | C4 B3 C4"
        rhythm_bars "2 1 1 | 1 1/3 1/3 1/3 3/4 1/4 1 | 1 1/2 1/2 1 1/4 1/4 1/4 1/4 | 1 2/3 2/3 2/3 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1 1 | 3/2 1/2 2"
      end

      placement :mid_line, part: :mid, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1 A2 r E2 A2 C3 B2 | E2 E3 D3 C3 B2 C3 B2 E2 | A2 r C3 D3 E3 F3 E3 | E2 D3 C3 B2 E2 | A2 r E3 r A2 r E2 r F2 E2 | E2 E1 A1"
        rhythm_bars "1 1/2 1/2 3/4 1/4 1/2 1/2 | 3/4 1/4 1/2 1/2 1/3 1/3 1/3 1 | 1 1/2 1/2 3/4 1/4 1/2 1/2 | 3/2 1/2 1 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1 1 | 3/2 1/2 2"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
