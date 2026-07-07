piece "Storyteller Surface Study" do
  meter "7/8", beat_pattern: [3, 2, 2]
  key "F"
  tempo "quarter = 96, unhurried but walking"

  roster do
    part :alto_flute, "Alto Flute", music21: "Flute", family: :woodwind, range: "G3-D6"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, range: "E3-C6"
    part :solo_violin, "Solo Violin", music21: "Violin", family: :string, range: "G3-A6"
    part :viola, "Viola", music21: "Viola", family: :string, range: "C3-E5"
    part :cello, "Violoncello", music21: "Violoncello", family: :string, range: "C2-G4"
    part :harp, "Harp", music21: "Harp", family: :plucked, range: "C2-G6"
    part :hand_drum, "Hand Drum", music21: "Percussion", family: :percussion
  end

  material :plain_call do
    description "The narrator's plain call: high C opens, then the F/Hijaz bite answers."
    notes "C5:1.5 Bb4:.25 A4:.25 F#4:.5 F4:1"
    allowed_transform "register transfer with exact notes written out"
    allowed_transform "cadence diversion with exact notes written out"
  end

  material :missed_answer do
    description "Answer shape that enters late and falls away before sharing the cadence."
    notes "r:.5 A4:1 G4:.5 F#4:.5 E4:.5 r:.5"
    allowed_transform "delayed entry with exact notes written out"
  end

  section :s1, "Plain call in a room", bars: 1..4, type: :plain_statement do
    journey "A single foreground line becomes readable because the bass walks underneath it."
    destination "The call is complete, but the ensemble stays chamber-sized."

    span bars: 1..4, label: "melody-first statement", texture: :melody_over_pizzicato_bass do
      harmony "F home with C# absent; F# is melodic bite, not a new root."
      process "The bass is a sentence, not a block progression."

      line :clarinet, role: :foreground do
        phrase "plain call"
        quote :plain_call, comment: "opening cell stated without transformation" do
          notes "C5:1.5 Bb4:.25 A4:.25 F#4:.5 F4:1"
        end
        phrase "answering tail" do
          notes "G4:1 A4:.5 Bb4:.5 C5:1 r:.5 | D5:1.5 C5:.5 Bb4:.5 A4:.5 F#4:.5 | G4:1 F4:1 E4:.5 F4:.5 r:.5"
        end
        role_detail "The clarinet owns the full sentence; no other line crosses above it."
      end

      line :cello, role: :bass_line, technique: "pizz." do
        notes "F2:1.5 C3:1 F2:1 | Eb3:1 Bb2:.5 C3:.5 F2:1 r:.5 | F2:1 A2:.5 Bb2:.5 C3:1 F2:.5 | E2:1 F2:1 C3:.5 F2:.5 r:.5"
        relation_to :clarinet, "contrary dips answer the clarinet's upward reach in bars 2-3"
      end

      line :viola, role: :counter_hint, technique: "pizz." do
        notes "F3:.5 r:1 C4:.5 r:1.5 | r:1 A3:.5 r:.5 Bb3:.5 r:1 | F3:.5 r:.5 A3:.5 C4:.5 r:1.5 | Bb3:.25 A3:.25 F#3:.5 F3:.5 r:2"
      end

      line :harp, role: :color_halo do
        notes "[F3,C4]:.5 r:1 [F4,A4]:.5 r:1.5 | [F3,C4]:.5 r:1.5 [F#4,A4]:.5 r:1 | [Bb3,F4]:.5 r:1 [C4,F4]:.5 r:1.5 | [F2,F3]:.5 r:3"
      end

      line :hand_drum, role: :quiet_pulse do
        notes "C3:.5 r:1 C3:.5 r:.5 C3:.5 r:.5 | C3:.5 r:1 C3:.5 r:1.5 | C3:.5 r:1 C3:.5 r:.5 C3:.5 r:.5 | C3:.5 r:1 C3:.5 r:1.5"
      end

      line :alto_flute, role: :breath_color do
        notes "r:7 E5:.75 r:6.25"
      end

      line :solo_violin, role: :held_light do
        notes "r:10.5 C5:1 r:2.5"
      end

      moment bar: 1, beat: 1, label: "first sonority" do
        sonority "C over F, bare enough that the call reads as speech."
        foreground :clarinet, "C5"
        bass :cello, "F2"
        color :harp, "F/C halo"
      end

      gesture :plain_speech do
        idea "The narrator speaks before the room decorates the story."
        mechanism "one unharmonized foreground line over a moving pizzicato bass"
        audible "harp attacks are separated by rests, so they do not become a pad"
      end
    end
  end

  section :s2, "Harmony changes the tale", bars: 5..8, type: :harmonic_variation do
    journey "The same call is heard through a darker floor."
    destination "The foreground is still singable, but its cadence is pulled sideways."

    span bars: 5..8, label: "harmony-first recoloring", texture: :thin_chorale_with_foreground do
      harmony "bar 5: F held open; bar 6: Db color under the line; bar 7: C-side pressure; bar 8: F withheld"
      process "The harmony is written as changing floors, not chord labels after the fact."

      line :solo_violin, role: :foreground do
        phrase "recolored call"
        quote :plain_call, transform: "moved into violin register and diverted at the cadence" do
          notes "C5:1 Bb4:.5 A4:.5 F#4:.5 G4:1 | Ab4:.75 Bb4:.25 C5:1 Db5:.5 C5:1 | E5:.5 D5:.5 C5:1 Bb4:.5 A4:.5 G4:.5 | F#4:.5 A4:.5 C5:1 Bb4:.5 r:1"
        end
      end

      line :clarinet, role: :counterline do
        notes "r:.5 F4:1 E4:.5 F4:1 r:.5 | r:1 Db4:.5 F4:.5 Ab4:1 r:.5 | G4:1 E4:.5 F4:.5 G4:.5 r:1 | C4:.5 E4:.5 F4:1 r:1.5"
        relation_to :solo_violin, "mostly under the violin; crosses only by shared C, not by register"
      end

      line :alto_flute, role: :upper_breath do
        notes "r:1 C6:.5 r:2 | r:.5 Db6:.5 C6:.5 r:2 | r:1 E6:.5 r:2 | r:2 A5:.5 r:1"
      end

      line :viola, role: :inner_chorale do
        notes "A3:1 C4:1 Bb3:.5 A3:.5 F3:.5 | Ab3:1 Db4:1 C4:.5 Ab3:.5 F3:.5 | G3:1 C4:.5 E4:.5 D4:1 C4:.5 | A3:.5 Bb3:.5 A3:1 F3:1 r:.5"
      end

      line :cello, role: :bass_line do
        notes "F2:2 C3:.5 F2:1 | Db2:1 Ab2:1 F2:.5 Db2:1 | C2:1 G2:.5 C3:.5 Bb2:1 G2:.5 | F2:.5 C3:.5 E2:1 F2:1 r:.5"
      end

      line :harp, role: :placed_chords do
        notes "[F3,A3,C4]:1 r:.5 [C4,F4]:.5 r:1.5 | [Db3,Ab3,F4]:1 r:1 [C4,Ab4]:.5 r:1 | [C3,G3,E4]:.5 r:1 [Bb3,E4]:.5 r:1.5 | [F3,A3]:.5 r:.5 [E3,Bb3]:.5 [F3,C4]:.5 r:1.5"
      end

      line :hand_drum, role: :reduced_pulse do
        notes "r:1 C3:.5 r:1 C3:.5 r:.5 | r:1.5 C3:.5 r:1.5 | C3:.5 r:1 C3:.5 r:1.5 | r:2 C3:.5 r:1"
      end

      moment bar: 6, beat: 1, label: "dark floor" do
        sonority "Db bass under the same call-shape turns recollection into unease."
        foreground :solo_violin, "Ab4"
        bass :cello, "Db2"
        relation "The call remains legible because the violin keeps the rhythm clear."
      end

      gesture :same_sentence_darker_floor do
        idea "The tale has not changed, but the room now hears a shadow inside it."
        mechanism "same call rhythm over Db and C-side bass floors"
        line_relation :solo_violin, :cello, "violin cadence is diverted while the cello refuses F until the end"
      end
    end
  end

  section :s3, "Crossed approach", bars: 9..12, type: :rhythmic_displacement do
    journey "The pulse becomes clearer while the lines stop meeting on the beat."
    destination "The near-cadence misses by timing, not by volume."

    span bars: 9..12, label: "rhythm-first missed arrival", texture: :locked_pulse_with_late_answer do
      harmony "F pedal pressure with C-side flashes; the harmony does not solve the missed timing."
      process "The hand drum states the floor; the lines reveal the problem by entering around it."

      line :hand_drum, role: :pulse_engine do
        notes "C3:.5 r:.5 C3:.5 C3:.5 r:.5 C3:.5 r:.5 | C3:.5 r:.5 C3:.5 r:1 C3:.5 r:.5 | C3:.5 r:.5 C3:.5 C3:.5 r:.5 C3:.5 r:.5 | C3:.5 r:.5 C3:.5 r:1 C3:.5 r:.5"
      end

      line :cello, role: :bass_ostinato do
        notes "F2:1 C3:.5 F2:.5 E2:.5 F2:.5 C3:.5 | F2:1 Bb2:.5 C3:.5 F2:1 r:.5 | F2:.5 C3:.5 F2:.5 A2:.5 Bb2:.5 C3:.5 F2:.5 | E2:1 F2:.5 C3:.5 F2:1 r:.5"
      end

      line :clarinet, role: :foreground do
        phrase "early caller"
        notes "C5:.75 D5:.25 E5:1 F5:.5 r:1 | G5:.5 F5:.5 E5:.5 D5:.5 C5:.5 r:1 | C5:1 Bb4:.5 A4:.5 G4:.5 F#4:.5 F4:.5 | E4:.5 F4:.5 G4:1 r:1.5"
        relation_to :solo_violin, "arrives before the violin answer and has to leave space"
      end

      line :solo_violin, role: :late_answer do
        quote :missed_answer, comment: "late answer shape materialized rather than generated" do
          notes "r:.5 A4:1 G4:.5 F#4:.5 E4:.5 r:.5 | r:1 C5:.5 Bb4:.5 A4:1 r:.5 | r:.5 D5:1 C5:.5 Bb4:.5 A4:.5 r:.5 | r:1 G4:.5 F#4:.5 E4:1 r:.5"
        end
        relation_to :clarinet, "answers late on every bar and never lands with the caller"
      end

      line :viola, role: :offbeat_counterline do
        notes "r:.5 F3:.5 A3:.5 r:.5 Bb3:.5 A3:.5 F3:.5 | r:1 C4:.5 Bb3:.5 A3:.5 r:1 | F3:.5 r:.5 A3:.5 C4:.5 Bb3:.5 A3:.5 r:.5 | G3:.5 F#3:.5 F3:1 r:1.5"
      end

      line :alto_flute, role: :edge_glint do
        notes "r:2 C6:.25 Db6:.25 C6:.5 r:.5 | r:2.5 E6:.5 r:.5 | r:1.5 C6:.25 Db6:.25 C6:.5 r:1 | r:3.5"
      end

      line :harp, role: :time_markers do
        notes "[F3,C4]:.5 r:1 [A3,E4]:.5 r:1.5 | [Bb3,F4]:.5 r:1.5 [C4,G4]:.5 r:1 | [F3,C4]:.5 r:.5 [A3,F4]:.5 r:2 | [E3,Bb3]:.5 r:.5 [F3,C4]:.5 r:2"
      end

      moment bar: 10, beat: 2.5, label: "not together" do
        sonority "Clarinet leaves the arrival space before violin claims it."
        foreground :clarinet, "C5"
        color :solo_violin, "late C5 answer"
        bass :cello, "Bb2"
        relation "The missed meeting is timing: both lines are audible, but not simultaneous."
      end

      gesture :missed_arrival do
        idea "Two voices approach the same cadence but never share the beat."
        mechanism "clarinet phrases start on the grid; violin answers after a rest on each bar"
        line_relation :clarinet, :solo_violin, "same register band, offset entrances, no shared final attack"
        audible "hand drum remains steady so the listener can hear the displacement"
      end
    end
  end

  section :s4, "Afterimage without fade", bars: 13..16, type: :withheld_arrival do
    journey "Energy disappears by broken entrances, not by four bars of sustained filler."
    destination "A shared rest after the last failed answer."

    span bars: 13..16, label: "gesture-and-silence first", texture: :broken_calls_and_resonance do
      harmony "F remains possible but is never granted as a tutti cadence."
      process "Every line has a specific leaving action: break, answer late, drop, or stop."

      line :clarinet, role: :foreground_fragment do
        notes "C5:1 r:.5 Bb4:.5 A4:.5 r:1 | F#4:.5 F4:.5 r:1 C5:.5 r:1 | Bb4:.5 A4:.5 F#4:.5 r:2 | F4:.5 r:3"
      end

      line :solo_violin, role: :answer_fragment do
        notes "r:1.5 A4:.5 G4:.5 F#4:.5 r:.5 | r:1 E4:.5 F4:.5 G4:.5 r:1 | r:.5 C5:.5 Bb4:.5 A4:.5 r:1.5 | r:1 F#4:.5 E4:.5 r:1.5"
      end

      line :cello, role: :bass_line do
        notes "F2:1 C3:.5 r:1 F2:1 | E2:.5 F2:.5 C3:.5 r:2 | Bb2:.5 A2:.5 F2:.5 r:2 | E2:.5 F2:.5 r:2.5"
      end

      line :viola, role: :inner_aftervoice do
        notes "r:.5 C4:.5 r:.5 A3:.5 r:1.5 | Bb3:.5 r:.5 A3:.5 F#3:.5 r:1.5 | r:1 F3:.5 A3:.5 r:1.5 | C4:.5 Bb3:.5 r:2.5"
      end

      line :alto_flute, role: :air_afterimage do
        notes "r:2.5 C6:.5 r:.5 | r:2 Db6:.25 C6:.25 r:1 | r:3.5 | r:3.5"
      end

      line :harp, role: :resonance_points do
        notes "[F3,C4]:.5 r:2 [A3,F4]:.5 r:.5 | [E3,Bb3]:.5 r:1.5 [F3,C4]:.5 r:1 | [Bb2,F3]:.5 r:3 | [F2,C3]:.5 r:3"
      end

      line :hand_drum, role: :pulse_stops do
        notes "C3:.5 r:1 C3:.5 r:1.5 | C3:.5 r:1.5 C3:.5 r:1 | C3:.5 r:3 | r:3.5"
      end

      moment bar: 16, beat: 2, label: "shared absence" do
        sonority "No cadence stack; the last sound is a failed answer over a bass drop."
        foreground :solo_violin, "F#4/E4 fragment"
        bass :cello, "F2 then rest"
        relation "The silence is composed as all lines stop by different routes."
      end

      gesture :not_a_fade do
        idea "The ending is absence after failed contact, not slow sustained neutral sound."
        mechanism "short fragments, separated rests, and staggered final exits"
        line_relation :clarinet, :solo_violin, "clarinet stops first; violin answers after the window has closed"
        orchestration "harp marks resonance points only; hand drum stops completely in the last bar"
        silence "the shared silence follows active departures, so it is an event rather than empty padding"
      end
    end
  end
end
