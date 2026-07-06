production_piece "Technique Card MEL2_DESC_FIFTHS - MEL2_DESC_FIFTHS" do
  meter "4/4"
  key "d"

  tempo do
    mark "quarter = 84", at: "bar 1 beat 1"
  end

# category: melody
# card: MEL2_DESC_FIFTHS
# cite: melody_craft:descending_fifths_melodic_sequence
# behavior: a D-minor Baroque descending-fifths cycle made audible from a SINGLE viola line -
#   the strong beats spell the complete diatonic lap i-iv-VII-III-VI-ii-V-i (roots
#   D-G-C-F-B--E-A-D, each a perfect 5th below the last, the 'inevitability' engine). Built as
#   COMPOUND MELODY: every downbeat drops the chord ROOT into the low register, agogic
#   (dotted-quarter), so the lowest strong-beat pitch is heard as the implied bass; the upper
#   strand then leaps up to state that chord's 3rd and runs the GUIDE-TONE SLIP that drives the
#   cycle - the 7th of each chord falls by step to the 3rd of the next (C=7th of Dm slips to
#   B-=3rd of Gm; F=7th of Gm slips to E=3rd of C; B-=7th of C to A=3rd of F; and so on), the
#   chained 7->3 resolution that IS the sound of the changes turning. The melodic-sequence cell
#   (low-root + leap-to-3rd + falling tail) transposes DOWN A STEP per link (b1-3) with a
#   half-bar breath between copies so the lock-step sequence phrases instead of churning. The
#   surface DEVELOPS: bright falling-thirds copies early -> b4 drives without breath into the
#   one rationed APEX (D6, b5, the 3rd of VI) -> a breath at the diminished ii link (b6) -> the
#   literal sequence ABANDONED at V (b7, the raised leading-tone C# held agogic) for a real
#   ^2-^1 PAC on the re-struck low tonic (b8).

  roster do
    part :melody, "Melody", music21: "Viola", family: :string, description: "Viola"
  end

  section :card, "MEL2_DESC_FIFTHS", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a D-minor Baroque descending-fifths cycle made audible from a SINGLE viola line - the strong beats spell the complete diatonic lap i-iv-VII-III-VI-ii-V-i (roots D-G-C-F-B--E-A-D, each a perfect 5th below the last, the 'inevitability' engine). Built as COMPOUND MELODY: every downbeat drops the chord ROOT into the low register, agogic (dotted-quarter), so the lowest strong-beat pitch is heard as the implied bass; the upper strand then leaps up to state that chord's 3rd and runs the GUIDE-TONE SLIP that drives the cycle - the 7th of each chord falls by step to the 3rd of the next (C=7th of Dm slips to B-=3rd of Gm; F=7th of Gm slips to E=3rd of C; B-=7th of C to A=3rd of F; and so on), the chained 7->3 resolution that IS the sound of the changes turning. The melodic-sequence cell (low-root + leap-to-3rd + falling tail) transposes DOWN A STEP per link (b1-3) with a half-bar breath between copies so the lock-step sequence phrases instead of churning. The surface DEVELOPS: bright falling-thirds copies early -> b4 drives without breath into the one rationed APEX (D6, b5, the 3rd of VI) -> a breath at the diminished ii link (b6) -> the literal sequence ABANDONED at V (b7, the raised leading-tone C# held agogic) for a real ^2-^1 PAC on the re-struck low tonic (b8)."

      phrase :melody_line, pitch: :degrees do
        key_context "D4"
        degrees "1 b3 5 b7 r | 4, b6 1' b3' r | b7, 2 4 b6 r | b3, 5 b7 2' | b6, b3' 1'' b6 5' | 2 4 6 1' r | 5, 7 2' 4 | 1 b3 2 1"
        rhythm  "3/2 1/2 1/2 1/2 1 | 3/2 1/2 1/2 1/2 1 | 3/2 1/2 1/2 1/2 1 | 3/2 1/2 1 1 | 1 1/2 1 1/2 1 | 3/2 1/2 1/2 1/2 1 | 3/2 1 1/2 1 | 3/2 1/2 1/2 3/2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
