production_piece "Technique Card FG4_DOUBLE_COMBINATION - FG4_DOUBLE_COMBINATION" do
  meter "4/4"
  key "am"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: fugue
# card: FG4_DOUBLE_COMBINATION
# cite: fugue_construction:9 double fugue ; fugue_construction:3 invertible counterpoint
# behavior: the DOUBLE-FUGUE engine: two subjects with INDEPENDENT identities in different
#   value classes, stated separately, then COMBINED, then SWAPPED -- invertible counterpoint
#   at the octave proven in sound. Subject A (violin, b1-2) is the slow subject: lilt and
#   quarters, one saved leap to E5, a G#-A leading-tone close. Subject B (cello, b3-4) is
#   the quick subject: running eighths with a rising head, a dodging leap E3->B2, and a
#   circling descent -- COMPOSED AGAINST SUBJECT A FIRST, so the combination is engineering,
#   not luck. Bars 5-6: the combination -- A above, B below; beats keep to 3rds/6ths/
#   octaves/10ths so the pairing INVERTS: no vertical fifth is trusted on a beat (it would
#   become a fourth), no parallel fourths (they would become fifths). Bars 7-8: the SWAP --
#   Subject A moves to the cello an octave down, Subject B runs above in the violin; every
#   6th has become a 10th and the counterpoint still holds. The two subjects never share a
#   value class for more than a beat, which is why both stay singable when combined. The
#   essential technique is separate statements -> engineered combination -> octave swap;
#   subjects, key, and forces are interchangeable. Write the combination BEFORE finalizing
#   either exposition.

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FG4_DOUBLE_COMBINATION", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "two independent subjects proven compatible both ways round"

    span bars: 1..8, texture: :library_card do
      process "subject A alone (violin b1-2, lilt/quarters, leading-tone close) -> subject B alone (cello b3-4, running eighths, dodge leap, composed against A in advance) -> COMBINATION (b5-6): A over B, beats in 3rds/6ths/octaves so the pair is invertible -> SWAP (b7-8): A in the cello an octave down, B running above in the violin, 6ths now 10ths, cadence together on the shared A. Independence (different value classes) plus engineered invertibility is the whole double-fugue law."

      phrase :fg4_subject_a, surface: :absolute do
        events %q{
          A4:1.5{mp,ten} C5:.5 E5:1 D5:.5 C5:.5 |
          B4:1 E4:1 G#4:1 A4:1
        }
      end

      placement :fg4_subject_a, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "subject A alone: the slow subject"

      phrase :fg4_subject_b, surface: :absolute do
        events %q{
          A2:.5{mp} B2:.5 C3:.5 A2:.5 E3:.5 D3:.5 F3:.5 E3:.5 |
          D3:.5 B2:.5 C3:.5 D3:.5 E3:.5 D3:.5 C3:.5 A2:.5
        }
      end

      placement :fg4_subject_b, part: :violoncello, at: "bar 3 beat 1", role: :specimen, realization: "subject B alone: the quick subject, already shaped to fit under A"

      phrase :fg4_combo_a, surface: :absolute do
        events %q{
          A4:1.5{mf,ten} C5:.5 E5:1 D5:.5 C5:.5 |
          B4:1 E4:1 G#4:1 A4:1
        }
      end

      placement :fg4_combo_a, part: :violin, at: "bar 5 beat 1", role: :specimen, realization: "combination: subject A above"

      phrase :fg4_combo_b, surface: :absolute do
        events %q{
          A2:.5{mf} B2:.5 C3:.5 A2:.5 E3:.5 D3:.5 F3:.5 E3:.5 |
          D3:.5 B2:.5 C3:.5 D3:.5 E3:.5 D3:.5 C3:.5 A2:.5
        }
      end

      placement :fg4_combo_b, part: :violoncello, at: "bar 5 beat 1", role: :specimen, realization: "combination: subject B below"

      phrase :fg4_swap_a, surface: :absolute do
        events %q{
          A3:1.5{f,ten} C4:.5 E4:1 D4:.5 C4:.5 |
          B3:1 E3:1 G#3:1 A3:1
        }
      end

      placement :fg4_swap_a, part: :violoncello, at: "bar 7 beat 1", role: :specimen, realization: "the swap: subject A in the bass, an octave down"

      phrase :fg4_swap_b, surface: :absolute do
        events %q{
          A4:.5{f} B4:.5 C5:.5 A4:.5 E5:.5 D5:.5 F5:.5 E5:.5 |
          D5:.5 B4:.5 C5:.5 D5:.5 E5:.5 D5:.5 C5:.5 A4:.5{ten}
        }
      end

      placement :fg4_swap_b, part: :violin, at: "bar 7 beat 1", role: :specimen, realization: "the swap: subject B running above -- octave inversion proven"

    end
  end
end
