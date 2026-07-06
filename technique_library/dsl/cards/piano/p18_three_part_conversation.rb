production_piece "Technique Card P18_THREE_PART_CONVERSATION - P18_THREE_PART_CONVERSATION" do
  meter "4/4"
  key "C"

# category: piano
# card: P18_THREE_PART_CONVERSATION
# cite: keyboard_figuration s6d
# behavior: interruption (B speaks in A's rests, bends A's tail note), harmonic anticipation in
#   the bass, ROLE INVERSION (bass takes the question augmented while A comps), HOCKET,
#   suspension resolved across voices

  roster do
    part :voice_a, "Voice A", music21: "Piano", family: :keyboard, description: "Piano"
    part :voice_b, "Voice B", music21: "Piano", family: :keyboard, description: "Piano"
    part :voice_c, "Voice C", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P18_THREE_PART_CONVERSATION", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "interruption (B speaks in A's rests, bends A's tail note), harmonic anticipation in the bass, ROLE INVERSION (bass takes the question augmented while A comps), HOCKET, suspension resolved across voices"

      phrase :voice_a_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4 Bb4 C5 r | r C5 D5 C5 Bb4 A4 | r [F4,A4] r [E4,G4] r [F4,A4] r [E4,Bb4] | r [F4,A4] r [E4,G4] [D4,F4] [E4,G4] [F4,A4] | F5 r D5 r Bb4 r C5 r r A4 C5 D5 | Bb4 A4"
        rhythm_bars "1/2 1/2 1 2 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 3/4 1/4 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 3/4 1/4 | 2 2"
      end

      placement :voice_a_line, part: :voice_a, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :voice_b_line, surface: :split_pitch_rhythm do
        pitch_bars  "r C4 C#4 D4 | C4 r B3 C4 E4 | C4 D4 E4 F4 E4 D4 C4 | Bb3 C4 D4 E4 F4 E4 D4 C4 Bb3 C4 | r G4 r F4 r D4 r E4 F4 E4 D4 E4 | E4 F4 C4"
        rhythm_bars "2 1/2 1/2 1 | 1 1 3/4 1/4 1 | 3/4 1/4 3/4 1/4 1/2 1/2 1 | 1/2 1/2 1/3 1/3 1/3 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1 1 2"
      end

      placement :voice_b_line, part: :voice_b, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :voice_c_line, surface: :split_pitch_rhythm do
        pitch_bars  "F2 G2 A2 B2 | C3 C2 r E2 G2 | A2 Bb2 C3 | D3 C3 Bb2 A2 | r F2 r A2 r G2 r C3 Bb2 B2 C3 | C2 C3 Bb2 F2"
        rhythm_bars "3/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 2 | 1 1 3/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 3/4 1/4 1 | 1 3/4 1/4 2"
      end

      placement :voice_c_line, part: :voice_c, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
