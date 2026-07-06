production_piece "Technique Card V4_CHANGED_EXIT_RETURN - V4_CHANGED_EXIT_RETURN" do
  meter "2/4", beat_pattern: [1, 1]
  key "G"

  tempo do
    mark "quarter = 108", at: "bar 1 beat 1"
  end

# category: variation
# card: V4_CHANGED_EXIT_RETURN
# cite: phrasing_variation_line s2 ; Wiedemann b13-19
# behavior: THE EXACT RETURN WITH ONLY ITS EXIT CHANGED: bars 5-7 restate bars 1-3 literally; the
#   single difference is the last bar - the settle becomes a plunge. Recognition is total,
#   the surprise is total, and it cost one bar. From Wiedemann b19 (the octave return whose
#   only variation is its exit) and Kietzer m17 (same station, new departure track).

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind
  end

  section :card, "V4_CHANGED_EXIT_RETURN", bars: 1..8, type: :technique_card do
    journey "auditionable lesson specimen for composing new material"
    destination "the device is audible in the line without reading the prose"

    span bars: 1..8, texture: :library_card do
      process "a four-bar phrase that settles; its literal return; the exit bar alone replaced by a plunge"

      phrase :v4_changed_exit_return, surface: :absolute do
        events %q{
          G5:.5{mf,ten} B5:.25{stacc} A5:.25{stacc} G5:.5 D5:.5{stacc} |
          E5:.5{ten} G5:.25{stacc} F#5:.25{stacc} E5:.5 C5:.5{stacc} |
          D5:.5{ten} F#5:.25{stacc} E5:.25{stacc} D5:.5 B4:.5{stacc} |
          A4:.5 B4:.25{stacc} C5:.25{stacc} B4:.5 G4:.5{ten} |
          G5:.5{mf,ten} B5:.25{stacc} A5:.25{stacc} G5:.5 D5:.5{stacc} |
          E5:.5{ten} G5:.25{stacc} F#5:.25{stacc} E5:.5 C5:.5{stacc} |
          D5:.5{ten} F#5:.25{stacc} E5:.25{stacc} D5:.5 B4:.5{stacc} |
          A4:.25{stacc} G4:.25{stacc} F#4:.25{stacc} E4:.25{stacc} D4:.5 G4:.5{marc}
        }
      end

      placement :v4_changed_exit_return, part: :flute, at: "bar 1 beat 1", role: :subject, realization: "lesson specimen"
    end
  end
end
