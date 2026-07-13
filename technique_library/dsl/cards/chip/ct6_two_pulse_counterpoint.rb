production_piece "Technique Card CT6_TWO_PULSE_COUNTERPOINT - CT6_TWO_PULSE_COUNTERPOINT" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: chip
# card: CT6_TWO_PULSE_COUNTERPOINT
# cite: chiptune_research:two_pulse_ensemble (docs/research/chiptune_nes_composition.md)
# behavior: Kondo-style three-part ensemble writing: pulse 1 carries a bouncy lead, pulse 2
#   shadows it in 6ths and answers in the lead's gap bars (call-and-response), triangle walks
#   quarters underneath - wide intervals between the voices read as fuller harmony on squares

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - bouncy lead"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - counterline in 6ths, answers in gaps"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - walking bass"
  end

  section :card, "CT6_TWO_PULSE_COUNTERPOINT", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "Kondo-style three-part ensemble writing: pulse 1 carries a bouncy lead, pulse 2 shadows it in 6ths and answers in the lead's gap bars (call-and-response), triangle walks quarters underneath - wide intervals between the voices read as fuller harmony on squares"

      phrase :bouncy_lead, surface: :split_pitch_rhythm do
        pitch_bars  "C5{mf,txt:pulse1_-_lead_leaves_gap_bars_for_the_answer} E5 G5 E5 G5 A5 | G5 F5 E5 D5 E5 C5 | D5 F5 A5 F5 A5 B5 | G5 r | C5 E5 G5 E5 G5 A5 | G5 F5 E5 D5 E5 C5 | A4 C5 F5 E5 D5 B4 | C5 r"
        rhythm_bars "1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 2 2 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 2 2"
      end

      placement :bouncy_lead, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :sixths_counter, surface: :split_pitch_rhythm do
        pitch_bars  "E4{mp,txt:pulse2_-_shadow_in_6ths_below} G4 B4 G4 B4 C5 | B4 A4 G4 F4 G4 E4 | F4 A4 C5 A4 C5 D5 | B4{mf,txt:answer_in_the_gap} D5 B4 G4 B4 D5 | E4{mp} G4 B4 G4 B4 C5 | B4 A4 G4 F4 G4 E4 | C4 E4 A4 G4 F4 D4 | E4 G4 E4 C4 G4"
        rhythm_bars "1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 2"
      end

      placement :sixths_counter, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :walking_floor, surface: :split_pitch_rhythm do
        pitch_bars  "C3{mf,txt:triangle_-_walking_quarters} D3 E3 G2 | C3 B2 A2 G2 | D3 E3 F3 D3 | G2 A2 B2 D3 | C3 D3 E3 G2 | C3 B2 A2 G2 | F2 G2 A2 G2 | C3 G2 E2 G2"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :walking_floor, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
