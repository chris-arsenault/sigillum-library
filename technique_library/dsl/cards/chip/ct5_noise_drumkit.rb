production_piece "Technique Card CT5_NOISE_DRUMKIT - CT5_NOISE_DRUMKIT" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 140", at: "bar 1 beat 1"
  end

# category: chip
# card: CT5_NOISE_DRUMKIT
# cite: chiptune_research:noise_kit (docs/research/chiptune_nes_composition.md)
# behavior: one noise channel plays the whole kit: kick C2, backbeat snare D2, closed hat F#2,
#   open hat A#2; a fill every fourth bar articulates the loop seam; triangle locks the kick
#   and pulse 1 drops sparse off-beat stabs to show the kit sitting under music

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - sparse off-beat stabs"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - kick-locked roots"
    part :noise, "Noise", music21: "Percussion", family: :percussion, description: "NES noise channel - the whole drum kit"
  end

  section :card, "CT5_NOISE_DRUMKIT", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "one noise channel plays the whole kit: kick C2, backbeat snare D2, closed hat F#2, open hat A#2; a fill every fourth bar articulates the loop seam; triangle locks the kick and pulse 1 drops sparse off-beat stabs to show the kit sitting under music"

      phrase :kit_engine, surface: :split_pitch_rhythm do
        pitch_bars  "C2{mf,txt:noise_kit_-_kick_hat_snare_hat} F#2 D2 F#2 C2 C2 D2 F#2 | C2 F#2 D2 F#2 C2 C2 D2 F#2 | C2 F#2 D2 F#2 C2 C2 D2 F#2 | D2{txt:fill_every_fourth_bar} D2 D2 D2 D2 D2 D2 A#2 | C2 A#2{txt:open_hat_variation} D2 F#2 C2 C2 D2 A#2 | C2 F#2 D2 F#2 C2 C2 D2 F#2 | C2 F#2 D2 F#2 C2 C2 D2 F#2 | C2 C2 D2 D2 D2 D2 A#2 A#2"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :kit_engine, part: :noise, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :kick_lock, surface: :split_pitch_rhythm do
        pitch_bars  "C2{mp,txt:triangle_-_locks_the_kick} r C2 r | C2 r C2 r | C2 r C2 r | C2 r C2 r | C2 r C2 r | C2 r C2 r | C2 r C2 r | G2 r G2 r"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :kick_lock, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :offbeat_stabs, surface: :split_pitch_rhythm do
        pitch_bars  "r C5{mp,txt:pulse1_-_off-beat_stabs_show_the_kit_under_music} r r E5 r | r C5 r r E5 r | r E5 r r G5 r | r | r C5 r r E5 r | r E5 r r G5 r | r G5 r r E5 r | r"
        rhythm_bars "1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 4 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 4"
      end

      placement :offbeat_stabs, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
