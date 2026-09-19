# Technical fixture for one realized clock across notes, controls and exports.
# All active-swing source values are straight; literal triplets occur only off.
production_piece "Global Swing Timing" do
  meter "4/4"
  meter { change "3/8", at: "bar 7" }
  key "C"
  tempo do
    mark "quarter = 104", at: "bar 1 beat 1"
    change "quarter = 96", at: "bar 3 beat 1.25"
  end
  roster do
    part :viola, "Viola", music21: "Viola", family: :string
    part :flute, "Flute", music21: "Flute", family: :woodwind
    part :snare, "Snare", music21: "Percussion", family: :percussion,
         percussion_map: { "C2" => :field_drum }
  end
  section :proof, "Timing cases", bars: 1..8 do
    span bars: 1..8 do
      phrase :bowed, surface: :absolute do
        events "C4:.5 D4:.5 r:.5 [E4,G4]:.5 F4:2 | C4:.75 D4:.25 r:.5 [E4,G4]:.5 F4:2 | C4:.375 D4:.125 E4:1.25 F4:.25 r:2 | r:3.75 G4:.25{tie(} | G4:.25{tie)} A4:.25 r:3.5 | C4:1/3 D4:1/3 E4:1/3 r:3 | C4:.5 D4:.5 E4:.5 | C4:.25 D4:.25 E4:.5 F4:.5"
      end
      phrase :wind, surface: :absolute do
        events "r:.5 G4:1.5 A4:2 | r:.25 B4:.75 C5:1 r:2 | r:.25 D5:1.5 E5:.25 r:2 | r:4 | F5:1 G5:1 r:2 | r:4 | G4:.5 A4:.5 B4:.5 | C5:.375 D5:.125 E5:1"
      end
      phrase :drum, surface: :absolute do
        events "C2:.5{accent} r:.5 C2:.5{ghost} r:2.5 | C2:.75 r:.25 C2:.5 r:2.5 | C2:.25 r:.25 C2:.25{ghost} r:3.25 | r:3.75 C2:.25 | C2:.25 r:3.75 | r:4 | C2:.5 r:.5 C2:.5 | C2:.25 r:.25 C2:.5 r:.5"
      end
      placement :bowed, part: :viola, at: "bar 1 beat 1", role: :foreground
      placement :wind, part: :flute, at: "bar 1 beat 1", role: :counterline
      placement :drum, part: :snare, at: "bar 1 beat 1", role: :rhythm
    end
  end
  control do
    swing :eighth, at: "bar 1 beat 1"
    swing :sixteenth, at: "bar 3 beat 1"
    swing :off, at: "bar 5 beat 1"
    swing :eighth, at: "bar 7 beat 1"
    swing :sixteenth, at: "bar 8 beat 1"
    dynamic :mf, at: "bar 1 beat 1", for: :all
    dynamic :p, at: "bar 3 beat 1.25", for: :flute
    crescendo from: "bar 3 beat 1.25", to: "bar 4 beat 4.75", exact: true, for: :viola
  end
end
