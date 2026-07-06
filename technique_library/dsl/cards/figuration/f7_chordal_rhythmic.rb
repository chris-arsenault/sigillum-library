production_piece "Technique Card F7_CHORDAL_RHYTHMIC - F7_CHORDAL_RHYTHMIC" do
  meter "4/4"
  key "C"

# category: figuration
# card: F7_CHORDAL_RHYTHMIC
# cite: keyboard_figuration s6b t7
# behavior: dactyl-spondee cell on full chords, RE-VOICED every bar, accents migrating; the
#   rhythm is the figure

  roster do
    part :strings_chords, "Strings (chords)", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "F7_CHORDAL_RHYTHMIC", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "dactyl-spondee cell on full chords, RE-VOICED every bar, accents migrating; the rhythm is the figure"

      phrase :strings_chords_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D4,F#4,A4]{mf} [D4,F#4,A4] [C#4,E4,A4] [D4,F#4,A4] [D4,F#4,A4] | [D4,G4,B4] [E4,A4,C5] [D4,G4,B4] [D4,F#4,B4] | [E4,G4,B4] [F#4,A4,C#5] [E4,G4,B4] [E4,G4,C#5] [D4,F#4,D5] | [C#4,F#4,A4] [D4,F#4,A4] [C#4,F#4,A4] [B3,E4,G#4] | [B3,D4,F#4] [C#4,E4,G4] [B3,D4,F#4] [A3,D4,F#4] [A3,C#4,E4] [A3,D4,F#4] [A3,C#4,G4] | [A3,D4,F#4] [A3,C#4,E4] [D4,F#4,A4]"
        rhythm_bars "1 1/2 1/2 1 1 | 1 1/2 1/2 2 | 1 1/2 1/2 1 1 | 1 1/2 1/2 2 | 1/2 1/4 1/4 1/2 1/2 1 1 | 2 1 1"
      end

      placement :strings_chords_line, part: :strings_chords, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0 0 -1 -2 -2 | +2 0 -2 -2 +4 | +5 0 -2 -1 -2 | -2 0 -1 +1 +4 | +1 0 -1 +1 +2 | +2 -2 -2"
        rhythm    "1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
