production_piece "Technique Card OB6_CUIVRE - OB6_CUIVRE" do
  meter "4/4"
  key "e"

  tempo do
    mark "quarter = 138", at: "bar 1 beat 1"
  end

# category: orch.brass
# card: OB6_CUIVRE
# cite: orchestration_techniques:brass
# behavior: brass-choir build (i-VI-VII) ignites a cuivre blare at the climax (tpts+horns ff,
#   octaves), a stopped-horn (+) snarling off-beat stinger, then resolves naturale onto a fff
#   open E tonic; tuba open floor - quality-not-quantity edge

  roster do
    part :trumpet_1, "Trumpet 1", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trumpet_2, "Trumpet 2", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn_1, "Horn 1", music21: "Horn", family: :brass, description: "Horn"
    part :horn_2, "Horn 2", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
  end

  section :card, "OB6_CUIVRE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "brass-choir build (i-VI-VII) ignites a cuivre blare at the climax (tpts+horns ff, octaves), a stopped-horn (+) snarling off-beat stinger, then resolves naturale onto a fff open E tonic; tuba open floor - quality-not-quantity edge"

      phrase :trumpet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "B4{mf,marc} E5 G5 B5 | C6{f,marc} B5 G5 E5 | D5{marc} F#5 A5 D6 | D6{ff,marc,txt:cuivre} E6{marc} | F#6{ff,marc,txt:stopped_+} r F#6{marc} r | E6{fff,marc,txt:naturale}"
        rhythm_bars "1 1 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 2 2 | 1 1/2 3/2 1 | 4"
      end

      placement :trumpet_1_line, part: :trumpet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{mf,marc} B4 E5 G5 | E5{f,marc} G5 E5 C5 | A4{marc} D5 F#5 A5 | A5{ff,marc,txt:cuivre} B5{marc} | D6{ff,marc,txt:stopped_+} r D6{marc} r | B5{fff,marc,txt:naturale}"
        rhythm_bars "1 1 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 2 2 | 1 1/2 3/2 1 | 4"
      end

      placement :trumpet_2_line, part: :trumpet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "E4{mf} G4 | C5{f} E5 | D5{cresc(} F#5{cresc)} | D5{ff,marc,txt:cuivre} E5{marc} | F#5{ff,marc,txt:stopped_+} r F#5{marc} r | E5{fff,marc,txt:naturale}"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 1 1/2 3/2 1 | 4"
      end

      placement :horn_1_line, part: :horn_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "B3{mf} E4 | G4{f} C5 | A4{cresc(} D5{cresc)} | A4{ff,marc,txt:cuivre} B4{marc} | D5{ff,marc,txt:stopped_+} r D5{marc} r | G4{fff,marc,txt:naturale}"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 1 1/2 3/2 1 | 4"
      end

      placement :horn_2_line, part: :horn_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "E3{mf,marc} E3{marc} | C3{f,marc} C3{marc} | D3{cresc(,marc} D3{cresc),marc} | D3{ff,marc} D3{marc} | B2{ff,marc} r B2{marc} r | E3{fff,marc}"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 1 1/2 3/2 1 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tuba_line, surface: :split_pitch_rhythm do
        pitch_bars  "E1{f} | C1 | D1{cresc(} | D1{ff,cresc)} | B1 r B1 | E1{fff}"
        rhythm_bars "4 | 4 | 4 | 4 | 2 1/2 3/2 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
