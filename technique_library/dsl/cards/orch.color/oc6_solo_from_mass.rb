production_piece "Technique Card OC6_SOLO_FROM_MASS - OC6_SOLO_FROM_MASS" do
  meter "4/4"
  key "Dm"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC6_SOLO_FROM_MASS
# cite: orchestration_techniques:color
# behavior: full Dm tutti recedes (decresc + voices drop) to a profile-less muted-string pad; a
#   solo oboe blooms out mp espressivo as the only moving voice in an unmasked register - the
#   figure-ground flip from many to one - then dovetails as the pad swells back faintly

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe_solo, "Oboe (solo)", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :timpani, "Timpani", music21: "Timpani", family: :percussion, description: "Timpani"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OC6_SOLO_FROM_MASS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "full Dm tutti recedes (decresc + voices drop) to a profile-less muted-string pad; a solo oboe blooms out mp espressivo as the only moving voice in an unmasked register - the figure-ground flip from many to one - then dovetails as the pad swells back faintly"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{f,txt:cresc.} A5 | D6{txt:dim.} A5{mp} | r | r | r | r | r | r"
        rhythm_bars "2 2 | 2 2 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_solo_line, pitch: :degrees do
        key_context "D4"
        degrees "r | r | r | r | 5{txt:mp_espr,txt:cresc.} 1' | b3' 2'{txt:dim.} | 1'{p} b7 5 | 1'{pp,txt:dim.}"
        rhythm  "4 | 4 | 4 | 4 | 2 2 | 3 1 | 2 1 1 | 4"
      end

      placement :oboe_solo_line, part: :oboe_solo, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "[A4,D5]{f,txt:dim.} | [A4,D5]{mp} | r | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{f,txt:dim.} | A2{mp} | r | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "[F4,A4]{f,txt:dim.} | [E4,A4]{mp} | r | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trumpet_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5{f,txt:dim.} | r | r | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :trombone_line, surface: :split_pitch_rhythm do
        pitch_bars  "[D3,A3]{f,txt:dim.} | r | r | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :timpani_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{f,trem,txt:dim.} | r | r | r | r | r | r | r"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :timpani_line, part: :timpani, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "D6{f,txt:dim.} | A5{mp,txt:dim.} | A5{pp} | A5 | A5 | A5 | A5 | D6{p,txt:cresc.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "A5{f,txt:dim.} | F5{mp,txt:dim.} | F5{pp} | F5 | F5 | F5 | F5 | F5{p,txt:cresc.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "F4{f,txt:dim.} | D4{mp,txt:dim.} | D4{pp} | D4 | D4 | D4 | D4 | D4{p,txt:cresc.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "D3"
        intervals "0{f,txt:dim.} | -5{mp,txt:dim.} | 0{pp} | 0 | 0 | 0 | 0 | +5{p,txt:cresc.}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "D2{f,txt:dim.} | D2{mp,txt:dim.} | r | r | r | r | r | D2{p,txt:cresc.}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
