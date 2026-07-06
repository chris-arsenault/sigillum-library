production_piece "Technique Card P6_PROCLAMATION_BREAK - P6_PROCLAMATION_BREAK" do
  meter "4/4"
  key "C"

# category: piano
# card: P6_PROCLAMATION_BREAK
# cite: keyboard_figuration s6c
# behavior: 2 bars cantabile -> ABRUPT ff unison proclamation + hammered blocks -> half-bar
#   silence -> the lyric resumes pp una corda, accompaniment thinned (shaken)

  roster do
    part :rh, "RH", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh, "LH", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "P6_PROCLAMATION_BREAK", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "2 bars cantabile -> ABRUPT ff unison proclamation + hammered blocks -> half-bar silence -> the lyric resumes pp una corda, accompaniment thinned (shaken)"

      phrase :rh_line, surface: :split_pitch_rhythm do
        pitch_bars  "Eb5{p} D5 C5 | B4 C5 D5 | [G3,G4]{ff} [G3,G4] [Ab3,Ab4] [Ab3,Ab4] [B3,B4] [C4,C5] | [C4,Eb4,G4,C5] [B3,D4,G4,B4] [C4,Eb4,G4,C5] r | Eb5{pp,txt:una_corda} D5 C5 | B4 C5 D5 Eb5 | F5 Eb5 D5 C5 | B4 C5 C5"
        rhythm_bars "2 1 1 | 3/2 1/2 2 | 3/4 1/4 3/4 1/4 1 1 | 1 1/2 1 3/2 | 2 1 1 | 3/2 1/2 1 1 | 3/2 1/2 1 1 | 1/4 3/4 3"
      end

      placement :rh_line, part: :rh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2 [Eb3,G3] G2 [Eb3,G3] Ab2 | G2 [D3,F3] G1 [D3,G3] | [G1,G2]{ff} [G1,G2] [Ab1,Ab2] [Ab1,Ab2] [B1,B2] [C2,C3] | [C2,G2,C3] [G1,G2] [C2,G2,C3] r | C2{pp} r G2 | G1 r B2 | Ab2 F2 G2 | G1 C2"
        rhythm_bars "1 1/2 1 1/2 1 | 1 1/2 3/2 1 | 3/4 1/4 3/4 1/4 1 1 | 1 1/2 1 3/2 | 2 1 1 | 2 1 1 | 2 1 1 | 1 3"
      end

      placement :lh_line, part: :lh, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
