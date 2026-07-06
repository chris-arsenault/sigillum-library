production_piece "Production Hybrid Surface Study" do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, range: "E3-C6"
    part :solo_violin, "Solo Violin", music21: "Violin", family: :string, range: "G3-A6"
    part :cello, "Violoncello", music21: "Violoncello", family: :string, range: "C2-G4"
    part :hand_drum, "Hand Drum", music21: "Percussion", family: :percussion
  end

  section :s1, "Hybrid proof span", bars: 1..8, type: :hybrid_phrase_staff do
    journey "plain call becomes displaced answer, then pressure line"
    destination "bar 5 foreground pressure without losing the bass path"

    span bars: 1..8, texture: :phrase_layer_with_staff_checkpoints do
      harmony "F home; raised 1 is melodic bite, not a modulation."
      process "degrees, intervals, split pitch/rhythm, absolute bass, and staff checkpoints coexist locally."

      phrase :plain_call, pitch: :degrees do
        key_context "F4"
        degrees "5 4 3 #1 1 | 2 3 4 5 r"
        rhythm  "1.5 .25 .25 .5 1 | 1 .5 .5 1 .5"
      end

      phrase :late_answer_cell, pitch: :intervals do
        anchor "A4"
        intervals "0 -2 -1 -2 r | +7 -2 -1 r"
        rhythm    ".5 1 .5 .5 1 | 1 .5 1 1"
      end

      phrase :pressure_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5 D5 E5 F5 r | G5 F5 E5 D5 C5"
        rhythm_bars ".75 .25 1 .5 1 | .5 .5 .5 .5 1.5"
      end

      phrase :bass_path, surface: :absolute do
        pitch_bars  "F2 C3 F2 | Eb3 Bb2 C3 F2 | F2 C3 F2 E2 F2 C3 | F2 Bb2 C3 F2"
        rhythm_bars "1.5 1 1 | 1 .5 .5 1.5 | 1 .5 .5 .5 .5 .5 | 1 .5 .5 1.5"
      end

      placement :plain_call, part: :clarinet, at: "bar 1 beat 1" do
        role :foreground
        realization "degree phrase realized as C5 Bb4 A4 F#4 F4..."
      end

      placement :late_answer_cell, part: :solo_violin, at: "bar 3 beat 1.5" do
        role :late_answer
        realization "interval cell enters late against the grid"
      end

      placement :pressure_line, part: :clarinet, at: "bar 5 beat 1" do
        role :foreground
        realization "split pitch/rhythm line takes foreground"
      end

      placement :bass_path, part: :cello, at: "bar 1 beat 1" do
        role :bass_line
        realization "absolute register is part of orchestration"
      end

      gesture :not_prose_only do
        idea "late answer fails to meet the opening call cleanly"
        mechanism "solo_violin enters at bar 3 beat 1.5 while cello is already moving through F2-C3-F2-E2"
        line_relation :solo_violin, :cello, "answer is displaced against active bass, not explained by text alone"
      end

      staff_bar 1 do
        check "opening vertical"
        foreground "clarinet: C5 _ _ Bb4/A4 F#4 _ F4"
        bass "cello: F2 _ _ C3 _ F2 _"
        pulse "hand_drum: X . X X . X ."
      end

      staff_bar 3 do
        check "late answer is visibly displaced"
        foreground "solo_violin: . A4 _ G4 F#4 E4 ."
        bass "cello: F2 _ C3 F2 E2 F2 C3"
        pulse "hand_drum: X . X X . X ."
      end

      staff_bar 5 do
        check "pressure line begins without losing bass line"
        foreground "clarinet: C5 D5 E5 _ F5 . ."
        bass "cello: F2 _ Bb2 C3 F2 _ ."
      end
    end
  end
end
