production_piece "Technique Card PV6_COMP_RHYTHM - PV6_COMP_RHYTHM" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: voicing
# card: PV6_COMP_RHYTHM
# cite: piano_voicing
# behavior: comp RHYTHM (the same rootless ii-V-I voicings, LH bass low / RH voicing mid with a
#   clean gap): Charleston, anticipations, space -- a different comp figure each bar, attacks
#   off the downbeat. Comping is rhythm, not block half-notes

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "PV6_COMP_RHYTHM", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "comp RHYTHM (the same rootless ii-V-I voicings, LH bass low / RH voicing mid with a clean gap): Charleston, anticipations, space -- a different comp figure each bar, attacks off the downbeat. Comping is rhythm, not block half-notes"

      phrase :piano_rh_line, pitch: :degrees do
        key_context "C3"
        degrees "[4,6,1',3']{mp,txt:comp_RHYTHM_--_Charleston/anticipation/16th_double/space_not_block} r [4,6,1',3'] [4,6,1',3'] r | r [4,6,7,3'] r [4,6,7,3'] | [3,5,7,2'] r [3,5,7,2'] | r [3,5,7,2'] r [3,5,7,2'] [3,5,7,2'] r | [4,6,1',3'] r [4,6,1',3'] r | [4,6,7,3'] r [4,6,7,3'] [4,6,7,3'] r | r [3,5,7,2'] [3,5,7,2'] r [3,5,7,2'] r | [3,5,7,2'] r [3,5,7,2']"
        rhythm  "3/2 1/2 3/4 1/4 1 | 1 3/2 1/2 1 | 2 3/2 1/2 | 1/2 1 1/2 3/4 1/4 1 | 3/2 1/2 1 1 | 1 1 3/4 1/4 1 | 1/2 3/4 1/4 1/2 1 1 | 2 1/2 3/2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :piano_lh_line, pitch: :degrees do
        key_context "C2"
        degrees "2{mp} 6 | 5 2' | 1 5 | 1 5 | 2 6 | 5 2' | 1 5 | 1"
        rhythm  "2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 2 2 | 4"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
