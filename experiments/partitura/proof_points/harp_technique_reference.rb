# DSL transcription of the Dorico-exported harp reference
# (~/repos/harpref/"Flows from Untitled Project 2").
#
# Library proof point, not an exploration: validates technique-notation parity
# for rolled chords up/down ({arp}/{arp:down}), chained glissandi ({gliss(}/{gliss)}
# including across a barline, laissez vibrer ({lv} on a note whose tie slot is
# taken by a structural cross-barline tie), harp pedal diagrams, grand-staff
# routing, and a mid-piece key change to F# major.
production_piece "Harp Technique Reference" do
  meter "4/4"
  key "C"

  roster do
    part :harp_rh, "Harp", music21: "Harp", family: :plucked, range: "C1-G7",
                           notation_group: :harp, notation_staff: 1
    part :harp_lh, "Harp", music21: "Harp", family: :plucked, range: "C1-G7",
                           notation_group: :harp, notation_staff: 2
  end

  section :s1, "C Major Statement", bars: 1..4, type: :reference do
    span bars: 1..4, texture: :reference do
      harmony "C major triads rolled up, first-inversion answer rolled down"
      process "rolled chords, a stepwise line, then a chained glissando landing on a tied G5 left ringing"

      phrase :s1_rh, surface: :absolute do
        events <<~EVENTS
          [C4,E4,G4]:1{arp} [C4,E4,C5]:1{arp} r:1 [A4,C5,E5]:1{arp:down} |
          G4:1 B4:1 C5:1 D5:1 |
          E5:1{gliss(} F5:2{gliss),gliss(} G5:2{gliss),lv} r:1 r:2
        EVENTS
      end

      phrase :s1_lh, surface: :absolute do
        events <<~EVENTS
          C3:1{arp} C3:1{arp} r:1 C3:1 |
          C3:1 r:1 E3:.5 r:.5 G3:.5 r:.5 |
          r:4 |
          r:4
        EVENTS
      end

      placement :s1_rh, part: :harp_rh, at: "bar 1 beat 1", role: :foreground
      placement :s1_lh, part: :harp_lh, at: "bar 1 beat 1", role: :bass_anchor
    end
  end

  section :s2, "F Sharp Major Restatement", bars: 5..8, type: :reference do
    span bars: 5..8, texture: :reference do
      harmony "the same shapes restated in F# major after the key change"
      process "rolled chords and line as before; the closing glissando spans a full barline between whole notes"

      phrase :s2_rh, surface: :absolute do
        events <<~EVENTS
          [D#4,F#4,A#4]:1{arp} [D#4,F#4,D#5]:1{arp} r:1 [B4,D#5,F#5]:1{arp:down} |
          A#4:1 C#5:1 D#5:1 E#5:1 |
          E#5:4{gliss(} |
          B4:4{gliss)}
        EVENTS
      end

      phrase :s2_lh, surface: :absolute do
        events <<~EVENTS
          D#3:1{arp} D#3:1{arp} r:1 D#3:1 |
          D#3:1 r:1 F#3:.5 r:.5 A#3:.5 r:.5 |
          r:4 |
          r:4
        EVENTS
      end

      placement :s2_rh, part: :harp_rh, at: "bar 5 beat 1", role: :foreground
      placement :s2_lh, part: :harp_lh, at: "bar 5 beat 1", role: :bass_anchor
    end
  end

  control do
    key_change "F#", at: "bar 5 beat 1"
    # pedal diagrams: what the Dorico project has entered but its exporter drops
    harp_pedals "D C B | E F G A", at: "bar 1 beat 1", for: :harp_rh
    harp_pedals "D# C# B# | E# F# G# A#", at: "bar 5 beat 1", for: :harp_rh
  end
end
