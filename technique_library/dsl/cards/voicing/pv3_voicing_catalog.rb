production_piece "Technique Card PV3_VOICING_CATALOG - PV3_VOICING_CATALOG" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 92", at: "bar 1 beat 1"
  end

# category: voicing
# card: PV3_VOICING_CATALOG
# cite: piano_voicing
# behavior: the voicing-type catalog on ONE chord (Cmaj7/C7): close / drop-2 / drop-3 / drop-2&4
#   / rootless A & B / quartal / upper-structure -- each labeled, so the actual voicing types
#   are heard side by side. A recognition/reference card

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "PV3_VOICING_CATALOG", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the voicing-type catalog on ONE chord (Cmaj7/C7): close / drop-2 / drop-3 / drop-2&4 / rootless A & B / quartal / upper-structure -- each labeled, so the actual voicing types are heard side by side. A recognition/reference card"

      phrase :piano_rh_line, pitch: :degrees do
        key_context "C4"
        degrees "3{mp,txt:close} 5 7 [3,5,7] r [3,5,7] r | r [1,3,7]{txt:drop-2} r [1,3,7] [1,3,7] r | [1,5,7]{txt:drop-3} [1,5,7] r [1,5,7] r | 3{txt:drop-2_4} 7 [3,7] r [3,7] r | 3{txt:rootless_A} 5 7 2' [3,5,7,2'] r [3,5,7,2'] r | r [7,,2,3,5]{txt:rootless_B} r [7,,2,3,5] [7,,2,3,5] r | 2{txt:quartal} 5 1' 4' [2,5,1',4'] r [2,5,1',4'] r | [2',#4',6']{txt:upper-structure_C13#11} [2',#4',6'] r [2',#4',6']"
        rhythm  "1/4 1/4 1/2 1 1/2 1/2 1 | 1/2 1 1/2 3/4 1/4 1 | 3/4 1/4 1/2 1 3/2 | 1/2 1/2 1 1/2 1/2 1 | 1/4 1/4 1/4 1/4 1 1/2 1/2 1 | 1/2 1 1/2 3/4 1/4 1 | 1/4 1/4 1/4 1/4 1 1/2 1/2 1 | 3/4 1/4 1/2 5/2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :piano_lh_line, pitch: :degrees do
        key_context "C2"
        degrees "1{mp} r 1 r | 5 r 5 r | 3 r 3 r | [1,5] r [1,5] r | 1 r 1 r | 1 r 1 r | 1 r 1 r | [3',b7'] r [3',b7'] r"
        rhythm  "1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
