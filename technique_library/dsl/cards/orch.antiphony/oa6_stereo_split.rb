production_piece "Technique Card OA6_STEREO_SPLIT - OA6_STEREO_SPLIT" do
  meter "2/4"
  key "D"

  tempo do
    mark "quarter = 152", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA6_STEREO_SPLIT
# cite: orchestration_techniques:antiphony
# behavior: L/R like-instrument pairing for stereo width (Vn I left / Vn II right, paired winds
#   Fl-Ob-Ob2 left vs Cl right): a bright D-major figure tossed side-to-side - bar-to-bar,
#   tightening to beat-to-beat L-R-L-R, then a rising scale handed L->R across the stage,
#   converging center on a unison V-I; the toss is rhythmic not dynamic; center floor in
#   Vc/Cb/Bsn/Va; Allegro vivace

  roster do
    part :violin_i_left, "Violin I (left)", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii_right, "Violin II (right)", music21: "Violin", family: :string, description: "Violin"
    part :flute_left, "Flute (left)", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe_1_left, "Oboe 1 (left)", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :oboe_2_left, "Oboe 2 (left)", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet_right, "Clarinet (right)", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :viola_center, "Viola (center)", music21: "Viola", family: :string, description: "Viola"
    part :violoncello_center, "Violoncello (center)", music21: "Violoncello", family: :string, description: "Violoncello"
    part :bassoon_center, "Bassoon (center)", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :contrabass_center, "Contrabass (center)", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OA6_STEREO_SPLIT", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "L/R like-instrument pairing for stereo width (Vn I left / Vn II right, paired winds Fl-Ob-Ob2 left vs Cl right): a bright D-major figure tossed side-to-side - bar-to-bar, tightening to beat-to-beat L-R-L-R, then a rising scale handed L->R across the stage, converging center on a unison V-I; the toss is rhythmic not dynamic; center floor in Vc/Cb/Bsn/Va; Allegro vivace"

      phrase :violin_i_left_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{f} E5 F#5 G5 | r | A5{f} G5 F#5 E5 r | F#5{f} E5 D5 C#5 r | D5{f} E5 F#5 G5 r | D5{ff} D5"
        rhythm_bars "1/2 1/2 1/2 1/2 | 2 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1 1"
      end

      placement :violin_i_left_line, part: :violin_i_left, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_right_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D5{f} E5 F#5 G5 | r A5{f} G5 F#5 E5 | r F#5{f} E5 D5 C#5 | r A5{f} B5 C#6 D6 | D5{ff} D5"
        rhythm_bars "2 | 1/2 1/2 1/2 1/2 | 1 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 1/4 | 1 1"
      end

      placement :violin_ii_right_line, part: :violin_ii_right, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_left_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | A5{f} G5 F#5 E5 r | F#5{f} E5 D5 C#5 r | D6{f} E6 F#6 G6 r | D6{ff} D6"
        rhythm_bars "4 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1 1"
      end

      placement :flute_left_line, part: :flute_left, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_1_left_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | F#5{f} E5 D5 C#5 r | D5{f} C#5 B4 A4 r | F#5{f} G5 A5 B5 r | F#5{ff} F#5"
        rhythm_bars "4 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1 1"
      end

      placement :oboe_1_left_line, part: :oboe_1_left, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_2_left_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D5{f} C#5 B4 A4 r | B4{f} A4 G4 F#4 r | D5{f} E5 F#5 G5 r | D5{ff} D5"
        rhythm_bars "4 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1/4 1/4 1/4 1/4 1 | 1 1"
      end

      placement :oboe_2_left_line, part: :oboe_2_left, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_right_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r A5{f} G5 F#5 E5 | r F#5{f} E5 D5 C#5 | r A5{f} B5 C#6 D6 | A4{ff} A4"
        rhythm_bars "4 | 1 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 1/4 | 1 1/4 1/4 1/4 1/4 | 1 1"
      end

      placement :clarinet_right_line, part: :clarinet_right, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_center_line, surface: :split_pitch_rhythm do
        pitch_bars  "[F#3,A3]{mf} [F#3,A3] [F#3,A3] [F#3,A3] | [F#3,A3]{mf} [F#3,A3] [F#3,A3] [F#3,A3] | [E3,A3]{mf} [E3,A3] [E3,A3] [E3,A3] | [E3,A3]{mf} [E3,A3] [E3,A3] [E3,A3] | [E3,G3]{mf} [E3,G3] [E3,A3] [E3,A3] | [F#3,A3]{ff} [F#3,A3]"
        rhythm_bars "1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1 1"
      end

      placement :viola_center_line, part: :viola_center, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_center_line, pitch: :intervals do
        anchor "D3"
        intervals "0{mf} 0 | 0 -5 | 0{mf} 0 | 0 +7 | -7{mf} 0 | +5{ff} 0"
        rhythm    "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :violoncello_center_line, part: :violoncello_center, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :bassoon_center_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mf} F#3 | D3 E3 | E3{mf} E3 | E3 E3 | E3{mf} E3 | D3{ff} A2"
        rhythm_bars "1 1 | 1 1 | 1 1 | 1 1 | 1 1 | 1 1"
      end

      placement :bassoon_center_line, part: :bassoon_center, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :contrabass_center_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{mf} | D2 | A1{mf} | A1 | A1{mf} | D2{ff}"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2"
      end

      placement :contrabass_center_line, part: :contrabass_center, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
