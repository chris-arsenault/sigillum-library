# Encoding regression fixture: mixed triplet groups, a delayed chord after a
# collapsed rest, beamed chords followed by single notes, and local ghosts.
# Deliberately short technical material, not a composition.
production_piece "Mixed Tuplets and Ghost Notes" do
  meter "4/4"
  key "C"
  tempo "quarter = 104"
  roster do
    part :viola, "Viola", music21: "Viola", family: :string
    part :flute, "Flute", music21: "Flute", family: :woodwind
  end
  section :proof, "Import safety", bars: 1..4 do
    span bars: 1..4 do
      phrase :chords, surface: :absolute do
        events "r:23/6 [C#4,G4]:1/6 | r:.5 [C4,E4]:1/3 [D4,F4]:1/6 E4:1/3 F4:1/6 G4:.5 r:2 | C4:1{mf} D4:1{ghost} E4:1 F4:1{ghost} | r:4"
      end
      phrase :mixed, surface: :absolute do
        events "r:4 | r:2.5 A3:1/3 C4:1/6 D4:.5 C4:1/3 B3:1/6 | r:4 | D4:1/3 r:1/6 E4:1/3 F4:1/6 G4:1/3 r:1/6 r:.5 A4:.5 r:1.5"
      end
      placement :chords, part: :viola, at: "bar 1 beat 1", role: :foreground
      placement :mixed, part: :flute, at: "bar 1 beat 1", role: :counterline
    end
  end
end
