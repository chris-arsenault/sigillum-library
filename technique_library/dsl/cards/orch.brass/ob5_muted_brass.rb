production_piece "Technique Card OB5_MUTED_BRASS - OB5_MUTED_BRASS" do
  meter "4/4"
  key "c"

  tempo do
    mark "quarter = 63", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB5_MUTED_BRASS
# cite: orchestration_techniques:brass
# behavior: muted brass two-face: pp cup-muted minor/tritone-laced veiled chorale (distant,
#   eerie) that crescendos, then via cup->straight mutes for an ff/fff syncopated off-beat
#   snarling stab figure (menace)

  roster do
    part :trumpet_1, "Trumpet 1", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_2, "Trumpet 2", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_3, "Trumpet 3", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone_1, "Trombone 1", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_2, "Trombone 2", music21: "Trombone", family: :brass, description: "Trombone"
    part :trombone_3, "Trombone 3", music21: "Trombone", family: :brass, description: "Trombone"
  end

  section :card, "OB5_MUTED_BRASS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "muted brass two-face: pp cup-muted minor/tritone-laced veiled chorale (distant, eerie) that crescendos, then via cup->straight mutes for an ff/fff syncopated off-beat snarling stab figure (menace)"

      phrase :trumpet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb5{pp,txt:con_sord._(cup)} | Eb5 | E5{cresc(} | F#5{mf} | r{txt:via_cup_con_sord._(straight)} F#5{ff,marc,stacc,cresc)} r G5{marc,stacc} r | r F#5{marc,stacc} r A5{marc,stacc} r | r G5{marc,stacc} r G5{marc,stacc} r F#5{marc,stacc} r | F#5{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 3/2 | 1 1/2 1 1/2 1 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 3"
      end

      placement :trumpet_1_line, part: :trumpet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb4{pp,txt:con_sord._(cup)} | Bb4 | B4{cresc(} | C#5{mf} | r{txt:via_cup_con_sord._(straight)} C#5{ff,marc,stacc,cresc)} r D5{marc,stacc} r | r C#5{marc,stacc} r E5{marc,stacc} r | r D5{marc,stacc} r D5{marc,stacc} r C#5{marc,stacc} r | C#5{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 3/2 | 1 1/2 1 1/2 1 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 3"
      end

      placement :trumpet_2_line, part: :trumpet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{pp,txt:con_sord._(cup)} | G4 | Ab4{cresc(} | A4{mf} | r{txt:via_cup_con_sord._(straight)} A4{ff,marc,stacc,cresc)} r Bb4{marc,stacc} r | r A4{marc,stacc} r C5{marc,stacc} r | r Bb4{marc,stacc} r Bb4{marc,stacc} r A4{marc,stacc} r | A4{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 3/2 | 1 1/2 1 1/2 1 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 3"
      end

      placement :trumpet_3_line, part: :trumpet_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb4{pp,txt:con_sord._(cup)} | Eb4 | E4{cresc(} | F#4{mf} | r{txt:via_cup_con_sord._(straight)} F#4{ff,marc,stacc,cresc)} r G4{marc,stacc} r | r F#4{marc,stacc} r A4{marc,stacc} r | r G4{marc,stacc} r G4{marc,stacc} r F#4{marc,stacc} r | F#4{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 3/2 | 1 1/2 1 1/2 1 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 3"
      end

      placement :trombone_1_line, part: :trombone_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "Bb3{pp,txt:con_sord._(cup)} | Bb3 | B3{cresc(} | C#4{mf} | r{txt:via_cup_con_sord._(straight)} C#4{ff,marc,stacc,cresc)} r D4{marc,stacc} r | r C#4{marc,stacc} r E4{marc,stacc} r | r D4{marc,stacc} r D4{marc,stacc} r C#4{marc,stacc} r | C#4{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 3/2 | 1 1/2 1 1/2 1 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 3"
      end

      placement :trombone_2_line, part: :trombone_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_3_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb3{pp,txt:con_sord._(cup)} | Eb3 | E3{cresc(} | F#3{mf} | r{txt:via_cup_con_sord._(straight)} F#3{ff,marc,stacc,cresc)} r G3{marc,stacc} r | r F#3{marc,stacc} r A3{marc,stacc} r | r G3{marc,stacc} r G3{marc,stacc} r F#3{marc,stacc} r | F#3{fff,marc} r"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1 1/2 3/2 | 1 1/2 1 1/2 1 | 1/2 1/2 1/2 1/2 1 1/2 1/2 | 1 3"
      end

      placement :trombone_3_line, part: :trombone_3, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
