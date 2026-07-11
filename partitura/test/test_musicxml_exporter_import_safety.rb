# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/musicxml_exporter_helpers"

class MusicXMLExporterImportSafetyTest < Minitest::Test
  include MusicXMLExporterHelpers

  def test_note_child_order_keeps_voice_before_type_and_staff_after_type
    note = REXML::XPath.first(render_document(grand_staff_piece), "//note[voice and type and staff]")
    names = child_element_names(note)

    assert_operator names.index("voice"), :<, names.index("type")
    assert_operator names.index("type"), :<, names.index("staff")
  end

  def test_notehead_marks_render_as_direct_note_children
    document = render_document(notehead_piece)
    note = REXML::XPath.first(document, "//note[notehead]")
    names = child_element_names(note)

    assert_equal "x", REXML::XPath.first(note, "notehead").text
    assert_nil REXML::XPath.first(note, "notations/notehead")
    assert_operator names.index("type"), :<, names.index("notehead")
  end

  def test_inactive_secondary_voice_does_not_emit_measure_rest_over_notes
    document = render_document(voice_rest_overlay_piece)
    bar_one = REXML::XPath.first(document, "/score-partwise/part/measure[@number='1']")
    bar_two = REXML::XPath.first(document, "/score-partwise/part/measure[@number='2']")

    assert_equal %w[1 2], REXML::XPath.match(bar_one, "note/voice").map(&:text).uniq.sort
    assert_equal 1, REXML::XPath.match(bar_two, "note[pitch]").length
    assert_empty REXML::XPath.match(bar_two, "note/rest[@measure='yes']")
    refute_includes REXML::XPath.match(document, "//note/voice").map(&:text), "0"
  end

  def test_small_tuplet_durations_render_with_matching_note_type
    note = REXML::XPath.first(render_document(small_tuplet_duration_piece), "//note[pitch]")

    assert_equal "210", text_at(note, "duration")
    assert_equal "128th", text_at(note, "type")
    assert_equal "3", text_at(note, "time-modification/actual-notes")
    assert_equal "2", text_at(note, "time-modification/normal-notes")
    assert_equal "128th", text_at(note, "time-modification/normal-type")
  end

  def test_chord_members_in_tuplets_carry_one_tuplet_mark_per_event
    document = render_document(tuplet_chord_balance_piece)
    starts = REXML::XPath.match(document, %(//tuplet[@type="start"])).length
    stops = REXML::XPath.match(document, %(//tuplet[@type="stop"])).length

    assert_equal starts, stops, "tuplet start/stop marks must balance across chord members"
    assert_equal 4, starts
  end

  def test_collapsed_triplet_rests_still_emit_tuplet_groups
    document = render_document(collapsed_triplet_rest_piece)
    first_rest = REXML::XPath.first(document, "//note[rest]")
    starts = REXML::XPath.match(document, %(//tuplet[@type="start"]))
    stops = REXML::XPath.match(document, %(//tuplet[@type="stop"]))

    assert_equal 4, starts.length
    assert_equal starts.length, stops.length
    assert_equal "eighth", text_at(first_rest, "time-modification/normal-type")
    assert_equal "eighth", text_at(first_rest, "notations/tuplet/tuplet-actual/tuplet-type")
  end

  def test_pending_metadata_uses_lexicographic_bar_and_onset_order
    notes = [
      Partitura::Production::MusicXMLImport::Note.new(bar: 1, onset: 0, midi: 60, duration: 1, marks: [], ties: []),
      Partitura::Production::MusicXMLImport::Note.new(bar: 2, onset: 1, midi: 62, duration: 1, marks: [], ties: [])
    ]

    found = Partitura::Production::MusicXMLImport.pending_anything_at_or_after(notes, 2, Rational(1))

    assert_equal notes.last, found
  end

  private

  def notehead_piece
    single_part_piece(
      "Notehead Export", :snare, "Snare", music21: "Percussion", family: :percussion,
      event_text: "C3:4{xstick}", role: :rhythm
    )
  end

  def small_tuplet_duration_piece
    single_part_piece(
      "Small Tuplet Duration", :viola, "Viola", music21: "Viola", family: :string,
      event_text: "C4:1/48 r:191/48", role: :inner
    )
  end

  def voice_rest_overlay_piece
    Partitura::Production.piece("Voice Rest Overlay") do
      meter "4/4"; key "C"; roster { part :violin, "Violin", music21: "Violin", family: :string }
      section :s1, "Opening", bars: 1..2 do
        span bars: 1..2 do
          phrase(:upper, surface: :absolute) { events "C5:4 | D5:4" }
          phrase(:lower, surface: :absolute) { events "E4:4 | r:4" }
          placement :upper, part: :violin, at: "bar 1 beat 1", role: :foreground
          placement :lower, part: :violin, at: "bar 1 beat 1", role: :inner
        end
      end
    end
  end

  def tuplet_chord_balance_piece
    grid = tuplet_chord_balance_grid
    Partitura::Production.piece("Tuplet Chord Balance") do
      meter "4/4"; key "C"; roster { part :viola, "Viola", music21: "Viola", family: :string }
      section :s1, "Flood", bars: 1..1 do
        span bars: 1..1 do
          texture(:chop, bars: 1..1) { score(grid: :eighth_triplet) { viola grid } }
        end
      end
    end
  end

  def tuplet_chord_balance_grid
    ". [C4,E4] [C4,E4] . [C4,E4] [C4,E4] . [C4,E4] [C4,E4] . [C4,E4] [C4,E4]"
  end

  def collapsed_triplet_rest_piece
    grid = collapsed_triplet_rest_grid
    Partitura::Production.piece("Collapsed Triplet Rests") do
      meter "4/4"; key "C"; roster { part :viola, "Viola", music21: "Viola", family: :string }
      section :s1, "Flood", bars: 1..1 do
        span bars: 1..1 do
          texture(:chop, bars: 1..1) { score(grid: :eighth_triplet) { viola grid } }
        end
      end
    end
  end

  def collapsed_triplet_rest_grid
    ". . [C4,E4] . . [C4,E4] . . [C4,E4] . . [C4,E4]"
  end
end
