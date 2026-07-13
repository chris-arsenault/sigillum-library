production_piece "Technique Card CT4_TRIANGLE_BASS_DRUM - CT4_TRIANGLE_BASS_DRUM" do
  meter "4/4"
  key "E minor"

  tempo do
    mark "quarter = 138", at: "bar 1 beat 1"
  end

# category: chip
# card: CT4_TRIANGLE_BASS_DRUM
# cite: chiptune_research:triangle_dual_duty (docs/research/chiptune_nes_composition.md)
# behavior: triangle dual duty (Follin, Silver Surfer): the triangle walks an octave-pop bass
#   and interleaves short low C2 drops that read as kick/tom hits, so bass and drums share one
#   channel; noise keeps hats and backbeat, and the idle pulse 2 doubles the bass an octave up

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - riff lead"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - idle, doubles the bass an octave up"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - bass AND kick drops"
    part :noise, "Noise", music21: "Percussion", family: :percussion, description: "NES noise channel - hats and backbeat"
  end

  section :card, "CT4_TRIANGLE_BASS_DRUM", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "triangle dual duty (Follin, Silver Surfer): the triangle walks an octave-pop bass and interleaves short low C2 drops that read as kick/tom hits, so bass and drums share one channel; noise keeps hats and backbeat, and the idle pulse 2 doubles the bass an octave up"

      phrase :bass_and_kick, surface: :split_pitch_rhythm do
        pitch_bars  "E2{f,txt:triangle_-_bass_walk_with_C2_kick_drops} E3 C2{txt:kick_drop} E2 E2 E3 C2 E2 | E2 E3 C2 E2 E2 E3 C2 E2 | G2 G3 C2 G2 G2 G3 C2 G2 | A2 A3 C2 A2 A2 A3 C2 A2 | E2 E3 C2 E2 E2 E3 C2 E2 | G2 G3 C2 G2 G2 G3 C2 G2 | C3 C4 C2 C3 C3 C4 C2 C3 | A2 A3 C2 A2 B2 B3 C2 B2"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :bass_and_kick, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :noise_kit, surface: :split_pitch_rhythm do
        pitch_bars  "F#2{mp,txt:noise_-_hats_plus_backbeat_snare} F#2 D2 F#2 F#2 F#2 D2 F#2 | F#2 F#2 D2 F#2 F#2 F#2 D2 F#2 | F#2 F#2 D2 F#2 F#2 F#2 D2 F#2 | F#2 F#2 D2 F#2 F#2 F#2 D2 F#2 | F#2 F#2 D2 F#2 F#2 F#2 D2 F#2 | F#2 F#2 D2 F#2 F#2 F#2 D2 F#2 | F#2 F#2 D2 F#2 F#2 F#2 D2 F#2 | D2 F#2 D2 D2 F#2 D2 D2 A#2"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :noise_kit, part: :noise, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :riff_lead, surface: :split_pitch_rhythm do
        pitch_bars  "E4{mf,txt:pulse1_-_pentatonic_riff_over_the_engine} G4 A4 B4 A4 G4 | E4 G4 A4 G4 E4 D4 | G4 B4 D5 B4 A4 G4 | A4 C5 E5 D5 C5 A4 | E4 G4 A4 B4 A4 G4 | G4 B4 D5 B4 A4 G4 | C5 E5 G5 E5 D5 C5 | B4 A4 G4 F#4 G4 B4"
        rhythm_bars "1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1"
      end

      placement :riff_lead, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_double, surface: :split_pitch_rhythm do
        pitch_bars  "E3{p,txt:pulse2_idle_-_doubles_bass_an_octave_up_for_thickness} | E3 | G3 | A3 | E3 | G3 | C4 | B3"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bass_double, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
