production_piece "Technique Card OT7_UNISON_TUTTI - OT7_UNISON_TUTTI" do
  meter "4/4"
  key "cm"

  tempo do
    mark "quarter = 92", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT7_UNISON_TUTTI
# cite: orchestration_techniques:tutti
# behavior: whole orchestra in bare octave unison, no harmony: one C-minor fate-theme stated
#   across 5 octaves (Cb/Tuba bottom -> Picc/Vn1-desk top), every instrument in its resonant
#   register, all ff marcato with unanimous attack -- the orchestra as one colossal monophonic
#   voice

  roster do
    part :piccolo, "Piccolo", music21: "Piccolo", family: :woodwind, description: "Piccolo"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_i_top, "Violin I top", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT7_UNISON_TUTTI", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "whole orchestra in bare octave unison, no harmony: one C-minor fate-theme stated across 5 octaves (Cb/Tuba bottom -> Picc/Vn1-desk top), every instrument in its resonant register, all ff marcato with unanimous attack -- the orchestra as one colossal monophonic voice"

      phrase :piccolo_line, surface: :split_pitch_rhythm do
        pitch_bars  "G6{ff,marc} Ab6 B6 C7 | D7 Eb7 D7 C7 B6 | C7 B6 C7 Eb7 | D7 G6"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :piccolo_line, part: :piccolo, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff,marc} Ab5 B5 C6 | D6 Eb6 D6 C6 B5 | C6 B5 C6 Eb6 | D6 G5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff,marc} Ab5 B5 C6 | D6 Eb6 D6 C6 B5 | C6 B5 C6 Eb6 | D6 G5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff,marc} Ab5 B5 C6 | D6 Eb6 D6 C6 B5 | C6 B5 C6 Eb6 | D6 G5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{ff,marc} Ab3 B3 C4 | D4 Eb4 D4 C4 B3 | C4 B3 C4 Eb4 | D4 G3"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{ff,marc} Ab4 B4 C5 | D5 Eb5 D5 C5 B4 | C5 B4 C5 Eb5 | D5 G4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff,marc} Ab5 B5 C6 | D6 Eb6 D6 C6 B5 | C6 B5 C6 Eb6 | D6 G5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{ff,marc} Ab3 B3 C4 | D4 Eb4 D4 C4 B3 | C4 B3 C4 Eb4 | D4 G3"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "G2{ff,marc} Ab2 B2 C3 | D3 Eb3 D3 C3 B2 | C3 B2 C3 Eb3 | D3 G2"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{ff,marc} C2 C2 C2 | G1 G1 G1 C2 C2 | C2 C2 C2 C2 | G1 G1"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{ff,marc} Ab5 B5 C6 | D6 Eb6 D6 C6 B5 | C6 B5 C6 Eb6 | D6 G5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_top_line, surface: :split_pitch_rhythm do
        pitch_bars  "G6{ff,marc} Ab6 B6 C7 | D7 Eb7 D7 C7 B6 | C7 B6 C7 Eb7 | D7 G6"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :violin_i_top_line, part: :violin_i_top, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{ff,marc} Ab4 B4 C5 | D5 Eb5 D5 C5 B4 | C5 B4 C5 Eb5 | D5 G4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{ff,marc} Ab4 B4 C5 | D5 Eb5 D5 C5 B4 | C5 B4 C5 Eb5 | D5 G4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G3"
        intervals "0{ff,marc} +1 +3 +1 | +2 +1 -1 -2 -1 | +1 -1 +1 +3 | -1 -7"
        rhythm    "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G2{ff,marc} Ab2 B2 C3 | D3 Eb3 D3 C3 B2 | C3 B2 C3 Eb3 | D3 G2"
        rhythm_bars "3/2 1/2 1 1 | 1 1 1 1/2 1/2 | 3/2 1/2 1 1 | 2 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
