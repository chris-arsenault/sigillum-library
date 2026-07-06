production_piece "Technique Card OA4_CORI_SPEZZATI - OA4_CORI_SPEZZATI" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 92", at: "bar 1 beat 1"
  end

# category: orch.antiphony
# card: OA4_CORI_SPEZZATI
# cite: orchestration_techniques:antiphony
# behavior: Venetian cori spezzati: two complete spatially-separated choirs (each
#   Tpt+Hn+Tbn+Vln+Vc with its own harmony+bass) trade phrases across the hall - Coro I near (f)
#   states, Coro II distant echoes echo-soft (p), Coro I returns extended, both COMBINE for the
#   cadence (b7-8); distant group terraced softer for depth; Maestoso

  roster do
    part :coro_i_trumpet, "Coro I Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :coro_i_horn, "Coro I Horn", music21: "Horn", family: :brass, description: "Horn"
    part :coro_i_trombone, "Coro I Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :coro_i_violin, "Coro I Violin", music21: "Violin", family: :string, description: "Violin"
    part :coro_i_cello, "Coro I Cello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :coro_ii_trumpet_distant, "Coro II Trumpet (distant)", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :coro_ii_horn_distant, "Coro II Horn (distant)", music21: "Horn", family: :brass, description: "Horn"
    part :coro_ii_trombone_distant, "Coro II Trombone (distant)", music21: "Trombone", family: :brass, description: "Trombone"
    part :coro_ii_violin_distant, "Coro II Violin (distant)", music21: "Violin", family: :string, description: "Violin"
    part :coro_ii_cello_distant, "Coro II Cello (distant)", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "OA4_CORI_SPEZZATI", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "Venetian cori spezzati: two complete spatially-separated choirs (each Tpt+Hn+Tbn+Vln+Vc with its own harmony+bass) trade phrases across the hall - Coro I near (f) states, Coro II distant echoes echo-soft (p), Coro I returns extended, both COMBINE for the cadence (b7-8); distant group terraced softer for depth; Maestoso"

      phrase :coro_i_trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{f} E5 E5 D5 C5 | B4 B4 C5 B4 | r | A4{f} C5 B4 C5 A4 | F5 E5 D5 C5 B4 | A4{f} F4 G4 | G4 B4 C5 B4"
        rhythm_bars "1 1 1/2 1/2 1 | 1 1 1 1 | 8 | 1 1 1/2 1/2 1 | 1 1 1/2 1/2 1 | 1 1 2 | 1 1 1 1"
      end

      placement :coro_i_trumpet_line, part: :coro_i_trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_i_horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{f} G4 G4 G4 | G4 G4 G4 G4 | r | F4{f} F4 F4 | C5 C5 A4 G4 | F4{f} A4 G4 | D4 D4 E4 D4"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 8 | 1 1 2 | 1 1 1 1 | 1 1 2 | 1 1 1 1"
      end

      placement :coro_i_horn_line, part: :coro_i_horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_i_trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{f} C4 E4 C4 | G3 G3 G3 | r | F3{f} F3 | A3 G3 | F3{f} D4 C4 | B3 B3 C4"
        rhythm_bars "1 1 1 1 | 2 1 1 | 8 | 2 2 | 2 2 | 1 1 2 | 1 1 2"
      end

      placement :coro_i_trombone_line, part: :coro_i_trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_i_violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{f,txt:Coro_I} G5 G5 F5 E5 | D5 D5 E5 D5 | r | F5{f} E5 D5 E5 F5 | A5 G5 F5 E5 D5 | C5{f} D5 E5 | D5 G5 G5 G5"
        rhythm_bars "1 1 1/2 1/2 1 | 1 1 1 1 | 8 | 1 1 1/2 1/2 1 | 1 1 1/2 1/2 1 | 1 1 2 | 1 1 1 1"
      end

      placement :coro_i_violin_line, part: :coro_i_violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_i_cello_line, pitch: :intervals do
        anchor "C3"
        intervals "0{f} 0 +4 | -9 0 | r | -2{f} +4 | -4 +2 | -2{f} 0 +7 | -5 +5"
        rhythm    "2 1 1 | 2 2 | 8 | 2 2 | 2 2 | 1 1 2 | 2 2"
      end

      placement :coro_i_cello_line, part: :coro_i_cello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :coro_ii_trumpet_distant_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | G4{p,txt:Coro_II_distant} B4 B4 A4 G4 | F4 F4 G4 G4 | r | A4{mp} C5 B4 C5 A4 | G4 F4 F4 G4"
        rhythm_bars "8 | 1 1 1/2 1/2 1 | 1 1 1 1 | 8 | 1 1 1/2 1/2 1 | 1 1 1 1"
      end

      placement :coro_ii_trumpet_distant_line, part: :coro_ii_trumpet_distant, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_ii_horn_distant_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D4{p} D4 D4 D4 | C4 C4 D4 E4 | r | F4{mp} F4 F4 | C4 B3 C4"
        rhythm_bars "8 | 1 1 1 1 | 1 1 1 1 | 8 | 1 1 2 | 1 1 2"
      end

      placement :coro_ii_horn_distant_line, part: :coro_ii_horn_distant, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_ii_trombone_distant_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | G3{p} G3 G3 | F3 E3 D3 E3 | r | F3{mp} F3 | G3 G3 G3"
        rhythm_bars "8 | 2 1 1 | 1 1 1 1 | 8 | 2 2 | 1 1 2"
      end

      placement :coro_ii_trombone_distant_line, part: :coro_ii_trombone_distant, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_ii_violin_distant_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | B4{p,txt:Coro_II_(distant)} D5 D5 C5 B4 | A4 A4 B4 C5 | r | F5{mp} E5 D5 E5 F5 | E5 D5 D5 E5"
        rhythm_bars "8 | 1 1 1/2 1/2 1 | 1 1 1 1 | 8 | 1 1 1/2 1/2 1 | 1 1 1 1"
      end

      placement :coro_ii_violin_distant_line, part: :coro_ii_violin_distant, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :coro_ii_cello_distant_line, pitch: :intervals do
        anchor "G2"
        intervals "r | 0{p} 0 | +5 0 | r | -7{mp} +4 | -2 +5"
        rhythm    "8 | 2 2 | 2 2 | 8 | 2 2 | 2 2"
      end

      placement :coro_ii_cello_distant_line, part: :coro_ii_cello_distant, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
