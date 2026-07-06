production_piece "Technique Card OV4_DIVISI_VERTICAL - OV4_DIVISI_VERTICAL" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV4_DIVISI_VERTICAL
# cite: orchestration_techniques:chord_voicing
# behavior: lush divisi vertical - one rich chord (Cadd9/13) with a different tone in every
#   desk, NO octave doubling, overtone-spread (open low / close high) so a dozen string+wind
#   parts read as one saturated sonority; staggered desk-by-desk niente swells make it breathe;
#   b3-4 every voice steps to the nearest tone of Fmaj13, so the color changes by voice-leading
#   not re-attack

  roster do
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :violoncello_div_b, "Violoncello (div b)", music21: "Violoncello", family: :string, description: "Violoncello"
    part :violoncello_div_a, "Violoncello (div a)", music21: "Violoncello", family: :string, description: "Violoncello"
    part :viola_div_b, "Viola (div b)", music21: "Viola", family: :string, description: "Viola"
    part :viola_div_a, "Viola (div a)", music21: "Viola", family: :string, description: "Viola"
    part :violin_ii_div_b, "Violin II (div b)", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii_div_a, "Violin II (div a)", music21: "Violin", family: :string, description: "Violin"
    part :violin_i_div_c, "Violin I (div c)", music21: "Violin", family: :string, description: "Violin"
    part :violin_i_div_b, "Violin I (div b)", music21: "Violin", family: :string, description: "Violin"
    part :violin_i_div_a, "Violin I (div a)", music21: "Violin", family: :string, description: "Violin"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
  end

  section :card, "OV4_DIVISI_VERTICAL", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "lush divisi vertical - one rich chord (Cadd9/13) with a different tone in every desk, NO octave doubling, overtone-spread (open low / close high) so a dozen string+wind parts read as one saturated sonority; staggered desk-by-desk niente swells make it breathe; b3-4 every voice steps to the nearest tone of Fmaj13, so the color changes by voice-leading not re-attack"

      phrase :contrabass_line, pitch: :degrees do
        key_context "C2"
        degrees "1{pp,txt:arco} | 1{txt:cresc.} | 4{p,txt:dim.} | 4{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violoncello_div_b_line, pitch: :degrees do
        key_context "C2"
        degrees "5{pp} | 5{txt:cresc.} | 6{p,txt:dim.} | 6{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violoncello_div_b_line, part: :violoncello_div_b, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violoncello_div_a_line, pitch: :degrees do
        key_context "C2"
        degrees "7{pp,txt:cresc.} | 7 | 1'{p,txt:dim.} | 1'{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violoncello_div_a_line, part: :violoncello_div_a, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :viola_div_b_line, pitch: :degrees do
        key_context "C3"
        degrees "2{pp} | 2{txt:cresc.} | 3{p,txt:dim.} | 3{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :viola_div_b_line, part: :viola_div_b, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :viola_div_a_line, pitch: :degrees do
        key_context "C3"
        degrees "3{pp,txt:cresc.} | 3 | 4{p,txt:dim.} | 4{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :viola_div_a_line, part: :viola_div_a, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_ii_div_b_line, pitch: :degrees do
        key_context "C3"
        degrees "6{pp} | 6{txt:cresc.} | 6{p,txt:dim.} | 6{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_ii_div_b_line, part: :violin_ii_div_b, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_ii_div_a_line, pitch: :degrees do
        key_context "C3"
        degrees "7{pp,txt:cresc.} | 7 | 1'{p,txt:dim.} | 1'{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_ii_div_a_line, part: :violin_ii_div_a, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_i_div_c_line, pitch: :degrees do
        key_context "C4"
        degrees "5{pp} | 5{txt:cresc.} | 5{p,txt:dim.} | 5{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_i_div_c_line, part: :violin_i_div_c, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_i_div_b_line, pitch: :degrees do
        key_context "C4"
        degrees "7{pp,txt:cresc.} | 7 | 6{p,txt:dim.} | 6{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_i_div_b_line, part: :violin_i_div_b, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_i_div_a_line, pitch: :degrees do
        key_context "C5"
        degrees "2{pp} | 2{txt:cresc.} | 1{p,txt:dim.} | 1{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_i_div_a_line, part: :violin_i_div_a, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :flute_line, pitch: :degrees do
        key_context "C5"
        degrees "3{pp,txt:cresc.} | 3 | 4{p,txt:dim.} | 4{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :clarinet_line, pitch: :degrees do
        key_context "C4"
        degrees "2{pp} | 2{txt:cresc.} | 2{p,txt:dim.} | 2{pp}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
