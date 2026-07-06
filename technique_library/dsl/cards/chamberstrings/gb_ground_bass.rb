production_piece "Technique Card GB_GROUND_BASS - GB_GROUND_BASS" do
  meter "3/4"
  key "a"

  tempo do
    mark "quarter = 60", at: "bar 1 beat 1"
  end

# category: chamberstrings
# card: GB_GROUND_BASS
# cite: ground_bass
# behavior: ground bass / passacaglia as a CUMULATIVE ENGINE: a 2-bar lament/Andalusian
#   tetrachord ground (A-G-F-E, i-VII-VI-V) repeats 4x and the texture accretes over the fixed
#   floor -- bare ground -> +moving inner viola -> +16th diminution & registral ascent (Vn1
#   enters) -> climax with the ground THEME MIGRATED up into Vn1

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :cello_ground, "Cello (ground)", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "GB_GROUND_BASS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "ground bass / passacaglia as a CUMULATIVE ENGINE: a 2-bar lament/Andalusian tetrachord ground (A-G-F-E, i-VII-VI-V) repeats 4x and the texture accretes over the fixed floor -- bare ground -> +moving inner viola -> +16th diminution & registral ascent (Vn1 enters) -> climax with the ground THEME MIGRATED up into Vn1"

      phrase :violin_i_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | r | E5{mf,txt:cantabile} D5 C5 B4 C5 E5 | D5 C5 B4 A4 B4 G#4 A4 | A5{f,txt:il_basso_migrato} G5 F5 E5 F5 E5 | E5 D#5 E5 A4"
        rhythm_bars "3 | 3 | 3 | 3 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/4 1/4 1/4 1/4 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | r | A3{mp} G3 G#3 | A3{mf} C4 E4 | D4 C4 B3 A3 G#3 | A4{f} E4 C4 | B3 C4 A3"
        rhythm_bars "3 | 3 | 3 | 1 1 1 | 1 1 1 | 1/2 1/2 1/2 1/2 1 | 1 1 1 | 1 1 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | E3{mp,txt:inner_voice} F3 E3 | D3 C3 B2 | C3{mf} D3 E3 D3 C3 B2 | A2 B2 C3 D3 E3 | E3{f} F3 E3 | D3 C3 B2"
        rhythm_bars "3 | 3 | 3/2 1/2 1 | 1 1 1 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 | 1 1 1 | 1 1 1"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :cello_ground_line, pitch: :intervals do
        anchor "A2"
        intervals "0{p,txt:il_basso_(the_ground)_cantabile} -2 -2 | -1 0 | +5{mp} +2 -4 -2 | -1 -2 +2 | +5{mf} +2 -4 +2 -4 +2 | -3 +1 -1 -2 +2 | +5{f} -2 -2 | -1 +7 -2"
        rhythm    "1 1 1 | 2 1 | 1 1/2 1/2 1 | 3/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1 | 1 1 1 | 3/2 1/2 1"
      end

      placement :cello_ground_line, part: :cello_ground, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
