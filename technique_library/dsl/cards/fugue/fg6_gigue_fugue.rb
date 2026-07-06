production_piece "Technique Card FG6_GIGUE_FUGUE - FG6_GIGUE_FUGUE" do
  meter "12/8", beat_pattern: [3, 3, 3, 3]
  key "G"

  tempo do
    mark "dotted-quarter = 112", at: "bar 1 beat 1"
  end

# category: fugue
# card: FG6_GIGUE_FUGUE
# cite: fugue_construction:10 gigue-fugue dialect ; fugue_construction:2 real answer ; fugue_construction:5 hemiola episode
# behavior: the GIGUE-FUGUE dialect (BWV 577 family): a compound-meter fugal exposition
#   whose two native value classes are the LILT (quarter+eighth inside the dotted beat)
#   and the RUNNING EIGHTH STREAM, with HEMIOLA as the rationed episode spice. The subject
#   (bassoon, b1-2) is pure gigue: three lilt beats and a running close, then a leap-crown
#   to G4 and a running descent to the tonic -- it starts on the tonic with no early
#   dominant prominence and no internal modulation, so it takes a REAL ANSWER (oboe, b3-4,
#   exact transposition to D with F#/C#). The countersubject (bassoon under the answer,
#   then oboe under the flute entry, transposed diatonically) is the running-eighth
#   stream: it RUNS where the subject lilts and lilts (the one quarter) where the subject
#   runs -- compound-meter complementary rhythm. Third entry (flute, b5-6) completes the
#   3-voice exposition over a slow dotted-quarter floor (bassoon), stacking all three
#   value classes at once. Bar 7: the HEMIOLA EPISODE -- flute and oboe regroup the bar
#   into six quarter-note pairs in parallel thirds (a 6/4 cross-meter) while the bassoon
#   keeps the dotted-quarter tread on a dominant D: the two meters audibly grind. Bar 8
#   resolves the friction into a plain V7-I gigue cadence. Swap key, subject, and forces
#   freely; keep lilt-vs-stream complementarity and ration the hemiola to the seam.

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
  end

  section :card, "FG6_GIGUE_FUGUE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "a compound-meter fugal exposition with real answer, stream countersubject, and one hemiola seam"

    span bars: 1..8, texture: :library_card do
      process "gigue subject alone (bassoon b1-2: lilt beats, running close, leap-crown, running descent to the tonic) -> real answer (oboe b3-4, exact transposition to D) over the running-eighth countersubject (bassoon) -> third entry (flute b5-6, back at the tonic octave) over the countersubject moved to the oboe and a dotted-quarter bassoon floor: lilt, stream, and tread stacked -> hemiola episode (b7): flute+oboe in parallel-third quarter pairs across the dotted beats over a re-struck D tread -> V7-I gigue cadence (b8). Compound-meter fugue law: the lilt and the stream are the two value classes, they complement, and hemiola is spent only at the seam."

      phrase :fg6_subject, surface: :absolute do
        events %q{
          G3:1{mf} A3:.5 B3:1 C4:.5 D4:1 B3:.5 C4:.5 B3:.5 A3:.5 |
          G3:1 B3:.5 D4:1 G4:.5 F#4:.5 E4:.5 D4:.5 C4:.5 A3:.5 G3:.5
        }
      end

      placement :fg6_subject, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "the gigue subject: lilt rise, running turn, leap-crown, running fall to the tonic"

      phrase :fg6_answer, surface: :absolute do
        events %q{
          D4:1{mf} E4:.5 F#4:1 G4:.5 A4:1 F#4:.5 G4:.5 F#4:.5 E4:.5 |
          D4:1 F#4:.5 A4:1 D5:.5 C#5:.5 B4:.5 A4:.5 G4:.5 E4:.5 D4:.5
        }
      end

      placement :fg6_answer, part: :oboe, at: "bar 3 beat 1", role: :specimen, realization: "real answer: exact transposition to the dominant, F# and C# and all"

      phrase :fg6_countersubject_bassoon, surface: :absolute do
        events %q{
          B2:.5{mp} A2:.5 B2:.5 D3:.5 C3:.5 B2:.5 C3:.5 D3:.5 E3:.5 B2:1 E3:.5 |
          B2:.5 A2:.5 G2:.5 F#2:.5 G2:.5 A2:.5 A2:1 G2:.5 B2:.5 G2:.5 D3:.5
        }
      end

      placement :fg6_countersubject_bassoon, part: :bassoon, at: "bar 3 beat 1", role: :specimen, realization: "the countersubject: the running stream under the lilting answer, one lilt where the answer runs"

      phrase :fg6_third_entry, surface: :absolute do
        events %q{
          G4:1{f} A4:.5 B4:1 C5:.5 D5:1 B4:.5 C5:.5 B4:.5 A4:.5 |
          G4:1 B4:.5 D5:1 G5:.5 F#5:.5 E5:.5 D5:.5 C5:.5 A4:.5 G4:.5
        }
      end

      placement :fg6_third_entry, part: :flute, at: "bar 5 beat 1", role: :specimen, realization: "third entry crowns the exposition at the upper tonic octave"

      phrase :fg6_countersubject_oboe, surface: :absolute do
        events %q{
          E4:.5{mp} D4:.5 E4:.5 G4:.5 F#4:.5 E4:.5 F#4:.5 G4:.5 A4:.5 E4:1 A4:.5 |
          E4:.5 D4:.5 C4:.5 B3:.5 C4:.5 D4:.5 D4:1 C4:.5 E4:.5 C4:.5 G4:.5
        }
      end

      placement :fg6_countersubject_oboe, part: :oboe, at: "bar 5 beat 1", role: :specimen, realization: "the countersubject transposed diatonically to the tonic, moved to the middle voice"

      phrase :fg6_floor_bassoon, surface: :absolute do
        events %q{
          G2:3{mp} B2:1.5 A2:1.5 |
          G2:1.5 B2:1.5 D3:1.5 D3:1.5
        }
      end

      placement :fg6_floor_bassoon, part: :bassoon, at: "bar 5 beat 1", role: :specimen, realization: "dotted-quarter floor: the third value class, ending on the dominant seventh into the episode"

      phrase :fg6_hemiola_flute, surface: :absolute do
        events %q{
          E5:1{f} D5:1 C5:1 B4:1 A4:1 C5:1
        }
      end

      placement :fg6_hemiola_flute, part: :flute, at: "bar 7 beat 1", role: :specimen, realization: "hemiola: six quarters across four dotted beats"

      phrase :fg6_hemiola_oboe, surface: :absolute do
        events %q{
          C5:1{f} B4:1 A4:1 G4:1 F#4:1 A4:1
        }
      end

      placement :fg6_hemiola_oboe, part: :oboe, at: "bar 7 beat 1", role: :specimen, realization: "hemiola partner in parallel thirds"

      phrase :fg6_hemiola_tread, surface: :absolute do
        events %q{
          D3:1.5{mf,marc} D3:1.5 D3:1.5 D3:1.5
        }
      end

      placement :fg6_hemiola_tread, part: :bassoon, at: "bar 7 beat 1", role: :specimen, realization: "the dotted-quarter tread holds the true meter under the cross-grouping"

      phrase :fg6_cadence_flute, surface: :absolute do
        events %q{
          B4:1.5{f} A4:1.5 G4:3
        }
      end

      placement :fg6_cadence_flute, part: :flute, at: "bar 8 beat 1", role: :specimen, realization: "cadence top"

      phrase :fg6_cadence_oboe, surface: :absolute do
        events %q{
          D4:1.5{f} C4:1.5 B3:3
        }
      end

      placement :fg6_cadence_oboe, part: :oboe, at: "bar 8 beat 1", role: :specimen, realization: "cadence middle: the seventh falls to the third"

      phrase :fg6_cadence_bassoon, surface: :absolute do
        events %q{
          G2:1.5{f} D3:1.5 G2:3
        }
      end

      placement :fg6_cadence_bassoon, part: :bassoon, at: "bar 8 beat 1", role: :specimen, realization: "cadence floor"

    end
  end
end
