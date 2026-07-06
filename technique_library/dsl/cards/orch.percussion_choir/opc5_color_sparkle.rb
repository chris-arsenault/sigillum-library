production_piece "Technique Card OPC5_COLOR_SPARKLE - OPC5_COLOR_SPARKLE" do
  meter "2/4"
  key "G"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC5_COLOR_SPARKLE
# cite: orchestration_techniques:percussion_choir
# behavior: warm winds+strings tune (substance) gilded by a high pitched-color layer: glock
#   pricks phrase-peaks 2 8ve up, celesta drops fountain fills, triangle pings downbeats + rolls
#   the cadence, harp lays rolled-chord sparkle - garnish, not substance

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :glockenspiel, "Glockenspiel", music21: "Glockenspiel", family: :percussion, description: "Glockenspiel"
    part :celesta, "Celesta", music21: "Celesta", family: :keyboard, description: "Celesta"
    part :triangle, "Triangle", music21: "Triangle", family: :percussion, description: "Triangle"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
  end

  section :card, "OPC5_COLOR_SPARKLE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "warm winds+strings tune (substance) gilded by a high pitched-color layer: glock pricks phrase-peaks 2 8ve up, celesta drops fountain fills, triangle pings downbeats + rolls the cadence, harp lays rolled-chord sparkle - garnish, not substance"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp,txt:warm_lead_-_the_tune_the_color_gilds} G5 B5 A5 | G5 E5 E5 D5 | E5 G5 C5 E5 | D5 A4 B4 | D5{mf,txt:phrase_rises_to_the_peak} G5 B5 D6 | C6 A5 F#5 A5 | B5 A5 D5 F#5 | G5{mp,txt:dim,txt:resolve}"
        rhythm_bars "1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4{p,txt:inner_warmth} C5 | B4 G4 | C5 G4 | F#4 F#4 | B4{mp} B4 | A4 D5 | D5 D5 | B4{p,txt:dim}"
        rhythm_bars "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{p,txt:third_of_the_harmony} E4 | E4 D4 | E4 C4 | D4 D4 | G4{mp} G4 | E4 F#4 | A4 A4 | G4{p,txt:dim}"
        rhythm_bars "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{p,txt:soft_horn_pad_under_the_winds} | B3 | C4 | A3 | D4{mp} | C4 | D4 | D4{txt:dim}"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2 | 2 | 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp,txt:violins_double_the_lead_warm} G5 B5 A5 | G5 E5 E5 D5 | E5 G5 C5 E5 | D5 A4 B4 | D5{mf} G5 B5 D6 | C6 A5 F#5 A5 | B5 A5 D5 F#5 | G5{mp,txt:dim}"
        rhythm_bars "1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 2"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{p,txt:viola_fills_the_chord} D4 | B3 B3 | C4 C4 | A3 A3 | B3{mp} B3 | E4 D4 | D4 C4 | B3{txt:dim}"
        rhythm_bars "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{p,txt:cello_bass_-_the_floor} +7 | +2 0 | -4 0 | +2 0 | -7{mp} 0 | +5 0 | +2 0 | -7{txt:dim}"
        rhythm    "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :glockenspiel_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:glock_tacet_-_saves_its_bright_attack} | r | r | r | r D6{mf,txt:glock_pricks_the_phrase-peak_(sounds_2_8ve_up)} | C6{mp,txt:one_bright_ping_on_the_apex} r | r | G6{mp,txt:final_sparkle_on_the_tonic} r"
        rhythm_bars "2 | 2 | 2 | 2 | 3/2 1/2 | 1/2 3/2 | 2 | 1/2 3/2"
      end

      placement :glockenspiel_line, part: :glockenspiel, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :celesta_line, surface: :split_pitch_rhythm do
        pitch_bars  "r G5{p,txt:celesta_dolce_-_fountain-drops_fill_between_phrases} B5 | r | r C5{p} E5 | r | r G5{mp,txt:fill_into_the_peak_run-up} B5 | E6{mp} C6 A5 G5 | r | [G5,B5,D6]{p,txt:soft_chime_on_the_resolution}"
        rhythm_bars "1 1/2 1/2 | 2 | 1 1/2 1/2 | 2 | 1 1/2 1/2 | 1/2 1/2 1/2 1/2 | 2 | 2"
      end

      placement :celesta_line, part: :celesta, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :triangle_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{p,txt:triangle_ping_on_the_downbeat_(indefinite_pitch)} r | r | C5{p,txt:ping} r | r | C5{mp,txt:ping} r | r | r | C5{p,txt:soft_roll_through_the_cadence}"
        rhythm_bars "1/2 3/2 | 2 | 1/2 3/2 | 2 | 1/2 3/2 | 2 | 2 | 2"
      end

      placement :triangle_line, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G3,B3,D4,G4]{p,txt:harp_rolled-chord_sparkle_(I)} | r | [C4,E4,G4,C5]{p,txt:rolled_IV} | r | [G3,B3,D4,G4]{mp,txt:rolled_I_under_the_peak} | C5{mp,txt:ascending_arpeggio_sparkle} E5 G5 C6 | [D4,F#4,A4,D5]{txt:rolled_V} | [G3,B3,D4,G4]{p,txt:final_roll}"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 1/2 1/2 1/2 1/2 | 2 | 2"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
