production_piece "Technique Card OT3_DYNAMIC_BALANCE - OT3_DYNAMIC_BALANCE" do
  meter "4/4"
  key "a"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT3_DYNAMIC_BALANCE
# cite: orchestration_techniques:tutti
# behavior: tenor melody cut through a full-ish accompaniment: Hn+Vc an 8ve apart f-espr, lone
#   Cl an 8ve above the horn claiming an exclusive band; muted Vn1/Vn2/Va mp sotto off the
#   tune's octaves, Bsn soft fill, Cb pizz light; b3-4 Vc crosses over the Va; b5 test bar
#   accomp mp< then ff-sub-p so the tune re-emerges; b6 strings ord (mute off) brighten w/o
#   louder dynamic

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT3_DYNAMIC_BALANCE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "tenor melody cut through a full-ish accompaniment: Hn+Vc an 8ve apart f-espr, lone Cl an 8ve above the horn claiming an exclusive band; muted Vn1/Vn2/Va mp sotto off the tune's octaves, Bsn soft fill, Cb pizz light; b3-4 Vc crosses over the Va; b5 test bar accomp mp< then ff-sub-p so the tune re-emerges; b6 strings ord (mute off) brighten w/o louder dynamic"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{f} G5 A5 E5 | F5 E5 D5 | E5 F5 G5 E5 | C5 E5 F5 | G5{f} F5 E5 F5 | G5{f} B5"
        rhythm_bars "1 1 1 1 | 1 1 2 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | C6{mp} B5 | A5 A5 | C6{mp} | D6 B5"
        rhythm_bars "4 | 4 | 2 2 | 2 2 | 4 | 2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{txt:f_espr} G4 A4 E4 | F4 E4 D4 | E4 F4 G4 E4 | C4 E4 F4 | G4{f} F4 E4 F4 | G4{f} B4"
        rhythm_bars "1 1 1 1 | 1 1 2 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{txt:mp_sotto} | D5 | D5 | C5 | D5{txt:mp} D5{txt:ff_sub_p} | B4{txt:ord}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{txt:mp_sotto} | A4 | B4 | A4 | A4{txt:mp} A4{txt:ff_sub_p} | G#4{txt:ord}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{txt:mp_sotto} | F4 | G#4 | C4 | F4{txt:mp} F4{txt:ff_sub_p} | D4{txt:ord}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "E3"
        intervals "0{txt:f_espr} +3 +2 -5 | +1 -1 -2 | +2{marc} +1 +2 -3 | -4 +4 +1 | +2{f} -2 -1 +1 | +2{f} +4"
        rhythm    "1 1 1 1 | 1 1 2 | 1 1 1 1 | 1 1 2 | 1 1 1 1 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{mp} | D3 | B2 | A2 | D3{txt:mp} D3{txt:p_sub} | B2{mp}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{txt:mp_pizz} A1 | D2 D2 | E2 E2 | F1 F1 | D2 D2 | E2 E2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
