production_piece "Technique Card CS3_CONVERSATIONAL - CS3_CONVERSATIONAL" do
  meter "3/4"
  key "e"

  tempo do
    mark "quarter = 160", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: CS3_CONVERSATIONAL
# cite: strings
# behavior: snappy cell (16th flicks + dotted-8th accent) tossed Vn1->Va->Vn2->Vc with witty
#   silences, hocket, stretto. E-minor vivace scherzando idiom

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "CS3_CONVERSATIONAL", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "snappy cell (16th flicks + dotted-8th accent) tossed Vn1->Va->Vn2->Vc with witty silences, hocket, stretto. E-minor vivace scherzando idiom"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{f,txt:scherz.} F#5 G5 F#5 E5 r | r | r D5 E5 D5 C5 B4 r | r | E5 G5 F#5 r E5 G5 r B4 | r G5 A5 B5 A5 G5 r | E5 F#5 G5 E5 F#5 G5 F#5 E5 | F#5 D#5 E5 E5"
        rhythm_bars "1/4 1/4 3/4 1/4 1/2 1 | 3 | 1/2 1/4 1/4 3/4 1/4 1/2 1/2 | 3 | 1/4 1/4 1/2 1/4 1/4 1/2 1/2 1/2 | 1/2 1/2 1/4 3/4 1/4 1/2 1/4 | 1/4 1/4 1/2 1/4 1/4 1/2 1/2 1/2 | 1/2 1/4 1/4 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r B4{txt:pizz.} B4 r B4 r | r | G4{f,txt:arco} A4 B4 A4 G4 r | r G4 F#4 E4 | r | E5 G5 F#5 r E5 G5 r D5 | r E5 F#5 G5 F#5 E5 r | B4 D#5 E5 E5"
        rhythm_bars "1/2 1/4 1/4 1/2 1/2 1 | 3 | 1/4 1/4 3/4 1/4 1/2 1 | 2 1/4 1/4 1/2 | 3 | 1/4 1/4 1/2 1/4 1/4 1/2 1/2 1/2 | 1 1/4 1/4 1/2 1/4 1/4 1/2 | 1/2 1/4 1/4 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r E4{txt:pizz.} r E4 r | B4{f,txt:arco} C5 D5 C5 B4 r | r B4 A4 G4 | r E4{txt:pizz.} r E4 r | r B4{txt:arco} A4 G4 r E4 r | r | r E4 F#4 G4 E4 F#4 G4 r | F#4 D#4 E4 E4"
        rhythm_bars "3/4 1/4 1/2 1/2 1 | 1/4 1/4 3/4 1/4 1/2 1 | 2 1/4 1/4 1/2 | 3/4 1/4 1/2 1/2 1 | 1/2 1/4 1/4 1/2 1/2 1/2 1/2 | 3 | 1/2 1/4 1/4 1/2 1/4 1/4 1/2 1/2 | 1/2 1/4 1/4 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "E2"
        intervals "0{txt:pizz.} r +7 r -7 r | 0 r +7 +5 r -5 r | -7 r +7 r -7 r | +12{txt:arco} +2 +1 -1 -2 r | -12{txt:pizz.} r +7 r -7 r | 0 r +7 +5 r -5 r | -7 +7 +5 -5 -7 +7 -7 r | +7 0 0 -7"
        rhythm    "1/2 1/4 1/4 1/2 1/2 1 | 1/2 1/2 1/4 1/4 1/2 1/2 1/2 | 1/2 1/4 1/4 1/2 1/2 1 | 1/4 1/4 3/4 1/4 1/2 1 | 1/2 1/4 1/4 1/2 1/2 1 | 1/2 1/2 1/4 1/4 1/2 1/2 1/2 | 1/4 1/4 1/2 1/4 1/4 1/2 1/2 1/2 | 1/2 1/4 1/4 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
