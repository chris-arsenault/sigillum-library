surface_study "32-bar relative-interval surface", family: :relative_intervals, bars: 1..32 do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F center"
  parts :clarinet, :solo_violin, :viola, :cello, :harp, :hand_drum

  section :a, "interval call", bars: 1..8
  section :b, "interval answer", bars: 9..16
  section :c, "interval pressure", bars: 17..24
  section :d, "interval afterimage", bars: 25..32

  phrase :foreground_interval_32 do
    anchor "C5"
    syntax "first event is anchor; later numbers are semitone motion from previous sounding event; r holds silence"
    intervals %q{
      0 -2 -1 -3 -1 | +2 +2 +1 +2 r | +2 -2 -2 -1 -3 | +2 -2 -1 +1 r |
      +7 +2 +2 +1 r | +2 -2 -2 -2 -2 | -2 -1 -2 -1 -1 | -1 +1 r |
      +4 -2 -1 -2 r | +7 -2 -1 r | +5 -2 -2 -1 r | -2 -1 -1 +1 r |
      +7 +4 -2 -2 -1 | -2 +1 +2 +2 -2 | -2 -1 -3 +1 r | -2 r |
      +7 +2 +2 +1 r | +2 -2 -2 -2 -2 | 0 -2 -1 -2 -1 -1 | -1 +1 +2 r |
      +2 +3 +2 +2 r | +1 -1 -4 +2 r | -2 -2 -3 +2 r | -3 -1 r |
      +7 r -2 -1 r | -3 -1 r +7 r | -2 -1 -3 r | -1 r |
      +4 -2 -1 -2 r | +7 -2 -1 r | -3 -1 +1 r | 0 r
    }
    durations %q{
      1.5 .25 .25 .5 1 | 1 .5 .5 1 .5 | 1.5 .5 .5 .5 .5 | 1 1 .5 .5 .5 |
      1 .5 .5 1 .5 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | 1.5 1 .5 |
      .5 1 .5 .5 1 | 1 .5 1 1 | 1 .5 .5 .5 1 | .5 .5 1 1 .5 |
      .75 .25 1 .5 1 | .5 .5 .5 .5 1 .5 | .75 .25 .5 1 1 | 2 1.5 |
      .75 .25 1 .5 1 | .5 .5 .5 .5 .5 .5 .5 | 1 .5 .5 .5 .5 .5 | .5 .5 1 1 |
      1 .5 .5 1 .5 | 1 .5 1 .5 .5 | 1 .5 1 .5 .5 | 1.5 1 1 |
      1 .5 .5 .5 1 | .5 .5 1 .5 1 | .5 .5 .5 2 | 1 2.5 |
      .5 1 .5 .5 1 | 1 .5 .5 1 | 1 .5 1 1 | 1 2.5
    }
    checkpoints "bar1=C5, bar9=A4, bar17=C5, bar25=C5, bar32=F4"
  end

  line :clarinet, role: :foreground, bars: 1..8 do
    source :foreground_interval_32
    interval_slice "bars 1-8"
  end

  line :solo_violin, role: :answer, bars: 9..16 do
    source :foreground_interval_32
    interval_slice "bars 9-16"
    entry_offset ".5"
  end

  line :clarinet, role: :foreground, bars: 17..24 do
    source :foreground_interval_32
    interval_slice "bars 17-24"
  end

  line :clarinet, role: :broken_fragment, bars: 25..32 do
    source :foreground_interval_32
    interval_slice "bars 25-32"
  end

  phrase :bass_interval_32 do
    anchor "F2"
    intervals %q{
      0 +7 -7 | +10 -5 +2 -7 | 0 +4 +1 +2 -7 | -1 +1 +7 -7 |
      0 +7 -7 | -4 +7 -3 -4 | -1 +7 -5 +5 -2 | -5 +7 -1 +1 |
      0 +7 -7 -1 +1 +7 | -7 +5 +2 -7 | 0 +7 -7 +4 +1 +2 -7 | -1 +1 +7 -7 |
      0 +7 r -7 | -1 +1 +7 r | +5 -1 -4 r | -1 +1 r |
      0 +7 -7 -1 +1 +7 | -7 +5 +2 -7 | 0 +7 -7 +4 +1 +2 -7 | -1 +1 +7 -7 |
      0 +7 -7 | +2 -2 -1 -2 | +5 -1 -2 -3 | -1 +1 r |
      0 +7 r -7 | -1 +1 +7 r | +5 -1 -4 r | 0 r |
      +4 -2 -1 -2 r | +7 -2 -1 r | -3 -1 +1 r | 0 r
    }
    durations "same bar rhythm as bass line in degree surface"
  end

  line :cello, role: :bass_line, bars: 1..32 do
    source :bass_interval_32
  end
end
