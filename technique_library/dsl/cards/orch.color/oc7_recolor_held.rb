production_piece "Technique Card OC7_RECOLOR_HELD - OC7_RECOLOR_HELD" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 50", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC7_RECOLOR_HELD
# cite: orchestration_techniques:color
# behavior: one frozen Dmaj9 (D4 F#4 A4 C#5 E5) held 8 bars while instrumentation rotates by
#   masked crossfade: winds state it -> strings fade in on the same notes as winds fade out ->
#   muted brass bloom on the middle/top tones -> thin to a single string color niente; pitch
#   never moves, color is the only motion

  roster do
    part :flute_1, "Flute 1", music21: "Flute", family: :woodwind, description: "Flute"
    part :flute_2, "Flute 2", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
  end

  section :card, "OC7_RECOLOR_HELD", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "one frozen Dmaj9 (D4 F#4 A4 C#5 E5) held 8 bars while instrumentation rotates by masked crossfade: winds state it -> strings fade in on the same notes as winds fade out -> muted brass bloom on the middle/top tones -> thin to a single string color niente; pitch never moves, color is the only motion"

      phrase :flute_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mp} | E5 | E5{txt:dim.} | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_1_line, part: :flute_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "C#5{mp} | C#5 | C#5{txt:dim.} | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_2_line, part: :flute_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} | A4 | A4{txt:dim.} | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#4{mp} | F#4 | F#4{txt:dim.} | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mp} | D4 | D4{txt:dim.} | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | E5{txt:pp} | E5 | E5{txt:dim.} | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | C#5{txt:pp} | C#5 | C#5 | C#5 | C#5 | C#5{txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A4{txt:pp} | A4 | A4{txt:dim.} | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F#4"
        intervals "r | r | 0{txt:pp} | 0 | 0{txt:dim.} | r | r | r"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D4{txt:pp} | D4 | D4 | D4 | D4{txt:dim.} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | A4{txt:pp} | A4 | A4{txt:dim.} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | F#4{txt:pp} | F#4 | F#4{txt:dim.} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | E5{txt:pp} | E5 | E5{txt:dim.} | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
