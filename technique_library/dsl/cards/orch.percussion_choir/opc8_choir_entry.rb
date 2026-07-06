production_piece "Technique Card OPC8_CHOIR_ENTRY - OPC8_CHOIR_ENTRY" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC8_CHOIR_ENTRY
# cite: orchestration_techniques:percussion_choir
# behavior: choir WITHHELD through an orchestral build (cresc.), then SATB crashes in ff on the
#   climax downbeat - doubling/crowning the D-major arrival chord, the entry itself the
#   structural event - then broadens (allarg.) to a strong PAC

  roster do
    part :soprano, "Soprano", music21: "Soprano", family: :voice, description: "Soprano"
    part :alto, "Alto", music21: "Alto", family: :voice, description: "Alto"
    part :tenor, "Tenor", music21: "Tenor", family: :voice, description: "Tenor"
    part :bass, "Bass", music21: "Bass", family: :voice, description: "Bass"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "OPC8_CHOIR_ENTRY", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "choir WITHHELD through an orchestral build (cresc.), then SATB crashes in ff on the climax downbeat - doubling/crowning the D-major arrival chord, the entry itself the structural event - then broadens (allarg.) to a strong PAC"

      phrase :soprano_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | A5{ff,marc,txt:CHOIR_ENTERS_SATB_doubles_the_climax_chord} A5 F#5 | G5 F#5 | F#5 D5"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 3 1"
      end

      placement :soprano_line, part: :soprano, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :alto_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | D5{ff,marc} D5 D5 | D5 D5 | D5 A4"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 3 1"
      end

      placement :alto_line, part: :alto, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tenor_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | A4{ff,marc} A4 A4 | B4 A4 | A4{txt:allarg.} F#4"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 3 1"
      end

      placement :tenor_line, part: :tenor, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | D3{ff,marc} D3 D3 | G2 A2 | D3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 4"
      end

      placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mf,txt:build_-_choir_SILENT} F#5 | A5 A5{cresc(} | B5 | A5 F#5 A5 | E5 E5{f,cresc),txt:dominant_-_push_to_arrival} | A5{ff,marc,txt:tutti_climax_-_choir_crowns} A5 F#5 | G5 F#5 | F#5{txt:allarg.} D5"
        rhythm_bars "2 2 | 2 2 | 4 | 2 1 1 | 2 2 | 2 1 1 | 2 2 | 3 1"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{mf} | F#4 | D4 F#4{cresc(} | D4 | C#4 E4{f,cresc)} | F#4{ff,marc} F#4 D4 | D4 D4 | D4{txt:allarg.}"
        rhythm_bars "4 | 4 | 2 2 | 4 | 2 2 | 2 1 1 | 2 2 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "A3{mf} | A3 | A3{cresc(} | F#3 A3 | A3{f,cresc)} | A3{ff,marc} A3 F#3 | G3 A3 | A3{txt:allarg.}"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 2 1 1 | 2 2 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mf} | D2 | D2{cresc(} | D2 | A1{f,cresc),txt:dominant_pedal} | D2{ff,marc} D2 D2 | G1 A1 | D2{txt:allarg.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{mp,txt:approach_cresc._poco_a_poco} F#5 A5 F#5 | D5 F#5 A5 D6 | A5{cresc(} D6 F#6 D6 | A5 B5 D6 B5 | E5{f} G5 E6 E6{cresc)} | A5{ff,marc} A5 F#5 | G5 F#5 | F#5{txt:allarg.} D5"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 2 1 1 | 2 2 | 3 1"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{mp} | -5 | +5{cresc(} | 0 | -5{f,cresc)} | +5{ff,marc,txt:doubles_choral_B} 0 0 | -7 +2 | +5{txt:allarg.}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} | D2 | D2{cresc(} | D2 | A1{f,cresc)} | D2{ff,marc} D2 D2 | G1 A1 | D2{txt:allarg.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 1 1 | 2 2 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{mp,txt:timp_D+A_pedal_on_dominant} r | A2 r | A2{cresc(,txt:roll_8ths_soft_felt_cresc._al_ff} A2 A2 A2 A2 A2 A2 A2 | A2 A2 A2 A2 A2 A2 A2 A2 | A2{f} A2 A2 A2 A2 A2 A2 A2{cresc)} | D2{ff,marc,txt:TONIC_stroke_-_choir_crowns_the_arrival} r A2 r | D2 r A2 r | D2{txt:allarg.} r"
        rhythm_bars "1 3 | 1 3 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1 1 1 | 1 1 1 1 | 1 3"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
