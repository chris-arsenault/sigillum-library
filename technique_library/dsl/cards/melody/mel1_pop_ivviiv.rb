production_piece "Technique Card MEL1_POP_IVVIIV - MEL1_POP_IVVIIV" do
  meter "4/4"
  key "D"

  tempo do
    mark "quarter = 72", at: "bar 1 beat 1"
  end

# category: melody
# card: MEL1_POP_IVVIIV
# cite: melody_craft:outlining_changes
# behavior: the I-V-vi-IV pop 'axis' progression (D-A-Bm-G in D major) made AUDIBLE from one
#   unaccompanied line via compound-melody / jazz outlining: each bar drops the chord ROOT low
#   on the downbeat as an implied bass, then arpeggios up through the chord stating its
#   quality-fixing 3rd (F#/C#/D/B) before the upper strand sings - register-segregated wide
#   enough (a 14th total span, G3 bass strand to A5 tune strand) that the ear streams a
#   bass-and-tune two-part texture and reconstructs the changes with nothing playing. An
#   ANTECEDENT (b1-4) plants the hook low and quiet - a rising D-F#-A launch answered by an
#   A4-F#-E-D 'sigh', each chord-change marked by a new low root + its 3rd, a half-bar of breath
#   ending the A and G bars; the CONSEQUENT (b5-8) lifts register and drives a rising D-arpeggio
#   up to the single leapt-to apex A5 (held, strong beat, b6, used once, not at the phrase end),
#   then a stepwise descent guide-tone-led into a PAC - ^3(F#)-^2(E)-^1(D) over a low-root D,
#   looping or closing soft rather than slamming. Avoids the in-loop V-I so the axis keeps its
#   'endless' pull; the 3rd is stated every bar so major-vs-minor is never in doubt.

  roster do
    part :melody, "Melody", music21: "Violin", family: :string, description: "Violin"
  end

  section :card, "MEL1_POP_IVVIIV", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "the I-V-vi-IV pop 'axis' progression (D-A-Bm-G in D major) made AUDIBLE from one unaccompanied line via compound-melody / jazz outlining: each bar drops the chord ROOT low on the downbeat as an implied bass, then arpeggios up through the chord stating its quality-fixing 3rd (F#/C#/D/B) before the upper strand sings - register-segregated wide enough (a 14th total span, G3 bass strand to A5 tune strand) that the ear streams a bass-and-tune two-part texture and reconstructs the changes with nothing playing. An ANTECEDENT (b1-4) plants the hook low and quiet - a rising D-F#-A launch answered by an A4-F#-E-D 'sigh', each chord-change marked by a new low root + its 3rd, a half-bar of breath ending the A and G bars; the CONSEQUENT (b5-8) lifts register and drives a rising D-arpeggio up to the single leapt-to apex A5 (held, strong beat, b6, used once, not at the phrase end), then a stepwise descent guide-tone-led into a PAC - ^3(F#)-^2(E)-^1(D) over a low-root D, looping or closing soft rather than slamming. Avoids the in-loop V-I so the axis keeps its 'endless' pull; the 3rd is stated every bar so major-vs-minor is never in doubt."

      phrase :melody_line, pitch: :degrees do
        key_context "D4"
        degrees "1 3 5 3 2 1 | 5, 2 7, 2 5 r | 6, 1 3 1 6, 3 | 4, 6, 1 6, 5, r | 1 5 3 5 1' 3' | 5' 2' 7 5 2 5, | 4, 6, 1 4 6, 5, | 5, 1 3 2 1"
        rhythm  "1/2 1/2 1 1/2 1/2 1 | 3/4 1/4 1/2 1/2 1 1 | 1/2 1/2 1 1/2 1/2 1 | 3/4 1/4 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1 1 | 3/2 1/2 1/2 1/2 1/2 1/2 | 1/2 1/2 1 1/2 1/2 1 | 1/2 1/2 1 1/2 3/2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
