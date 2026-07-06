production_piece "Technique Card OT9_STOP_AND_PROCLAIM - OT9_STOP_AND_PROCLAIM" do
  meter "2/4", beat_pattern: [1, 1]
  key "am"

  tempo do
    mark "quarter = 120", at: "bar 1 beat 1"
  end

# category: orch.tutti
# card: OT9_STOP_AND_PROCLAIM
# cite: orchestration_techniques:tutti ; The Banner Recursion bridge (bars 41-44)
# behavior: a "stop and tutti proclamation" that JOINS TWO SECTIONS. The independent
#   groove of section A (1-2) first breaks into a sparse shared off-beat cell -- every
#   voice on the same hit / rest-rest / hit rhythm (3-4) -- then ALL voices STOP their
#   separate parts and hit ONE rhythmic gesture together: a tutti triplet break-beat on
#   a dominant-function chord (5), which lands section B (6). The essential technique is
#   the FULL-ENSEMBLE UNISON BREAK BEAT at the seam, not the specific timing or harmony:
#   any rhythm (here a triplet), any approach chord, any two sections. Swap the pitches
#   and the key freely; keep every voice participating in the one shared break-beat hit.

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
    part :percussion, "Percussion", music21: "Percussion", family: :percussion, description: "Snare / bass drum / cymbal"
  end

  section :card, "OT9_STOP_AND_PROCLAIM", bars: 1..6, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "the full-voice break-beat proclamation joins section A to section B"

    span bars: 1..6, texture: :library_card do
      process "section A groove (1-2) -> sparse shared off-beat cell that breaks the groove, every voice on the same hit/rest-rest/hit rhythm (3-4) -> tutti triplet break-beat proclamation, the whole ensemble in one unison rhythm on a dominant chord (5) -> section B arrival (6). Full voice participation in the single break beat is the technique; pitches, harmony, and the exact rhythm are interchangeable."

      phrase :flute_line, surface: :absolute do
        events %q{
          C6:.5{mf,marc} E6:.5 A6:.5 E6:.5 |
          B5:.5 C6:.5 E6:.5 C6:.5 |
          A5:.5{mp} r:.5 r:.5 D6:.5 |
          G#5:.5 r:.5 r:.5 B5:.5 |
          E6:2/3{ff,marc} G#6:2/3 B6:2/3 |
          A5:2{f,ten}
        }
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

      phrase :trumpet_line, surface: :absolute do
        events %q{
          E5:.5{mf} A5:.5 C6:.5 A5:.5 |
          G#5:.5 A5:.5 E5:.5 r:.5 |
          A5:.5{mp} r:.5 r:.5 F5:.5 |
          E5:.5 r:.5 r:.5 D5:.5 |
          B4:2/3{ff,marc} D5:2/3 G#5:2/3 |
          A5:2{f,ten}
        }
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

      phrase :trombone_line, surface: :absolute do
        events %q{
          A3:.5{mf} E3:.5 A3:.5 E3:.5 |
          E3:.5 A3:.5 G#3:.5 E3:.5 |
          F3:.5{mp} r:.5 r:.5 A3:.5 |
          E3:.5 r:.5 r:.5 G#3:.5 |
          E3:2/3{ff,marc} G#3:2/3 B3:2/3 |
          A3:2{f,ten}
        }
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

      phrase :violin_line, surface: :absolute do
        events %q{
          A5:.5{mf,marc} C6:.5 E6:.5 C6:.5 |
          D6:.5 C6:.5 B5:.5 A5:.5 |
          A5:.5{mp} r:.5 r:.5 D6:.5 |
          B5:.5 r:.5 r:.5 G#5:.5 |
          G#5:2/3{ff,marc} B5:2/3 E6:2/3 |
          A5:2{f,ten}
        }
      end

      placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

      phrase :violoncello_line, surface: :absolute do
        events %q{
          A2:.5{mf,marc} E3:.5 A2:.5 E3:.5 |
          A2:.5 E3:.5 A2:.5 E3:.5 |
          D3:.5{mp} r:.5 r:.5 D3:.5 |
          E3:.5 r:.5 r:.5 E3:.5 |
          E3:2/3{ff,marc} B3:2/3 D4:2/3 |
          A2:2{f,ten}
        }
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

      phrase :contrabass_line, surface: :absolute do
        events %q{
          A1:.5{mf,marc} A1:.5 E2:.5 A1:.5 |
          E2:.5 A1:.5 E2:.5 A1:.5 |
          D2:.5{mp} r:.5 r:.5 D2:.5 |
          E2:.5 r:.5 r:.5 E2:.5 |
          E2:2/3{ff,marc} E2:2/3 E2:2/3 |
          A1:2{f,ten}
        }
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

      phrase :percussion_line, surface: :absolute do
        events %q{
          C3:.5{mf,marc} r:.5 F2:.5 C3:.5 |
          r:.5 C3:.5 F2:.5 C3:.5 |
          C3:.5{mp} r:.5 r:.5 C3:.5 |
          C3:.5 r:.5 r:.5 C3:.5 |
          G3:2/3{ff,accent} C3:2/3 C3:2/3 |
          C3:2{f}
        }
      end

      placement :percussion_line, part: :percussion, at: "bar 1 beat 1", role: :specimen, realization: "absolute audition specimen"

    end
  end
end
