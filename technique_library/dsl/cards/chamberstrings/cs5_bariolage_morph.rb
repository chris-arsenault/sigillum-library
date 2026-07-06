production_piece "Technique Card CS5_BARIOLAGE_MORPH - CS5_BARIOLAGE_MORPH" do
  meter "4/4"
  key "c"

  tempo do
    mark "quarter = 138", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: CS5_BARIOLAGE_MORPH
# cite: strings
# behavior: viola bariolage 16th motor (open-G pedal) + syncopated cello riff engine +
#   sul-pont->ord->tasto morph + biting motif. C-minor allegro film-tension idiom

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "CS5_BARIOLAGE_MORPH", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "viola bariolage 16th motor (open-G pedal) + syncopated cello riff engine + sul-pont->ord->tasto morph + biting motif. C-minor allegro film-tension idiom"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{f,txt:marcato} Bb4 Ab4 G4 F4 G4 | Eb5 D5 C5 Bb4 Ab4 G4 | Ab4 Bb4 C5 Bb4 Ab4 G4 F4 | G5 F5 Eb5 D5 C5 | Eb5 D5 C5 Ab4 G4 F4 Eb4 | D4 Eb4 C4 D4 C4"
        rhythm_bars "1 1/2 1/2 3/4 1/4 1 | 3/4 1/4 1/2 1/2 1 1 | 1/2 1/2 3/4 1/4 1/2 1/2 1 | 3/2 1/2 1 1/2 1/2 | 3/4 1/4 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r G4{pp,txt:sul_pont.} r G4 r Ab4 r G4 | r Ab4 r Ab4 r G4 F4 G4 | r Ab4{txt:ord.} G4 Ab4 r G4 r G4 | G4 Ab4 Bb4 Ab4 G4 Ab4 G4 F4 | r G4{txt:sul_tasto} r G4 Eb4 Eb4 | D4 C4 C4"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1 1 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{pp,txt:sul_pont._bariolage} C4 G3 Eb4 G3 C4 G3 D4 G3 Eb4 G3 C4 G3 D4 G3 C4 | G3 Eb4 G3 F4 G3 Eb4 G3 D4 G3 C4 G3 D4 G3 Eb4 G3 F4 | G3{pp,txt:ord.} Ab4 G3 G4 G3 F4 G3 Eb4 G3 D4 G3 Eb4 G3 F4 G3 G4 | G3 G4 G3 Ab4 G3 G4 G3 F4 G3 Eb4 G3 F4 G3 G4 G3 Ab4 | G3{pp,txt:sul_tasto} C4 G3 Eb4 G3 C4 G3 D4 G3 Eb4 G3 C4 G3 D4 G3 C4 | G3 C4 G3 Eb4 G3 C4 G3 D4 G3 C4 G3 G3 G3 G3 G3 G3"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C2"
        intervals "0{f} 0 +7 r -7 +3 -1 -2 | 0 0 +7 r -7 +3 +2 +2 | +1 0 -1 r -2 -2 -1 -2 | 0 0 +7 +1 -1 -2 -2 -1 | -2 0 +7 r -7 +3 -1 -2 | 0 +7 -7 0"
        rhythm    "3/4 1/4 1/2 1/2 1/2 1/2 1/2 1/2 | 3/4 1/4 1/2 1/2 1/2 1/2 1/2 1/2 | 3/4 1/4 1/2 1/2 1/2 1/2 1/2 1/2 | 3/4 1/4 1/2 1/2 1/2 1/2 1/2 1/2 | 3/4 1/4 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
