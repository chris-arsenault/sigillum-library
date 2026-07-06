production_piece "Technique Card EL3_CONCERTANTE_ELEGY - EL3_CONCERTANTE_ELEGY" do
  meter "4/4"
  key "C"

# category: elegy
# card: EL3_CONCERTANTE_ELEGY
# cite: keyboard_figuration s6d/s6e (concertante-elegy fabric)
# behavior: string melody with real gaps; piano answers IN SENTENCES (dotted reply -> triplet
#   current -> bell at the peak -> 16th descent), crest follows phrase; viola agitates in cells;
#   cello bass walks with anticipations

  roster do
    part :violin_slot, "Violin (slot)", music21: "Violin", family: :string, description: "Violin"
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "EL3_CONCERTANTE_ELEGY", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "string melody with real gaps; piano answers IN SENTENCES (dotted reply -> triplet current -> bell at the peak -> 16th descent), crest follows phrase; viola agitates in cells; cello bass walks with anticipations"

      phrase :violin_slot_line, pitch: :intervals do
        anchor "Ab4"
        intervals "0{p} -2 -1 -2 | +2 r | -4 -1 +1 +2 +2 | +1 r +2 | +2 -2 -2 -1 | +3 r | -3 -2 -2 +2 | -2"
        rhythm    "2 1/2 1/2 1 | 3 1 | 3/2 1/2 1 1/2 1/2 | 2 1 1 | 3/2 1/2 1 1 | 3 1 | 1 3/4 1/4 2 | 4"
      end

      placement :violin_slot_line, part: :violin_slot, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :piano_rh_line, pitch: :intervals do
        anchor "F4"
        intervals "r 0 +1 +2 +2 | r -2 -2 -1 +1 +2 +2 +2 | +1 r -1 +1 r | r +2 +2 +1 -1 -2 -2 | [0,+3]{txt:l.v.} +2 -2 -1 -2 -2 -2 -1 | r +1 -1 -2 +2 | -2 +2 +1 +2 +2 -2 -2 -1 -2 | +2 -2 -2"
        rhythm    "5/2 1/4 1/4 1/2 1/2 | 1/2 3/4 1/4 1/3 1/3 1/3 1/2 1 | 1 1 3/4 1/4 1 | 1 1/3 1/3 1/3 3/4 1/4 1 | 3/2 1/4 1/4 1/4 1/4 1/4 1/4 1 | 1/2 1/2 3/4 1/4 2 | 1/4 1/4 1/4 1/4 3/4 1/4 1/2 1/2 1 | 3/2 1/2 2"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :piano_lh_line, pitch: :intervals do
        anchor "Db2"
        intervals "0 +7 r +5 +2 +2 | -19 +7 +5 +3 +4 -2 -2 | -19 +7 +5 +4 | -14 +7 +5 +4 +1 +2 | [-26,-19,-14]{txt:l.v.} +16 +3 | -14 +12 r -10 +12 | -10 -2 -2 +2 | -7 +7 +5"
        rhythm    "1 1/2 1/2 3/4 1/4 1 | 1 1/3 1/3 1/3 1 1/2 1/2 | 3/2 1/2 1 1 | 1 1/2 1/2 3/4 1/4 1 | 2 1 1 | 1 1/2 1/2 1 1 | 3/2 1/2 1 1 | 1 1 2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :viola_line, pitch: :intervals do
        anchor "Ab3"
        intervals "r | r 0 +2 -2 -2 +2 +2 -2 -2 | -1 +1 -1 -2 +2 +1 -1 -2 r | r +5 +2 +2 +1 -1 -2 +2 +1 | 0 -1 -2 -2 +2 -2 -2 +2 +2 | +2 -2 -2 -2 -1 +1 +2 -2 -1 +1 +2 -5 +2 | +1 -1 +1 -3 | +2 -2 +2"
        rhythm    "4 | 1 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1/2 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1 | 1 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/2 1/2 1/2 1/2 1 | 1/2 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/2 1/2 | 3/4 1/4 2 1 | 3/2 1/2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "Db2"
        intervals "0 +2 +2 +1 +4 | 0 -2 -2 -1 -2 | +3 -5 -7 +4 | -2 +12 -2 -3 -3 | +1 +4 +3 +5 -5 | -2 -3 -2 -5 +4 | -2 +12 -2 -2 +2 -12 | +5 -5 +5"
        rhythm    "1 1/2 1/2 1 1 | 1 1 1 1/2 1/2 | 1 1 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1 | 1 1/2 1/2 1 1/2 1/2 | 3/2 1/2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
