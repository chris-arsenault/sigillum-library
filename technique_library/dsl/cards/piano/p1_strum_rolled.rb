production_piece "Technique Card P1_STRUM_ROLLED - P1_STRUM_ROLLED" do
  meter "4/4"
  key "C"

# category: piano
# card: P1_STRUM_ROLLED
# cite: keyboard_figuration s6c
# behavior: written-out strums: LH open 5th, Mid rolls the triad a 32nd later (everything
#   rings); strum rhythm long-short-short-up; melody above

  roster do
    part :melody, "Melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :strum_roll, "Strum (roll)", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_5ths, "LH 5ths", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P1_STRUM_ROLLED", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "written-out strums: LH open 5th, Mid rolls the triad a 32nd later (everything rings); strum rhythm long-short-short-up; melody above"

      phrase :melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "G#5{mf} F#5 E5 | F#5 G#5 B5 | C#6 B5 G#5 | F#5 E5 F#5 G#5 | A5 B5 C#6 B5 | G#5 F#5 E5"
        rhythm_bars "3/2 1/2 2 | 3/2 1/2 2 | 2 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 3/2 1/2 2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :strum_roll_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [G#3,B3,E4] [G#3,B3,E4] [G#3,B3,E4] [B3,E4,G#4] | r [A3,C#4,E4] [A3,C#4,E4] [A3,C#4,E4] [C#4,E4,A4] | r [G#3,C#4,E4] [G#3,C#4,E4] [C#4,E4,G#4] | r [F#3,B3,D#4] [F#3,B3,D#4] [B3,D#4,F#4] [D#4,F#4,B4] | r [A3,C#4,E4] [A3,C#4,E4] [C#4,E4,A4] [E4,A4,C#5] | r [G#3,B3,E4] [B3,E4,G#4]"
        rhythm_bars "1/8 11/8 1 1 1/2 | 1/8 11/8 1 1 1/2 | 1/8 11/8 1 3/2 | 1/8 11/8 1 1 1/2 | 1/8 7/8 1 1 1 | 1/8 15/8 2"
      end

      placement :strum_roll_line, part: :strum_roll, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_5ths_line, surface: :split_pitch_rhythm do
        pitch_bars  "[E2,B2] [E2,B2] [E2,B2] [E2,B2] | [A2,E3] [A2,E3] [A2,E3] [A2,E3] | [C#2,G#2] [C#2,G#2] [C#2,G#2] | [B1,F#2] [B1,F#2] [B1,F#2] [B1,F#2] | [A1,E2] [A1,E2] [A1,E2] [A1,E2] | [E2,B2] [E1,B1,E2]"
        rhythm_bars "3/2 1 1 1/2 | 3/2 1 1 1/2 | 3/2 1 3/2 | 3/2 1 1 1/2 | 1 1 1 1 | 2 2"
      end

      placement :lh_5ths_line, part: :lh_5ths, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
