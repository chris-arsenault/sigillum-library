production_piece "Technique Card OV6_BLOCK_PLANING - OV6_BLOCK_PLANING" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 50", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV6_BLOCK_PLANING
# cite: orchestration_techniques:chord_voicing
# behavior: one fixed dom-9th spread voicing (R-5-7-9-3 low->high) planed chromatically by the
#   full block in lockstep - every voice moves the same interval each bar, spacing/doubling
#   fixed; bottom octave bare 5th/8ve so no 3rd ever drops below the limit; color motion, not
#   voice-leading

  roster do
    part :crown_3rd, "Crown 3rd", music21: "Flute", family: :woodwind, description: "Flute"
    part :p_3rd_8ve_under, "3rd 8ve under", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :p_9th_upper, "9th upper", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :p_7th_inner, "7th inner", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :p_9th_top_str, "9th top str", music21: "Violin", family: :string, description: "Violin"
    part :p_7th_str, "7th str", music21: "Violin", family: :string, description: "Violin"
    part :p_3rd_alto, "3rd alto", music21: "Violin", family: :string, description: "Violin"
    part :p_7th_tenor, "7th tenor", music21: "Viola", family: :string, description: "Viola"
    part :p_5th_tenor, "5th tenor", music21: "Horn", family: :brass, description: "Horn"
    part :shell_root, "shell root", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :shell_5th, "shell 5th", music21: "Violoncello", family: :string, description: "Violoncello"
    part :shell_floor, "shell floor", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OV6_BLOCK_PLANING", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one fixed dom-9th spread voicing (R-5-7-9-3 low->high) planed chromatically by the full block in lockstep - every voice moves the same interval each bar, spacing/doubling fixed; bottom octave bare 5th/8ve so no 3rd ever drops below the limit; color motion, not voice-leading"

      phrase :crown_3rd_line, pitch: :degrees do
        key_context "C5"
        degrees "3{p} | 2 | 1 | #1 | b3 | 3"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :crown_3rd_line, part: :crown_3rd, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_3rd_8ve_under_line, pitch: :degrees do
        key_context "C4"
        degrees "3{p} | 2 | 1 | #1 | b3 | 3"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_3rd_8ve_under_line, part: :p_3rd_8ve_under, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_9th_upper_line, pitch: :degrees do
        key_context "C4"
        degrees "2{p} | 1 | b7, | 7, | #1 | 2"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_9th_upper_line, part: :p_9th_upper, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_7th_inner_line, pitch: :degrees do
        key_context "C3"
        degrees "b7{p} | b6 | #4 | 5 | 6 | b7"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_7th_inner_line, part: :p_7th_inner, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_9th_top_str_line, pitch: :degrees do
        key_context "C5"
        degrees "2{p} | 1 | b7, | 7, | #1 | 2"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_9th_top_str_line, part: :p_9th_top_str, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_7th_str_line, pitch: :degrees do
        key_context "C4"
        degrees "b7{p} | b6 | #4 | 5 | 6 | b7"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_7th_str_line, part: :p_7th_str, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_3rd_alto_line, pitch: :degrees do
        key_context "C4"
        degrees "3{p} | 2 | 1 | #1 | b3 | 3"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_3rd_alto_line, part: :p_3rd_alto, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_7th_tenor_line, pitch: :degrees do
        key_context "C3"
        degrees "b7{p} | b6 | #4 | 5 | 6 | b7"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_7th_tenor_line, part: :p_7th_tenor, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :p_5th_tenor_line, pitch: :degrees do
        key_context "C3"
        degrees "5{p} | 4 | b3 | 3 | #4 | 5"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :p_5th_tenor_line, part: :p_5th_tenor, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :shell_root_line, pitch: :degrees do
        key_context "C3"
        degrees "1{p} | b7, | b6, | 6, | 7, | 1"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :shell_root_line, part: :shell_root, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :shell_5th_line, pitch: :degrees do
        key_context "C2"
        degrees "5{p} | 4 | b3 | 3 | #4 | 5"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :shell_5th_line, part: :shell_5th, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :shell_floor_line, pitch: :degrees do
        key_context "C2"
        degrees "1{p} | b7, | b6, | 6, | 7, | 1"
        rhythm  "4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :shell_floor_line, part: :shell_floor, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
