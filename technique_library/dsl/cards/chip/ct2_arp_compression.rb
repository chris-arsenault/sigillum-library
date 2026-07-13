production_piece "Technique Card CT2_ARP_COMPRESSION - CT2_ARP_COMPRESSION" do
  meter "4/4"
  key "A minor"

  tempo do
    mark "quarter = 150", at: "bar 1 beat 1"
  end

# category: chip
# card: CT2_ARP_COMPRESSION
# cite: chiptune_research:harmonic_compression (docs/research/chiptune_nes_composition.md)
# behavior: harmonic compression by super-fast arpeggio: pulse 2 iterates the chord tones in
#   constant eighths so ONE channel states the full harmony, freeing pulse 1 for a slow
#   singing lead and the triangle for plain roots - the defining PSG idiom

  roster do
    part :pulse1, "Pulse 1", music21: "Clarinet", family: :woodwind, description: "NES pulse channel 1 - square lead"
    part :pulse2, "Pulse 2", music21: "Oboe", family: :woodwind, description: "NES pulse channel 2 - arpeggio engine"
    part :triangle, "Triangle", music21: "Violoncello", family: :string, description: "NES triangle channel - bass"
  end

  section :card, "CT2_ARP_COMPRESSION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "harmonic compression by super-fast arpeggio: pulse 2 iterates the chord tones in constant eighths so ONE channel states the full harmony, freeing pulse 1 for a slow singing lead and the triangle for plain roots - the defining PSG idiom"

      phrase :arp_engine, surface: :split_pitch_rhythm do
        pitch_bars  "A3{mp,txt:pulse2_-_one_channel_is_the_whole_chord} C4 E4 A4 E4 C4 A3 C4 | F3 A3 C4 F4 C4 A3 F3 A3 | C4 E4 G4 C5 G4 E4 C4 E4 | B3 D4 G4 B4 G4 D4 B3 D4 | A3 C4 E4 A4 E4 C4 A3 C4 | F3 A3 C4 F4 C4 A3 F3 A3 | C4 E4 G4 C5 G4 E4 C4 E4 | E4 G#4 B4 E5 B4 G#4 E4 B3"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :arp_engine, part: :pulse2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :slow_lead, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mf,txt:pulse1_-_freed_for_a_slow_singing_lead} C5 A4 | F5 A5 C5 | E5 G5 E5 | D5 B4 G4 | E5 C5 A4 | F5 A5 F5 | G5 E5 C5 | B4 G#4 E4"
        rhythm_bars "2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1 | 2 1 1"
      end

      placement :slow_lead, part: :pulse1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :root_floor, surface: :split_pitch_rhythm do
        pitch_bars  "A2{mf,txt:triangle_-_plain_roots} A2 | F2 F2 | C3 C3 | G2 G2 | A2 A2 | F2 F2 | C3 C3 | E2 E2"
        rhythm_bars "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2"
      end

      placement :root_floor, part: :triangle, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
