production_piece "Technique Card OV1_SPREAD_VOICING - OV1_SPREAD_VOICING" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 63", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV1_SPREAD_VOICING
# cite: orchestration_techniques:chord_voicing
# behavior: sustained chords voiced like the harmonic series - wide octave/fifth at the floor,
#   fourths/thirds in the middle, close thirds at the crown - so the orchestral chord rings;
#   b1-2 the C-major spread model, b3 the muddy close-low C trap (do not use), b4-5 the same
#   spread on IV(F), b6 resolves to C

  roster do
    part :crown_top, "Crown top", music21: "Flute", family: :woodwind, description: "Flute"
    part :crown_mid, "Crown mid", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :inner_close, "Inner close", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bright_inner, "Bright inner", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :crown_thirds, "Crown thirds", music21: "Violin", family: :string, description: "Violin"
    part :upper_close, "Upper close", music21: "Violin", family: :string, description: "Violin"
    part :mid_fill, "Mid fill", music21: "Horn", family: :brass, description: "Horn"
    part :tenor_fill, "Tenor fill", music21: "Viola", family: :string, description: "Viola"
    part :tenor_fifth, "Tenor fifth", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :foundation_fifth, "Foundation fifth", music21: "Trombone", family: :brass, description: "Trombone"
    part :wide_fifth, "Wide fifth", music21: "Violoncello", family: :string, description: "Violoncello"
    part :floor_octave, "Floor octave", music21: "Tuba", family: :brass, description: "Tuba"
    part :root_floor, "Root floor", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OV1_SPREAD_VOICING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "sustained chords voiced like the harmonic series - wide octave/fifth at the floor, fourths/thirds in the middle, close thirds at the crown - so the orchestral chord rings; b1-2 the C-major spread model, b3 the muddy close-low C trap (do not use), b4-5 the same spread on IV(F), b6 resolves to C"

      phrase :crown_top_line, pitch: :degrees do
        key_context "C5"
        degrees "5{mf} | 5 | r | 6{mf} | 6 | 5{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :crown_top_line, part: :crown_top, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :crown_mid_line, pitch: :degrees do
        key_context "C5"
        degrees "3{mf} | 3 | r | 4{mf} | 4 | 3{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :crown_mid_line, part: :crown_mid, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :inner_close_line, pitch: :degrees do
        key_context "C5"
        degrees "1{mp} | 1 | r | 1{mp} | 1 | 1{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :inner_close_line, part: :inner_close, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :bright_inner_line, pitch: :degrees do
        key_context "C5"
        degrees "3{mp} | 3 | r | 4{mp} | 4 | 3{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bright_inner_line, part: :bright_inner, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :crown_thirds_line, pitch: :degrees do
        key_context "C5"
        degrees "[3,5]{mf} | [3,5] | r | [4,6]{mf} | [4,6] | [3,5]{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :crown_thirds_line, part: :crown_thirds, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :upper_close_line, pitch: :degrees do
        key_context "C5"
        degrees "[1,3]{mp} | [1,3] | r | [1,4]{mp} | [1,4] | [1,3]{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :upper_close_line, part: :upper_close, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :mid_fill_line, pitch: :degrees do
        key_context "C3"
        degrees "[5,1']{mp} | [5,1'] | 3,{f} | [6,1']{mp} | [6,1'] | [5,1']{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :mid_fill_line, part: :mid_fill, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :tenor_fill_line, pitch: :degrees do
        key_context "C4"
        degrees "1{mp} | 1 | 3,{f} | [1,4]{mp} | [1,4] | 1{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tenor_fill_line, part: :tenor_fill, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :tenor_fifth_line, pitch: :degrees do
        key_context "C3"
        degrees "5{mp} | 5 | 3,{f} | 6{mp} | 6 | 5{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tenor_fifth_line, part: :tenor_fifth, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :foundation_fifth_line, pitch: :degrees do
        key_context "C2"
        degrees "5{mf} | 5 | 5{f} | 1'{mf} | 1' | 5{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :foundation_fifth_line, part: :foundation_fifth, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :wide_fifth_line, pitch: :degrees do
        key_context "C2"
        degrees "5{mf} | 5 | 3{f} | 1'{mf} | 1' | 5{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :wide_fifth_line, part: :wide_fifth, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :floor_octave_line, pitch: :degrees do
        key_context "C2"
        degrees "1{f} | 1 | 1{f} | 4{f} | 4 | 1{f}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :floor_octave_line, part: :floor_octave, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :root_floor_line, pitch: :degrees do
        key_context "C2"
        degrees "1{f} | 1 | 1{f} | 4,{f} | 4, | 1{f}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :root_floor_line, part: :root_floor, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
