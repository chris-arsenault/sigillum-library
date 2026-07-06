production_piece "Technique Card MEL3_GUIDE_TONES - MEL3_GUIDE_TONES" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 168", at: "bar 1 beat 1"
  end

# category: melody
# card: MEL3_GUIDE_TONES
# cite: melody_craft:guide_tone_outlining
# behavior: a bebop head that spells a ii-V-I turnaround through its GUIDE TONES alone, no
#   comping - Gm7-C7-Fmaj7 | A7-Dm7-G7-C7-Fmaj7 in F major, medium-up and swung. The engine is
#   the 7th-of-one-chord-resolves-down-to-the-3rd-of-the-next half-step chain (C/7-of-Gm7 -> B-,
#   B-/7-of-C7 -> A then E the 3rd of F; F/7-of-G7 -> E the 3rd of C7): the 3rds and 7ths state
#   every chord's quality before any root is needed. To anchor a SOLO line with no bass, each
#   bar plants its ROOT LOW on the downbeat (G3, C4, F3, A3, D4, G3, C4, F3) - the lowest
#   strong-beat pitch reads as the implied bass - then arpeggiates UP through the guide-tone 3rd
#   and 7th so quality rings above identity. The load-bearing accidental is C#4 on the A7
#   downbeat (the chromatic 3rd outside F major) HAMMERED agogic over two beats - one note that
#   forces the ear to hear the secondary dominant V/vi. Off-beat chromatic/diatonic approaches
#   (B-->A into C7, F->E into the G7 leading tone) sit on the weak beats so they decorate
#   without lying. The head LAUNCHES on the b1 downbeat root and crosses each barline; a
#   half-bar rest after the Fmaj7 arrival (b3) gives the only breath; the line then rises
#   through the second ii-V to a rationed apex G5 over the cadential C7 (b7), and resolves the
#   final 7->3 slip onto A (the 3rd of F), held - quality, not root, as the close.

  roster do
    part :melody, "Melody", music21: "Trumpet", family: :brass, description: "Trumpet"
  end

  section :card, "MEL3_GUIDE_TONES", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..8, texture: :library_card do
      process "a bebop head that spells a ii-V-I turnaround through its GUIDE TONES alone, no comping - Gm7-C7-Fmaj7 | A7-Dm7-G7-C7-Fmaj7 in F major, medium-up and swung. The engine is the 7th-of-one-chord-resolves-down-to-the-3rd-of-the-next half-step chain (C/7-of-Gm7 -> B-, B-/7-of-C7 -> A then E the 3rd of F; F/7-of-G7 -> E the 3rd of C7): the 3rds and 7ths state every chord's quality before any root is needed. To anchor a SOLO line with no bass, each bar plants its ROOT LOW on the downbeat (G3, C4, F3, A3, D4, G3, C4, F3) - the lowest strong-beat pitch reads as the implied bass - then arpeggiates UP through the guide-tone 3rd and 7th so quality rings above identity. The load-bearing accidental is C#4 on the A7 downbeat (the chromatic 3rd outside F major) HAMMERED agogic over two beats - one note that forces the ear to hear the secondary dominant V/vi. Off-beat chromatic/diatonic approaches (B-->A into C7, F->E into the G7 leading tone) sit on the weak beats so they decorate without lying. The head LAUNCHES on the b1 downbeat root and crosses each barline; a half-bar rest after the Fmaj7 arrival (b3) gives the only breath; the line then rises through the second ii-V to a rationed apex G5 over the cadential C7 (b7), and resolves the final 7->3 slip onto A (the 3rd of F), held - quality, not root, as the close."

      phrase :melody_line, pitch: :degrees do
        key_context "F3"
        degrees "2 4 6 1' 4' 3' 1' | 5 7 2' 4' 3' 2' | 1 3 5 7 3' r | 3 #5 7 #5 3 | 6 1' 3' 6 1' 5' 3' 1' | 2 #4 6 1' 7 #4 | 5 7 2' 4' 7' 2'' | 1' 7 1 3 5 3'"
        rhythm  "1/2 1/2 1/2 1/2 1/2 1/2 1 | 1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1 1 1/2 1/2 1 | 1/2 1/2 1/2 1/2 1/2 1/4 1/4 1 | 1 1/2 1/2 1 1/2 1/2 | 1/2 1/2 1/2 1/2 1 1 | 1/2 1/2 1/2 1/2 1/2 3/2"
      end

      placement :melody_line, part: :melody, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
