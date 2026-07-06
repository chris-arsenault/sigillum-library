production_piece "Technique Card OC3_COLOR_ALTERNATION - OC3_COLOR_ALTERNATION" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 120", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC3_COLOR_ALTERNATION
# cite: orchestration_techniques:color
# behavior: same rocking-triad cell on a fixed C-major harmony restated bar-by-bar in
#   alternating family-colors (winds->strings->brass->winds->strings->brass) at an equal mp, so
#   the event is pure timbre-change on identical material; all three families converge on a
#   sustained tutti C in bar 7

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "OC3_COLOR_ALTERNATION", bars: 1..7, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..7, texture: :library_card do
      process "same rocking-triad cell on a fixed C-major harmony restated bar-by-bar in alternating family-colors (winds->strings->brass->winds->strings->brass) at an equal mp, so the event is pure timbre-change on identical material; all three families converge on a sustained tutti C in bar 7"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "G5{mp} A5 G5 G5 | r | r | G5{mp} A5 G5 G5 | r | r | G5{mp}"
        rhythm_bars "1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mp} F5 E5 E5 | r | r | E5{mp} F5 E5 E5 | r | r | E5{mp}"
        rhythm_bars "1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{mp} D5 C5 C5 | r | r | C5{mp} D5 C5 C5 | r | r | C5{mp}"
        rhythm_bars "1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | G5{mp} A5 G5 G5 | r | r | G5{mp} A5 G5 G5 | r | G5{mp}"
        rhythm_bars "4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | E5{mp} F5 E5 E5 | r | r | E5{mp} F5 E5 E5 | r | E5{mp}"
        rhythm_bars "4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | C5{mp} D5 C5 C5 | r | r | C5{mp} D5 C5 C5 | r | C4{mp}"
        rhythm_bars "4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C4"
        intervals "r | 0{mp} +2 -2 0 | r | r | 0{mp} +2 -2 0 | r | -5{mp}"
        rhythm    "4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | G4{mp} A4 G4 G4 | r | r | G4{mp} A4 G4 G4 | G4{mp}"
        rhythm_bars "4 | 4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | E4{mp} F4 E4 E4 | r | r | E4{mp} F4 E4 E4 | E4{mp}"
        rhythm_bars "4 | 4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | C5{mp} D5 C5 C5 | r | r | C5{mp} D5 C5 C5 | C5{mp}"
        rhythm_bars "4 | 4 | 1/2 1/2 1 2 | 4 | 4 | 1/2 1/2 1 2 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | C3{mp} | r | r | C3{mp} | C3{mp}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
