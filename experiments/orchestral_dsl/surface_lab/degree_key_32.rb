surface_study "32-bar key-relative degree surface", family: :key_relative_degrees, bars: 1..32 do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F", mode: "F with raised-1 bite and flat-6 color"
  parts :clarinet, :solo_violin, :viola, :cello, :harp, :hand_drum

  section :a, "plain call", bars: 1..8
  section :b, "late answer", bars: 9..16
  section :c, "crossed pressure", bars: 17..24
  section :d, "broken afterimage", bars: 25..32

  phrase :foreground_32 do
    syntax "scale degrees relative to F; #1 = F#, b6 = Db; r = rest"
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

  line :clarinet, role: :foreground, bars: 1..8 do
    source :foreground_32
    slice "bars 1-8"
  end

  line :solo_violin, role: :late_answer, bars: 9..16 do
    source :foreground_32
    slice "bars 9-16"
    relation "uses same degree space but starts from degree 3 rather than degree 5"
  end

  line :clarinet, role: :foreground, bars: 17..24 do
    source :foreground_32
    slice "bars 17-24"
  end

  line :clarinet, role: :fragment, bars: 25..32 do
    source :foreground_32
    slice "bars 25-32"
  end

  line :cello, role: :bass_degrees, bars: 1..32 do
    degrees %q{
      1 5 1 | b7 4 5 1 | 1 3 4 5 1 | 7 1 5 1 |
      1 5 1 | b6 b3 1 b6 | 5 2 5 4 2 | 1 5 7 1 |
      1 5 1 7 1 5 | 1 4 5 1 | 1 5 1 3 4 5 1 | 7 1 5 1 |
      1 5 r 1 | 7 1 5 r | 4 3 1 r | 7 1 r |
      1 5 1 7 1 5 | 1 4 5 1 | 1 5 1 3 4 5 1 | 7 1 5 1 |
      1 5 1 | 6 5 4 3 | 4 3 2 #1 | 7 1 r |
      1 5 r 1 | 7 1 5 r | 4 3 #1 r | 1 r |
      3 2 #1 7 r | 5 4 3 r | #1 7 1 r | 1 r
    }
    rhythm %q{
      1.5 1 1 | 1 .5 .5 1 .5 | 1 .5 .5 1 .5 | 1 1 .5 .5 .5 |
      2 .5 1 | 1 1 .5 1 | 1 .5 .5 1 .5 | .5 .5 1 1 .5 |
      1 .5 .5 .5 .5 .5 | 1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 1 .5 |
      1.5 .5 .5 1 | .5 .5 .5 2 | .5 .5 .5 2 | .5 .5 2.5 |
      1 .5 .5 .5 .5 .5 | 1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 1 .5 |
      1 .5 2 | 1 .5 .5 1.5 | .5 .5 .5 2 | 1 1 1.5 |
      1 .5 2 | .5 .5 1 1 | .5 .5 .5 2 | .5 .5 2.5 |
      .5 1 .5 .5 1 | 1 .5 .5 1 | 1 .5 1 1 | 1 2.5
    }
  end

  line :hand_drum, role: :metric_engine, bars: 1..32 do
    grid %q{
      X . X X . X . | X . X . . X . | X . X X . X . | X . X . . X . |
      X . . X . X . | . X . X . . X | X . X . X . . | X . . . X . . |
      X . X X . X . | X . X . . X . | X . X X . X . | X . X . . X . |
      X . X . . . . | X . . X . . . | X . . . . . . | . . . . . . . |
      X . X X . X . | X . X . . X . | X . X X . X . | X . X . . X . |
      X . . X . X . | X . . X . . X | X . . . X . . | X . . . . . . |
      X . X . . . . | X . . X . . . | X . . . . . . | . . . . . . . |
      X . . X . . . | X . . . X . . | X . . . . . . | . . . . . . .
    }
  end
end
