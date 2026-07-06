production_piece "Technique Card D9_REINFORCE_CONTRAST - D9_REINFORCE_CONTRAST" do
  meter "4/4"
  key "g"

  tempo do
    mark "quarter = 120", at: "bar 1 beat 1"
  end

# category: dialogue
# card: D9_REINFORCE_CONTRAST
# cite: complementary_rhythm
# behavior: a CLARINET lead + PIANO COMP that alternates REINFORCING the lead's played notes
#   (hitting/doubling WITH them) and CONTRASTING (answering in the lead's rests, moving against
#   a held note). The answer-in-the-gap technique at its strongest -- a wind melody (breath =
#   built-in gaps) over a comp that converses. NOT a piano-only device

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :piano_rh, "Piano RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :piano_lh, "Piano LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "D9_REINFORCE_CONTRAST", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a CLARINET lead + PIANO COMP that alternates REINFORCING the lead's played notes (hitting/doubling WITH them) and CONTRASTING (answering in the lead's rests, moving against a held note). The answer-in-the-gap technique at its strongest -- a wind melody (breath = built-in gaps) over a comp that converses. NOT a piano-only device"

      phrase :clarinet_line, pitch: :intervals do
        anchor "D5"
        intervals "r 0{mp,txt:clarinet_lead_--_syncopated_8ths_gaps_for_the_comp} +5 +3 -1 r -2 | -2 +2 -2 -2 -1 r | r 0 +1 +2 +2 +2 +1 | -1 r -4 -3 r | r +5 r +3 r -1 r -2 | -2 -2 -1 -2 +2 r | r 0 +3 +4 -2 r | 0 -2 -2 -1 -7"
        rhythm    "1/2 1/2 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1 | 1 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :piano_rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "r [Bb3,D4]{mp,txt:CONTRAST_--_comp_fills_the_gaps_(16ths/off-beats)} [Bb3,D4] r [Bb3,D4] [Bb3,D4] r | r [Eb4,G4] r [Eb4,G4] r [Eb4,G4] [Eb4,G4] r | [Bb3,D4]{txt:REINFORCE_--_drives_WITH_the_lead_s_8ths} [Bb3,D4] [C4,Eb4] [C4,Eb4] [D4,G4] r | [D4,F#4,A4]{txt:reinforce_the_peak_then_space} r [D4,F#4,A4] [D4,F#4,A4] r | r [Bb3,D4]{txt:CONTRAST_--_stabs_in_the_gaps_(hocket)} r [Bb3,D4] r [Bb3,D4] [C4,Eb4] r | [C4,Eb4]{txt:REINFORCE} [C4,Eb4] [Bb3,D4] [Bb3,D4] [A3,C4] r | r [F#3,C4]{txt:CONTRAST} [F#3,C4] r [F#3,C4] [F#3,C4] r | [Bb3,D4,G4]{txt:reinforce_the_cadence_+_fill} D4 Eb4 F#4 G4 [Bb3,D4,G4]"
        rhythm_bars "1/2 1/4 1/4 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 3/2 1/2 3/4 1/4 1 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/4 1/4 1/2 1/2 1 1 | 1 1/2 1/2 1/2 1/2 1"
      end

      placement :piano_rh_line, part: :piano_rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :piano_lh_line, pitch: :intervals do
        anchor "G2"
        intervals "0{mp} +7 +1 -1 | -11 +7 +5 -5 | -3 +7 -4 +4 | -12 +7 +5 -5 | -2 +7 +1 -1 | -14 +7 +8 -8 | -5 +7 +5 -5 | -2 +7 -7"
        rhythm    "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 2"
      end

      placement :piano_lh_line, part: :piano_lh, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
