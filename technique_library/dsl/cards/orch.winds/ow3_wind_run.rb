production_piece "Technique Card OW3_WIND_RUN - OW3_WIND_RUN" do
  meter "2/4"
  key "D"

  tempo do
    mark "quarter = 152", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW3_WIND_RUN
# cite: orchestration_techniques:winds
# behavior: one continuous virtuosic D-major 16th run dovetailed Bsn->Cl->Fl rising and back,
#   2-note overlap at every handoff (the union = one unbroken brilliant line), leapt-to E6 apex
#   over a light fast pizz cello bass; Allegro vivace leggiero

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "OW3_WIND_RUN", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "one continuous virtuosic D-major 16th run dovetailed Bsn->Cl->Fl rising and back, 2-note overlap at every handoff (the union = one unbroken brilliant line), leapt-to E6 apex over a light fast pizz cello bass; Allegro vivace leggiero"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r G5{f} A5 | B5 C#6 D6 E6 D6 C#6 B5 A5 | G5 F#5 r | r | D6{f}"
        rhythm_bars "2 | 3/2 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 3/2 | 2 | 2"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | F#5{f}"
        rhythm_bars "2 | 2 | 2 | 2 | 2 | 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r D4{mf} E4 | F#4 G4 A4 B4 C#5 D5 E5 F#5 | r | E5{mf} D5 C#5 B4 A4 G4 F#4 E4 | r | r"
        rhythm_bars "3/2 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 2 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 2 | 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{mf} E3 F#3 G3 A3 B3 A3 C#4 | r | r | r F#3{mf} E3 | D3 C#3 D3 E3 F#3 G3 A3 A2 | D3{f}"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 2 | 2 | 3/2 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0{mf,txt:pizz.} +7 +5 -5 | -7 +7 +2 -2 | 0 +7 -7 +4 | -4 +7 -9 +9 | -7 -5 +5 0 | -7{f} 0"
        rhythm    "1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 | 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
