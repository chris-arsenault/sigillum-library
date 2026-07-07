surface_study "32-bar hybrid phrase+staff surface", family: :hybrid_phrase_staff, bars: 1..32 do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F", mode: "degree phrases, staff checkpoints"
  parts :clarinet, :solo_violin, :viola, :cello, :harp, :hand_drum

  section :a, "phrase stated; staff checks exposure", bars: 1..8
  section :b, "phrase displaced; staff checks missed answer", bars: 9..16
  section :c, "phrase returns; staff checks pressure", bars: 17..24
  section :d, "phrase breaks; staff checks exits", bars: 25..32

  phrase :foreground_32 do
    pitch_mode "scale degrees in F"
    degrees %q{
      5 4 3 #1 1 | 2 3 4 5 r | 6 5 4 3 #1 | 2 1 7 1 r |
      5 6 7 1' r | 2' 1' 7 6 5 | 4 3 2 #1 1 | 7 1 r |
      3 2 #1 7 r | 5 4 3 r | 6 5 4 3 r | 2 #1 7 1 r |
      5 7 6 5 4 | 3 4 5 6 5 | 4 3 #1 2 r | 1 r |
      5 6 7 1' r | 2' 1' 7 6 5 | 5 4 3 2 #1 1 | 7 1 2 r |
      3 5 6 7 r | 1' 7 5 6 r | 5 4 2 3 r | #1 1 r |
      5 r 4 3 r | #1 1 r 5 r | 4 3 #1 r | 1 r |
      3 2 #1 7 r | 5 4 3 r | #1 7 1 r | 1 r
    }
    rhythm %q{
      1.5 .25 .25 .5 1 | 1 .5 .5 1 .5 | 1.5 .5 .5 .5 .5 | 1 1 .5 .5 .5 |
      1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | 1.5 1 .5 |
      .5 1 .5 .5 1 | 1 .5 1 1 | 1 .5 .5 .5 1 | .5 .5 1 1 .5 |
      .75 .25 1 .5 1 | .5 .5 .5 .5 1 .5 | .75 .25 .5 1 1 | 2 1.5 |
      .75 .25 1 .5 1 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | .5 .5 1 1 |
      1 .5 .5 1 .5 | 1 .5 1 .5 .5 | 1 .5 1 .5 .5 | 1.5 1 1 |
      1 .5 .5 .5 1 | .5 .5 1 .5 1 | .5 .5 .5 2 | 1 2.5 |
      .5 1 .5 .5 1 | 1 .5 .5 1 | 1 .5 1 1 | 1 2.5
    }
  end

  phrase :bass_32 do
    pitch_mode "absolute bass, because register is part of the orchestration"
    pitch_bars %q{
      F2 C3 F2 | Eb3 Bb2 C3 F2 | F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 |
      F2 C3 F2 | Db2 Ab2 F2 Db2 | C2 G2 C3 Bb2 G2 | F2 C3 E2 F2 |
      F2 C3 F2 E2 F2 C3 | F2 Bb2 C3 F2 | F2 C3 F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 |
      F2 C3 r F2 | E2 F2 C3 r | Bb2 A2 F2 r | E2 F2 r |
      F2 C3 F2 E2 F2 C3 | F2 Bb2 C3 F2 | F2 C3 F2 A2 Bb2 C3 F2 | E2 F2 C3 F2 |
      F2 C3 F2 | D3 C3 Bb2 A2 | Bb2 A2 G2 F#2 | E2 F2 r |
      F2 C3 r F2 | E2 F2 C3 r | Bb2 A2 F#2 r | F2 r |
      A2 G2 F#2 E2 r | C3 Bb2 A2 r | F#2 E2 F2 r | F2 r
    }
  end

  placement :foreground_32, part: :clarinet, at: "bar 1 beat 1", bars: 1..8 do
    role :foreground
    realization "degree phrase, absolute spelling deferred to key view"
  end

  placement :foreground_32, part: :solo_violin, at: "bar 9 beat 1.5", bars: 9..16 do
    role :late_answer
    realization "same phrase window with displaced entrance"
  end

  placement :foreground_32, part: :clarinet, at: "bar 17 beat 1", bars: 17..24 do
    role :foreground
    realization "return window, no new material object"
  end

  placement :foreground_32, part: :clarinet, at: "bar 25 beat 1", bars: 25..32 do
    role :fragment
    realization "broken ending window"
  end

  placement :bass_32, part: :cello, at: "bar 1 beat 1", bars: 1..32 do
    role :bass_line
    realization "absolute bass phrase"
  end

  staff_bar 1 do
    check "opening vertical"
    foreground "clarinet degree 5 = C5"
    bass "cello F2"
    harp "F/C"
  end

  staff_bar 9 do
    check "late answer begins against established grid"
    foreground "solo_violin degree 3 = A4, delayed"
    bass "cello F2"
    pulse "drum attacks on 1, 2, 2.5, 3.5"
  end

  staff_bar 13 do
    check "answer pressure compresses"
    foreground "clarinet degrees 5-7-6-5-4"
    bass "cello F2-C3-rest-F2"
  end

  staff_bar 17 do
    check "return with higher pressure"
    foreground "clarinet degree 5 rises to high 1"
    bass "cello F2-C3-F2-E2-F2-C3"
  end

  staff_bar 21 do
    check "violin takes pressure window"
    foreground "solo_violin degrees 3-5-6-7"
    bass "cello F2-C3-F2"
  end

  staff_bar 25 do
    check "fragmented afterimage starts"
    foreground "clarinet degree 5, rest, 4, 3, rest"
    bass "cello F2-C3-rest-F2"
  end

  staff_bar 29 do
    check "final answer fragment"
    foreground "solo_violin degrees 3-2-#1-7"
    bass "cello A2-G2-F#2-E2"
  end

  staff_bar 32 do
    check "last shared F without tutti cadence"
    foreground "solo_violin degree 1 = F4"
    bass "cello F2"
    pulse "silent"
  end
end
