production_piece "Technique Card P20_SINGING_OVER_CURRENT - P20_SINGING_OVER_CURRENT" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 66", at: "bar 1 beat 1"
  end

# category: piano
# card: P20_SINGING_OVER_CURRENT
# cite: sixteenth_deployment
# behavior: a lyrical melody in LONG values (halves / dotted-q+8th / rests) rides a flowing
#   CHROMATIC 16th under-current; the current is 16th-driven but VARIED (8ths bind across the
#   beat, a dotted figure) + chromatic; strata complementary (current moves under every melody
#   hold, thins where the melody moves); one fill in the melody's rest

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P20_SINGING_OVER_CURRENT", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a lyrical melody in LONG values (halves / dotted-q+8th / rests) rides a flowing CHROMATIC 16th under-current; the current is 16th-driven but VARIED (8ths bind across the beat, a dotted figure) + chromatic; strata complementary (current moves under every melody hold, thins where the melody moves); one fill in the melody's rest"

      phrase :piano_rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | A4 A4 D5 | F5 E5 D5 | C5 A4 | r Bb4 G4 | A4 C5 F5 | E5 D5 C5 | D5 A4 D5"
        rhythm_bars "4 | 3/2 1/2 2 | 3/2 1/2 2 | 1 3 | 1 1 2 | 3/2 1/2 2 | 1 1 2 | 3/2 1/2 2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :piano_lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3 F3 A3 D4 C4 A3 A3 A3 B3 C#4 D4 C4 A3 F3 E3 | F3 G3 A3 D3 A3 F3 E3 F3 F#3 G3 A3 G3 A3 | A3 Bb3 A3 G3 Bb2 D3 F3 A3 Bb3 A3 G3 E3 D#3 E3 G3 Bb3 | A3 C4 A3 F2 C3 F3 A3 C4 A3 A3 A3 Ab3 G3 F3 | E3 F3 G3 A3 Bb2 C3 C#3 D3 E3 F3 G3 Bb3 A3 G3 F3 | E3 D3 C3 Bb2 F2 C3 E3 F3 G3 A3 A3 Bb3 C4 D4 | C4 Bb3 A3 G3 G3 F3 E3 D3 C#3 D3 E3 A2 C#3 E3 | G3 E3 C#3 A2 D3 F3 A3 D4 C4 A3 F3 E3 D3 A2 D2"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/2 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 | 1/4 1/4 1/4 1/4 3/8 1/8 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 | 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
