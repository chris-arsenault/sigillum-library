production_piece "Technique Card OD9_BALANCE_DOUBLING - OD9_BALANCE_DOUBLING" do
  meter "4/4"
  key "Dm"

  tempo do
    mark "quarter = 76", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD9_BALANCE_DOUBLING
# cite: orchestration_techniques:doublings
# behavior: an inner-band (A4-F5) countermelody - buried under a clear Vn1/Fl melody above and
#   Vc/Cb bass below - is rescued by doubling it in unison with two cutting timbres (Cor anglais
#   + Clarinet, mf espr.) while the Vn2/Ob harmony is pushed up off the tenor band and the
#   Bsn/Hn/Va pad held soft below, so the reinforced inner line reads as the event

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :english_horn, "English Horn", music21: "EnglishHorn", family: :other, description: "EnglishHorn"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD9_BALANCE_DOUBLING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "an inner-band (A4-F5) countermelody - buried under a clear Vn1/Fl melody above and Vc/Cb bass below - is rescued by doubling it in unison with two cutting timbres (Cor anglais + Clarinet, mf espr.) while the Vn2/Ob harmony is pushed up off the tenor band and the Bsn/Hn/Va pad held soft below, so the reinforced inner line reads as the event"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{p} G5 | F5 A5 | G5 F5 | A5 Bb5 | A5 G5 | F5 E5"
        rhythm_bars "2 2 | 2 2 | 3 1 | 2 2 | 2 2 | 2 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{pp} | Bb5 | G5 | A5 | Bb5 | A5"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :english_horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{txt:mf_espr,txt:project} Bb4 C5 A4 | D5 C5 Bb4 A4 | G4 A4 Bb4 C5 | D5 E5 F5 | E5 D5 C5 Bb4 | A4 A4"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 3/2 1/2 | 2 1 1 | 3/2 1/2 1 1 | 2 2"
      end

      placement :english_horn_line, part: :english_horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{txt:mf_espr,txt:project} Bb4 C5 A4 | D5 C5 Bb4 A4 | G4 A4 Bb4 C5 | D5 E5 F5 | E5 D5 C5 Bb4 | A4 A4"
        rhythm_bars "3/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 3/2 1/2 | 2 1 1 | 3/2 1/2 1 1 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{p} | D3 | C3 | D3 | Bb2 | A2"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{p} | A3 | G3 | A3 | A3 | A3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{txt:mp_dolce} G5 | F5 A5 | G5 F5 | A5 Bb5 | A5 G5 | F5 E5"
        rhythm_bars "2 2 | 2 2 | 3 1 | 2 2 | 2 2 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "F5{pp} | F5 | E5 | F5 | G5 | F5"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{p} | D4 | C4 | D4 | D4 | A3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{mp} -5 | +5 +3 | -5 +4 | -2 -5 | +1 +2 | +2 -5"
        rhythm    "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} | D2 | C2 | D2 | Bb1 | A1"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
