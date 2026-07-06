production_piece "Technique Card OV2_COMBINE_GROUPS - OV2_COMBINE_GROUPS" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV2_COMBINE_GROUPS
# cite: orchestration_techniques:chord_voicing
# behavior: one ii7-V7-I cadence (G7-C7-F) voiced three ways by winds+strings in turn: b1-2
#   SUPERPOSED (winds entirely above the strings, two clear bands); b3-4 ENCLOSED (each wind
#   tone between two string tones, one fused block); b5-6 CROSSED (Cl below Va, Fl below Vn1 at
#   the resolution) - the changing fusion/clarity is the event

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OV2_COMBINE_GROUPS", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one ii7-V7-I cadence (G7-C7-F) voiced three ways by winds+strings in turn: b1-2 SUPERPOSED (winds entirely above the strings, two clear bands); b3-4 ENCLOSED (each wind tone between two string tones, one fused block); b5-6 CROSSED (Cl below Va, Fl below Vn1 at the resolution) - the changing fusion/clarity is the event"

      phrase :flute_line, pitch: :degrees do
        key_context "F5"
        degrees "1{p} | 2 | b6, | 4, | 4,{mp} | 3,{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :oboe_line, pitch: :degrees do
        key_context "F5"
        degrees "b6,{p} | 7, | 1, | 2, | 2,{mp} | 1,{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :clarinet_line, pitch: :degrees do
        key_context "F4"
        degrees "4{p} | 4 | b6, | 7, | 5,{mp} | 1{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :bassoon_line, pitch: :degrees do
        key_context "F4"
        degrees "2{p} | 2 | 4, | 4, | 4,{mp} | 3,{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_i_line, pitch: :degrees do
        key_context "F4"
        degrees "1{p} | 7, | 1 | 7, | 5{mp} | 5{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_ii_line, pitch: :degrees do
        key_context "F4"
        degrees "b6,{p} | 5, | b6, | 5, | 2{mp} | 1{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :viola_line, pitch: :degrees do
        key_context "F3"
        degrees "4{p} | 2 | 2 | 2 | 7{mp} | 1'{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violoncello_line, pitch: :degrees do
        key_context "F3"
        degrees "b6,{p} | 7, | b6, | 7, | 5,{mp} | 5,{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :contrabass_line, pitch: :degrees do
        key_context "F2"
        degrees "2{p} | 5, | 2 | 5, | 5,{mp} | 1{p}"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
