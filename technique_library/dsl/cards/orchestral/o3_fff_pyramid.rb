production_piece "Technique Card O3_FFF_PYRAMID - O3_FFF_PYRAMID" do
  meter "4/4"
  key "C"

# category: orchestral
# card: O3_FFF_PYRAMID
# cite: chord_scoring s5 fff recipe
# behavior: 3 octaves of melody, sections internally complete, seams overlapped, timp+cymbal at
#   the peak only, re-voiced hammers

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horns, "Horns", music21: "Horn", family: :brass, description: "Horn"
    part :trombones, "Trombones", music21: "Trombone", family: :brass, description: "Trombone"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :cymbal, "Cymbal", music21: "Percussion", family: :other, description: "Percussion"
  end

  section :card, "O3_FFF_PYRAMID", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "3 octaves of melody, sections internally complete, seams overlapped, timp+cymbal at the peak only, re-voiced hammers"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{ff} E6 F#6 G6 A6 | B6 A6 G6 F#6 E6 | [D6,F#6] [E6,G6] | [D6,F#6,A6]"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 2 2 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5 E5 F#5 G5 A5 | B5 A5 G5 F#5 E5 | [D5,A5]{ff} [E5,A5] | [D5,A5]"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 2 2 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4 E4 F#4 G4 A4 | B4 A4 G4 F#4 E4 | [A4,D5]{ff} [A4,C#5] | [A4,D5]"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 2 2 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horns_line, surface: :split_pitch_rhythm do
        pitch_bars  "[F#4,A4]{ff} [F#4,A4] [G4,B4] [F#4,A4] | [G4,B4] [F#4,A4] [E4,G4] [E4,A4] | [F#4,A4] [G4,A4] | [F#4,A4]"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 2 2 | 4"
      end

      placement :horns_line, part: :horns, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombones_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D3,A3,D4]{ff} [D3,G3,B3] | [D3,F#3,A3] [C#3,E3,A3] | [D3,A3,D4] [E3,A3,C#4] | [D3,A3,D4]"
        rhythm_bars "2 2 | 2 2 | 2 2 | 4"
      end

      placement :trombones_line, part: :trombones, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0{ff} 0 +2 +2 +1 | 0 +2 0 -2 +2 | -7 +7 | -7"
        rhythm    "1 1/2 1/2 1 1 | 1 1 1/2 1/2 1 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r A2 A2 A2 | D2{ff,trem} A2{trem} | D2"
        rhythm_bars "4 | 2 1 1/2 1/2 | 2 2 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :cymbal_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | A3{ff,txt:cymbal}"
        rhythm_bars "4 | 4 | 4 | 4"
      end

      placement :cymbal_line, part: :cymbal, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
