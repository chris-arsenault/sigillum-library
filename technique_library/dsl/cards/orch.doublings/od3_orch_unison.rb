production_piece "Technique Card OD3_ORCH_UNISON - OD3_ORCH_UNISON" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 80", at: "bar 1 beat 1"
  end

# category: orch.doublings
# card: OD3_ORCH_UNISON
# cite: orchestration_techniques:doublings
# behavior: balanced orchestral unison: one noble D-major theme massed across all families in
#   four octaves at a moderate mf, voiced by Rimsky's strength-equivalences (brass weighted to
#   the middle octaves, the thin top tripled, the floor doubled) so no octave dominates and the
#   orchestra reads as one unified blended voice -- not the OT7 fff blast

  roster do
    part :piccolo, "Piccolo", music21: "Piccolo", family: :woodwind, description: "Piccolo"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OD3_ORCH_UNISON", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "balanced orchestral unison: one noble D-major theme massed across all families in four octaves at a moderate mf, voiced by Rimsky's strength-equivalences (brass weighted to the middle octaves, the thin top tripled, the floor doubled) so no octave dominates and the orchestra reads as one unified blended voice -- not the OT7 fff blast"

      phrase :piccolo_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{mf,txt:cantabile} E6 F#6 A6 | G6 F#6 E6 | D6 F#6 A6 D7 | C#7 B6 A6 | G6 A6 B6 A6 | D7"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :piccolo_line, part: :piccolo, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{mf,txt:cantabile} E6 F#6 A6 | G6 F#6 E6 | D6 F#6 A6 D7 | C#7 B6 A6 | G6 A6 B6 A6 | D7"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{mf,txt:cantabile} E6 F#6 A6 | G6 F#6 E6 | D6 F#6 A6 D7 | C#7 B6 A6 | G6 A6 B6 A6 | D7"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf,txt:cantabile} E5 F#5 A5 | G5 F#5 E5 | D5 F#5 A5 D6 | C#6 B5 A5 | G5 A5 B5 A5 | D6"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf,txt:cantabile} E5 F#5 A5 | G5 F#5 E5 | D5 F#5 A5 D6 | C#6 B5 A5 | G5 A5 B5 A5 | D6"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf,txt:cantabile} E5 F#5 A5 | G5 F#5 E5 | D5 F#5 A5 D6 | C#6 B5 A5 | G5 A5 B5 A5 | D6"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf,txt:cantabile} E5 F#5 A5 | G5 F#5 E5 | D5 F#5 A5 D6 | C#6 B5 A5 | G5 A5 B5 A5 | D6"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mf,txt:cantabile} E4 F#4 A4 | G4 F#4 E4 | D4 F#4 A4 D5 | C#5 B4 A4 | G4 A4 B4 A4 | D5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mf,txt:cantabile} E4 F#4 A4 | G4 F#4 E4 | D4 F#4 A4 D5 | C#5 B4 A4 | G4 A4 B4 A4 | D5"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D4"
        intervals "0{mf,txt:cantabile} +2 +2 +3 | -2 -1 -2 | -2 +4 +3 +5 | -1 -2 -2 | -2 +2 +2 -2 | +5"
        rhythm    "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mf,txt:cantabile} E3 F#3 A3 | G3 F#3 E3 | D3 F#3 A3 D4 | C#4 B3 A3 | G3 A3 B3 A3 | D4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mf,txt:cantabile} E3 F#3 A3 | G3 F#3 E3 | D3 F#3 A3 D4 | C#4 B3 A3 | G3 A3 B3 A3 | D4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mf,txt:cantabile} E3 F#3 A3 | G3 F#3 E3 | D3 F#3 A3 D4 | C#4 B3 A3 | G3 A3 B3 A3 | D4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mf,txt:cantabile} E3 F#3 A3 | G3 F#3 E3 | D3 F#3 A3 D4 | C#4 B3 A3 | G3 A3 B3 A3 | D4"
        rhythm_bars "3/2 1/2 1 1 | 1 1 2 | 1 1 1 1 | 2 1 1 | 1 1 1 1 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
