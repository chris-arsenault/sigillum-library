production_piece "Technique Card P2_SYNCOPATED_COMP - P2_SYNCOPATED_COMP" do
  meter "4/4"
  key "C"

# category: piano
# card: P2_SYNCOPATED_COMP
# cite: keyboard_figuration s6c
# behavior: on-beat bass groove (a line) under OFF-beat chords with ties and anticipations; the
#   melody rides the syncopation from b3

  roster do
    part :comp_chords, "Comp chords", music21: "Piano", family: :keyboard, description: "Piano"
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :bass_groove, "Bass groove", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P2_SYNCOPATED_COMP", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "on-beat bass groove (a line) under OFF-beat chords with ties and anticipations; the melody rides the syncopation from b3"

      phrase :comp_chords_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [F4,A4] r [F4,A4] [E4,G4] | r [F4,A4] [G4,Bb4] [F4,A4] | r [E4,G4] r [F4,A4] [E4,A4] | r [D4,G4] [D4,F4] [C#4,E4] | r [D4,F4] [E4,G4] [F4,A4] [G4,Bb4] | [F4,A4] [E4,G4] [D4,F4]"
        rhythm_bars "1/2 1 1 1/2 1 | 1/2 3/2 3/2 1/2 | 1/2 1 1/2 1 1 | 1/2 3/2 1 1 | 1/2 1 1/2 3/2 1/2 | 3/2 1 3/2"
      end

      placement :comp_chords_line, part: :comp_chords, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r D5 E5 F5 | r G5 F5 E5 | r F5 E5 D5 | C#5 D5"
        rhythm_bars "4 | 4 | 3/2 1 1/2 1 | 1/2 3/2 1 1 | 1 1/2 1 3/2 | 3/2 5/2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_groove_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2 r A2 D3 r C3 D2 | Bb1 r F2 Bb2 r A2 Bb1 | G1 r D2 G2 r F2 E2 | A1 r E2 A2 G2 E2 C#2 | D2 r A2 Bb2 r G2 A1 | D2 A1 D2 A2"
        rhythm_bars "1 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1 3/2 1/2"
      end

      placement :bass_groove_line, part: :bass_groove, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
