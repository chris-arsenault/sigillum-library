production_piece "Technique Card MEL6_MODAL - MEL6_MODAL" do
  meter "4/4"
  key "G"

  tempo do
    mark "quarter = 128", at: "bar 1 beat 1"
  end

# category: melody
# card: MEL6_MODAL
# cite: melody_craft:modal_melody
# behavior: a brisk folk-rock line in G MIXOLYDIAN whose strong beats expose the double-plagal
#   Mixolydian vamp I-bVII-IV-I | I-bVII-IV-I (G-F-C-G), the mode's signature progression.
#   Mixolydian = major tonic with a FLAT 7TH (F-natural, never F#), so the bVII is a MAJOR chord
#   built on that flat-7 - the single 'this is Mixolydian, not Ionian' event. The line is built
#   as compound melody: the chord ROOT is dropped low on each downbeat (G3 for I, F3 for bVII,
#   C4 for IV) as an implied bass, then leaps up to state the chord's 3rd (B for G, A for F, E
#   for C) so each bar arpeggiates its triad and the ear streams a bass + an upper voice. The
#   HOOK is the F-natural (b7) signature given AGOGIC weight: held a full beat over the bVII
#   (b2, b6), the bright-flat-7-over-a-major-frame that colors the whole tune. Antecedent (b1-4)
#   launches low on the tonic, climbs through the vamp, and makes a modal half-close on I (b4)
#   with a breath; the consequent (b5-8) leaps to the single agogic apex G5 (b5, on the strong
#   beat, held, not at phrase-end), terraces down, and closes with the leading-tone-FREE modal
#   cadence bVII->I - a stepwise b7->1 (F-natural->G, a WHOLE step, no F#) onto the long held
#   tonic.

  roster do
    part :melody, "Melody", music21: "Viola", family: :string, description: "Viola"
  end

  section :card, "MEL6_MODAL", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a brisk folk-rock line in G MIXOLYDIAN whose strong beats expose the double-plagal Mixolydian vamp I-bVII-IV-I | I-bVII-IV-I (G-F-C-G), the mode's signature progression. Mixolydian = major tonic with a FLAT 7TH (F-natural, never F#), so the bVII is a MAJOR chord built on that flat-7 - the single 'this is Mixolydian, not Ionian' event. The line is built as compound melody: the chord ROOT is dropped low on each downbeat (G3 for I, F3 for bVII, C4 for IV) as an implied bass, then leaps up to state the chord's 3rd (B for G, A for F, E for C) so each bar arpeggiates its triad and the ear streams a bass + an upper voice. The HOOK is the F-natural (b7) signature given AGOGIC weight: held a full beat over the bVII (b2, b6), the bright-flat-7-over-a-major-frame that colors the whole tune. Antecedent (b1-4) launches low on the tonic, climbs through the vamp, and makes a modal half-close on I (b4) with a breath; the consequent (b5-8) leaps to the single agogic apex G5 (b5, on the strong beat, held, not at phrase-end), terraces down, and closes with the leading-tone-FREE modal cadence bVII->I - a stepwise b7->1 (F-natural->G, a WHOLE step, no F#) onto the long held tonic."

      phrase :melody_line, pitch: :degrees do
        key_context "G3"
        degrees "1 3 5 3 1' r | b7, 2 4 2 b7 r | 4 6 1' 6 4 r | 1 5 3 1 r | 1 5 3' 1'' 6' r | b7 2' b7 4 b7, 2 r | 4 1' 6 4 6 r | 5 3 b7, 1 3 1"
        rhythm  "1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1 1/2 3/2 | 1/2 1/2 1/2 3/2 1/2 1/2 | 1/2 1/2 1/2 1/2 1/2 1 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1 1/2 1"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
