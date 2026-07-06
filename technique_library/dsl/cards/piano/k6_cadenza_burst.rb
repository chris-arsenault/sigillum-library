production_piece "Technique Card K6_CADENZA_BURST - K6_CADENZA_BURST" do
  meter "4/4"
  key "C"

# category: piano
# card: K6_CADENZA_BURST
# cite: ornamentation s2 / keyboard_figuration
# behavior: anchor -> 2-octave run down -> anchor -> run up -> l.v. landing

  roster do
    part :piano, "Piano", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "K6_CADENZA_BURST", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "anchor -> 2-octave run down -> anchor -> run up -> l.v. landing"

      phrase :piano_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{txt:rubato} Bb5 A5 G5 F5 E5 D5 C#5 D5 E5 F5 E5 D5 C5 Bb4 A4 G4 F4 E4 | D4 C#4 D4 E4 F4 G4 A4 Bb4 C#5 D5 E5 F5 G5 A5 Bb5 C#6 D6 E6 | F6{txt:l.v.} E6 D6 A5 F5 | [D4,A4,D5,F5]{txt:l.v.}"
        rhythm_bars "3/2 1/4 1/4 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 | 3/2 1/2 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 | 1 1/2 1/2 1 1 | 4"
      end

      placement :piano_line, part: :piano, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
