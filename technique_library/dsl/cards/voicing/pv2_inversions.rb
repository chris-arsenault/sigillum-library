production_piece "Technique Card PV2_INVERSIONS - PV2_INVERSIONS" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: voicing
# card: PV2_INVERSIONS
# cite: piano_voicing
# behavior: inversions as a voice-leading tool: a descending-bass diatonic progression (C - G/B
#   - Am - C/G - Fmaj7 - Em7 - Dm7 - G7 - C) where inversion choice makes a stepwise descending
#   bass (C-B-A-G-F-E-D) under a singing top -- inversions made visible

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "PV2_INVERSIONS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "inversions as a voice-leading tool: a descending-bass diatonic progression (C - G/B - Am - C/G - Fmaj7 - Em7 - Dm7 - G7 - C) where inversion choice makes a stepwise descending bass (C-B-A-G-F-E-D) under a singing top -- inversions made visible"

      phrase :piano_rh_line, pitch: :degrees do
        key_context "C4"
        degrees "[3,5,1'] r [3,5,7] | r [2,5,7] r [2,5,7] | [1,3,6] r [1,3,6] | r [1,3,5] [1,3,5] r [1,3,5] | [6,1',3'] r [6,1',3'] | [5,7,2'] r [5,7,2'] | [4,6,1'] r [4,6,1'] r | r [4,5,7] [3,5,1']"
        rhythm  "3/2 1/2 2 | 1/2 3/2 1/2 3/2 | 2 1/2 3/2 | 1/2 1 1 1/2 1 | 3/2 1/2 2 | 2 1/2 3/2 | 3/2 1/2 1 1 | 1/2 3/2 2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :piano_lh_line, pitch: :degrees do
        key_context "C3"
        degrees "1{mp,txt:inversions_in_a_groove_--_bass_C-B-A-G-F-E-D} 5 1' 3' 1' 5 | 7, 5 7 2' 7 5 | 6, 3 6 1' 6 3 | 5, 5 1' 3' 1' 5 | 4, 1 4 6 4 1 | 3, 7, 3 5 3 7, | 2, 6, 2 4 2 6, | 5, 2 4 5 1"
        rhythm  "1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
