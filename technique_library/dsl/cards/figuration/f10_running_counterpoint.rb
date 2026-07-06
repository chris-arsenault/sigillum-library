production_piece "Technique Card F10_RUNNING_COUNTERPOINT - F10_RUNNING_COUNTERPOINT" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 88", at: "bar 1 beat 1"
  end

# category: figuration
# card: F10_RUNNING_COUNTERPOINT
# cite: running_counterpoint
# behavior: a two-voice invention: imitative subject entry at a 1-bar delay, 16ths handed
#   between the voices, an EPISODE with BOTH voices running 16ths in contrary motion, invertible
#   counterpoint (subject swapped to the bass), a stretto, PAC -- running counterpoint

  roster do
    part :voice_1, "Voice 1", music21: "Piano", family: :keyboard, description: "Piano"
    part :voice_2, "Voice 2", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "F10_RUNNING_COUNTERPOINT", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a two-voice invention: imitative subject entry at a 1-bar delay, 16ths handed between the voices, an EPISODE with BOTH voices running 16ths in contrary motion, invertible counterpoint (subject swapped to the bass), a stretto, PAC -- running counterpoint"

      phrase :voice_1_line, pitch: :intervals do
        anchor "C5"
        intervals "0 +2 +2 +1 +2 -3 -4 +7 -2 -1 -2 +2 +1 +4 -2 -3 | -2 +2 +1 -3 +2 +1 +2 +2 -2 -3 | +3 -2 -1 -2 +2 -2 -2 -1 +1 -1 -2 -2 +2 -2 -2 -1 | +10 -2 -1 -2 +2 -2 -2 -2 +2 +2 +2 +1 +2 +2 +1 +2 | +2 -2 -2 +4 -2 -2 -1 -2 +2 -4 | +2 +2 +1 -3 -2 +2 +2 +1 -1 +3 | 0 +2 -2 -2 -1 +1 -1 -2 -2 +2 +2 +1 +2 -2 -1 -2 | +2 +3 -2 +4 -2 -2 -1 -2 0 -3 +3 -3 +1{ten}"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/2 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/2 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/2 | 1/2 1/2 1/2 1/2 1/4 1/4 1/4 1/4 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1"
      end

      placement :voice_1_line, part: :voice_1, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :voice_2_line, pitch: :intervals do
        anchor "C4"
        intervals "0 -1 +1 +2 +2 -4 -5 0 | +5 +2 +2 +1 +2 -3 -4 +7 -2 -1 -2 +2 +1 +4 -2 -3 | -4 +2 +2 +1 +2 +2 +2 +1 -10 +2 +1 +2 +2 +2 +1 +2 | -3 -2 -2 -2 -1 -2 -2 -1 +1 +2 +2 +1 +2 -7 -1 +1 | 0 +2 +2 +1 +2 -3 -4 -5 +2 +2 +1 +2 +2 -4 -5 -3 | +1 +2 +2 +2 +1 -3 -4 +4 -2 -2 -1 -2 +2 +3 +5 -5 | -3 +1 +2 +2 -2 +2 +2 +1 -1 +1 +2 +2 +1 -1 -2 -7 | +5 +4 -9 -2 +2 +4 -16 +5"
        rhythm    "1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :voice_2_line, part: :voice_2, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
