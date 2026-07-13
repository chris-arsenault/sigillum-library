production_piece "Technique Card CT7_HURRYUP_TRANSFORM - CT7_HURRYUP_TRANSFORM" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 120", at: "bar 1 beat 1"
    change "quarter = 168", at: "bar 5 beat 1"
  end

# category: chip
# card: CT7_HURRYUP_TRANSFORM
# cite: chiptune_research:hurry_up_variant (docs/research/chiptune_nes_composition.md)
# behavior: NES danger-state practice: bars 1-4 state the calm theme, bars 5-8 are the SAME
#   theme as a discrete hurry-up variant (SMB time warning, Tetris) - tempo up 40 percent,
#   3rds and 6ths flattened to minor, subdivision doubled to repeated eighths, noise enters

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - theme, then its danger variant"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - pad, then invariant stab cell"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - halves, then driving eighths"
    part :noise, "Noise", music21: "Percussion", family: :percussion, description: "NES noise channel - silent until danger"
  end

  section :card, "CT7_HURRYUP_TRANSFORM", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "NES danger-state practice: bars 1-4 state the calm theme, bars 5-8 are the SAME theme as a discrete hurry-up variant (SMB time warning, Tetris) - tempo up 40 percent, 3rds and 6ths flattened to minor, subdivision doubled to repeated eighths, noise enters"

      phrase :theme_then_danger, surface: :split_pitch_rhythm do
        pitch_bars  "C5{mp,txt:pulse1_-_calm_theme} E5 G5 E5 | A5 G5 E5 | F5 A5 G5 E5 | D5 C5 | C5{f,txt:same_theme_minor_faster_doubled} C5 Eb5 Eb5 G5 G5 Eb5 Eb5 | Ab5 Ab5 G5 G5 G5 G5 Eb5 Eb5 | F5 F5 Ab5 Ab5 G5 G5 Eb5 Eb5 | D5 D5 C5 C5 C5 C5 B4 B4"
        rhythm_bars "1 1 1 1 | 1 2 1 | 1 1 1 1 | 1 3 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :theme_then_danger, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :pad_then_stabs, surface: :split_pitch_rhythm do
        pitch_bars  "E4{p,txt:pulse2_-_gentle_pad_under_the_calm_theme} B4 | C5 B4 | A4 B4 | F4 E4 | Eb4{mf,txt:stab_cell_under_danger} Eb4 r Eb4 Eb4 r | Eb4 Eb4 r Eb4 Eb4 r | F4 F4 r F4 F4 r | D4 D4 r D4 D4 r"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1"
      end

      placement :pad_then_stabs, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :floor_then_drive, surface: :split_pitch_rhythm do
        pitch_bars  "C3{mp,txt:triangle_-_halves_then_driving_eighths} C3 | A2 A2 | F2 F2 | G2 G2 | C3{f} C3 C3 C3 C3 C3 C3 C3 | Ab2 Ab2 Ab2 Ab2 Ab2 Ab2 Ab2 Ab2 | F2 F2 F2 F2 F2 F2 F2 F2 | G2 G2 G2 G2 G2 G2 B2 B2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :floor_then_drive, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :noise_enters, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:noise_-_silent_until_danger} | r | r | r | C2{mf,txt:kick_hat_snare_hat_drive} F#2 D2 F#2 C2 F#2 D2 F#2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | D2 D2 D2 D2 D2 D2 A#2 A#2"
        rhythm_bars "4 | 4 | 4 | 4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :noise_enters, part: :noise, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
