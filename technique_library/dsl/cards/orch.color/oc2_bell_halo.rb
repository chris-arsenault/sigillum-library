production_piece "Technique Card OC2_BELL_HALO - OC2_BELL_HALO" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 66", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC2_BELL_HALO
# cite: orchestration_techniques:color
# behavior: soft sustained chord per bar (winds + muted divisi strings, enter pp attackless)
#   ignited on each downbeat by a coincident plucked/struck attack (harp roll + CB pizz +
#   celesta strike + glock ping, l.v., voicing the SAME chord) so the bright fast-decaying
#   transient and the swelling halo fuse into one struck-bell-into-halo color

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
    part :celesta, "Celesta", music21: "Celesta", family: :keyboard, description: "Celesta"
    part :glockenspiel, "Glockenspiel", music21: "Glockenspiel", family: :percussion, description: "Glockenspiel"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OC2_BELL_HALO", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "soft sustained chord per bar (winds + muted divisi strings, enter pp attackless) ignited on each downbeat by a coincident plucked/struck attack (harp roll + CB pizz + celesta strike + glock ping, l.v., voicing the SAME chord) so the bright fast-decaying transient and the swelling halo fuse into one struck-bell-into-halo color"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#5{pp,txt:cresc-dim} | F#5{txt:cresc-dim} | D6{txt:cresc-dim} | G5{txt:cresc-dim} | E5{txt:cresc-dim} | F#5{ppp,txt:morendo}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{pp,txt:cresc-dim} | D5{txt:cresc-dim} | B4{txt:cresc-dim} | B4{txt:cresc-dim} | A4{txt:cresc-dim} | A4{ppp,txt:morendo}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{pp,txt:cresc-dim} | F#4{txt:cresc-dim} | G4{txt:cresc-dim} | E4{txt:cresc-dim} | E4{txt:cresc-dim} | D4{ppp,txt:morendo}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{pp,txt:cresc-dim} | F#5{txt:cresc-dim} | D6{txt:cresc-dim} | D5{txt:cresc-dim} | E5{txt:cresc-dim} | F#5{ppp,txt:morendo}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "F#5{pp,txt:cresc-dim} | D5{txt:cresc-dim} | B5{txt:cresc-dim} | B4{txt:cresc-dim} | A4{txt:cresc-dim} | D5{ppp,txt:morendo}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{pp,txt:cresc-dim} | B3{txt:cresc-dim} | G4{txt:cresc-dim} | G3{txt:cresc-dim} | E4{txt:cresc-dim} | A3{ppp,txt:morendo}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{pp,txt:cresc-dim} | -3{txt:cresc-dim} | -4{txt:cresc-dim} | -3{txt:cresc-dim} | +5{txt:cresc-dim} | +5{ppp,txt:morendo}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D3,F#3,A3,D4,E4]{p,txt:harp_rolls_the_chord_l.v.} r | [B2,D3,F#3,B3,C#4]{p} r | [G2,B2,D3,G3,A3]{p} r | [E2,G2,B2,D3]{p} r | [A2,D3,E3,A3]{p} r | [D3,F#3,A3,D4]{pp} r"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :celesta_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D5,F#5,A5,E6]{mp,txt:celesta_strike_l.v.} r | [B4,D5,F#5,C#6]{mp} r | [G4,B4,D5,A5]{mp} r | [E4,G4,B4,D5]{mp} r | [A4,D5,E5,A5]{mp} r | [D5,F#5,A5]{p} r"
        rhythm_bars "1 3 | 1 3 | 1 3 | 1 3 | 1 3 | 1 3"
      end

      placement :celesta_line, part: :celesta, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :glockenspiel_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{mp,txt:glock_ping_8va_l.v.} r | F#6{mp} r | D6{mp} r | B5{mp} r | E6{mp} r | D6{p} r"
        rhythm_bars "1 3 | 1 3 | 1 3 | 1 3 | 1 3 | 1 3"
      end

      placement :glockenspiel_line, part: :glockenspiel, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{p,txt:pizz} r | B1{p,txt:pizz} r | G1{p,txt:pizz} r | E2{p,txt:pizz} r | A1{p,txt:pizz} r | D2{pp,txt:pizz} r"
        rhythm_bars "1 3 | 1 3 | 1 3 | 1 3 | 1 3 | 1 3"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
