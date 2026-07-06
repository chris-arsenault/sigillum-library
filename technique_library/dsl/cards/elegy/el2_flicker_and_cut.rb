production_piece "Technique Card EL2_FLICKER_AND_CUT - EL2_FLICKER_AND_CUT" do
  meter "4/4"
  key "C"

# category: elegy
# card: EL2_FLICKER_AND_CUT
# cite: keyboard_figuration s6d (interruption/cut fabric)
# behavior: the lead voice speaks in cells WITH rests; a second voice creeps in FLICKERS (short
#   touches in the lead's rests, never held against it); the cello borrows and augments the
#   lead's tail; a dissonance names itself in ONE strike-instant -> the texture CUTS -> silence
#   -> the lead restarts alone, pure tonic (named simplicity)

  roster do
    part :celesta, "Celesta", music21: "Celesta", family: :keyboard, description: "Celesta"
    part :violin_gather, "Violin (gather)", music21: "Violin", family: :string, description: "Violin"
    part :cello_song, "Cello (song)", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "EL2_FLICKER_AND_CUT", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "the lead voice speaks in cells WITH rests; a second voice creeps in FLICKERS (short touches in the lead's rests, never held against it); the cello borrows and augments the lead's tail; a dissonance names itself in ONE strike-instant -> the texture CUTS -> silence -> the lead restarts alone, pure tonic (named simplicity)"

      phrase :celesta_line, pitch: :intervals do
        anchor "Db5"
        intervals "0 +4 +3 -3 -4 +4 +2 -1 -1 | -4 +4 r -4 +4 r | -4 +4 +3 -2 r 0 -1 | r -4 +4 r -4 +4 r | -4 r +4 r +3 r -2 r -1 r -2 r | r -2{pp} +4 +3 -3"
        rhythm    "1/2 1/2 1/2 1/2 1/2 1/2 1/4 1/4 1/2 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1/4 1/4 3/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1/4 1/4 1/4 1/4 1/4 3/4 1/4 1/4 1/4 1/4 1/4 3/4 | 2 1/2 1/2 1/2 1/2"
      end

      placement :celesta_line, part: :celesta, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violin_gather_line, pitch: :intervals do
        anchor "Bb4"
        intervals "r | r 0 +2 r 0 +1 | r -1 -1 +1 r | 0 r +2 -1 -1 | r 0 r +2 r 0 r -2 +2 -7 +7 | [0,+5]{ff,marc} r"
        rhythm    "4 | 1 3/4 1/4 1 3/4 1/4 | 1/2 1 1/2 1/2 3/2 | 1 1/2 1/2 1 1 | 1/4 1/4 1/4 1/4 1/2 1/4 1/4 1/2 1/2 1/2 1/2 | 1/2 7/2"
      end

      placement :violin_gather_line, part: :violin_gather, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :cello_song_line, pitch: :intervals do
        anchor "Db3"
        intervals "r 0 -1 -2 | -2 -2 -1 +1 -1 -2 | -2 +6 -1 | -1 -2 -2 -1 +1 | +4 +1 +1 +1 +1 r +1 +2 +1 | -12 r"
        rhythm    "2 3/4 1/4 1 | 3/2 1/2 1/3 1/3 1/3 1 | 1 1 2 | 3/4 1/4 1/2 1/2 2 | 1/2 1/2 1/2 1/2 1/4 1/4 1/2 1/2 1/2 | 1/2 7/2"
      end

      placement :cello_song_line, part: :cello_song, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
