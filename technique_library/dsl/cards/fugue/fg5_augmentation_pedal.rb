production_piece "Technique Card FG5_AUGMENTATION_PEDAL - FG5_AUGMENTATION_PEDAL" do
  meter "4/4"
  key "F"

  tempo do
    mark "quarter = 116", at: "bar 1 beat 1"
  end

# category: fugue
# card: FG5_AUGMENTATION_PEDAL
# cite: fugue_construction:8 final section ; fugue_construction:7 augmentation in stretto
# behavior: the FUGUE FINAL-SECTION kit: dominant PEDAL POINT with imitation built above
#   it, the subject in AUGMENTATION against its own quick form, and ADDED VOICES at the
#   last cadence. Bars 1-2: the one-bar subject in its plain eighth-note form (violin),
#   answered at the lower fifth (viola). Bars 3-6: the cello locks a re-struck C pedal
#   (attack logic, not a held drone -- long-short-long-long each bar); above it the viola
#   carries the subject in AUGMENTATION (quarters, twice the length) while the violin
#   answers with the eighth-note form displaced to the half-bar (per arsin et thesin) --
#   the subject imitated BY ITS OWN AUGMENTATION at close distance, Prout's device. Bars
#   5-6 escalate cumulatively: the augmentation moves UP to the violin at the dominant
#   pitch level while the viola runs eighths below -- roles swapped, second entry higher
#   and brighter. Dissonances against the bass are pedal-licensed (tonic-over-dominant
#   6/4 colors, V7/V9 stacks); the upper PAIR keeps to 3rds/6ths/10ths. Bar 7 breaks the
#   pedal into a rhythmic C7 approach (Bb held as the seventh); bar 8 resolves to F with
#   the sanctioned final-cadence license: the three players open into a six-note spread
#   (double stops) -- added parts approaching the final chord. Swap key, subject, and the
#   pedal's rhythm freely; keep pedal-in-final-section, augmentation-against-quick-form,
#   and the reserve of added voices for the last bar.

  roster do
    part :violin, "Violin", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
  end

  section :card, "FG5_AUGMENTATION_PEDAL", bars: 1..8, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "pedal, augmentation against quick form, and an added-voice final cadence"

    span bars: 1..8, texture: :library_card do
      process "subject in eighths (violin b1), answer at the lower fifth (viola b2) -> dominant pedal locks (cello b3-6, re-struck long-short-long-long) carrying: augmented subject in quarters (viola b3-4) under the eighth-note form displaced to the half-bar (violin), then the augmentation SWAPPED UP to the violin at the dominant level over running eighths (viola b5-6) -> the pedal breaks into a rhythmic C7 bar (b7, Bb held as the seventh) -> F arrival with added voices: six notes from three players (b8). Final-section law: pedal belongs here, augmentation crowns the subject, added parts are legal at the last cadence."

      phrase :fg5_subject_quick, surface: :absolute do
        events %q{
          F4:.5{mf} A4:.5 C5:.5 D5:.5 C5:.5 A4:.5 G4:.5 F4:.5
        }
      end

      placement :fg5_subject_quick, part: :violin, at: "bar 1 beat 1", role: :specimen, realization: "the subject: one bar of eighths, arch contour"

      phrase :fg5_answer_quick, surface: :absolute do
        events %q{
          C4:.5{mf} E4:.5 G4:.5 A4:.5 G4:.5 E4:.5 D4:.5 C4:.5
        }
      end

      placement :fg5_answer_quick, part: :viola, at: "bar 2 beat 1", role: :specimen, realization: "answer at the lower fifth"

      phrase :fg5_pedal, surface: :absolute do
        events %q{
          C2:1.5{mp} C2:.5 C2:1 C2:1 |
          C2:1.5 C2:.5 C2:1 C2:1 |
          C2:1.5 C2:.5 C2:1 C2:1 |
          C2:1.5 C2:.5 C2:1 C2:1 |
          C2:1.5{mf} C2:.5 C2:1 C3:1
        }
      end

      placement :fg5_pedal, part: :violoncello, at: "bar 3 beat 1", role: :specimen, realization: "dominant pedal with attack logic: re-struck long-short-long-long, breaking upward into the cadence bar"

      phrase :fg5_augmentation_viola, surface: :absolute do
        events %q{
          F3:1{mf,ten} A3:1 C4:1 D4:1 |
          C4:1 A3:1 G3:1 F3:1
        }
      end

      placement :fg5_augmentation_viola, part: :viola, at: "bar 3 beat 1", role: :specimen, realization: "the subject in augmentation: quarters, twice the length, over the pedal"

      phrase :fg5_quick_over_aug_violin, surface: :absolute do
        events %q{
          r:2 F5:.5{mf} A5:.5 C6:.5 D6:.5 |
          C6:.5 A5:.5 G5:.5 F5:.5 G5:.5 F5:.5 D5:.5 C5:.5
        }
      end

      placement :fg5_quick_over_aug_violin, part: :violin, at: "bar 3 beat 1", role: :specimen, realization: "the quick form displaced to the half-bar against its own augmentation, then a free descent landing on the next entry's first note"

      phrase :fg5_augmentation_violin, surface: :absolute do
        events %q{
          C5:1{f,ten} E5:1 G5:1 A5:1 |
          G5:1 E5:1 D5:1 C5:1
        }
      end

      placement :fg5_augmentation_violin, part: :violin, at: "bar 5 beat 1", role: :specimen, realization: "second augmentation entry, swapped up to the dominant level: cumulative escalation"

      phrase :fg5_quick_under_aug_viola, surface: :absolute do
        events %q{
          E4:.5{mf} F4:.5 G4:.5 A4:.5 E4:.5 D4:.5 F4:.5 C4:.5 |
          E4:.5 F4:.5 C4:.5 D4:.5 F4:.5 G4:.5 E4:.5 C4:.5
        }
      end

      placement :fg5_quick_under_aug_viola, part: :viola, at: "bar 5 beat 1", role: :specimen, realization: "running eighths under the augmentation: roles swapped"

      phrase :fg5_break_violin, surface: :absolute do
        events %q{
          E5:1.5{f} F5:.5 G5:1 E5:1
        }
      end

      placement :fg5_break_violin, part: :violin, at: "bar 7 beat 1", role: :specimen, realization: "the pedal bar breaks into a rhythmic dominant-seventh approach"

      phrase :fg5_break_viola, surface: :absolute do
        events %q{
          C4:1{f} Bb3:3
        }
      end

      placement :fg5_break_viola, part: :viola, at: "bar 7 beat 1", role: :specimen, realization: "Bb held as the seventh of C7, resolving only at the arrival"

      phrase :fg5_final_violin, surface: :absolute do
        events %q{
          [A4,F5]:3{f,ten} r:1
        }
      end

      placement :fg5_final_violin, part: :violin, at: "bar 8 beat 1", role: :specimen, realization: "added-voice final chord, top pair"

      phrase :fg5_final_viola, surface: :absolute do
        events %q{
          [A3,F4]:3{f,ten} r:1
        }
      end

      placement :fg5_final_viola, part: :viola, at: "bar 8 beat 1", role: :specimen, realization: "added-voice final chord, the seventh resolved into the middle pair"

      phrase :fg5_final_cello, surface: :absolute do
        events %q{
          [F2,C3]:3{f} r:1
        }
      end

      placement :fg5_final_cello, part: :violoncello, at: "bar 8 beat 1", role: :specimen, realization: "added-voice final chord, floor"

    end
  end
end
