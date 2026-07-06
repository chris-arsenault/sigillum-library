production_piece "Technique Card F1_REPEATED_PULSE - F1_REPEATED_PULSE" do
  meter "4/4"
  key "C"

# category: figuration
# card: F1_REPEATED_PULSE
# cite: keyboard_figuration s6b t2
# behavior: repeated-chord hammering, dynamics carry the phrase; pulse subdivides
#   q->8th->triplet->16th (measured-tremolo crest) as the dial turns, then breaks for the hit;
#   bass is a line

  roster do
    part :strings_rep, "Strings (rep.)", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "F1_REPEATED_PULSE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "repeated-chord hammering, dynamics carry the phrase; pulse subdivides q->8th->triplet->16th (measured-tremolo crest) as the dial turns, then breaks for the hit; bass is a line"

      phrase :strings_rep_line, surface: :split_pitch_rhythm do
        pitch_bars  "[Bb3,D4]{pp} [Bb3,D4] [Bb3,D4] [Bb3,D4] | [Bb3,D4]{p} [Bb3,D4]{p} [Bb3,D4]{p} [Bb3,D4]{p} [Bb3,D4]{p} [Bb3,D4]{p} [Bb3,D4]{p} [Bb3,D4]{p} | [A3,C4] [A3,C4] [A3,C4] [A3,C4] [A3,D4] [A3,D4] [A3,D4] [A3,D4] | [Bb3,D4]{mf} [Bb3,D4]{mf} [Bb3,D4]{mf} [Bb3,D4]{mf} [Bb3,D4]{mf} [Bb3,D4]{mf} [Bb3,Eb4] [Bb3,Eb4] [Bb3,Eb4] [Bb3,Eb4] [Bb3,Eb4] [Bb3,Eb4] | [A3,Eb4]{f} [A3,Eb4]{f} [A3,Eb4]{f} [A3,Eb4]{f} [A3,Eb4]{f} [A3,Eb4]{f} [A3,Eb4]{f} [A3,Eb4]{f} [A3,C4,F#4] [A3,C4,F#4] [A3,C4,F#4] [A3,C4,F#4] [A3,C4,F#4] [A3,C4,F#4] [A3,C4,F#4] [A3,C4,F#4] | [Bb3,D4,G4]{ff} [A3,C4,F#4] [Bb3,D4,G4]"
        rhythm_bars "1 1 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 1/3 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 2 1 1"
      end

      placement :strings_rep_line, part: :strings_rep, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{pp} -1 +1 | -5 +1 -1 -2 | +5 -2 -1 -2 | -2 +2 +2 +1 +1 | +1 +1 -4 -1 | -6 +7 +5"
        rhythm    "2 1 1 | 3/2 1/2 1 1 | 1 1 1 1 | 1 1/2 1/2 1 1 | 1 1 1 1 | 2 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
