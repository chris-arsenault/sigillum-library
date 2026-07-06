production_piece "Technique Card OPC1_CHOIR_PAD - OPC1_CHOIR_PAD" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC1_CHOIR_PAD
# cite: orchestration_techniques:percussion_choir
# behavior: SATB choir as orchestral section: close-position chorale that MOVES (tenor 4-3
#   suspension, contrary S/B into a PAC) opening into a sustained wordless 'ah' pad

  roster do
    part :choir_upper, "Choir (upper)", music21: "Choir", family: :other, description: "Choir"
    part :choir_lower, "Choir (lower)", music21: "Choir", family: :other, description: "Choir"
  end

  section :card, "OPC1_CHOIR_PAD", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "SATB choir as orchestral section: close-position chorale that MOVES (tenor 4-3 suspension, contrary S/B into a PAC) opening into a sustained wordless 'ah' pad"

      phrase :choir_upper_line, surface: :split_pitch_rhythm do
        pitch_bars  "[E5,C5]{mf} [E5,C5] | [F5,A4] [D5,B4] | [E5,B4] [D5,A4] | [D5,B4] [C5,C5] | [G5,C5] [E5,C5] | [F5,C5] [E5,C5]"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :choir_upper_line, part: :choir_upper, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :choir_lower_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G4,C3]{mf} [E4,A2] | [C4,F2] [C4,G2] [B3,G2] | [G4,E3] [F4,D3] | [F4,G2] [E4,C3] | [G4,C3] [E4,C3] | [F4,F2] [E4,C3]"
        rhythm_bars "2 2 | 2 1 1 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :choir_lower_line, part: :choir_lower, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
