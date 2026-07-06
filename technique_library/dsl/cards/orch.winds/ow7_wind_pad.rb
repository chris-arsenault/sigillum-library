production_piece "Technique Card OW7_WIND_PAD - OW7_WIND_PAD" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW7_WIND_PAD
# cite: orchestration_techniques:winds
# behavior: breathing wind pad: Fl/Bsn hold the outer frame (staggered re-breaths, real <>
#   swells), Ob+Cl animate inside with stepwise neighbors + 9-8/4-3 suspensions on a slow IV-I
#   plagal hover (add9); supports a soft Vln melody; never a dead held chord

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
  end

  section :card, "OW7_WIND_PAD", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "breathing wind pad: Fl/Bsn hold the outer frame (staggered re-breaths, real <> swells), Ob+Cl animate inside with stepwise neighbors + 9-8/4-3 suspensions on a slow IV-I plagal hover (add9); supports a soft Vln melody; never a dead held chord"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{pp,txt:cresc.} | C5{txt:dim.} | C5{pp,txt:riprende,txt:cresc.} | C5{txt:dim.} | C5{pp,txt:riprende,txt:cresc.} | C5{txt:dim.} | D5{pp,txt:riprende,txt:cresc.} | C5{txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{pp,txt:cresc.} G4{txt:dim.} | A4 Bb4{txt:cresc.} | Bb4{pp,txt:susp,txt:dim.} A4 | A4 G4{txt:dim.} | A4{pp,txt:cresc.} Bb4 | A4{txt:dim.} G4 | Bb4{pp,txt:susp_4-3,txt:cresc.} A4{txt:dim.} | A4{p,txt:cresc.,txt:dim.}"
        rhythm_bars "3 1 | 2 2 | 2 2 | 2 2 | 3 1 | 2 2 | 2 2 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp} | G4{txt:cresc.} F4{txt:dim.} | F4{pp,txt:riprende} | E4{txt:cresc.} D4{txt:dim.} | F4{pp,txt:riprende} | G4{txt:cresc.} E4{txt:dim.} | F4{pp,txt:9-8,txt:cresc.} E4{txt:dim.} | F4{p,txt:cresc.,txt:dim.}"
        rhythm_bars "4 | 2 2 | 4 | 2 2 | 4 | 2 2 | 2 2 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "F3{pp,txt:cresc.} | F3{txt:dim.} | Bb2{pp,txt:riprende,txt:cresc.} | Bb2{txt:dim.} | F3{pp,txt:riprende,txt:cresc.} | F3{txt:dim.} | Bb2{pp,txt:riprende,txt:cresc.} | F3{p,txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_line, surface: :split_pitch_rhythm do
        pitch_bars  "F5{p,txt:espress.,txt:cresc.} G5 A5{txt:dim.} | G5 F5 | D5{txt:cresc.} F5{txt:dim.} | E5{txt:dolce} | F5{txt:cresc.} A5{txt:dim.} | G5 F5 | E5{txt:cresc.} D5{txt:dim.} | F5{p,txt:morendo}"
        rhythm_bars "2 1 1 | 3 1 | 2 2 | 4 | 2 2 | 3 1 | 2 2 | 4"
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
