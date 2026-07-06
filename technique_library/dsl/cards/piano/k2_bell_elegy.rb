production_piece "Technique Card K2_BELL_ELEGY - K2_BELL_ELEGY" do
  meter "4/4"
  key "C"

# category: piano
# card: K2_BELL_ELEGY
# cite: keyboard_figuration s2
# behavior: LH continuous 8ths spanning Db1-Db4, crest = rising inner line; melody plain then
#   octaves; ONE bell toll at the peak (l.v.)

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_sweeps, "LH sweeps", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "K2_BELL_ELEGY", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "LH continuous 8ths spanning Db1-Db4, crest = rising inner line; melody plain then octaves; ONE bell toll at the peak (l.v.)"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{p} Eb4 Db4 | Db4 C4 Db4 | Bb3 Db4 Eb4 | F4 Eb4 | [F4,F5]{mf} [Gb4,Gb5] [Ab4,Ab5] | [Bb4,Bb5] [Ab4,Ab5] [Gb4,Gb5] | [Db5,Fb5]{txt:l.v.} Eb5 Db5 | [Db4,Db5]{txt:morendo}"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 2 1 1 | 3 1 | 2 1 1 | 2 1 1 | 2 1 1 | 4"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_sweeps_line, surface: :split_pitch_rhythm do
        pitch_bars  "Db1 Ab1 F2 Ab2 Db3 F3 Ab3 F3 | Bb1 F2 Db3 F3 Bb3 F3 Db3 F2 | Gb1 Db2 Bb2 Db3 Gb3 Bb3 Gb3 Db3 | Ab1 Eb2 C3 Gb3 Ab3 C4 Ab3 Eb3 | Db1 Ab1 F2 Ab2 Db3 F3 Ab3 Db4 | Gb1 Db2 Bb2 Db3 Gb3 Bb3 Db4 Bb3 | [Db1,Ab1,Db2]{txt:l.v.} Ab1 Eb2 C3 Gb3 | Db1 Ab1 Db2 F2 Ab2 F2 Db2 Ab1"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :lh_sweeps_line, part: :lh_sweeps, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
