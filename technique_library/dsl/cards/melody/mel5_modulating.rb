production_piece "Technique Card MEL5_MODULATING - MEL5_MODULATING" do
  meter "3/4"
  key "C"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: melody
# card: MEL5_MODULATING
# cite: melody_craft:common_tone_modulation
# behavior: a COMMON-TONE modulation by chromatic mediant - C major -> A- major (down a major
#   3rd) - the 'sudden new light' wonder modulation, hearable from the LINE alone with no chord.
#   The pivot is the single shared pitch C: it is ^1 of C major and ^3 of A- major, so the line
#   holds/re-strikes it across the seam and lets its MEANING flip (tonic -> the bright 3rd of
#   the new world). b1-4 plant C unmistakably, every downbeat landing the chord ROOT to spell a
#   clean I-IV-V-I (C-F-G-C): a rising tonic gesture to a held 5th, a bright F-A-C subdominant
#   arch, a dominant climb that hangs on ^2 (D) as the open question, then an IAC return to C -
#   and THERE is the pivot: the common tone C is held agogic, dropped low, and FRAMED BY A
#   HALF-BAR BREATH (silence is the accent before the door opens). b5 is the EVENT: a low A-
#   root sounds the new tonal floor while the just-held C is re-cast above it as the 3rd of A-
#   (the chromatic-mediant glow) and the line settles onto the new 5th E- - four flats arrive at
#   once and the world has tilted. The second half LIVES in A- and CADENCES there (a true
#   modulation): b6 is D- (IV of A-) arching to the single leapt-to APEX F5 (recovered by step),
#   b7 the E- dominant (V of A-, 3rd G = the new leading tone), b8 a PAC in A- - ^2->^1 (B-->A-)
#   clinched by a falling A--triad arpeggio onto the low new tonic.

  roster do
    part :melody, "Melody", music21: "Clarinet", family: :woodwind, description: "Clarinet"
  end

  section :card, "MEL5_MODULATING", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a COMMON-TONE modulation by chromatic mediant - C major -> A- major (down a major 3rd) - the 'sudden new light' wonder modulation, hearable from the LINE alone with no chord. The pivot is the single shared pitch C: it is ^1 of C major and ^3 of A- major, so the line holds/re-strikes it across the seam and lets its MEANING flip (tonic -> the bright 3rd of the new world). b1-4 plant C unmistakably, every downbeat landing the chord ROOT to spell a clean I-IV-V-I (C-F-G-C): a rising tonic gesture to a held 5th, a bright F-A-C subdominant arch, a dominant climb that hangs on ^2 (D) as the open question, then an IAC return to C - and THERE is the pivot: the common tone C is held agogic, dropped low, and FRAMED BY A HALF-BAR BREATH (silence is the accent before the door opens). b5 is the EVENT: a low A- root sounds the new tonal floor while the just-held C is re-cast above it as the 3rd of A- (the chromatic-mediant glow) and the line settles onto the new 5th E- - four flats arrive at once and the world has tilted. The second half LIVES in A- and CADENCES there (a true modulation): b6 is D- (IV of A-) arching to the single leapt-to APEX F5 (recovered by step), b7 the E- dominant (V of A-, 3rd G = the new leading tone), b8 a PAC in A- - ^2->^1 (B-->A-) clinched by a falling A--triad arpeggio onto the low new tonic."

      phrase :melody_line, pitch: :degrees do
        key_context "C4"
        degrees "1 3 5 3 | 4 6 1' 6 | 5 7 2' 7 | 1' 5 1 r | b6, 1 b3 b6 | b2 b6 4' b3' | b3 5 b7 5 | b7 b6 b3 1 b6,"
        rhythm  "1/2 1/2 3/2 1/2 | 1 1/2 1/2 1 | 1/2 1/2 3/2 1/2 | 1 1/2 1 1/2 | 1/2 1 1/2 1 | 1/2 1/2 1 1 | 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
