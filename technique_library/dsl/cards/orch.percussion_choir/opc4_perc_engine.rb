production_piece "Technique Card OPC4_PERC_ENGINE - OPC4_PERC_ENGINE" do
  meter "3/4"
  key "D"

  tempo do
    mark "quarter = 120", at: "bar 1 beat 1"
  end

# category: orch.percussion_choir
# card: OPC4_PERC_ENGINE
# cite: orchestration_techniques:percussion_choir
# behavior: war-drum/march ostinato: a dry snare states an INVARIANT 1-bar cell as the rhythmic
#   engine, unchanged all 8 bars; pp->ff by accretion (bass-drum tread + Vc pizz double the cell
#   + a grim horn tune rides above + timp war-drum; tutti+trumpet beat the SAME cell ff in
#   unison) - the rhythm is the subject, it propels

  roster do
    part :snare, "Snare", music21: "Percussion", family: :other, description: "Percussion"
    part :bass_drum, "Bass Drum", music21: "Percussion", family: :other, description: "Percussion"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "OPC4_PERC_ENGINE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "war-drum/march ostinato: a dry snare states an INVARIANT 1-bar cell as the rhythmic engine, unchanged all 8 bars; pp->ff by accretion (bass-drum tread + Vc pizz double the cell + a grim horn tune rides above + timp war-drum; tutti+trumpet beat the SAME cell ff in unison) - the rhythm is the subject, it propels"

      phrase :snare_line, surface: :split_pitch_rhythm do
        pitch_bars  "E5{pp,txt:snare_dry_INVARIANT_cell_-_rhythm_is_the_subject} E5 E5 E5 E5 E5 E5 | E5 E5 E5 E5 E5 E5 E5 | E5{p} E5 E5 E5 E5 E5 E5 | E5 E5 E5 E5 E5 E5 E5 | E5{mf,cresc(} E5 E5 E5 E5 E5 E5 | E5{f} E5 E5 E5 E5 E5 E5{cresc)} | E5{ff,marc,txt:tutti_beats_the_SAME_cell} E5 E5 E5 E5 E5 E5 | E5{ff,marc} E5 E5 E5 E5 E5 E5"
        rhythm_bars "1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2"
      end

      placement :snare_line, part: :snare, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_drum_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:bass_drum_-_tacet} | r | C2{mp,txt:bass_drum_-_heavy_tread_on_beat_1} r | C2 r | C2{mf} r | C2{f} r | C2{ff,marc} r | C2{ff,marc} r"
        rhythm_bars "3 | 3 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2 | 1 2"
      end

      placement :bass_drum_line, part: :bass_drum, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:timp_D+A_-_tacet} | r | r | r | A2{mf,cresc(,txt:timp_doubles_the_cell} A2 A2 A2 A2 A2 A2 | A2{f} A2 A2 A2 A2 A2 A2{cresc)} | D2{ff,marc} D2 D2 D2 D2 A2 A2 | D2{ff,marc} D2 D2 D2 D2 A2{marc}"
        rhythm_bars "3 | 3 | 3 | 3 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:Hn_-_tacet} | r | D4{mp,txt:horn_-_grim_march-tune_rides_the_drive} F4 | E4 D4 | F4{mf,cresc(} G4 A4 | A4 G4{cresc)} | A4{ff,marc} D5 | D5{marc} C#5 D5"
        rhythm_bars "3 | 3 | 2 1 | 2 1 | 1 1 1 | 2 1 | 1 2 | 1 1 1"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r{txt:Tpt_-_reserved} | r | r | r | r | r | D5{ff,marc,txt:trumpet_crowns_the_tutti_cell} D5 D5 D5 D5 A5 A5 | D5{ff,marc} D5 D5 D5 D5 A5{marc}"
        rhythm_bars "3 | 3 | 3 | 3 | 3 | 3 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "r{txt:Vc_-_tacet} | r | 0{p,txt:Vc_pizz_-_double_the_cell_(menace)} 0 0 0 0 +7 0 | -7 0 0 0 0 +7 0 | -7{mf,cresc(} 0 0 0 0 +7 0 | -12{f} 0 0 0 0 +12 0{cresc)} | -7{ff,marc,txt:arco} 0 0 0 0 +7 0 | -7{ff,marc} 0 0 0 0 +7{marc}"
        rhythm    "3 | 3 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1/2 1/2 | 1 1/4 1/4 1/4 1/4 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
