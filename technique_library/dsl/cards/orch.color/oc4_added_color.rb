production_piece "Technique Card OC4_ADDED_COLOR - OC4_ADDED_COLOR" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC4_ADDED_COLOR
# cite: orchestration_techniques:color
# behavior: warm flute melody (doubled 8vb by violins for body) gilded by a thin
#   metallic/plucked sheen doubling the actual line: glock note-for-note 8va up (p), celesta
#   unison-glint on the two phrase-peaks only, harp pricking each melodic onset l.v. (pp); over
#   a light clarinet/horn/viola/cello harmony bed

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :glockenspiel, "Glockenspiel", music21: "Glockenspiel", family: :percussion, description: "Glockenspiel"
    part :celesta, "Celesta", music21: "Celesta", family: :keyboard, description: "Celesta"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "OC4_ADDED_COLOR", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "warm flute melody (doubled 8vb by violins for body) gilded by a thin metallic/plucked sheen doubling the actual line: glock note-for-note 8va up (p), celesta unison-glint on the two phrase-peaks only, harp pricking each melodic onset l.v. (pp); over a light clarinet/horn/viola/cello harmony bed"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "F5{mp} G5 A5 F5 | A5{mp} Bb5 C6 A5 | Bb5 A5 G5 | G5{mp} A5 Bb5 G5 | A5{mf} C6 D6 C6 | Bb5{mp,txt:dim} A5 F5"
        rhythm_bars "1 1 1 1 | 1 1 3/2 1/2 | 1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :glockenspiel_line, surface: :split_pitch_rhythm do
        pitch_bars  "F6{p} G6 A6 F6 | A6{p} Bb6 C7 A6 | Bb6 A6 G6 | G6{p} A6 Bb6 G6 | A6{p} C7 D7 C7 | Bb6{p,txt:dim} A6 F6"
        rhythm_bars "1 1 1 1 | 1 1 3/2 1/2 | 1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :glockenspiel_line, part: :glockenspiel, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :celesta_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r C6{p} r | r | r | r D6{p} r | r"
        rhythm_bars "4 | 2 1 1 | 4 | 4 | 2 1 1 | 4"
      end

      placement :celesta_line, part: :celesta, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp} G4 A4 F4 | A4{pp} Bb4 C5 A4 | Bb4 A4 G4 | G4{pp} A4 Bb4 G4 | A4{pp} C5 D5 C5 | Bb4{pp} A4 F4"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{mp} G4 A4 F4 | A4{mp} Bb4 C5 A4 | Bb4 A4 G4 | G4{mp} A4 Bb4 G4 | A4{mf} C5 D5 C5 | Bb4{mp,txt:dim} A4 F4"
        rhythm_bars "1 1 1 1 | 1 1 3/2 1/2 | 1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{p} | D5 | Bb4 | E5 | C5 | A4{txt:dim}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{p} | F4 | D4 | G4 | E4 | F4{txt:dim}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{p} A3 | D4 Bb3 | D4 G3 | E4 C4 | C4 G3 | A3{txt:dim} F3"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "F2"
        intervals "0{p} | +5 | -3 | +5 | 0 | -7{txt:dim}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
