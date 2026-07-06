production_piece "Technique Card PV5_DROP2_MOTION - PV5_DROP2_MOTION" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 126", at: "bar 1 beat 1"
  end

# category: voicing
# card: PV5_DROP2_MOTION
# cite: piano_voicing
# behavior: drop-2 in motion: the C6 drop-2 DESCENDING CYCLE (a chord run down its inversions,
#   tops falling E5-C5-A4-G4, dropped voice walking down in the LH) then a drop-2 ii-V-I -- one
#   chord becomes a melodic phrase; drop-2 as voice-leading

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "PV5_DROP2_MOTION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "drop-2 in motion: the C6 drop-2 DESCENDING CYCLE (a chord run down its inversions, tops falling E5-C5-A4-G4, dropped voice walking down in the LH) then a drop-2 ii-V-I -- one chord becomes a melodic phrase; drop-2 as voice-leading"

      phrase :piano_rh_line, pitch: :degrees do
        key_context "C4"
        degrees "[5,6,3'] r [5,6,3'] r [3,5,1'] [3,5,1'] r | [1,3,6] r [1,3,6] r [6,,1,5] [6,,1,5] r | r [5,6,3'] [5,6,3'] r [3,5,1'] r [3,5,1'] | r [1,3,6] [1,3,6] r [6,,1,5] r [6,,1,5] | [2,4,1'] r [2,4,1'] r | r [2,4,7] r [2,4,7] [2,4,7] r | [1,3,7] r [1,3,7] | [1,3,7]"
        rhythm  "1/2 1/2 1 1/2 3/4 1/4 1/2 | 1/2 1/2 1 1/2 3/4 1/4 1/2 | 1/2 3/4 1/4 1/2 1/2 1/2 1 | 1/2 3/4 1/4 1/2 1/2 1/2 1 | 3/2 1/2 1 1 | 1/2 1 1/2 3/4 1/4 1 | 3/2 1/2 2 | 4"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :piano_lh_line, pitch: :degrees do
        key_context "C4"
        degrees "1{mp,txt:drop-2_cycle_--_dropped_voice_walks_C4-A3-G3-E3} r 6, r | 5, r 3, r | 1 r 6, r | 5, r 3, r | 6,{txt:drop-2_ii-V-I} r 6, r | 5, r 5, r | 5, r 5, r | 5, r"
        rhythm  "1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 3/2 1/2 3/2 | 1/2 7/2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
