production_piece "Technique Card FG3_STRETTO - FG3_STRETTO" do
  meter "4/4"
  key "G"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: fugue
# card: FG3_STRETTO
# cite: fugue_construction:7 stretto ; fugue_construction:1 canon-first subject design ; fugue_construction:8 pedal
# behavior: STRETTO built the correct way round: the subject was DESIGNED AS A SELF-CANON
#   FIRST (Prout 254 -- write the subject as a canon at the shortest intended distance,
#   then complete it), so its bar 2 is consonant counterpoint against its own bar 1 at the
#   octave, and every voice can carry the subject COMPLETE (stretto maestrale; the minimum
#   law is only that the LAST entering voice completes the subject). Bar 1-2: the subject
#   alone (violin). Bars 3-5: FIRST STRETTO, two voices at one bar's distance (viola leads
#   at the lower octave, violin replies), the leader continuing into a free tail. Bars
#   6-9: SECOND STRETTO -- cumulative interest by MORE VOICES, not just closer time: three
#   entries at one bar's distance stacked bottom-up (cello, viola, violin), and from bar 8
#   the cello, its statement complete, drops to a re-struck DOMINANT PEDAL in the subject's
#   own lilt rhythm -- "close stretti built above a pedal" -- while the viola descends to
#   the leading tone. The whole passage stays in tonic/dominant harmony (the old masters
#   rarely modulate in a very close stretto; entries may be at any interval, here octaves).
#   Bar 10 seals V-I. Swap key, subject, and spacing freely; keep the canon-first design,
#   the completion rule, and the cumulative escalation.

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FG3_STRETTO", bars: 1..10, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "two stretti of the same subject, the second more voices over a pedal, all entries complete"

    span bars: 1..10, texture: :library_card do
      process "subject alone (violin b1-2, built as a self-canon at the octave at one bar) -> stretto 1 (b3-5): viola leads an octave down, violin replies at one bar, viola continues free -> breath -> stretto 2 (b6-9): cello, viola, violin pile up at one bar each, every entry complete; the cello finishes and locks a re-struck D pedal under the last statement, viola sinks to F# -> V-I seal (b10). Cumulative stretto law: later stretti in more parts or at shorter distance; last voice always completes the subject."

      phrase :fg3_subject_statement, pitch: :degrees do
        key_context "G4"
        degrees "1 3 2 5 4 3 | 6 5 6 3 2 1"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 .5 .5"
      end

      placement :fg3_subject_statement, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "the subject alone: lilt head, saved leap to 6, running close"

      phrase :fg3_stretto_a_viola, pitch: :degrees do
        key_context "G3"
        degrees "1 3 2 5 4 3 | 6 5 6 3 2 1"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 .5 .5"
      end

      placement :fg3_stretto_a_viola, part: :viola, at: "bar 3 beat 1", role: :specimen, realization: "stretto 1 leader, lower octave"

      phrase :fg3_stretto_a_violin, pitch: :degrees do
        key_context "G4"
        degrees "1 3 2 5 4 3 | 6 5 6 3 2 1"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 .5 .5"
      end

      placement :fg3_stretto_a_violin, part: :violin, at: "bar 4 beat 1", role: :specimen, realization: "stretto 1 reply at one bar's distance: subject against its own second bar"

      phrase :fg3_stretto_a_viola_tail, pitch: :degrees do
        key_context "G3"
        degrees "4 3 5 4 3"
        rhythm  "1 1 1 .5 .5"
      end

      placement :fg3_stretto_a_viola_tail, part: :viola, at: "bar 5 beat 1", role: :specimen, realization: "the leader, complete, continues in free counterpoint under the reply"

      phrase :fg3_stretto_b_cello, pitch: :degrees do
        key_context "G2"
        degrees "1 3 2 5 4 3 | 6 5 6 3 2 1"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 .5 .5"
      end

      placement :fg3_stretto_b_cello, part: :violoncello, at: "bar 6 beat 1", role: :specimen, realization: "stretto 2: the bass announces the new group alone"

      phrase :fg3_stretto_b_viola, pitch: :degrees do
        key_context "G3"
        degrees "1 3 2 5 4 3 | 6 5 6 3 2 1"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 .5 .5"
      end

      placement :fg3_stretto_b_viola, part: :viola, at: "bar 7 beat 1", role: :specimen, realization: "second entry, one bar later"

      phrase :fg3_stretto_b_violin, pitch: :degrees do
        key_context "G4"
        degrees "1 3 2 5 4 3 | 6 5 6 3 2 1"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 .5 .5"
      end

      placement :fg3_stretto_b_violin, part: :violin, at: "bar 8 beat 1", role: :specimen, realization: "last entry, complete over the pedal: the completion rule made audible"

      phrase :fg3_free_violin_b7, pitch: :degrees do
        key_context "G4"
        degrees "3 1 6,"
        rhythm  "1 2 1"
      end

      placement :fg3_free_violin_b7, part: :violin, at: "bar 7 beat 1", role: :specimen, realization: "quiet free descent before the violin's own entry"

      phrase :fg3_pedal_cello, pitch: :degrees do
        key_context "G2"
        degrees "5 5 5 5 5 5 | 5, 5, 5, 5, 5,"
        rhythm  "1 .5 .5 1 .5 .5 | 1 .5 .5 1 1"
      end

      placement :fg3_pedal_cello, part: :violoncello, at: "bar 8 beat 1", role: :specimen, realization: "dominant pedal re-struck in the subject's lilt rhythm, dropping an octave into the cadence"

      phrase :fg3_free_viola_b9, pitch: :degrees do
        key_context "G3"
        degrees "4 3 1 7,"
        rhythm  "1 1 1 1"
      end

      placement :fg3_free_viola_b9, part: :viola, at: "bar 9 beat 1", role: :specimen, realization: "inner voice sinks to the leading tone against the pedal"

      phrase :fg3_cadence_violin, pitch: :degrees do
        key_context "G4"
        degrees "3 2 1"
        rhythm  ".5 .5 3"
      end

      placement :fg3_cadence_violin, part: :violin, at: "bar 10 beat 1", role: :specimen, realization: "cadence top"

      phrase :fg3_cadence_viola, pitch: :degrees do
        key_context "G3"
        degrees "1 2 3"
        rhythm  ".5 .5 3"
      end

      placement :fg3_cadence_viola, part: :viola, at: "bar 10 beat 1", role: :specimen, realization: "leading tone resolves, inner voice settles on the third"

      phrase :fg3_cadence_cello, pitch: :degrees do
        key_context "G2"
        degrees "1 1' 5 1"
        rhythm  "1 .5 .5 2"
      end

      placement :fg3_cadence_cello, part: :violoncello, at: "bar 10 beat 1", role: :specimen, realization: "bass seal"

    end
  end
end
