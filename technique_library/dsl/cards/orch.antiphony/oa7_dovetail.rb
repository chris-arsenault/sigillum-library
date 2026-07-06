production_piece "Technique Card OA7_DOVETAIL - OA7_DOVETAIL" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 58", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA7_DOVETAIL
# cite: orchestration_techniques:antiphony
# behavior: dovetailed antiphony, no gap: one continuous Adagio cantabile melody relayed
#   strings(Va+Vc 8ve)->winds(Cl+Bsn)->horns->strings, each incoming group ENTERING on the
#   outgoing group's exact sustained seam pitch (A/A/D) one beat before it releases, matched
#   dim/cresc hairpins hiding the join, Cb a soft floor; the line never breaks

  roster do
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
  end

  section :card, "OA7_DOVETAIL", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "dovetailed antiphony, no gap: one continuous Adagio cantabile melody relayed strings(Va+Vc 8ve)->winds(Cl+Bsn)->horns->strings, each incoming group ENTERING on the outgoing group's exact sustained seam pitch (A/A/D) one beat before it releases, matched dim/cresc hairpins hiding the join, Cb a soft floor; the line never breaks"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} C5 D5 | F5 E5 D5 C5 | D5 F5 A5 A5{txt:dim} | A5 r | r | r | r D5{txt:cresc} | C5 Bb4 A4 F4"
        rhythm_bars "1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 3 | 4 | 4 | 3 1 | 1 1 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A3"
        intervals "0{mp} +3 +2 | +3 -1 -2 -2 | +2 +3 +4 0{txt:dim} | 0 r | r | r | r -7{txt:cresc} | -2 -2 -1 -4"
        rhythm    "1 1 2 | 1 1 1 1 | 1 1 1 1 | 1 3 | 4 | 4 | 3 1 | 1 1 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} | D2 | D2 Bb1{txt:dim} | Bb1 r | r | r | r Bb1{txt:cresc} | F2 G2 C2 F2"
        rhythm_bars "4 | 4 | 2 2 | 1 3 | 4 | 4 | 3 1 | 1 1 1 1"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | A5{txt:cresc} G5 F5 G5 | E5 G5 C6 Bb5 | A5{txt:dim} r | r | r"
        rhythm_bars "12 | 1 1 1 1 | 1 1 1 1 | 1 3 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | A3{txt:cresc} G3 F3 G3 | E3 G3 C4 Bb3 | A3{txt:dim} r | r | r"
        rhythm_bars "12 | 1 1 1 1 | 1 1 1 1 | 1 3 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | A4{txt:cresc} Bb4 C5 A4 | F4 G4 D5 D5{txt:dim} | r"
        rhythm_bars "20 | 1 1 1 1 | 1 1 1 1 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | F4{txt:cresc} G4 A4 F4 | D4 E4 F4 F4{txt:dim} | r"
        rhythm_bars "20 | 1 1 1 1 | 1 1 1 1 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
