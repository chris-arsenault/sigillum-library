production_piece "Technique Card OT8_SECONDARY_LINE - OT8_SECONDARY_LINE" do
  meter "4/4"
  key "a"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT8_SECONDARY_LINE
# cite: orchestration_techniques:tutti
# behavior: full f->ff tutti (melody top in Fl/Vn1, Tpt crowning; harmony Cl/Vn2/Va held ABOVE
#   C4 and Cb/Tuba/Timp BELOW) with the tenor band A2-A3 kept harmonically clear so a marcato
#   rising countermelody in Hn+Vc unison (+Bsn 8ve below, Tbn at its bar-5 peak) cuts through
#   and is heard under the mass; i-VI-iv-V-iv6-i

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OT8_SECONDARY_LINE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "full f->ff tutti (melody top in Fl/Vn1, Tpt crowning; harmony Cl/Vn2/Va held ABOVE C4 and Cb/Tuba/Timp BELOW) with the tenor band A2-A3 kept harmonically clear so a marcato rising countermelody in Hn+Vc unison (+Bsn 8ve below, Tbn at its bar-5 peak) cuts through and is heard under the mass; i-VI-iv-V-iv6-i"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "E6{f} E6 | F6 E6 | E6 D6 | C6 D6 | F6{txt:cresc} E6 | E6{ff} A5"
        rhythm_bars "2 2 | 2 2 | 2 2 | 3 1 | 2 2 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C5,E5]{f} | [C5,F5] | [C5,F5] | [B4,E5] | [D5,F5]{txt:cresc} | [C5,E5]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{txt:f_marc} B1 C2 | E2 F2 E2 | D2{txt:cresc} E2 F2 G2 | E2 E2 | F2{txt:cresc} G2 A2 | E2{ff} A2"
        rhythm_bars "1 1 2 | 1 1 2 | 1 1 1 1 | 2 2 | 1 1 2 | 2 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{txt:f_marc} B2 C3 | E3 F3 E3 | D3{txt:cresc} E3 F3 G3 | E3 E3 | F3{txt:cresc} G3 A3 | E3{ff} A3"
        rhythm_bars "1 1 2 | 1 1 2 | 1 1 1 1 | 2 2 | 1 1 2 | 2 2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | F5{txt:cresc} E5 | E5{ff} A4"
        rhythm_bars "4 | 4 | 4 | 4 | 2 2 | 2 2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | F3{txt:cresc_marc} G3 A3 | E3{ff} A3"
        rhythm_bars "4 | 4 | 4 | 4 | 1 1 2 | 2 2"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{f} | F1 | D1 | E1 | D1{txt:cresc} | A1{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{f,trem} | r | r | E1{txt:cresc,trem} | E1{trem} | A1{ff,trem}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{f} E5 | F5 E5 | E5 D5 | C5 D5 | F5{txt:cresc} E5 | E5{ff} A4"
        rhythm_bars "2 2 | 2 2 | 2 2 | 3 1 | 2 2 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "[A4,C5]{f} | [A4,C5] | [A4,D5] | [G4,B4] | [A4,D5]{txt:cresc} | [A4,C5]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C4,E4]{f} | [C4,F4] | [C4,F4] | [B3,E4] | [D4,F4]{txt:cresc} | [C4,E4]{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{txt:f_marc} +2 +1 | +4 +1 -1 | -2{txt:cresc} +2 +1 +2 | -3 0 | +1{txt:cresc} +2 +2 | -5{ff} +5"
        rhythm    "1 1 2 | 1 1 2 | 1 1 1 1 | 2 2 | 1 1 2 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{f} | F1 | D2 | E2 | D2{txt:cresc} | A1{ff}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
