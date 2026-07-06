production_piece "Technique Card K5_CHORDAL_CLIMAX - K5_CHORDAL_CLIMAX" do
  meter "4/4"
  key "C"

# category: piano
# card: K5_CHORDAL_CLIMAX
# cite: keyboard_figuration s2
# behavior: melody in octaves + inner doubling over leaping bass octaves + afterbeat chords; one
#   written spread at the peak

  roster do
    part :rh_chords, "RH chords", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_octaves, "LH octaves", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "K5_CHORDAL_CLIMAX", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "melody in octaves + inner doubling over leaping bass octaves + afterbeat chords; one written spread at the peak"

      phrase :rh_chords_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C5,Eb5,G5,C6]{ff} [Bb4,D5,Bb5] [Ab4,C5,Eb5,Ab5] [G4,Bb4,Eb5,G5] | [F4,Ab4,C5,F5] [G4,B4,D5,G5] [Ab4,C5,Ab5] [B4,D5,G5] | C5 Eb5 G5 C6 [C5,Eb5,G5,Eb6] [Bb4,D5,D6] [Ab4,C5,C6] | [G4,C5,Eb5,G5] [G4,B4,D5] [C5,Eb5,G5]"
        rhythm_bars "1 1 1 1 | 3/2 1/2 1 1 | 1/8 1/8 1/8 1/8 3/2 1 1 | 2 1 1"
      end

      placement :rh_chords_line, part: :rh_chords, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_octaves_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C2,C3] [G3,C4,Eb4] r [Ab1,Ab2] [Ab3,C4,Eb4] r | [F1,F2] [Ab3,C4] r [G1,G2] [G3,B3,D4] r | [C2,C3] [G3,C4] r [Ab1,Ab2] [Ab3,C4] r | [G1,G2] [G2,G3] [C2,G2,C3]"
        rhythm_bars "1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 2 1 1"
      end

      placement :lh_octaves_line, part: :lh_octaves, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
