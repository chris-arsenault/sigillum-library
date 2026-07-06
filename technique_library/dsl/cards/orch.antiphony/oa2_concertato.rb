production_piece "Technique Card OA2_CONCERTATO - OA2_CONCERTATO" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA2_CONCERTATO
# cite: orchestration_techniques:antiphony
# behavior: concerto-grosso contrast: a light solo concertino (Fl+Ob+Vc, p) floats a nimble
#   idea, the full tutti (paired winds+brass+strings, f) seizes it back in mass; swaps tighten
#   to 1 bar at b5-6, then tutti carries the cadence while the concertino threads a soft
#   filigree descant above; terraced dynamics, Allegro

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OA2_CONCERTATO", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "concerto-grosso contrast: a light solo concertino (Fl+Ob+Vc, p) floats a nimble idea, the full tutti (paired winds+brass+strings, f) seizes it back in mass; swaps tighten to 1 bar at b5-6, then tutti carries the cadence while the concertino threads a soft filigree descant above; terraced dynamics, Allegro"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{p} F#5 D5 F#5 A5 D6 C#6 A5 | B5 A5 F#5 D5 E5 F#5 | r | r | B5{p} D6 C#6 B5 A5 F#5 B5 A5 | r | F#6{p} E6 F#6 G6 A6 F#6 E6 D6 | D6{p} C#6 B5 A5 F#5"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 4 | 4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1 1"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{p} D5 F#5 A5 F#5 F#5 E5 F#5 | G5 F#5 A5 F#5 C#5 D5 | r | r | G5{p} F#5 E5 D5 D5 D5 D5 F#5 | r | A5{p} G5 A5 B5 C#6 A5 G5 F#5 | A5{p} A5 G5 F#5 A5"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 4 | 4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1 1"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A4{f} A4 G4 A4 G4 | F#4 A4 E4 | r | D4{f} D4 D4 G4 B4 | A4{f} A4 A4 A4 | F#4 E4 F#4"
        rhythm_bars "4 | 4 | 1 1 1 1/2 1/2 | 1 1 2 | 4 | 1 1 1 1/2 1/2 | 1 1 1 1 | 2 1 1"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D3{f} C#3 D3 E3 | A2 C#3 A2 | r | G2{f} B2 G2 B2 | A2{f} C#3 E3 E3 | A2 E2 A2"
        rhythm_bars "4 | 4 | 1 1 1 1 | 1 1 2 | 4 | 1 1 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | F#4{f} E4 F#4 G4 | E4 E4 E4 | r | B3{f} D4 B3 D4 | C#4{f} E4 G4 G4 | A4 G4 A4"
        rhythm_bars "4 | 4 | 1 1 1 1 | 1 1 2 | 4 | 1 1 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A4{f} A4 A4 B4 A4 | C#5 A4 A4 | r | D5{f} D5 B4 G4 | E5{f} E5 C#5 E5 | D5 C#5 D5"
        rhythm_bars "4 | 4 | 1 1 1 1/2 1/2 | 1 1 2 | 4 | 1 1 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D3{f} A2 A2 | A2 A2 | r | G2{f} G2 | A2{f} A2 | A2 A2 D3"
        rhythm_bars "4 | 4 | 2 1 1 | 2 2 | 4 | 2 2 | 2 2 | 2 1 1"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D5{f} C#5 D5 F#5 E5 | A5 G5 A5 | r | G5{f} F#5 D5 B4 | E5{f} G5 E5 C#5 | D5 C#5 D5"
        rhythm_bars "4 | 4 | 1 1 1 1/2 1/2 | 1 1 2 | 4 | 1 1 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A4{f} A4 A4 A4 | E5 D5 C#5 | r | D5{f} D5 G4 G4 | A4{f} C#5 A4 A4 | A4 A4 A4"
        rhythm_bars "4 | 4 | 1 1 1 1 | 1 1 2 | 4 | 1 1 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | F#4{f} E4 F#4 A4 | A4 A4 A4 | r | B3{f} B3 B3 D4 | A4{f} A4 E4 E4 | F#4 E4 F#4"
        rhythm_bars "4 | 4 | 1 1 1 1 | 1 1 2 | 4 | 1 1 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{p} -5 +5 +4 -4 | +5 +2 -3 -4 +7 -12 | +5{f} -5 +5 +7 -12 | 0{f} +7 -7 +4 +3 | -5{p} +7 -7 +3 -3 | -4{f} +7 -7 +4 +3 | +2{f} 0 -7 0 | +5 -5 +5"
        rhythm    "1 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | D2{f} A1 | A1 A1 | r | G1{f} G1 | A1{f} A1 | A1 A1 D2"
        rhythm_bars "4 | 4 | 2 2 | 2 2 | 4 | 2 2 | 2 2 | 2 1 1"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
