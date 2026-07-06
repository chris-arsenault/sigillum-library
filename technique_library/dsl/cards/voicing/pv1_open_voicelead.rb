production_piece "Technique Card PV1_OPEN_VOICELEAD - PV1_OPEN_VOICELEAD" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: voicing
# card: PV1_OPEN_VOICELEAD
# cite: piano_voicing
# behavior: open voicing & voice-leading (romantic/general craft): LH open arpeggio
#   (root-10th-5th, no low clump), RH a singing top over moving inner voices, guide tones held,
#   7th->9th resolutions. The antidote to the close low clump

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "PV1_OPEN_VOICELEAD", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "open voicing & voice-leading (romantic/general craft): LH open arpeggio (root-10th-5th, no low clump), RH a singing top over moving inner voices, guide tones held, 7th->9th resolutions. The antidote to the close low clump"

      phrase :piano_rh_line, pitch: :degrees do
        key_context "F4"
        degrees "[3,5] [2,5] [2,5] [3,5] | [1,6] [7,,6] [1,6] [3,5] | [4,6] [3,6] [4,6] [3,6] [4,6] | [2,7] [2,6] [2,6] | [3,1'] [5,1'] [5,1'] | [6,1'] [6,7] [7,1'] [6,1'] [6,7] | [2,7] [2,6] [2,6] | [3,5] [3,5]"
        rhythm  "3/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 2 | 1 1 2 | 1 1/2 1/2 1 1 | 3/2 1/2 2 | 2 2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :piano_lh_line, pitch: :degrees do
        key_context "F2"
        degrees "1{p,txt:dolce_una_corda_--_open_arpeggio_w/_16th_passing_current} 3' #4' 5' 6' 5' 6' 5' | 6, 1' 2' 3' 4' 3' 5' 3' | 2 4' 5' 6' b7' 6' 6' 4' | 5, 7 4' 2' | 3 1' 2' 3' 4' 3' 5' 3' | 4 6' 7' 1'' 2'' 1'' 1'' 6' | 5, 7 1' 2' 3' 4' 4' 2' | 1 3' 5'"
        rhythm  "1 1/2 1/4 1/4 1/4 1/4 1/2 1 | 1 1/2 1/4 1/4 1/4 1/4 1/2 1 | 1 1/2 1/4 1/4 1/4 1/4 1/2 1 | 1 1 1 1 | 1 1/2 1/4 1/4 1/4 1/4 1/2 1 | 1 1/2 1/4 1/4 1/4 1/4 1/2 1 | 1 1/2 1/4 1/4 1/4 1/4 1/2 1 | 2 1 1"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
