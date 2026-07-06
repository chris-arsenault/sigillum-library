production_piece "Technique Card OG7_ACTIVE_INNER - OG7_ACTIVE_INNER" do
  meter "3/4"
  key "a"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG7_ACTIVE_INNER
# cite: orchestration_techniques:accompaniment
# behavior: active inner voices instead of held chords: Va walks a flowing 8th-note inner
#   counterline + Vn2 runs an Alberti broken-chord 8th figure, two independent inner lives
#   driving forward; Cl a slower syncopated counter-line, Hn/Bsn glue; Vn1+Ob lyric tune (Fl
#   joins the b5-7 lift), Vc arco ground + Cb pizz floor; i-iv-V-i-VI-iv-V-i, Andantino con moto

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

  section :card, "OG7_ACTIVE_INNER", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "active inner voices instead of held chords: Va walks a flowing 8th-note inner counterline + Vn2 runs an Alberti broken-chord 8th figure, two independent inner lives driving forward; Cl a slower syncopated counter-line, Hn/Bsn glue; Vn1+Ob lyric tune (Fl joins the b5-7 lift), Vc arco ground + Cb pizz floor; i-iv-V-i-VI-iv-V-i, Andantino con moto"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | A5{mp,txt:joins_at_the_lift} C6 A5 | D6 C6{txt:cresc.} | B5{mf} G#5 E5 | r"
        rhythm_bars "3 | 3 | 3 | 3 | 1 1 1 | 2 1 | 1 1 1 | 3"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp} C5 E5 | D5 C5 | B4 C5 E5 | C5 A4 | A4{mp} F4 C5 | F5 E5 | D5{mf} B4 E5 | A4{p}"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 3"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{p,txt:inner_counter-line_under_the_tune} B4 | A4 F4 | G#4 B4 | C5 E5 | C5{mp} A4 | D5 F5 | E5{mf} D5 | C5{p} B4"
        rhythm_bars "3/2 3/2 | 3/2 3/2 | 2 1 | 3/2 3/2 | 3/2 3/2 | 2 1 | 3/2 3/2 | 2 1"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{p} E3 | F3 D3 | B3 E3 | A3 E3 | F3{mp} C3 | D3 A3 | E3 B3 | A3{p}"
        rhythm_bars "3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{p,txt:sustain_glue_do_not_cover} | F4 | E4 | E4 | C4{mp} | A4 | B4 E4 | A4{p}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3 | 2 1 | 3"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mf,txt:cantabile_sopra} A5 C6 | B5 E5 | E5{txt:cresc.} F5 G#5 | A5 E5{txt:dim.} | F5{mf} C6 A5 | D6 C6{txt:cresc.} | B5{f} G#5 E5 | A5{mp,txt:morendo}"
        rhythm_bars "1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 2 1 | 1 1 1 | 3"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{p,txt:Alberti_figure_leggiero} E4 C4 E4 A3 E4 | D4 A4 F4 A4 D4 A4 | E4 B4 G#4 B4 E4 B4 | A3 E4 C4 E4 A3 C4 | F4{mp} C5 A4 C5 F4 A4 | D4 A4 F4 A4 D4 F4 | E4 B4 G#4 B4 E4 G#4 | A3{p} E4 C4 E4 A3"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{mp,txt:inner_walk_flowing} B3 C4 E4 D4 C4 | D4 E4 F4 A4 G4 F4 | E4 F4 G#4 B4 A4 G#4 | A4 G4 E4 C4 D4 E4 | F4{mf} E4 D4 C4 D4 E4 | F4 G4 A4 D5 C5 A4 | G#4 A4 B4 E5 D5 B4 | A4{mp} E4 C4 E4 A4"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{mp,txt:arco_ground} -5 | -2 +7 | -5 | +5 -5 | +1{mf} +7 | -10 +3 | -1 +7 | -2{mp}"
        rhythm    "3/2 3/2 | 3/2 3/2 | 3 | 3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3/2 3/2 | 3"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "A1{p,txt:pizz.} r | D2{p} r | E1{p} r | A1{p} r | F1{mp} r | D2{mp} r | E1{mp} r | A1{p} r"
        rhythm_bars "1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
