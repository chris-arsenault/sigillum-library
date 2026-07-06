production_piece "Technique Card P11_TREMOLO_ORCHESTRAL - P11_TREMOLO_ORCHESTRAL" do
  meter "4/4"
  key "C"

# category: piano
# card: P11_TREMOLO_ORCHESTRAL
# cite: keyboard_figuration s6c
# behavior: measured tremolo (orchestra-on-piano) under octave melody; LH joins the tremolo at
#   b3; cresc to a re-voiced arrival

  roster do
    part :melody_8ves, "Melody 8ves", music21: "Piano", family: :keyboard, description: "Piano"
    part :tremolo, "Tremolo", music21: "Piano", family: :keyboard, description: "Piano"
    part :bass, "Bass", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P11_TREMOLO_ORCHESTRAL", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "measured tremolo (orchestra-on-piano) under octave melody; LH joins the tremolo at b3; cresc to a re-voiced arrival"

      phrase :melody_8ves_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D5,D6]{mf} [E5,E6] [F5,F6] | [G5,G6] [F5,F6] [E5,E6] | [F5,F6] [G5,G6] [A5,A6] | [A5,A6] [G5,G6] [F5,F6] [E5,E6] [D5,D6]"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 1 1 2 | 3/4 1/4 1 1/2 3/2"
      end

      placement :melody_8ves_line, part: :melody_8ves, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tremolo_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4 A4 F4 A4 F4 A4 F4 A4 F4 A4 F4 A4 F4 A4 F4 A4 | E4 G4 E4 G4 E4 G4 E4 G4 E4 A4 E4 A4 E4 A4 E4 A4 | F4 A4 F4 A4 F4 A4 F4 A4 G4 Bb4 G4 Bb4 G4 Bb4 G4 Bb4 | F4 A4 F4 A4 F4 A4 F4 A4 E4 G4 E4 G4 D4 F4 D4 F4"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :tremolo_line, part: :tremolo, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2 C2 Bb1 | G1 A1 | D2 D3 D2 D3 D2 D3 D2 D3 D2 D3 D2 D3 D2 D3 D2 D3 | D2 D3 D2 D3 D2 D3 D2 D3 A1 A2 A1 A2 D2 D3 D2 D3"
        rhythm_bars "2 1 1 | 2 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
