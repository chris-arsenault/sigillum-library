production_piece "Technique Card P10_THUMB_MELODY - P10_THUMB_MELODY" do
  meter "4/4"
  key "C"

# category: piano
# card: P10_THUMB_MELODY
# cite: keyboard_figuration s6c
# behavior: melody in the MIDDLE deck (thumb, marc.); oscillation halo above (type 5, not
#   arpeggio); bass line below - three decks, one player

  roster do
    part :halo_osc, "Halo (osc.)", music21: "Piano", family: :keyboard, description: "Piano"
    part :thumb_melody, "Thumb melody", music21: "Piano", family: :keyboard, description: "Piano"
    part :bass_line, "Bass line", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P10_THUMB_MELODY", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "melody in the MIDDLE deck (thumb, marc.); oscillation halo above (type 5, not arpeggio); bass line below - three decks, one player"

      phrase :halo_osc_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 | Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 Db5 Eb5 Db5 Eb5 Db5 Eb5 Db5 Eb5 | C5 Db5 C5 Db5 C5 Db5 C5 Db5 Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 | Eb5 Gb5 Eb5 Gb5 Eb5 Gb5 Eb5 Gb5 Eb5 F5 Eb5 F5 Eb5 F5 Eb5 F5 | Db5 Eb5 Db5 Eb5 Db5 Eb5 Db5 Eb5 C5 Db5 C5 Db5 C5 Db5 C5 Db5 | C5 Db5 C5 C5"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/2 3"
      end

      placement :halo_osc_line, part: :halo_osc, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :thumb_melody_line, surface: :split_pitch_rhythm do
        pitch_bars  "C4{mf,txt:thumb_melody_marc.} Db4 Eb4 | F4 Eb4 Db4 | Eb4 Ab4 G4 | F4 Eb4 Db4 C4 | Bb3 C4 Db4 Eb4 | C4"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 2 1 1 | 1 1 1 1 | 3/2 1/2 1 1 | 4"
      end

      placement :thumb_melody_line, part: :thumb_melody, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line_line, pitch: :intervals do
        anchor "Ab1"
        intervals "0 +12 -1 -2 | -4 +7 +5 +2 -12 | -7 +7 +5 -3 -2 | -2 +12 -15 +12 | -7 +12 -2 -1 -2 | -14 +7 +5"
        rhythm    "1 1 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 1 1 | 1 1/2 1/2 1 1 | 1 1 2"
      end

      placement :bass_line_line, part: :bass_line, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
