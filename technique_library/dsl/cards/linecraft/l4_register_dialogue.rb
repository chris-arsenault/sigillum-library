production_piece "Technique Card L4_REGISTER_DIALOGUE - L4_REGISTER_DIALOGUE" do
  meter "3/4", beat_pattern: [1, 1, 1]
  key "e"

  tempo do
    mark "quarter = 112", at: "bar 1 beat 1"
  end

# category: linecraft
# card: L4_REGISTER_DIALOGUE
# cite: etude_pitch_devices ; Wiedemann b20-23
# behavior: CONSECUTIVE BARS AS DIFFERENT VOICES: bar-by-bar contrast made of pure register - a
#   low-voice bar asks, a high-voice bar answers, the rhythm never changes. The two-voice
#   illusion means adjacent bars are maximally different while the material stays unified.
#   From Wiedemann b20-23 (registral antiphony spanning 26 semitones inside single bars).

  roster do
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
  end

  section :card, "L4_REGISTER_DIALOGUE", bars: 1..6, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..6, texture: :library_card do
      process "low bar asks, high bar answers, twice; the fifth bar spans both registers in one gesture; seal"

      phrase :l4_register_dialogue, surface: :absolute do
        events %q{
          E3:.5{mp,slur(} F#3:.5 G3:.5 A3:.5 B3:.5 E4:.5{slur)} |
          E5:.5{slur(} D5:.5 C5:.5 B4:.5 A4:.5 G4:.5{slur)} |
          C4:.5{slur(} B3:.5 A3:.5 G3:.5 F#3:.5 B3:.5{slur)} |
          D#5:.5{slur(} E5:.5 F#5:.5 G5:.5 F#5:.5 B4:.5{slur)} |
          E4:.5{slur(} B4:.5 E5:.5 G5:.5{slur)} F#5:.5{stacc} D#5:.5{stacc} |
          E5:2.5{ten} r:.5
        }
      end

      placement :l4_register_dialogue, part: :clarinet, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
