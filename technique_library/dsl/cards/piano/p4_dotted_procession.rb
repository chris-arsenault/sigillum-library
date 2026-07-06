production_piece "Technique Card P4_DOTTED_PROCESSION - P4_DOTTED_PROCESSION" do
  meter "4/4"
  key "C"

# category: piano
# card: P4_DOTTED_PROCESSION
# cite: keyboard_figuration s6c
# behavior: overture sharp-dotting, DOUBLE-dotted at the return, Scotch snap closes phrases;
#   bass octaves dotted but a LINE

  roster do
    part :chords, "Chords", music21: "Piano", family: :keyboard, description: "Piano"
    part :bass_octaves, "Bass octaves", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P4_DOTTED_PROCESSION", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "overture sharp-dotting, DOUBLE-dotted at the return, Scotch snap closes phrases; bass octaves dotted but a LINE"

      phrase :chords_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G4,Bb4,D5] [G4,Bb4,D5] [A4,C5] [A4,C5] [Bb4,D5] [Bb4,D5] [A4,C5,F#5] | [G4,Bb4,G5] [G4,Bb4,G5] [C5,Eb5] [C5,Eb5] D5 Eb5 [D5,F#5] | [G4,D5,G5] [G4,D5,G5] [F4,Bb4,F5] [F4,Bb4,F5] [Eb4,G4,Eb5] [Eb4,G4,Eb5] [D4,G4,D5] | [C4,Eb4,C5] [C4,Eb4,C5] [D4,F#4,D5] [D4,F#4,D5] G4 Bb4 [A4,D5] | [G4,Bb4,D5,G5] [G4,Bb4,D5,G5] [A4,C5,Eb5] [A4,C5,Eb5] [Bb4,D5,G5] [Bb4,D5,G5] [A4,C5,F#5] | [Bb4,D5,Bb5] [Bb4,D5,Bb5] [A4,D5,A5] [A4,D5,A5] [G4,Bb4,G5]"
        rhythm_bars "3/4 1/4 3/4 1/4 3/4 1/4 1 | 3/4 1/4 3/4 1/4 1/4 3/4 1 | 3/4 1/4 3/4 1/4 3/4 1/4 1 | 3/4 1/4 3/4 1/4 1/4 3/4 1 | 7/8 1/8 7/8 1/8 7/8 1/8 1 | 1/4 3/4 1/4 3/4 2"
      end

      placement :chords_line, part: :chords, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_octaves_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G2,G3] [G2,G3] [F2,F3] [F2,F3] [Eb2,Eb3] [Eb2,Eb3] [D2,D3] | [Eb2,Eb3] [Eb2,Eb3] [C2,C3] [C2,C3] [Bb1,Bb2] [C2,C3] [D2,D3] | [Bb1,Bb2] [Bb1,Bb2] [Bb2,Bb3] [Bb2,Bb3] [C2,C3] [C2,C3] [Bb1,Bb2] | [A1,A2] [A1,A2] [D2,D3] [D2,D3] [Eb2,Eb3] [Eb2,Eb3] [D2,D3] | [G1,G2] [G1,G2] [F#1,F#2] [F#1,F#2] [G1,G2] [G1,G2] [D2,D3] | [Eb2,Eb3] [Eb2,Eb3] [D2,D3] [D2,D3] [G1,G2,G3]"
        rhythm_bars "3/4 1/4 3/4 1/4 3/4 1/4 1 | 3/4 1/4 3/4 1/4 1/4 3/4 1 | 3/4 1/4 3/4 1/4 3/4 1/4 1 | 3/4 1/4 3/4 1/4 1/4 3/4 1 | 7/8 1/8 7/8 1/8 7/8 1/8 1 | 1/4 3/4 1/4 3/4 2"
      end

      placement :bass_octaves_line, part: :bass_octaves, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
