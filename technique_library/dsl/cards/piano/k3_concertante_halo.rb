production_piece "Technique Card K3_CONCERTANTE_HALO - K3_CONCERTANTE_HALO" do
  meter "4/4"
  key "C"

# category: piano
# card: K3_CONCERTANTE_HALO
# cite: keyboard_figuration s3 + dialogue_doubling s7
# behavior: piano accompanies a solo slot: RH filigree above (contour varies per bar), LH
#   walking bass-line + tenor afterbeats; union continuous

  roster do
    part :solo_slot, "Solo slot", music21: "Violoncello", family: :string, description: "Violoncello"
    part :rh_filigree, "RH filigree", music21: "Piano", family: :keyboard, description: "Piano"
    part :lh_line_tenor, "LH line+tenor", music21: "Piano", family: :keyboard, description: "Piano"
  end

  section :card, "K3_CONCERTANTE_HALO", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "piano accompanies a solo slot: RH filigree above (contour varies per bar), LH walking bass-line + tenor afterbeats; union continuous"

      phrase :solo_slot_line, surface: :split_pitch_rhythm do
        pitch_bars  "G3{txt:melody_slot} A3 B3 | D4 C4 | B3 A3 G3 | E4 D4 | C4 B3 A3 | G3"
        rhythm_bars "2 1 1 | 3 1 | 3/2 1/2 2 | 2 2 | 1 1 2 | 4"
      end

      placement :solo_slot_line, part: :solo_slot, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :rh_filigree_line, surface: :split_pitch_rhythm do
        pitch_bars  "D5 B4 G4 B4 D5 G5 F#5 D5 B4 D5 G5 B5 A5 F#5 D5 C5 | B4 D5 F#5 A5 B5 A5 F#5 D5 C5 E5 G5 C6 B5 G5 E5 C5 | B4 G5 D5 B5 G5 D6 B5 G5 E5 C6 G5 E5 D5 B4 G4 B4 | C5 E5 G5 C6 E6 C6 G5 E5 B4 D5 F#5 B5 D6 B5 F#5 D5 | A4 C5 E5 A5 C6 A5 E5 C5 D5 F#5 A5 D6 C6 A5 F#5 D5 | B4 D5 G5 B5 D6 B5 G5 D5 G5 B5 D6 G6 D6 B5 G5 D5"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :rh_filigree_line, part: :rh_filigree, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :lh_line_tenor_line, pitch: :intervals do
        anchor "G2"
        intervals "0 [+16,+19] r -17 [+15,+20] r | -17 [+15,+20] r -17 [+16,+22] r | -11 [+16,+19] r -12 +1 +2 | -2 [+4,+7] r -7 [+7,+10] r | -7 [+3,+7] r +2 -2 -1 -2 | -2 [+16,+19] r -21 -7"
        rhythm    "1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1 | 1 1/2 1/2 1 1/2 1/2 | 1 1/2 1/2 1/2 1/2 1/2 1/2 | 1 1/2 1/2 1 1"
      end

      placement :lh_line_tenor_line, part: :lh_line_tenor, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
