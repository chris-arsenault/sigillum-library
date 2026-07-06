surface_study "32-bar staff-grid surface", family: :staff_grid, bars: 1..32 do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"
  parts :clarinet, :solo_violin, :viola, :cello, :harp, :hand_drum

  section :a, "call on grid", bars: 1..8
  section :b, "answer on grid", bars: 9..16
  section :c, "crossed grid", bars: 17..24
  section :d, "broken grid", bars: 25..32

  note "Grid tokens are eighth-position cells inside 7/8. '_' sustains previous pitch; '.' rests."

  staff_bar 1 do
    foreground "clarinet: C5 _ _ Bb4/A4 F#4 _ F4 _"
    bass "cello: F2 _ _ C3 _ F2 _"
    pulse "drum: X . X X . X ."
  end

  staff_bar 2 do
    foreground "clarinet: G4 _ A4 Bb4 C5 _ ."
    bass "cello: Eb3 _ Bb2 C3 F2 _ ."
    pulse "drum: X . X . . X ."
  end

  staff_bar 3 do
    foreground "clarinet: D5 _ _ C5 Bb4 A4 F#4"
    bass "cello: F2 _ A2 Bb2 C3 _ F2"
    pulse "drum: X . X X . X ."
  end

  staff_bar 4 do
    foreground "clarinet: G4 _ F4 _ E4 F4 ."
    bass "cello: E2 _ F2 _ C3 F2 ."
    pulse "drum: X . X . . X ."
  end

  staff_bar 5 do
    foreground "clarinet: C5 _ D5 E5 F5 _ ."
    bass "cello: F2 _ _ _ C3 F2 _"
    pulse "drum: X . . X . X ."
  end

  staff_bar 6 do
    foreground "clarinet: G5 F5 E5 D5 C5 . ."
    bass "cello: Db2 _ Ab2 _ F2 Db2 _"
    pulse "drum: . X . X . . X"
  end

  staff_bar 7 do
    foreground "clarinet: Bb4 _ A4 G4 F#4 F4 ."
    bass "cello: C2 _ G2 C3 Bb2 _ G2"
    pulse "drum: X . X . X . ."
  end

  staff_bar 8 do
    foreground "clarinet: E4 _ _ F4 _ . ."
    bass "cello: F2 C3 E2 _ F2 _ ."
    pulse "drum: X . . . X . ."
  end

  staff_bar 9 do
    foreground "solo_violin: . A4 _ G4 F#4 E4 ."
    bass "cello: F2 _ C3 F2 E2 F2 C3"
    pulse "drum: X . X X . X ."
  end

  staff_bar 10 do
    foreground "solo_violin: . . C5 Bb4 A4 _ ."
    bass "cello: F2 _ Bb2 C3 F2 _ ."
    pulse "drum: X . X . . X ."
  end

  staff_bar 11 do
    foreground "solo_violin: . D5 _ C5 Bb4 A4 ."
    bass "cello: F2 C3 F2 A2 Bb2 C3 F2"
    pulse "drum: X . X X . X ."
  end

  staff_bar 12 do
    foreground "solo_violin: . . G4 F#4 E4 _ F4"
    bass "cello: E2 _ F2 C3 F2 _ ."
    pulse "drum: X . X . . X ."
  end

  staff_bar 13 do
    foreground "clarinet: C5/E5 D5 _ C5 Bb4 _ ."
    bass "cello: F2 _ C3 . F2 _ ."
    pulse "drum: X . X . . . ."
  end

  staff_bar 14 do
    foreground "clarinet: A4 Bb4 C5 D5 C5 _ ."
    bass "cello: E2 F2 C3 . . . ."
    pulse "drum: X . . X . . ."
  end

  staff_bar 15 do
    foreground "clarinet: Bb4/A4 F#4 _ G4 _ . ."
    bass "cello: Bb2 A2 F2 . . . ."
    pulse "drum: X . . . . . ."
  end

  staff_bar 16 do
    foreground "clarinet: F4 _ _ _ . . ."
    bass "cello: E2 F2 . . . . ."
    pulse "drum: . . . . . . ."
  end

  staff_bar 17 do
    foreground "clarinet: C5 D5 E5 _ F5 . ."
    bass "cello: F2 _ C3 F2 E2 F2 C3"
    pulse "drum: X . X X . X ."
  end

  staff_bar 18 do
    foreground "clarinet: G5 F5 E5 D5 C5 . ."
    bass "cello: F2 _ Bb2 C3 F2 _ ."
    pulse "drum: X . X . . X ."
  end

  staff_bar 19 do
    foreground "clarinet: C5 _ Bb4 A4 G4 F#4 F4"
    bass "cello: F2 C3 F2 A2 Bb2 C3 F2"
    pulse "drum: X . X X . X ."
  end

  staff_bar 20 do
    foreground "clarinet: E4 F4 G4 _ . . ."
    bass "cello: E2 _ F2 C3 F2 _ ."
    pulse "drum: X . X . . X ."
  end

  staff_bar 21 do
    foreground "solo_violin: A4 _ C5 D5 E5 _ ."
    bass "cello: F2 _ C3 F2 . . ."
    pulse "drum: X . . X . X ."
  end

  staff_bar 22 do
    foreground "solo_violin: F5 _ E5 C5 D5 . ."
    bass "cello: D3 _ C3 Bb2 A2 _ ."
    pulse "drum: X . . X . . X"
  end

  staff_bar 23 do
    foreground "solo_violin: C5 _ Bb4 G4 A4 . ."
    bass "cello: Bb2 A2 G2 F#2 . . ."
    pulse "drum: X . . . X . ."
  end

  staff_bar 24 do
    foreground "solo_violin: F#4 _ _ F4 _ . ."
    bass "cello: E2 _ F2 _ . . ."
    pulse "drum: X . . . . . ."
  end

  staff_bar 25 do
    foreground "clarinet: C5 _ . Bb4 A4 . ."
    bass "cello: F2 _ C3 . F2 _ ."
    pulse "drum: X . X . . . ."
  end

  staff_bar 26 do
    foreground "clarinet: F#4 F4 . C5 . . ."
    bass "cello: E2 F2 C3 . . . ."
    pulse "drum: X . . X . . ."
  end

  staff_bar 27 do
    foreground "clarinet: Bb4 A4 F#4 . . . ."
    bass "cello: Bb2 A2 F#2 . . . ."
    pulse "drum: X . . . . . ."
  end

  staff_bar 28 do
    foreground "clarinet: F4 _ . . . . ."
    bass "cello: F2 . . . . . ."
    pulse "drum: . . . . . . ."
  end

  staff_bar 29 do
    foreground "solo_violin: A4 _ G4 F#4 E4 . ."
    bass "cello: A2 _ G2 F#2 E2 . ."
    pulse "drum: X . . X . . ."
  end

  staff_bar 30 do
    foreground "solo_violin: C5 _ Bb4 A4 . . ."
    bass "cello: C3 _ Bb2 A2 . . ."
    pulse "drum: X . . . X . ."
  end

  staff_bar 31 do
    foreground "solo_violin: F#4 _ E4 F4 . . ."
    bass "cello: F#2 _ E2 F2 . . ."
    pulse "drum: X . . . . . ."
  end

  staff_bar 32 do
    foreground "solo_violin: F4 _ . . . . ."
    bass "cello: F2 . . . . . ."
    pulse "drum: . . . . . . ."
  end
end
