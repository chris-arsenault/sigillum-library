production_piece "Technique Card CS1_ROLE_ROTATION - CS1_ROLE_ROTATION" do
  meter "4/4"
  key "a"

  tempo do
    mark "quarter = 80", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: CS1_ROLE_ROTATION
# cite: strings
# behavior: the melody passes Vn1->Va->Vc; the others stratified (sustained inner / off-beat
#   pulse / walking bass). A-minor quartet slow-movement idiom

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "CS1_ROLE_ROTATION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the melody passes Vn1->Va->Vc; the others stratified (sustained inner / off-beat pulse / walking bass). A-minor quartet slow-movement idiom"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{mp,txt:cantabile} D5 C5 B4 | C5 D5 E5 C5 B4 A4 | B4 r D5 C5 r | r B4 A4 | E5{txt:dolce} D5 E5 | C5 B4 C5 | E5 D5 C5 B4 C5 B4 | A4 G#4 A4"
        rhythm_bars "3/2 1/2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 1 1 1/2 1/2 1 | 2 1 1 | 2 1 1 | 3/2 1/2 2 | 1/2 1/2 1/2 1/2 1 1 | 1 1 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{mp} A4 | A4 B4 C5 A4 | r E4 r E4 r F4 r E4 | r E4 r D4 E4 E4 | A4 G4 A4 B4 | A4 G4 F4 E4 E4 | C5 B4 A4 G#4 A4 G#4 | C5 B4 A4"
        rhythm_bars "2 2 | 1 1 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1 1 1 1 | 1 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 1 1 2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r A3{mp} r E4 r A3 r E4 | r A3 r F4 r E4 r C4 | A3 B3 C4 D4 C4 | E4 D4 C4 B3 | A3{txt:pizz.} r E4 r A3 r C4 r | A3 r E4 D4 C4 r A3 r E4 | A3{txt:arco} B3 C4 D4 E4 D4 C4 B3 | E4 E4"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/4 1/4 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A2"
        intervals "0{mp} -5 +5 -5 +8 | -7 -1 -2 +2 | +5 -5 +5 -4 -1 | +5 -5 0 | +5{txt:espr.} +2 +1 +2 +2 -2 | -2 -1 -2 +3 +4 | -7 -5 +1 -1 | 0 +5"
        rhythm    "1 1 1/2 1/2 1 | 1 1 1 1 | 1 1/2 1/2 1 1 | 2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 3/2 1/2 1/2 1/2 1 | 1 1 1 1 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
