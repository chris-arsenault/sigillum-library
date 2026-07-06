production_piece "Technique Card OG1_ARP_ENGINE - OG1_ARP_ENGINE" do
  meter "6/8"
  key "C"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: orch.accompaniment
# card: OG1_ARP_ENGINE
# cite: orchestration_techniques:accompaniment
# behavior: broken-chord engine ignites under a clarinet: harp rolls a continuous arpeggio
#   (wide-low/narrow-high, contour varies per bar), piano doubles the upper crown, Vn2+Va pizz
#   interlock in at b3; Vc/Cb root floor; pp->f build, b6 peaks then settles

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :harp, "Harp", music21: "Harp", family: :plucked, description: "Harp"
    part :piano, "Piano", music21: "Piano", family: :keyboard, description: "Piano"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :bass, "Bass", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "OG1_ARP_ENGINE", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..6, texture: :library_card do
      process "broken-chord engine ignites under a clarinet: harp rolls a continuous arpeggio (wide-low/narrow-high, contour varies per bar), piano doubles the upper crown, Vn2+Va pizz interlock in at b3; Vc/Cb root floor; pp->f build, b6 peaks then settles"

      phrase :clarinet_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | G4{mp} A4 B4 C5 | D5 C5 E5 C5 | A4 C5 F4 A4 | D5{mf} C5 B4 A4 G4 | C5{f} E5"
        rhythm_bars "3 | 3/2 1/2 1/2 1/2 | 1 1/2 1 1/2 | 3/2 1/2 1/2 1/2 | 1 1/2 1/2 1/2 1/2 | 2 1"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :harp_line, surface: :split_pitch_rhythm do
        pitch_bars  "C3 G3 E4 G4 C5 E5 G4 E4 C5 G4 E4 C4 | G2 D3 B3 D4 G4 B4 D5 B4 G4 D4 B3 G3 | A2 E3 C4 E4 A4 C5 E5 C5 A4 E4 C4 A3 | F2 C3 A3 C4 F4 A4 C5 F5 C5 A4 F4 C4 | D3 A3 F4 A4 D5 F5 G2 D3 B3 D4 G4 B4 | C3 G3 E4 G4 C5 E5 G5 E5 C5 G4 E4 C4"
        rhythm_bars "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4"
      end

      placement :harp_line, part: :harp, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :piano_line, surface: :split_pitch_rhythm do
        pitch_bars  "C5{pp} E5 G5 E5 C5 G4 | D5 G5 B5 G5 D5 B4 | E5 A5 C6 A5 E5 C5 | F5{mp} A5 C6 F6 C6 A5 | F5 A5 D6 D5 G5 B5 | C6{f} E6 G6 E6 C6 G5"
        rhythm_bars "1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :piano_line, part: :piano, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :violin_ii_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | E4{p} A4 C5 E4 A4 C5 | A4 C5 F5 A4 C5 F5 | F4 A4 D5 D4 G4 B4 | E4 G4 C5 E4 G4 C5"
        rhythm_bars "3 | 3 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :viola_line, surface: :split_pitch_rhythm do
        pitch_bars  "r | r | A3{p} C4 E4 A3 C4 E4 | F3 A3 C4 F3 A3 C4 | D3 F3 A3 G3 B3 D4 | C4 E4 G4 C4 E4 G4"
        rhythm_bars "3 | 3 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1/2"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

      phrase :bass_line, surface: :split_pitch_rhythm do
        pitch_bars  "C2{p} | G1 | A1 | F1 | D2 G1 | C2"
        rhythm_bars "3 | 3 | 3 | 3 | 3/2 3/2 | 3"
      end

      placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :specimen, realization: "split_pitch_rhythm audition specimen"

    end
  end
end
