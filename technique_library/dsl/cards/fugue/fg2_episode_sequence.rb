production_piece "Technique Card FG2_EPISODE_SEQUENCE - FG2_EPISODE_SEQUENCE" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 100", at: "bar 1 beat 1"
  end

# category: fugue
# card: FG2_EPISODE_SEQUENCE
# cite: fugue_construction:5 episodes ; fugue_construction:6 entries and keys
# behavior: the FUGUE EPISODE engine: sequence a subject FRAGMENT to modulate between
#   entries, then bring the episode back TRANSFORMED (inverted direction, parts swapped),
#   never as a plain transposition. Bars 1-3: the first episode -- the violin sequences a
#   descending four-8th tail fragment down one step per bar (E-D-C-B / D-C-B-A / C-B-A-G#)
#   while the cello answers each landing with the fragment's INVERSION rising in the gap
#   (gap-fill dialogue, voices alternating, two-voice thinning for relief); the G# and the
#   cello's F2-D2-E2 turn the sequence into dominant preparation for A minor. Bar 4: the
#   episode does its job -- it LEADS TO AN ENTRY: the cello states the subject head in A
#   minor under falling-third quarters. Bars 5-7: the SECOND episode uses the SAME material
#   with the roles exchanged and the direction inverted -- now the cello runs the rising
#   form, the violin answers with the falling fragment, and the sequence climbs by step
#   (white-note pivot, no accidental) back toward C, landing on G as dominant. Bar 8: the
#   arrival entry in C (violin head) over the cadence floor. The essential technique is
#   fragment + sequence + modulation-inside-the-episode + inverted/swapped return; the
#   fragment itself and the two keys are interchangeable.

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FG2_EPISODE_SEQUENCE", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "two episodes from one fragment, each leading to an entry, the second inverted and swapped"

    span bars: 1..8, texture: :library_card do
      process "episode 1 (b1-3): violin sequences the descending tail fragment down a step per bar, cello answers with the rising inversion in each gap; G# + F2-D2-E2 make it dominant preparation -> entry (b4): cello subject head in A minor under falling thirds -> episode 2 (b5-7): same fragment, parts SWAPPED and direction INVERTED, rising stepwise back to C, cello landing G2 as dominant -> entry (b8): violin head in C over the close. Episodes are sequences of subject fragments that modulate and always deliver an entry; a return of an episode must be transformed, not transposed."

      phrase :fg2_ep1_violin, surface: :absolute do
        events %q{
          E5:.5{mf} D5:.5 C5:.5 B4:.5 C5:1 r:1 |
          D5:.5 C5:.5 B4:.5 A4:.5 B4:1 r:1 |
          C5:.5 B4:.5 A4:.5 G#4:.5 A4:1 r:1
        }
      end

      placement :fg2_ep1_violin, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "descending tail fragment sequenced down one step per bar"

      phrase :fg2_ep1_cello, surface: :absolute do
        events %q{
          r:2 A2:.5{mp} B2:.5 C3:.5 D3:.5 |
          r:2 G2:.5 A2:.5 B2:.5 C3:.5 |
          r:2 F2:.5 D2:.5 E2:1
        }
      end

      placement :fg2_ep1_cello, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "rising inversion answers in the gaps; bar 3 bends to dominant preparation"

      phrase :fg2_entry_am_cello, surface: :absolute do
        events %q{
          A2:1{mf,marc} C3:.5 E3:.5 D3:.5 C3:.5 B2:.5 E2:.5
        }
      end

      placement :fg2_entry_am_cello, part: :violoncello, at: "bar 4 beat 1", role: :specimen, realization: "the entry the episode exists to introduce: subject head in A minor"

      phrase :fg2_entry_am_violin, surface: :absolute do
        events %q{
          C5:1{mp} A4:1 F4:1 D4:1
        }
      end

      placement :fg2_entry_am_violin, part: :violin, at: "bar 4 beat 1", role: :specimen, realization: "falling-third quarters clear space above the entry"

      phrase :fg2_ep2_cello, surface: :absolute do
        events %q{
          C3:.5{mp} D3:.5 E3:.5 F3:.5 E3:1 r:1 |
          D3:.5 E3:.5 F3:.5 G3:.5 F3:1 r:1 |
          E3:.5 F3:.5 G3:.5 A3:.5 G3:1 G2:1
        }
      end

      placement :fg2_ep2_cello, part: :violoncello, at: "bar 5 beat 1", role: :specimen, realization: "episode 2: the cello now leads with the rising form, climbing a step per bar to the dominant"

      phrase :fg2_ep2_violin, surface: :absolute do
        events %q{
          r:2 G4:.5{mp} F4:.5 E4:.5 D4:.5 |
          r:2 A4:.5 G4:.5 F4:.5 E4:.5 |
          r:2 B4:.5 C5:.5 D5:.5 B4:.5
        }
      end

      placement :fg2_ep2_violin, part: :violin, at: "bar 5 beat 1", role: :specimen, realization: "the falling fragment answers in the gaps: parts swapped, direction inverted"

      phrase :fg2_entry_c_violin, surface: :absolute do
        events %q{
          C5:1{mf,marc} G5:.5 E5:.5 D5:.5 E5:.5 C5:1
        }
      end

      placement :fg2_entry_c_violin, part: :violin, at: "bar 8 beat 1", role: :specimen, realization: "arrival entry: subject head back in C"

      phrase :fg2_entry_c_cello, surface: :absolute do
        events %q{
          C3:2{mf} G2:1 C3:1
        }
      end

      placement :fg2_entry_c_cello, part: :violoncello, at: "bar 8 beat 1", role: :specimen, realization: "cadence floor under the tonic entry"

    end
  end
end
