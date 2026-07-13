production_piece "Technique Card CT1_PULSE_ECHO_LEAD - CT1_PULSE_ECHO_LEAD" do
  meter "4/4"
  key "A minor"

  tempo do
    mark "quarter = 120", at: "bar 1 beat 1"
  end

# category: chip
# card: CT1_PULSE_ECHO_LEAD
# cite: chiptune_research:pulse_echo (docs/research/chiptune_nes_composition.md)
# behavior: Follin-style pulse echo: pulse 2 restates pulse 1's lead delayed by one beat and one
#   dynamic softer, faking delay/reverb on hardware that has none; triangle keeps a plain
#   root-fifth bass so the echo pair stays legible

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - square lead"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - echo of the lead"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - bass"
  end

  section :card, "CT1_PULSE_ECHO_LEAD", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "Follin-style pulse echo: pulse 2 restates pulse 1's lead delayed by one beat and one dynamic softer, faking delay/reverb on hardware that has none; triangle keeps a plain root-fifth bass so the echo pair stays legible"

      phrase :lead_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{mf,txt:pulse1_lead_-_the_dry_signal} C5 E5 D5 C5 B4 | G4 B4 D5 C5 B4 A4 | A4 C5 E5 D5 C5 B4 | E5 D5 C5 B4 C5 A4 | C5{f} E5 G5 F5 E5 D5 | B4 D5 F5 E5 D5 C5 | E5 C5 A4 B4 C5 D5 | C5{mf} B4 A4 r"
        rhythm_bars "1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 2 1"
      end

      placement :lead_line, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :echo_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:pulse2_-_same_stream_one_beat_late_one_dynamic_softer} A4{mp} C5 E5 D5 C5 | B4 G4 B4 D5 C5 B4 | A4 A4 C5 E5 D5 C5 | B4 E5 D5 C5 B4 C5 | A4 C5{mf} E5 G5 F5 E5 | D5 B4 D5 F5 E5 D5 | C5 E5 C5 A4 B4 C5 | D5 C5{mp} B4 A4"
        rhythm_bars "1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 2"
      end

      placement :echo_line, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "A2{mf,txt:triangle_-_plain_root-fifth_floor} E3 A2 E3 | G2 D3 G2 D3 | A2 E3 A2 E3 | E2 B2 E2 B2 | F2 C3 F2 C3 | G2 D3 G2 D3 | A2 E3 A2 E3 | E2 E3 A2"
        rhythm_bars "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :bass_line, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
