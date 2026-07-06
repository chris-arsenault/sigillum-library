production_piece "Technique Card OG3_PULSE_ENGINE - OG3_PULSE_ENGINE" do
  meter "2/4"
  key "d"

  tempo do
    mark "quarter = 138", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG3_PULSE_ENGINE
# cite: orchestration_techniques:accompaniment
# behavior: repeated-chord pulse engine: Vn2+Va reiterate the chord in even 8ths (short,
#   lifted), the pulse rises register-to-register (Va alone -> +Vn2 8ve -> +Vn1 peak -> thins)
#   under a horn tune; cello drives 8th-note bass, Cb strong-beat root floor; the motor, not a
#   pad; Allegro

  roster do
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OG3_PULSE_ENGINE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "repeated-chord pulse engine: Vn2+Va reiterate the chord in even 8ths (short, lifted), the pulse rises register-to-register (Va alone -> +Vn2 8ve -> +Vn1 peak -> thins) under a horn tune; cello drives 8th-note bass, Cb strong-beat root floor; the motor, not a pad; Allegro"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mf} A4 D5 | F5 E5 D5 | Bb4{mf} A4 G4 | Bb4 A4 G4 | A4{f} C5 E5 A4 | C#5 E5 G5 | F5{f} E5 D5 | D5 A4"
        rhythm_bars "1 1/2 1/2 | 1 1/2 1/2 | 1 1/2 1/2 | 1 1/2 1/2 | 3/4 1/4 1/2 1/2 | 1 1/2 1/2 | 1 1/2 1/2 | 3/2 1/2"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | [A4,E5]{f} [A4,E5] [A4,E5] [A4,E5] | [A4,E5]{f} [A4,E5] [A4,E5] [A4,E5] | r | r"
        rhythm_bars "2 | 2 | 2 | 2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 2 | 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | [D4,G4]{mp} [D4,G4] [D4,G4] [D4,G4] | [D4,G4]{mp} [D4,G4] [D4,G4] [D4,G4] | [E4,A4]{f} [E4,A4] [E4,A4] [E4,A4] | [E4,A4]{f} [E4,A4] [E4,A4] [E4,A4] | [D4,A4]{mf} [D4,A4] [D4,A4] [D4,A4] | [D4,A4] [D4,A4] [D4,A4] [D4,A4]"
        rhythm_bars "2 | 2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "[F3,A3]{mp} [F3,A3] [F3,A3] [F3,A3] | [F3,A3]{mp} [F3,A3] [F3,A3] [F3,A3] | [G3,Bb3]{mf} [G3,Bb3] [G3,Bb3] [G3,Bb3] | [G3,Bb3]{mf} [G3,Bb3] [G3,Bb3] [G3,Bb3] | [C#4,E4]{f} [C#4,E4] [C#4,E4] [C#4,E4] | [C#4,E4]{f} [C#4,E4] [C#4,E4] [C#4,E4] | [F3,A3]{mf} [F3,A3] [F3,A3] [F3,A3] | [F3,A3]{mf} [F3,A3] [F3,A3] [F3,A3]"
        rhythm_bars "1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{mp} -5 +5 +3 | -3 -5 +5 -2 | -2{mf} +4 +5 -5 | -7 +7 -4 -1 | 0{f} +7 -7 +4 | +3 -3 -4 -5 | +10{f} -5 +5 +3 | -3 -5 -7 +7"
        rhythm    "1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mp} A1 | D2 A1 | G1{mf} D2 | G1 D2 | A1{f} E2 | A1 E2 | D2{f} A1 | D2 D2"
        rhythm_bars "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
