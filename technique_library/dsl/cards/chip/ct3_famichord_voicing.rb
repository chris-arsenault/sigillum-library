production_piece "Technique Card CT3_FAMICHORD_VOICING - CT3_FAMICHORD_VOICING" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 96", at: "bar 1 beat 1"
  end

# category: chip
# card: CT3_FAMICHORD_VOICING
# cite: chiptune_research:famichord (docs/research/chiptune_nes_composition.md)
# behavior: famichord voicing (Akesson): maj7/m7 chords with the 5th omitted fit the three
#   pitched channels - root low on triangle, 7th mid on pulse 2, 3rd HIGH on pulse 1; the
#   wide spacing exploits the square wave's rich harmonics so three voices read as five (Kondo)

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - the chord 3rd, high"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - the chord 7th, mid"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - the chord root, low"
  end

  section :card, "CT3_FAMICHORD_VOICING", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "famichord voicing (Akesson): maj7/m7 chords with the 5th omitted fit the three pitched channels - root low on triangle, 7th mid on pulse 2, 3rd HIGH on pulse 1; the wide spacing exploits the square wave's rich harmonics so three voices read as five (Kondo)"

      phrase :third_voice, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mp,txt:pulse1_-_chord_3rd_kept_high_and_wide} D5 | C5 B4 | F5 E5 | B5 A5 | G5 A5 | C5 B4 | A5 G5 | B4 D5"
        rhythm_bars "3 1 | 3 1 | 3 1 | 3 1 | 3 1 | 3 1 | 3 1 | 2 2"
      end

      placement :third_voice, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :seventh_voice, surface: :split_pitch_rhythm do
        pitch_bars  "B3{p,txt:pulse2_-_chord_7th_mid_register} | G3 | C4 | F3 | D4 | G3 | E4 | F3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :seventh_voice, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :root_voice, surface: :split_pitch_rhythm do
        pitch_bars  "C2{mp,txt:triangle_-_root_only_the_5th_is_omitted} C2 | A2 A2 | D2 D2 | G2 G2 | E2 E2 | A2 A2 | F2 F2 | G2 G2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :root_voice, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
