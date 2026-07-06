production_piece "Technique Card OPC6_UNPITCHED_STINGER - OPC6_UNPITCHED_STINGER" do
  meter "4/4"
  key "c"

  tempo do
    mark "quarter = 126", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC6_UNPITCHED_STINGER
# cite: orchestration_techniques:percussion_choir
# behavior: dry orchestral stabs punctuated by decisive un-pitched stingers
#   (B.D.+crash+snare+tam-tam) on the impact beats - exact rests around each hit so it lands in
#   clean air; an empty bar and a held-back bar set up a final fff stinger that buttons it and
#   rings l.v.

  roster do
    part :bass_drum, "Bass Drum", music21: "BassDrum", family: :percussion, description: "BassDrum"
    part :crash_cymbals, "Crash Cymbals", music21: "Cymbals", family: :percussion, description: "Cymbals"
    part :snare_drum, "Snare Drum", music21: "SnareDrum", family: :percussion, description: "SnareDrum"
    part :tam_tam, "Tam-tam", music21: "TamTam", family: :percussion, description: "TamTam"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
  end

  section :card, "OPC6_UNPITCHED_STINGER", bars: 1..7, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..7, texture: :library_card do
      process "dry orchestral stabs punctuated by decisive un-pitched stingers (B.D.+crash+snare+tam-tam) on the impact beats - exact rests around each hit so it lands in clean air; an empty bar and a held-back bar set up a final fff stinger that buttons it and rings l.v."

      phrase :bass_drum_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{txt:sff,txt:STINGER_1_-_B.D.+crash+snare+tam-tam_decisive_impact} r | r C2{ff,txt:bite_-_B.D.+snare} | C2{txt:sff,txt:STINGER_2_-_impact} r | r{txt:the_empty_bar_-_dry_silence} | C2{txt:sff,txt:double-stab} r C2{txt:sff} r | r{txt:held_back} | C2{fff,txt:FINAL_STINGER_-_button_it} r"
        rhythm_bars "1 3 | 3 1 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :bass_drum_line, part: :bass_drum, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :crash_cymbals_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{txt:sff,txt:crash_cym_-_secco_impact} r | r | C2{txt:sff,txt:crash} r | r | C2{txt:sff,txt:crash} r C2{txt:sff} r | r | C2{fff,txt:crash_-_final} r"
        rhythm_bars "1 3 | 4 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :crash_cymbals_line, part: :crash_cymbals, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :snare_drum_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{txt:sff,txt:snare_-_sharp_transient_on_the_impact} r | r C2{ff} C2 | C2{txt:sff} r | r | C2{txt:sff} r C2{txt:sff} r | r C2{mf,txt:soft_snare_upbeat_into_the_button} C2{cresc(} | C2{fff,marc,cresc),txt:snare_-_final_hit} r"
        rhythm_bars "1 3 | 3 1/2 1/2 | 1 3 | 4 | 1 1 1 1 | 3 1/2 1/2 | 1 3"
      end

      placement :snare_drum_line, part: :snare_drum, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :tam_tam_line, surface: :split_pitch_rhythm do
        pitch_bars  "C1{txt:sff,txt:tam-tam_-_bloom_on_impact_1_l.v.} r | r | C1{txt:sff,txt:tam-tam_l.v.} r | r C1{mf,txt:lone_tam-tam_swell_into_the_void_l.v.} | r | r | C1{fff,txt:tam-tam_-_FINAL_soft_heavy_beater_ring_l.v._to_the_end}"
        rhythm_bars "1 3 | 4 | 1 3 | 2 2 | 4 | 4 | 4"
      end

      placement :tam_tam_line, part: :tam_tam, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C5,G5]{ff,marc,txt:stabbed_chord_-_i_on_the_impact} r | r [Ab4,C5]{f,marc,txt:off-impact_answer_(VI)} r | [C5,G5]{ff,marc} r | r | [Bb4,D5]{ff,marc,txt:stab_(VII)} r [C5,Eb5]{ff,marc,txt:stab_(i)} r | r | [C5,G5,C6]{fff,marc,txt:FINAL_chord_-_tonic} r{txt:into_the_ring} r"
        rhythm_bars "1 3 | 1 1 2 | 1 3 | 4 | 1 1 1 1 | 4 | 1 1 2"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C3,G3]{ff,marc} r | r [Ab2,Eb3]{f,marc} r | [C3,G3]{ff,marc} r | r | [Bb2,F3]{ff,marc} r [C3,G3]{ff,marc} r | r | [C3,G3]{fff,marc} r"
        rhythm_bars "1 3 | 1 1 2 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "[G3,C4]{ff,marc} r | r [C4,Ab4]{f,marc} r | [G3,C4]{ff,marc} r | r | [D4,F4]{ff,marc} r [C4,Eb4]{ff,marc} r | r | [C4,Eb4,G4]{fff,marc} r"
        rhythm_bars "1 3 | 1 1 2 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "[C5,Eb5]{ff,marc,txt:string_stab_dig_in} r | r [C5,Ab5]{f,marc} r | [C5,Eb5]{ff,marc} r | r | [D5,Bb5]{ff,marc} r [Eb5,C6]{ff,marc} r | r | [Eb5,C6]{fff,marc} C6{txt:ring_out_-_sustain_the_tonic_over_the_tam-tam}"
        rhythm_bars "1 3 | 1 1 2 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "C2"
        intervals "0{ff,marc,txt:cello/bass_root_on_the_impact} r | r +8{f,marc} r | -8{ff,marc} r | r | -2{ff,marc} r +2{ff,marc} r | r | 0{fff,marc} 0{txt:hold_the_floor_under_the_ring}"
        rhythm    "1 3 | 1 1 2 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{ff,marc,txt:timp_C+G_-_reinforce_the_impact_root} r | r | C2{ff,marc} r | r | G2{ff,marc} r C2{ff,marc} r | r | C2{fff,marc} C2{trem,txt:short_tonic_roll_under_the_final_ring}"
        rhythm_bars "1 3 | 4 | 1 3 | 4 | 1 1 1 1 | 4 | 1 3"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
