production_piece "Technique Card OG4_ORCH_WALTZ - OG4_ORCH_WALTZ" do
  meter "3/4"
  key "D"

  tempo do
    mark "quarter = 168", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG4_ORCH_WALTZ
# cite: orchestration_techniques:accompaniment
# behavior: orchestral oom-pah-pah: bass-on-1 (Cb pizz root + Vc arco walking + Bsn body), beats
#   2&3 light staccato off-beat triads voiced close-harmony across Vn2/Va/Cl/Hn (lighter than
#   the tune), under a cantabile Fl/Ob/Vn1 waltz melody; I-I-V-V-vi-IV-V-I, Tempo di valse

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OG4_ORCH_WALTZ", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "orchestral oom-pah-pah: bass-on-1 (Cb pizz root + Vc arco walking + Bsn body), beats 2&3 light staccato off-beat triads voiced close-harmony across Vn2/Va/Cl/Hn (lighter than the tune), under a cantabile Fl/Ob/Vn1 waltz melody; I-I-V-V-vi-IV-V-I, Tempo di valse"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{mf} F#6 A6 | F#6 A6 | E6{mf} A6 G6 | C#6 E6 | F#6{f} B6 A6 | G6 B6 D6 | C#6 E6 A5 | D6{mf}"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 1 1 1 | 1 1 1 | 3"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf} F#5 A5 | F#5 A5 | E5{mf} A5 G5 | C#5 E5 | F#5{mf} B5 A5 | G5 B5 D5 | C#5 E5 A4 | D5{mp}"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 1 1 1 | 1 1 1 | 3"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r D4{p,stacc} D4{stacc} | r D4{p,stacc} D4{stacc} | r C#4{p,stacc} C#4{stacc} | r C#4{p,stacc} C#4{stacc} | r B3{p,stacc} B3{stacc} | r G3{p,stacc} G3{stacc} | r A3{p,stacc} A3{stacc} | r A3{p,stacc} r"
        rhythm_bars "1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mp} r | D3{mp} r | A2{mp} r | A2{mp} r | B2{mp} r | G2{mp} r | A2{mp} r | D3{mp} r"
        rhythm_bars "1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 2 1"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r A3{p,stacc} A3{stacc} | r A3{p,stacc} A3{stacc} | r A3{p,stacc} A3{stacc} | r A3{p,stacc} A3{stacc} | r F#3{p,stacc} F#3{stacc} | r D3{p,stacc} D3{stacc} | r E3{p,stacc} E3{stacc} | r F#3{p,stacc} r"
        rhythm_bars "1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf} F#5 A5 | F#5 A5 | E5{mf} A5 G5 | C#5 E5 | F#5{f} B5 A5 | G5 B5 D5 | C#5 E5 A4 | D5{mf}"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 1 1 1 | 1 1 1 | 3"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r A4{p,stacc} A4{stacc} | r A4{p,stacc} A4{stacc} | r E4{p,stacc} E4{stacc} | r E4{p,stacc} E4{stacc} | r F#4{p,stacc} F#4{stacc} | r D4{p,stacc} D4{stacc} | r E4{p,stacc} E4{stacc} | r F#4{p,stacc} r"
        rhythm_bars "1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r F#4{p,stacc} F#4{stacc} | r F#4{p,stacc} F#4{stacc} | r C#4{p,stacc} C#4{stacc} | r C#4{p,stacc} C#4{stacc} | r D4{p,stacc} D4{stacc} | r B3{p,stacc} B3{stacc} | r C#4{p,stacc} C#4{stacc} | r D4{p,stacc} r"
        rhythm_bars "1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{mp} r +4{stacc} | -4{mp} r +2{stacc} | -7{mp} r -2{stacc} | +2{mp} r +2{stacc} | 0{mp} r -2{stacc} | -2{mp} r +4{stacc} | -2{mp} r +4{stacc} | +1{mp} r"
        rhythm    "1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 2 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} r | D2{mp} r | A1{mp} r | A1{mp} r | B1{mp} r | G1{mp} r | A1{mp} r | D2{mp} r"
        rhythm_bars "1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
