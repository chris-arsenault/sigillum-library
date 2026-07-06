production_piece "Technique Card PV4_LOCKED_HANDS - PV4_LOCKED_HANDS" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 138", at: "bar 1 beat 1"
  end

# category: voicing
# card: PV4_LOCKED_HANDS
# cite: piano_voicing
# behavior: Shearing locked-hands / Barry Harris 6th-diminished: a melodic line harmonized with
#   a close 4-note chord under each note (chord tones->C6, passing tones->B dim7), melody
#   doubled an octave below in the LH. Voicing a LINE

  roster do
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "PV4_LOCKED_HANDS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "Shearing locked-hands / Barry Harris 6th-diminished: a melodic line harmonized with a close 4-note chord under each note (chord tones->C6, passing tones->B dim7), melody doubled an octave below in the LH. Voicing a LINE"

      phrase :piano_rh_line, pitch: :degrees do
        key_context "C4"
        degrees "[6,1',3',5'] [1',3',5',6'] [6,1',3',5'] [5,6,1',3'] [6,1',3',5'] [5,6,1',3'] | [4,b6,7,2'] [5,6,1',3'] [b6,7,2',4'] [5,6,1',3'] [4,b6,7,2'] [3,5,6,1'] | [5,6,1',3'] [6,1',3',5'] [1',3',5',6'] [6,1',3',5'] [b6,7,2',4'] [5,6,1',3'] | [4,b6,7,2'] [5,6,1',3'] [4,b6,7,2'] [3,5,6,1'] | [5,6,1',3'] [b6,7,2',4'] [6,1',3',5'] [1',3',5',6'] [6,1',3',5'] | [1',3',5',6'] [6,1',3',5'] [5,6,1',3'] [4,b6,7,2'] [3,5,6,1'] [4,b6,7,2'] [5,6,1',3'] | [b6,7,2',4'] [5,6,1',3'] [4,b6,7,2'] [3,5,6,1'] [4,b6,7,2'] [5,6,1',3'] | [3,5,6,1'] [5,6,1',3'] [4,b6,7,2'] [3,5,6,1']"
        rhythm  "1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 1 1/2 1/2 2 | 1/2 1/2 1/2 1/2 2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :piano_lh_line, pitch: :degrees do
        key_context "C4"
        degrees "5{mp,txt:locked_hands_(swing)_--_melody_doubled_8ve_below} 6 5 3 5 3 | 2 3 4 3 2 1 | 3 5 6 5 4 3 | 2 3 2 1 | 3 4 5 6 5 | 6 5 3 2 1 2 3 | 4 3 2 1 2 3 | 1 3 2 1"
        rhythm  "1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 1 1/2 1/2 2 | 1/2 1/2 1/2 1/2 2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 1 1/2 1/2 2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
