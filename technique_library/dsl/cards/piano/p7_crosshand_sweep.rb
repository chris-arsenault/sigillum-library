production_piece "Technique Card P7_CROSSHAND_SWEEP - P7_CROSSHAND_SWEEP" do
  meter "4/4"
  key "C"

# category: piano
# card: P7_CROSSHAND_SWEEP
# cite: keyboard_figuration s6c
# behavior: one 4-octave gesture passed LH->RH (dovetailed seam); then LH crosses OVER (m.s.
#   sopra) to strike bells above the working RH

  roster do
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_crossing, "LH (crossing)", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P7_CROSSHAND_SWEEP", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one 4-octave gesture passed LH->RH (dovetailed seam); then LH crosses OVER (m.s. sopra) to strike bells above the working RH"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "r Db3 F3 Ab3 C4 Eb4 F4 Ab4 C5 | Db5 Eb5 F5 Ab5 Db6{txt:l.v.} | r Gb3 Bb3 Db4 F4 Gb4 Bb4 Db5 F5 | Gb5{txt:l.v.} | Ab3 Db4 F4 Ab4 F4 Db4 Ab3 F3 | Gb3 Db4 Gb4 Bb4 Gb4 Db4 Bb3 Gb3"
        rhythm_bars "2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 9/4 | 2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_crossing_line, surface: :split_pitch_rhythm do
        pitch_bars  "Db1 Ab1 Db2 F2 Ab2 Db3 F3 Ab3 r | r | Gb1 Db2 Gb2 Bb2 Db3 Gb3 Bb3 Db4 r | r | Db2 r F6{txt:m.s._sopra} r Ab2 r | Gb2 r Db6{txt:m.s._sopra} r Gb1"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 2 | 4 | 1/2 1 1 1/2 1/2 1/2 | 1/2 1 1 1/2 1"
      end

      placement :lh_crossing_line, part: :lh_crossing, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
