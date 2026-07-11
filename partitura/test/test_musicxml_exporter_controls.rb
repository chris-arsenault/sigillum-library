# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/musicxml_exporter_helpers"

class MusicXMLExporterControlsTest < Minitest::Test
  include MusicXMLExporterHelpers

  def test_single_staff_clefs_follow_instrument_metadata
    document = render_document(clef_export_piece)

    assert_equal ["G", "2"], clef_signature(document, 1)
    assert_equal ["C", "3"], clef_signature(document, 2)
    assert_equal ["F", "4"], clef_signature(document, 3)
    assert_equal ["percussion", nil], clef_signature(document, 4)
  end

  def test_control_hairpin_wedge_numbers_stay_within_musicxml_number_level
    wedges = wedge_events(render_document(many_hairpins_piece))

    assert_equal 40, wedges.length
    assert(wedges.all? { |event| (1..16).cover?(event.fetch(:number)) })
    wedges.each_slice(2) do |start_event, stop_event|
      assert_equal "crescendo", start_event.fetch(:type)
      assert_equal "stop", stop_event.fetch(:type)
      assert_equal start_event.fetch(:number), stop_event.fetch(:number)
    end
  end

  def test_inline_hairpin_across_barline_uses_matching_wedge_number
    wedges = wedge_events(render_document(inline_hairpin_piece))

    assert_equal ["crescendo", "stop"], (wedges.map { |event| event.fetch(:type) })
    assert_equal wedges.first.fetch(:number), wedges.last.fetch(:number)
    assert_operator wedges.first.fetch(:number), :<=, 16
  end

  def test_text_controls_route_to_target_parts_and_preserve_notes_ledger
    document = render_document(notes_staff_piece)
    part_names = REXML::XPath.match(document, "/score-partwise/part-list/score-part/part-name").map(&:text)

    assert_equal %w[Flute Notes], part_names
    assert_equal "mark this transition", text_at(document, "//part[1]//words")
    assert_equal "mark this transition", text_at(document, "//part[2]//words")
  end

  def test_text_control_honors_an_explicit_part_target
    document = render_document(targeted_text_piece)

    assert_empty REXML::XPath.match(document, "//part[1]//words")
    assert_equal "cellos only", text_at(document, "//part[2]//words")
  end

  def test_written_transpositions_clef_changes_and_abbreviation_overrides
    document = render_document(engraving_metadata_piece)

    assert_equal ["Hn. A", "Cb. A", "Vc. A"],
      REXML::XPath.match(document, "/score-partwise/part-list/score-part/part-abbreviation").map(&:text)

    assert_equal "F", text_at(document, "//part[1]/measure[1]/note[1]/pitch/step")
    assert_equal "4", text_at(document, "//part[1]/measure[1]/note[1]/pitch/octave")
    assert_equal "-1", text_at(document, "//part[1]/measure[1]/attributes/key/fifths")
    assert_equal "-4", text_at(document, "//part[1]/measure[1]/attributes/transpose/diatonic")
    assert_equal "-7", text_at(document, "//part[1]/measure[1]/attributes/transpose/chromatic")

    assert_equal "D", text_at(document, "//part[2]/measure[1]/note[1]/pitch/step")
    assert_equal "3", text_at(document, "//part[2]/measure[1]/note[1]/pitch/octave")
    assert_equal "-1", text_at(document, "//part[2]/measure[1]/attributes/transpose/octave-change")

    cello_clefs = REXML::XPath.match(document, "//part[3]/measure/attributes/clef").map do |clef|
      [text_at(REXML::Document.new(clef.to_s), "//sign"), text_at(REXML::Document.new(clef.to_s), "//line")]
    end
    assert_equal [["F", "4"], ["C", "4"], ["F", "4"]], cello_clefs
    assert_equal 1, REXML::XPath.match(document, "//part[3]/measure/attributes/key").length
    assert_equal 1, REXML::XPath.match(document, "//part[3]/measure/attributes/time").length
    assert_empty REXML::XPath.match(document, "//part[3]/measure[2]/attributes/key | //part[3]/measure[2]/attributes/time")
    assert_empty REXML::XPath.match(document, "//part[3]/measure[3]/attributes/key | //part[3]/measure[3]/attributes/time")
  end

  private

  def clef_export_piece
    Partitura::Production.piece("Clef Export") do
      meter "4/4"; key "C"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
        part :viola, "Viola", music21: "Viola", family: :string
        part :cello, "Cello", music21: "Violoncello", family: :string
        part :snare, "Snare", music21: "Percussion", family: :percussion
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:flute_line, surface: :absolute) { events "C5:4" }
          phrase(:viola_line, surface: :absolute) { events "C4:4" }
          phrase(:cello_line, surface: :absolute) { events "C3:4" }
          phrase(:snare_line, surface: :absolute) { events "C3:4" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :inner
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :bass
          placement :snare_line, part: :snare, at: "bar 1 beat 1", role: :rhythm
        end
      end
    end
  end

  def many_hairpins_piece
    event_text = many_hairpin_events
    Partitura::Production.piece("Many Hairpins") do
      meter "1/4"; key "C"; roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      control { (1..20).each { |bar| crescendo from: "bar #{bar} beat 1", to: "bar #{bar + 1} beat 1", for: :flute } }
      section :s1, "Opening", bars: 1..21 do
        span bars: 1..21 do
          phrase(:line, surface: :absolute) { events event_text }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def many_hairpin_events
    "C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | " \
      "C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | " \
      "C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | C5:1 | C5:1"
  end

  def inline_hairpin_piece
    Partitura::Production.piece("Inline Hairpin") do
      meter "4/4"; key "C"; roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      section :s1, "Opening", bars: 1..2 do
        span bars: 1..2 do
          phrase(:line, surface: :absolute) { events "C5:4{cresc(} | D5:4{cresc)}" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def notes_staff_piece
    Partitura::Production.piece("Notes Staff Export") do
      meter "4/4"; key "C"; roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      control { text "mark this transition", at: "bar 1 beat 1", for: :all }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end

  def targeted_text_piece
    Partitura::Production.piece("Targeted Text Export") do
      meter "4/4"; key "C"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
        part :cello, "Cello", music21: "Violoncello", family: :string
      end
      control { text "cellos only", at: "bar 1 beat 2", for: :cello }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:flute_line, surface: :absolute) { events "C5:4" }
          phrase(:cello_line, surface: :absolute) { events "C3:4" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end

  def engraving_metadata_piece
    Partitura::Production.piece("Engraving Metadata") do
      meter "4/4"; key "Bb"
      roster do
        part :horn, "Horn", music21: "Horn", family: :brass, abbreviation: "Hn. A"
        part :bass, "Bass", music21: "Contrabass", family: :string, abbreviation: "Cb. A"
        part :cello, "Cello", music21: "Violoncello", family: :string, abbreviation: "Vc. A"
      end
      control do
        clef :tenor, at: "bar 2 beat 1", for: :cello
        clef :bass, at: "bar 3 beat 1", for: :cello
      end
      section :s1, "Opening", bars: 1..3 do
        span bars: 1..3 do
          phrase(:horn_line, surface: :absolute) { events "Bb3:4 | Bb3:4 | Bb3:4" }
          phrase(:bass_line, surface: :absolute) { events "D2:4 | D2:4 | D2:4" }
          phrase(:cello_line, surface: :absolute) { events "C3:4 | A4:4 | C3:4" }
          placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :foreground
          placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :bass
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :inner
        end
      end
    end
  end
end
