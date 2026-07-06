production_piece "Technique Card OV7_REGISTER_WEIGHT - OV7_REGISTER_WEIGHT" do
  meter "4/4"
  key "b-"

  tempo do
    mark "quarter = 50", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV7_REGISTER_WEIGHT
# cite: orchestration_techniques:chord_voicing
# behavior: one B-flat-minor triad (B-/D-/F) held constant, only its register changing: b1-2 LOW
#   ff (Cb/Cbn/Tbn/Tba/Vc open-shell below C3 - heavy, grave, massive), b3-4 MIDDLE mf
#   (Bsn/Hn/Va/Vc/Cl/Vn2 around C3-C4 - balanced, vocal), b5-6 HIGH pp (Vn1/Vn2/Cl/Ob/Fl above
#   C5 - light, airborne); same three pitch-classes throughout, tessitura sets the physical
#   weight

  roster do
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :contrabassoon, "Contrabassoon", music21: "Contrabassoon", family: :woodwind, description: "Contrabassoon"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
  end

  section :card, "OV7_REGISTER_WEIGHT", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one B-flat-minor triad (B-/D-/F) held constant, only its register changing: b1-2 LOW ff (Cb/Cbn/Tbn/Tba/Vc open-shell below C3 - heavy, grave, massive), b3-4 MIDDLE mf (Bsn/Hn/Va/Vc/Cl/Vn2 around C3-C4 - balanced, vocal), b5-6 HIGH pp (Vn1/Vn2/Cl/Ob/Fl above C5 - light, airborne); same three pitch-classes throughout, tessitura sets the physical weight"

      phrase :contrabass_line, pitch: :degrees do
        key_context "Bb1"
        degrees "1{ff} | 1 | r | r | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :contrabassoon_line, pitch: :degrees do
        key_context "Bb1"
        degrees "1{ff} | 1 | r | r | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabassoon_line, part: :contrabassoon, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :tuba_line, pitch: :degrees do
        key_context "Bb2"
        degrees "5,{ff} | 5, | r | r | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :trombone_line, pitch: :degrees do
        key_context "Bb2"
        degrees "1{ff} | 1 | r | r | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violoncello_line, pitch: :degrees do
        key_context "Bb3"
        degrees "b3,{ff} | 5, | 1{mf} | 1 | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :bassoon_line, pitch: :degrees do
        key_context "Bb2"
        degrees "r | r | 1{mf} | 1 | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :horn_line, pitch: :degrees do
        key_context "Bb3"
        degrees "r | r | 5,{mf} | 5, | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :viola_line, pitch: :degrees do
        key_context "Bb4"
        degrees "r | r | b3,{mf} | b3, | r | r"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :clarinet_line, pitch: :degrees do
        key_context "Bb4"
        degrees "r | r | 5,{mf} | 5, | 1'{p} | 1'"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_ii_line, pitch: :degrees do
        key_context "Bb4"
        degrees "r | r | 1{mf} | 1 | b3{pp} | b3"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_i_line, pitch: :degrees do
        key_context "Bb5"
        degrees "r | r | r | r | 5,{pp} | 1"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :oboe_line, pitch: :degrees do
        key_context "Bb6"
        degrees "r | r | r | r | b3,{pp} | b3,"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :flute_line, pitch: :degrees do
        key_context "Bb6"
        degrees "r | r | r | r | 1{pp} | 5,"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
