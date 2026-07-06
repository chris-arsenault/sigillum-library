production_piece "Technique Card OW5_SOLO_WIND - OW5_SOLO_WIND" do
  meter "4/4"
  key "d"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: orch.winds
# card: OW5_SOLO_WIND
# cite: orchestration_techniques:winds
# behavior: solo oboe sings an exposed lyric line in its plaintive middle/upper register (one
#   apex, breath-shaped) over a cleared minimal accompaniment - sustained clarinet chord-tone w/
#   one neighbor drift, bassoon anchor, cello pizz on beats 1&3; nothing in the solo's register

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "OW5_SOLO_WIND", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "solo oboe sings an exposed lyric line in its plaintive middle/upper register (one apex, breath-shaped) over a cleared minimal accompaniment - sustained clarinet chord-tone w/ one neighbor drift, bassoon anchor, cello pizz on beats 1&3; nothing in the solo's register"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "A4{p,txt:espr.} D5 E5 F5 | E5 D5 r | F5 G5 A5 G5 | Bb5{mf} A5 G5 | F5 E5 D5 C5 | D5{p} A4 r"
        rhythm_bars "3/2 1 1 1/2 | 2 1 1 | 1 1 3/2 1/2 | 2 1 1 | 3/2 1/2 1 1 | 2 1 1"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{pp} | F4 | A4 | Bb4{p} A4 | A4 | A4 F4"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 2 2"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{pp} | Bb2 | F2 | G2{p} A2 | D3 C3 | D3 r"
        rhythm_bars "4 | 4 | 4 | 2 2 | 2 2 | 3 1"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D2"
        intervals "0{p,txt:pizz.} r +7 r | -11 r +7 r | 0 r +7 r | -5 r +2 r | -7 r +7 r | -7 r +7 r"
        rhythm    "1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1 | 1 1 1 1"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
