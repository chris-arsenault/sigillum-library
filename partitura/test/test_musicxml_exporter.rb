# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class MusicXMLExporterTest < Minitest::Test
  def test_renders_single_staff_piece_to_musicxml
    piece = Partitura::Production.piece("Ruby Export Core") do
      meter "4/4"
      key "C"

      roster do
        part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind
      end

      section :s1, "Opening", bars: 1..2 do
        span bars: 1..2 do
          phrase(:line, surface: :absolute) { events "C5:1 r:1 [E4,G4]:2 | D5:4{accent}" }
          placement :line, part: :clarinet, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)

    assert_equal "score-partwise", document.root.name
    assert_equal "4.0", document.root.attributes["version"]
    assert_equal "Ruby Export Core", text_at(document, "/score-partwise/work/work-title")
    assert_equal "Clarinet", text_at(document, "/score-partwise/part-list/score-part/part-name")
    assert_equal 2, REXML::XPath.match(document, "//measure").length
    assert_equal 5, REXML::XPath.match(document, "//note").length
    assert_equal 1, REXML::XPath.match(document, "//note/rest").length
    assert_equal 1, REXML::XPath.match(document, "//note/chord").length
    assert_equal 1, REXML::XPath.match(document, "//articulations/accent").length
  end

  def test_splits_long_notes_at_barlines_with_ties
    piece = Partitura::Production.piece("Ruby Tie Split") do
      meter "4/4"
      key "d"

      roster do
        part :violin, "Violin", music21: "Violin", family: :string
      end

      section :s1, "Opening", bars: 1..2 do
        span bars: 1..2 do
          phrase(:line, surface: :absolute) { events "F#4:6" }
          placement :line, part: :violin, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)

    assert_equal 2, REXML::XPath.match(document, "//note[pitch]").length
    assert_equal(%w[start stop], REXML::XPath.match(document, "//tie").map { |element| element.attributes["type"] })
    assert_equal(%w[start stop], REXML::XPath.match(document, "//tied").map { |element| element.attributes["type"] })
    assert_equal "-1", text_at(document, "//key/fifths")
    assert_equal "minor", text_at(document, "//key/mode")
  end

  def test_authored_ties_connect_notes_split_by_bar_marker
    piece = Partitura::Production.piece("Ruby Authored Tie") do
      meter "2/4"
      key "g"

      roster do
        part :trombone, "Trombone", music21: "Trombone", family: :brass
      end

      section :s1, "Opening", bars: 1..2 do
        span bars: 1..2 do
          phrase(:line, surface: :absolute) do
            events "Eb4:.5 Bb3:.5 G3:1{tie(} | G3:.5{tie)} Bb3:.5 C4:1"
          end
          placement :line, part: :trombone, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)

    assert_equal(%w[start stop], REXML::XPath.match(document, "//tie").map { |element| element.attributes["type"] })
    assert_equal(%w[start stop], REXML::XPath.match(document, "//tied").map { |element| element.attributes["type"] })
    assert_empty REXML::XPath.match(document, "//words[text()='tie(' or text()='tie)']")
  end

  def test_top_level_production_musicxml_helper_accepts_piece
    piece = Partitura::Production.piece("Helper Export") do
      meter "3/4"
      key "F"

      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
      end

      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "A4:3" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    xml = Partitura.production_musicxml(piece)

    assert_includes xml, "<work-title>Helper Export</work-title>"
    assert_includes xml, "<beats>3</beats>"
    assert_includes xml, "<beat-type>4</beat-type>"
  end

  def test_notation_group_renders_as_two_staff_score_part
    document = render_document(grand_staff_piece)

    assert_equal 1, REXML::XPath.match(document, "/score-partwise/part-list/score-part").length
    assert_equal "Piano", text_at(document, "/score-partwise/part-list/score-part/part-name")
    assert_equal "2", text_at(document, "//attributes/staves")
    assert_equal "96", REXML::XPath.first(document, "//sound[@tempo]").attributes["tempo"]
    assert_equal(%w[1 2], REXML::XPath.match(document, "//clef").map { |element| element.attributes["number"] })
    assert_equal %w[1 2], REXML::XPath.match(document, "//note/staff").map(&:text).uniq
    assert_equal 1, REXML::XPath.match(document, "//backup").length
  end

  def test_dotted_tempo_preserves_notation_and_uses_quarter_normalized_sound_tempo
    piece = Partitura::Production.piece("Dotted Tempo Export") do
      meter "6/8"; key "C"; tempo "dotted-quarter = 52"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:3" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)
    metronome = REXML::XPath.first(document, "//metronome")

    assert_equal "quarter", text_at(document, "//metronome/beat-unit")
    assert_equal 1, REXML::XPath.match(metronome, "beat-unit-dot").length
    assert_equal "52", text_at(document, "//metronome/per-minute")
    assert_equal "78", REXML::XPath.first(document, "//sound[@tempo]").attributes["tempo"]
  end

  def test_tempo_without_notation_metadata_defaults_to_quarter_bpm
    piece = Partitura::Production.piece("Legacy Tempo Export") do
      meter "4/4"; key "C"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
    piece.add_tempo_event(
      Partitura::Production::TempoEvent.new(kind: :mark, text: "legacy", at: "bar 1 beat 1", bpm: 90)
    )

    document = render_document(piece)

    assert_equal "quarter", text_at(document, "//metronome/beat-unit")
    assert_empty REXML::XPath.match(document, "//metronome/beat-unit-dot")
    assert_equal "90", text_at(document, "//metronome/per-minute")
    assert_equal "90", REXML::XPath.first(document, "//sound[@tempo]").attributes["tempo"]
  end

  def test_text_controls_create_notes_staff
    piece = Partitura::Production.piece("Notes Staff Export") do
      meter "4/4"
      key "C"

      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
      end

      control do
        text "mark this transition", at: "bar 1 beat 1", for: :all
      end

      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)

    assert_equal %w[Flute Notes], 
REXML::XPath.match(document, "/score-partwise/part-list/score-part/part-name").map(&:text)
    assert_equal "mark this transition", text_at(document, "//part[2]//words")
  end

  private

  def grand_staff_piece
    Partitura::Production.piece("Grand Staff Export") do
      meter "4/4"; key "C"; tempo "quarter = 96"
      roster do
        part :piano_upper, "Piano Upper", music21: "Piano", family: :keyboard, notation_group: :piano, notation_staff: 1
        part :piano_lower, "Piano Lower", music21: "Piano", family: :keyboard, notation_group: :piano, notation_staff: 2
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:upper, surface: :absolute) { events "C5:1 D5:1 E5:2" }
          phrase(:lower, surface: :absolute) { events "C3:2 G2:2" }
          placement :upper, part: :piano_upper, at: "bar 1 beat 1", role: :foreground
          placement :lower, part: :piano_lower, at: "bar 1 beat 1", role: :bass
        end
      end
    end
  end

  def render_document(piece)
    REXML::Document.new(Partitura::Export::MusicXML.render(piece))
  end

  def text_at(document, path)
    REXML::XPath.first(document, path).text
  end
end
