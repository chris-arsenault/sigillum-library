production_piece "Technique Card FG1_EXPOSITION - FG1_EXPOSITION" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: fugue
# card: FG1_EXPOSITION
# cite: fugue_construction:4 exposition assembly ; fugue_construction:2 tonal answer ; fugue_construction:3 countersubject
# behavior: a complete THREE-VOICE FUGAL EXPOSITION with a TONAL ANSWER and a recurring,
#   invertible COUNTERSUBJECT. The subject (viola, b1-2) opens with the tonic-dominant leap
#   1->5 -- exactly the head shape that FORCES a tonal answer: the answer (violin, b3-4)
#   replies 5->1' (the early dominant is answered by the TONIC, up a fourth not a fifth,
#   so the key is not undermined), and only AFTER the head does it become a plain
#   transposition to the dominant (#4' = the F# of G major). The degree notation makes the
#   adjustment visible: subject "1 5 3 4..." vs answer "5 1' 7 1'...". The countersubject
#   enters under the answer (viola, b3-4) in the DOMINANT key with ONE head-zone note
#   adjusted (Prout's sanctioned license), moving in quarters against the answer's eighths
#   -- complementary value classes -- and keeping beats to 3rds/6ths/octaves so it INVERTS
#   cleanly: in b6-7 the same countersubject line returns ABOVE the bass entry (violin, in
#   parallel-10th chains that were 6ths when it sat below). A one-bar CODETTA (b5, built
#   from the subject's descending tail over falling-third quarters, F-natural cancelling
#   the dominant's F#) modulates back to C for the bass entry. Bar 8 closes with a
#   rhythmically alive V7-I, every entry preceded by a rest or approached by leap. The
#   essential technique is the S-A-S entry engine with tonal head adjustment + invertible
#   countersubject; swap the key, subject, and forces freely.

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FG1_EXPOSITION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "three entries, one tonal answer, one countersubject heard below then above"

    span bars: 1..8, texture: :library_card do
      process "subject alone (viola b1-2, head 1->5) -> tonal answer (violin b3-4, head 5->1', then real transposition with #4) over the countersubject in the dominant (viola, one head-zone note adjusted) -> codetta (b5, subject tail sequenced over falling thirds, F-natural pivots home) -> bass entry (cello b6-7, subject in C) under the SAME countersubject now INVERTED above it (violin, 10ths that were 6ths) with a free inner voice (viola) -> rhythmic V7-I close (b8). The S-A-S engine, the tonal head answer, and the invertible countersubject are the technique; key, forces, and the tune itself are interchangeable."

      phrase :fg1_subject, pitch: :degrees do
        key_context "C4"
        degrees "1 5 3 4 5 6 7 | 1' 7 6 5 4 3 2"
        rhythm  "1 .5 .5 .5 .5 .5 .5 | .5 .5 .5 .5 .5 .5 1"
      end

      placement :fg1_subject, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "subject statement, degrees expose the 1->5 head"

      phrase :fg1_answer, pitch: :degrees do
        key_context "C4"
        degrees "5 1' 7 1' 2' 3' #4' | 5' #4' 3' 2' 1' 7 6"
        rhythm  "1 .5 .5 .5 .5 .5 .5 | .5 .5 .5 .5 .5 .5 1"
      end

      placement :fg1_answer, part: :violin, at: "bar 3 beat 1", role: :specimen, realization: "tonal answer: 5->1' head, then real transposition to the dominant"

      phrase :fg1_countersubject_below, pitch: :degrees do
        key_context "C4"
        degrees "7, 1 1 3 5 | 7 5 3 #4"
        rhythm  ".5 .5 1 1 1 | 1 1 1 1"
      end

      placement :fg1_countersubject_below, part: :viola, at: "bar 3 beat 1", role: :specimen, realization: "countersubject below the answer, dominant key, head-zone note adjusted"

      phrase :fg1_codetta_upper, pitch: :degrees do
        key_context "C4"
        degrees "3' 2' 1' 7 6 5 4"
        rhythm  ".5 .5 .5 .5 .5 .5 1"
      end

      placement :fg1_codetta_upper, part: :violin, at: "bar 5 beat 1", role: :specimen, realization: "codetta: subject tail sequenced down, F-natural cancels the dominant"

      phrase :fg1_codetta_lower, pitch: :degrees do
        key_context "C4"
        degrees "1 6, 4, 5,"
        rhythm  "1 1 1 1"
      end

      placement :fg1_codetta_lower, part: :viola, at: "bar 5 beat 1", role: :specimen, realization: "codetta floor: falling thirds to the dominant"

      phrase :fg1_subject_bass, pitch: :degrees do
        key_context "C3"
        degrees "1 5 3 4 5 6 7 | 1' 7 6 5 4 3 2"
        rhythm  "1 .5 .5 .5 .5 .5 .5 | .5 .5 .5 .5 .5 .5 1"
      end

      placement :fg1_subject_bass, part: :violoncello, at: "bar 6 beat 1", role: :specimen, realization: "bass entry: subject in the tonic"

      phrase :fg1_countersubject_above, pitch: :degrees do
        key_context "C4"
        degrees "3 4 5 6 1' | 3' 1' 6 7"
        rhythm  ".5 .5 1 1 1 | 1 1 1 1"
      end

      placement :fg1_countersubject_above, part: :violin, at: "bar 6 beat 1", role: :specimen, realization: "the same countersubject INVERTED above the subject: 6ths become 10ths"

      phrase :fg1_inner_free, pitch: :degrees do
        key_context "C4"
        degrees "r 7, 6, 1 | r 3 4"
        rhythm  "1 1 1 1 | 1 1 2"
      end

      placement :fg1_inner_free, part: :viola, at: "bar 6 beat 1", role: :specimen, realization: "free inner voice: enters after rests, then prepares the 4-3 suspension into the cadence"

      phrase :fg1_cadence_violin, pitch: :degrees do
        key_context "C4"
        degrees "2' 7 1'"
        rhythm  "1 1 2"
      end

      placement :fg1_cadence_violin, part: :violin, at: "bar 8 beat 1", role: :specimen, realization: "cadence top: 2-7-1 over V7-I"

      phrase :fg1_cadence_viola, pitch: :degrees do
        key_context "C4"
        degrees "4 3"
        rhythm  "2 2"
      end

      placement :fg1_cadence_viola, part: :viola, at: "bar 8 beat 1", role: :specimen, realization: "cadence inner voice: the prepared F re-struck as the seventh of V7, resolving 4-3"

      phrase :fg1_cadence_cello, pitch: :degrees do
        key_context "C3"
        degrees "5, 5 1"
        rhythm  "1 1 2"
      end

      placement :fg1_cadence_cello, part: :violoncello, at: "bar 8 beat 1", role: :specimen, realization: "cadence bass: octave kick into the tonic"

    end
  end
end
