production_piece "Technique Card F6_TOCCATA_ALTERNATION - F6_TOCCATA_ALTERNATION" do
  meter "4/4"
  key "C"

# category: figuration
# card: F6_TOCCATA_ALTERNATION
# cite: keyboard_figuration s6b t2/idiom
# behavior: one pitch traded between two desks in 16ths (bariolage class); accents displaced per
#   bar; off-grid bass stabs

  roster do
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "F6_TOCCATA_ALTERNATION", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "one pitch traded between two desks in 16ths (bariolage class); accents displaced per bar; off-grid bass stabs"

      phrase :violin_i_line, pitch: :intervals do
        anchor "E5"
        intervals "0{mf} r 0{mf} r 0{mf} r 0{mf} r 0{mf} r 0{mf} r 0{mf} r 0{mf} r | r 0 r 0 r 0 r 0 r 0 r 0 r 0 r 0 | 0 r 0 r r 0 0 r 0 r 0 r r 0 0 r | 0 +1 -1 -2 +2 [-12,0]"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1 2"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violin_ii_line, pitch: :intervals do
        anchor "E4"
        intervals "r 0 r 0 r 0 r 0 r 0 r 0 r 0 r 0 | 0 r 0 r 0 r 0 r 0 r 0 r 0 r 0 r | r 0 r 0 0 r r 0 r 0 r 0 0 r r 0 | r -7 +2 +1 [-3,+4]"
        rhythm    "1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 | 1 1/2 1/2 1 1"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

      phrase :violoncello_line, pitch: :intervals do
        anchor "A1"
        intervals "r 0 r | r 0 r | r 0 r +7 r | -7 +7 -7"
        rhythm    "3/2 1/2 2 | 5/2 1/2 1 | 1/2 1/2 2 1/2 1/2 | 1 1 2"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "intervals audition specimen"

    end
  end
end
