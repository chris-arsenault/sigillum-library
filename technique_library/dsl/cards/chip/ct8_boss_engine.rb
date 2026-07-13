production_piece "Technique Card CT8_BOSS_ENGINE - CT8_BOSS_ENGINE" do
  meter "4/4"
  key "A minor"

  tempo do
    mark "quarter = 160", at: "bar 1 beat 1"
  end

# category: chip
# card: CT8_BOSS_ENGINE
# cite: chiptune_research:boss_loop (docs/research/chiptune_nes_composition.md)
# behavior: boss-loop archetype (Mega Man 2 Wily-stage school): short hectic loop built from an
#   invariant driving triangle ostinato, an unchanging pulse 2 riff cell as the rhythmic
#   subject, a roller-coaster pulse 1 lead with wide leaps and a chromatic turnaround, and
#   relentless eighth-note noise with fills at the seams

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - roller-coaster lead"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - invariant riff cell"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - driving ostinato"
    part :noise, "Noise", music21: "Percussion", family: :percussion, description: "NES noise channel - relentless drive"
  end

  section :card, "CT8_BOSS_ENGINE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "boss-loop archetype (Mega Man 2 Wily-stage school): short hectic loop built from an invariant driving triangle ostinato, an unchanging pulse 2 riff cell as the rhythmic subject, a roller-coaster pulse 1 lead with wide leaps and a chromatic turnaround, and relentless eighth-note noise with fills at the seams"

      phrase :coaster_lead, surface: :split_pitch_rhythm do
        pitch_bars  "A4{f,txt:pulse1_-_roller-coaster_lead} B4 C5 D5 E5 D5 C5 B4 | A4 C5 E5 A5 E5 C5 A4 E4 | F5 E5 D5 C5 B4 C5 D5 B4 | G4 B4 D5 F5 D5 B4 G4 B4 | A4 B4 C5 D5 E5 F5 G5 A5 | A5 E5 C6 A5 G5 E5 D5 B4 | C5 E5 D5 F5 E5 G5 F5 D5 | E5 D#5 D5 C5 B4 A4 G#4 B4"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :coaster_lead, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :riff_cell, surface: :split_pitch_rhythm do
        pitch_bars  "A3{mf,txt:pulse2_-_INVARIANT_riff_cell_-_rhythm_is_the_subject} A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4 | A3 A3 r A3 r A3 C4 D4"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :riff_cell, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :ostinato_floor, surface: :split_pitch_rhythm do
        pitch_bars  "A2{f,txt:triangle_-_driving_ostinato} A2 E3 A2 A2 E3 A2 E3 | A2 A2 E3 A2 A2 E3 A2 E3 | F2 F2 C3 F2 F2 C3 F2 C3 | G2 G2 D3 G2 G2 D3 G2 D3 | A2 A2 E3 A2 A2 E3 A2 E3 | A2 A2 E3 A2 A2 E3 A2 E3 | F2 F2 C3 F2 G2 G2 D3 G2 | E2 E2 B2 E2 E2 B2 G#2 B2"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :ostinato_floor, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :drive_kit, surface: :split_pitch_rhythm do
        pitch_bars  "C2{f,txt:noise_-_relentless_drive} F#2 D2 F#2 C2 F#2 D2 F#2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | D2 D2 D2 D2 A#2 A#2 D2 D2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | C2 F#2 D2 F#2 C2 F#2 D2 F#2 | D2 D2 D2 D2 D2 D2 A#2 A#2"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :drive_kit, part: :noise, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
