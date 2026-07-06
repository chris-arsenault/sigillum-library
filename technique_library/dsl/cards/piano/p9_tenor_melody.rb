production_piece "Technique Card P9_TENOR_MELODY - P9_TENOR_MELODY" do
  meter "4/4"
  key "C"

# category: piano
# card: P9_TENOR_MELODY
# cite: keyboard_figuration s6c
# behavior: the song in the LH tenor; bass kept by downbeat leaps; RH off-beat inner dyads + one
#   sparkle answer per phrase

  roster do
    part :rh_halo, "RH halo", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_bass_tenor_song, "LH bass+tenor song", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P9_TENOR_MELODY", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "the song in the LH tenor; bass kept by downbeat leaps; RH off-beat inner dyads + one sparkle answer per phrase"

      phrase :rh_halo_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [C4,F4] r [C4,F4] r [C4,E4] r [C4,E4] | r [C4,G4] r [C4,G4] r [Bb3,G4] r [Bb3,E4] | r [Bb3,F4] r [Bb3,D4] A4 Bb4 C5 F5 E5 C5 | r [C4,G4] r [C4,G4] r [E4,G4] r [E4,Bb4] | r [C4,F4] r [C4,F4] r [C4,A4] r [C4,A4] | r [C4,G4] C5 D5 E5 F5 [A4,C5]"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/4 1/4 1/4 1/4 2"
      end

      placement :rh_halo_line, part: :rh_halo, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_bass_tenor_song_line, surface: :split_pitch_rhythm do
        pitch_bars  "F2 A3 G3 F3 | C2 E3 F3 G3 | Bb1 F3 E3 D3 C3 | C2 E3 G3 Bb3 | F2 A3 C4 A3 | C2 G3 E3 F3"
        rhythm_bars "1/2 3/2 1 1 | 1/2 3/2 1 1 | 1/2 3/2 1/2 1/2 1 | 1/2 1 1 3/2 | 1/2 3/2 1 1 | 1/2 1 1 3/2"
      end

      placement :lh_bass_tenor_song_line, part: :lh_bass_tenor_song, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
