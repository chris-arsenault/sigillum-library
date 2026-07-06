production_piece "Technique Card OC8_THE_WASH - OC8_THE_WASH" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 40", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC8_THE_WASH
# cite: orchestration_techniques:color
# behavior: veiled impressionist wash: staggered, attackless soft sustains - divisi strings sul
#   tasto + tremolo, low veiled flutes/clarinets holding an added-9th cluster, harp arpeggio
#   washes (l.v.) and a faint celesta top shimmer, all ppp with gentle swells; harmony drifts by
#   oblique motion to a whole-tone-tinged neighbor then dissolves to niente - the blurred color
#   IS the event

  roster do
    part :violin_i_div_a, "Violin I (div a)", music21: "Violin", family: :string, description: "Violin"
    part :violin_i_div_b, "Violin I (div b)", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello_div_a, "Violoncello (div a)", music21: "Violoncello", family: :string, description: "Violoncello"
    part :violoncello_div_b, "Violoncello (div b)", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :flute_1, "Flute 1", music21: "Flute", family: :woodwind, description: "Flute"
    part :flute_2, "Flute 2", music21: "Flute", family: :woodwind, description: "Flute"
    part :clarinet_1, "Clarinet 1", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :clarinet_2, "Clarinet 2", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
    part :celesta, "Celesta", music21: "Celesta", family: :keyboard, description: "Celesta"
  end

  section :card, "OC8_THE_WASH", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "veiled impressionist wash: staggered, attackless soft sustains - divisi strings sul tasto + tremolo, low veiled flutes/clarinets holding an added-9th cluster, harp arpeggio washes (l.v.) and a faint celesta top shimmer, all ppp with gentle swells; harmony drifts by oblique motion to a whole-tone-tinged neighbor then dissolves to niente - the blurred color IS the event"

      phrase :violin_i_div_a_line, surface: :split_pitch_rhythm do
        pitch_bars  "r A5{pp,trem,txt:cresc.} | A5{txt:dim.} | B5{ppp,txt:cresc.} | B5{txt:dim.} | C#6{ppp,txt:cresc.} | C#6{txt:dim.} | B5{ppp,trem} | A5{ppp,txt:dim.}"
        rhythm_bars "1 3 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_div_a_line, part: :violin_i_div_a, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_div_b_line, surface: :split_pitch_rhythm do
        pitch_bars  "r F#5{ppp,trem,txt:cresc.} | F#5{txt:dim.} | E5{ppp} | F#5{txt:cresc.} | F#5{txt:dim.} | G#5{ppp,trem} | F#5{txt:dim.} | E5{ppp} r"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :violin_i_div_b_line, part: :violin_i_div_b, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r F#5{ppp,trem,txt:cresc.} | E5{txt:dim.} | E5{ppp} | D5{txt:cresc.} | E5{txt:dim.} | E5{ppp,trem} | F#5{txt:dim.} | E5{ppp} r"
        rhythm_bars "3 1 | 4 | 4 | 4 | 4 | 4 | 4 | 3 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D5{ppp,trem,txt:cresc.} | C#5{txt:dim.} | B4{ppp} | C#5{txt:cresc.} | C#5{txt:dim.} | B4{ppp,trem} | B4{txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_div_a_line, pitch: :intervals do
        anchor "A4"
        intervals "r 0{ppp,txt:cresc.} | 0{txt:dim.} | -1{ppp} | +1{trem,txt:cresc.} | 0{txt:dim.} | -1{ppp} | +1{txt:dim.} | -1{ppp,trem}"
        rhythm    "2 2 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_div_a_line, part: :violoncello_div_a, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_div_b_line, pitch: :intervals do
        anchor "F#3"
        intervals "r 0{ppp,txt:cresc.} | 0{txt:dim.} | -2{ppp} | 0{txt:cresc.} | 0{txt:dim.} | 0{ppp} | 0{txt:dim.}"
        rhythm    "5 3 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_div_b_line, part: :violoncello_div_b, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D2{ppp,txt:cresc.} | D2{txt:dim.} | B1{ppp} | B1{txt:cresc.} | B1{txt:dim.} | B1{ppp} | D2{txt:dim.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r D6{ppp,txt:cresc.} | D6{txt:dim.} | C#6{ppp} | D6{txt:cresc.} | D6{txt:dim.} | C#6{ppp} | D6{txt:dim.} | C#6{ppp}"
        rhythm_bars "1 3 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_1_line, part: :flute_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r B5{ppp,txt:cresc.} | B5{txt:dim.} | A5{ppp,txt:cresc.} | B5{txt:dim.} | B5{ppp} | A5{txt:dim.} | B5{ppp}"
        rhythm_bars "6 2 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_2_line, part: :flute_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_1_line, surface: :split_pitch_rhythm do
        pitch_bars  "r E5{ppp,txt:cresc.} | E5{txt:dim.} | E5{ppp} | E5{txt:cresc.} | E5{txt:dim.} | E5{ppp} | E5{txt:dim.} | E5{ppp}"
        rhythm_bars "3 1 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_1_line, part: :clarinet_1, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :clarinet_2_line, surface: :split_pitch_rhythm do
        pitch_bars  "r A4{ppp,txt:cresc.} | B4{txt:dim.} | B4{ppp} | C#5{txt:cresc.} | C#5{txt:dim.} | B4{ppp} | C#5{txt:dim.} | B4{ppp}"
        rhythm_bars "2 2 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_2_line, part: :clarinet_2, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | D4{ppp} A4 D5 F#5 E4 B4 E5 F#5 | D4 A4 D5 B5 E4 B4 E5 C#6 | D4 F#4 A4 D5 E4 G#4 B4 E5 | E4 B4 E5 F#5 D4 A4 D5 F#5 | E4 B4 E5 B5 r | r | r"
        rhythm_bars "4 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 2 | 4 | 4"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :celesta_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | F#6{ppp,txt:cresc.} | F#6{txt:dim.} | E6{ppp} | F#6{txt:cresc.} | F#6{txt:dim.} | E6{ppp,txt:dim.} r"
        rhythm_bars "8 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :celesta_line, part: :celesta, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
