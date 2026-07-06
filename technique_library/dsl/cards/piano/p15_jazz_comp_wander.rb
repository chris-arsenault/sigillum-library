production_piece "Technique Card P15_JAZZ_COMP_WANDER - P15_JAZZ_COMP_WANDER" do
  meter "4/4"
  key "C"

# category: piano
# card: P15_JAZZ_COMP_WANDER
# cite: keyboard_figuration s6c
# behavior: the comping hand cycles STATES - root / 3-5 dyad / connecting 3-4-5 run / full 1-3-5
#   stack - syncopated, guide tones voice-led; the melody wanders (off-grid entries, chromatic
#   approaches, drift)

  roster do
    part :wandering_melody, "Wandering melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :comp_hand, "Comp hand", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P15_JAZZ_COMP_WANDER", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the comping hand cycles STATES - root / 3-5 dyad / connecting 3-4-5 run / full 1-3-5 stack - syncopated, guide tones voice-led; the melody wanders (off-grid entries, chromatic approaches, drift)"

      phrase :wandering_melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "r A4 B4 C5 | B4 A4 G4 r E4 F4 | E4 G4 B4 C#5 D5 B4 | C#5 D5 E5 r G4 | F4 E4 F4 A4 Bb4 C5 | Bb4 A4 G4 E4 | r A4 C5 C#5 D5 C5 A4 | G4 F4 E4 C#4 D4"
        rhythm_bars "3/2 1 1/2 1 | 3/2 1/2 1 1/2 1/4 1/4 | 3/2 1/2 1 1/4 1/4 1/2 | 3/2 1/2 1 1/2 1/2 | 1/2 1/2 3/2 1/4 1/4 1 | 1 1/2 3/2 1 | 1/2 1/2 1/2 1/4 3/4 1/2 1 | 1 1/2 1 1/2 1"
      end

      placement :wandering_melody_line, part: :wandering_melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :comp_hand_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2 r [F3,A3] r C3 D3 E3 F3 | G2 r [F3,B3] r G3 A3 B3 C4 | [C3,E3,G3] r [E3,B3] D3 C3 | A2 [C#3,G3] C#3 D3 D#3 E3 E3 r | [D3,F3,A3] r [F3,A3] r A2 C3 | G2 [Bb2,D3] r C3 [E3,Bb3] | [F2,C3] C3 D3 E3 F3 G3 A3 Bb3 A3 [F3,A3,C4] | E2 [D3,G#3] A2 Bb2 G#2 [C#3,E3,G3]"
        rhythm_bars "1 1/2 1 1/2 1/4 1/4 1/4 1/4 | 1 1/2 1 1/2 1/4 1/4 1/4 1/4 | 3/2 1/2 1 1/2 1/2 | 1 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1 1 | 1 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1 | 1 1 1/2 1/4 1/4 1"
      end

      placement :comp_hand_line, part: :comp_hand, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
