production_piece "Technique Card OPC3_CLIMAX_STACK - OPC3_CLIMAX_STACK" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC3_CLIMAX_STACK
# cite: orchestration_techniques:percussion_choir
# behavior: cym/B.D./tam-tam withheld for the whole 6-bar crescendo + the held-back V7 bar; all
#   three detonate ONCE together fff on the b8 tonic downbeat (the saved crash), then cut while
#   tam-tam rings l.v.

  roster do
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :cymbals, "Cymbals", music21: "Percussion", family: :other, description: "Percussion"
    part :bass_drum, "Bass Drum", music21: "Percussion", family: :other, description: "Percussion"
    part :tam_tam, "Tam-tam", music21: "Percussion", family: :other, description: "Percussion"
  end

  section :card, "OPC3_CLIMAX_STACK", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "cym/B.D./tam-tam withheld for the whole 6-bar crescendo + the held-back V7 bar; all three detonate ONCE together fff on the b8 tonic downbeat (the saved crash), then cut while tam-tam rings l.v."

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mp,txt:build_on_the_dominant} A4 | A4{mf} B4 A4 | A4{f,cresc(} C#5 A4 | B4 C#5 | D5 C#5 D5 | E5{ff} E5{cresc)} | [A4,C#5,E5]{ff,txt:held-back_bar_-_dominant_NO_heavy_perc} | [D5,F#5,A5]{fff,marc,txt:ARRIVAL_-_tonic_apex} D5{txt:dim,txt:decay} r"
        rhythm_bars "2 2 | 2 1 1 | 2 1 1 | 2 2 | 2 1 1 | 2 2 | 4 | 1 1 2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "[A2,E3]{mp} | [A2,E3]{mf} | [A2,E3,A3]{f,cresc(} | [A2,C#3,E3] | [A2,C#3,E3] | [A2,C#3,E3]{ff,cresc)} | [A2,C#3,E3,G3]{ff} | [D2,A2,D3]{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{p,trem,txt:tremolo_cresc.} | A5{mp,trem} | B5{mf,trem,cresc(} | C#6{trem} | D6{trem} | E6{ff,trem,cresc)} | E6{ff,trem} | F#6{fff,marc} D6{txt:dim} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 1 1 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{mp} | 0{mf} | 0{f,cresc(} | 0 | 0 | 0{ff,cresc)} | 0{ff} | -7{fff,marc} r"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{p,txt:timp_D+A_dominant_cell} A2 A2 | A2{mp} A2 A2 | A2{mf} A2 A2 A2 | A2 A2 A2 A2 A2 A2 | A2 A2 A2 A2 A2 A2 A2 A2 | A2{f,trem,txt:roll_cresc._al_ff,cresc(} A2{trem} | A2{ff,trem,cresc)} | D2{fff,marc,txt:tonic_stroke_then_cut} r"
        rhythm_bars "2 1 1 | 2 1 1 | 2 1/2 1/2 1 | 1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 2 2 | 4 | 1 3"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :cymbals_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:tacet_-_RESERVED} | r | r | r | r | r | r{txt:still_tacet_-_the_held-back_bar} | A4{fff,marc,txt:crash_cymbals_-_FIRST_entrance_secco} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :cymbals_line, part: :cymbals, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_drum_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:tacet_-_RESERVED} | r | r | r | r | r | r | C2{fff,txt:bass_drum_-_FIRST_entrance_felt_beater} r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 1 3"
      end

      placement :bass_drum_line, part: :bass_drum, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tam_tam_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:tacet_-_RESERVED} | r | r | r | r | r | r | A1{fff,txt:tam-tam_-_FIRST_entrance_soft_heavy_beater_l.v._ring_through}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tam_tam_line, part: :tam_tam, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
