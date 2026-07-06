production_piece "Technique Card OV3_LOW_INTERVAL_LIMIT - OV3_LOW_INTERVAL_LIMIT" do
  meter "4/4"
  key "cm"

  tempo do
    mark "quarter = 46", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV3_LOW_INTERVAL_LIMIT
# cite: orchestration_techniques:chord_voicing
# behavior: low-interval limit: b1 the MUDDY trap (close low m3 E-2 under the bass, below the
#   limit); b2-5 fix it as an open low shell (octaves+bare 5ths only) with the 3rd lifted out of
#   the bass to E-3/E-4 (a clean tenth), thirds allowed close only high; i-iv-V-i, Largo, dark

  roster do
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :contrabassoon, "Contrabassoon", music21: "Contrabassoon", family: :woodwind, description: "Contrabassoon"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
  end

  section :card, "OV3_LOW_INTERVAL_LIMIT", bars: 1..5, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..5, texture: :library_card do
      process "low-interval limit: b1 the MUDDY trap (close low m3 E-2 under the bass, below the limit); b2-5 fix it as an open low shell (octaves+bare 5ths only) with the 3rd lifted out of the bass to E-3/E-4 (a clean tenth), thirds allowed close only high; i-iv-V-i, Largo, dark"

      phrase :contrabass_line, pitch: :degrees do
        key_context "C1"
        degrees "1{f} | 1{f} | 4 | 5 | 1{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :tuba_line, pitch: :degrees do
        key_context "C2"
        degrees "r | 1{f} | 4 | 5 | 1{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :contrabassoon_line, pitch: :degrees do
        key_context "C2"
        degrees "r | 5{mp} | 1' | 2' | 5{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :contrabassoon_line, part: :contrabassoon, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :trombone_line, pitch: :degrees do
        key_context "C2"
        degrees "5{f} | 5{mf} | 1' | 7 | 5{mp}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violoncello_line, pitch: :degrees do
        key_context "C2"
        degrees "b3{f} | 1{f} | b6 | 5 | 1{mf}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :viola_line, pitch: :degrees do
        key_context "C3"
        degrees "r | b3{mp} | 4 | 2 | b3{p}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :bassoon_line, pitch: :degrees do
        key_context "C3"
        degrees "r | 5{mp} | b6 | 5 | 5{p}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_line, pitch: :degrees do
        key_context "C4"
        degrees "r | b3{mp} | [4,b6] | [5,7,] | b3{p}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :oboe_line, pitch: :degrees do
        key_context "C4"
        degrees "r | 5{mp} | 1' | 2' | 5{p}"
        rhythm  "4 | 4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
