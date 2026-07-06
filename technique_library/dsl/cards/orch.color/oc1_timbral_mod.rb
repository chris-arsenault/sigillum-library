production_piece "Technique Card OC1_TIMBRAL_MOD - OC1_TIMBRAL_MOD" do
  meter "4/4"
  key "G"

  tempo do
    mark "quarter = 52", at: "bar 1 beat 1"
  end

# category: orch.color
# card: OC1_TIMBRAL_MOD
# cite: orchestration_techniques:color
# behavior: one held G4 morphs color through a seamless crossfade relay Cl->muted Hn->Fl
#   flautando->Vn sul tasto->Ob, each entering pp under the previous and swelling as it fades to
#   niente, over a pp open-fifth G/D drone, Adagio so the color-change-in-place is audible; no
#   re-attack on the carried pitch

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OC1_TIMBRAL_MOD", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "one held G4 morphs color through a seamless crossfade relay Cl->muted Hn->Fl flautando->Vn sul tasto->Ob, each entering pp under the previous and swelling as it fades to niente, over a pp open-fifth G/D drone, Adagio so the color-change-in-place is audible; no re-attack on the carried pitch"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "G4{txt:p_espr.} | G4 | G4{txt:dim.} G4{txt:niente} | r | r | r | r | r"
        rhythm_bars "4 | 4 | 2 2 | 4 | 4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :horn_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r G4{txt:pp} | G4 | G4 | G4{txt:dim.} G4{txt:niente} | r | r | r"
        rhythm_bars "4 | 2 2 | 4 | 4 | 2 2 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :flute_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r G4{txt:pp_flautando} | G4 | G4 | G4{txt:dim.} G4{txt:niente} | r"
        rhythm_bars "4 | 4 | 4 | 2 2 | 4 | 4 | 2 2 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r G4{txt:pp_sul_tasto} | G4 | G4{txt:dim.} G4{ppp}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 2 2 | 4 | 2 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :oboe_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | r | r | r G4{txt:pp} | G4 G4{txt:niente}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 2 2 | 2 2"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bassoon_line, surface: :split_pitch_rhythm do
        pitch_bars  "D3{pp} | D3 | D3 | D3 | D3 | D3 | D3 | D3 D3{txt:niente}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "D4{txt:pp_sul_tasto} | D4 | D4 | D4 | D4 | D4 | D4 | D4 D4{txt:niente}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "G2"
        intervals "0{pp} | 0 | 0 | 0 | 0 | 0 | 0 | 0 0{txt:niente}"
        rhythm    "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :contrabass_line, surface: :split_pitch_rhythm do
        pitch_bars  "G1{pp} | G1 | G1 | G1 | G1 | G1 | G1 | G1 G1{txt:niente}"
        rhythm_bars "4 | 4 | 4 | 4 | 4 | 4 | 4 | 2 2"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
