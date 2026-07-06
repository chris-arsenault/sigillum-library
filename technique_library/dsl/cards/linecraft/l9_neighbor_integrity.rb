production_piece "Technique Card L9_NEIGHBOR_INTEGRITY - L9_NEIGHBOR_INTEGRITY" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "am"

  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L9_NEIGHBOR_INTEGRITY
# cite: etude_pitch_devices device 1 ; Wiedemann b3/b5/b26
# behavior: SEMITONE-INTEGRITY ENFORCEMENT: the turn cell keeps its semitone lower neighbor at
#   EVERY station, and the accidentals exist solely to enforce it - G# on the tonic, C# on
#   D, D# on E, and F-DOUBLE-SHARP when the turn lands on the leading tone itself. The
#   motif's interval identity outranks the key signature. From Wiedemann: A# (b3), D## (b5),
#   C## (b26) - every exotic accidental in the piece is this one law.

  roster do
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind
  end

  section :card, "L9_NEIGHBOR_INTEGRITY", bars: 1..6, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..6, texture: :library_card do
      process "the same turn on A, D, E, and the leading tone G sharp - the semitone neighbor enforced by G#, C#, D#, and finally F-double-sharp"

      phrase :l9_neighbor_integrity, surface: :absolute do
        events %q{
          A4:.5{mp,slur(} G#4:.5 A4:.5{slur)} C5:.5{slur(} B4:.5 E5:.5{slur)} |
          D5:.5{slur(} C#5:.5 D5:.5{slur)} F5:.5{slur(} E5:.5 A5:.5{slur)} |
          E5:.5{slur(} D#5:.5 E5:.5{slur)} G5:.5{slur(} F#5:.5 B4:.5{slur)} |
          G#4:.5{slur(} F##4:.5 G#4:.5{slur)} B4:.5{slur(} A4:.5 D5:.5{slur)} |
          C5:.5{slur(} B4:.5 A4:.5{slur)} E5:.5{stacc} G#4:.5{stacc} B4:.5{stacc} |
          A4:2.5{ten} r:.5
        }
      end

      placement :l9_neighbor_integrity, part: :oboe, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
