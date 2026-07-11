# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/musicxml_exporter_helpers"

class MusicXMLExporterTest < Minitest::Test
  include MusicXMLExporterHelpers

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

  def test_beat_pattern_controls_beaming_without_additive_time_display
    piece = Partitura::Production.piece("Additive Beaming") do
      meter "7/8", beat_pattern: [3, 2, 2]
      key "C"
      roster { part :violin, "Violin", music21: "Violin", family: :string }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:.5 D5:.5 E5:.5 F5:.5 G5:.5 A5:.5 B5:.5" }
          placement :line, part: :violin, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)

    assert_equal "7", text_at(document, "//time/beats")
    assert_equal %w[begin continue end begin end begin end],
      REXML::XPath.match(document, "//note/beam[@number='1']").map(&:text)
  end

  def test_tremolo_survives_every_fragment_of_a_tied_long_note
    piece = Partitura::Production.piece("Sustained Tremolo") do
      meter "11/8", beat_pattern: [3, 3, 3, 2]
      key "C"
      roster { part :cymbal, "Cymbal", music21: "Percussion", family: :percussion }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:roll, surface: :absolute) { events "C3:5.5{trem}" }
          placement :roll, part: :cymbal, at: "bar 1 beat 1", role: :rhythm
        end
      end
    end

    document = render_document(piece)

    assert_equal 2, REXML::XPath.match(document, "//note[pitch]").length
    assert_equal 2, REXML::XPath.match(document, "//ornaments/tremolo").length
    assert_equal %w[start stop], REXML::XPath.match(document, "//tie").map { |element| element.attributes["type"] }
  end

  def test_trill_span_nests_wavy_line_inside_ornaments
    piece = Partitura::Production.piece("Trill Span") do
      meter "4/4"
      key "C"
      roster { part :violin, "Violin", music21: "Violin", family: :string }
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:1{trill(} D5:1 E5:1 F5:1{trill)}" }
          placement :line, part: :violin, at: "bar 1 beat 1", role: :foreground
        end
      end
    end

    document = render_document(piece)
    wavy_lines = REXML::XPath.match(document, "//ornaments/wavy-line")

    assert_equal %w[start stop], wavy_lines.map { |element| element.attributes["type"] }
    refute_nil REXML::XPath.first(document, "//ornaments[trill-mark and wavy-line[@type='start']]")
    assert_empty REXML::XPath.match(document, "//notations/wavy-line")
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

  def test_emits_tuba_and_timpani_programs_and_abbreviations
    tuba = render_document(
      single_part_piece(
        "Tuba Program", :tuba, "Tuba", music21: "Tuba", family: :brass, event_text: "C2:4"
      )
    )
    timpani = render_document(
      single_part_piece(
        "Timpani Program", :timpani, "Timpani", music21: "Timpani",
        family: :pitched_percussion, event_text: "D2:4"
      )
    )

    assert_equal "59", text_at(tuba, "//midi-instrument/midi-program")
    assert_equal "Tba", text_at(tuba, "//score-part/part-abbreviation")
    assert_equal "48", text_at(timpani, "//midi-instrument/midi-program")
    assert_equal "Timp.", text_at(timpani, "//score-part/part-abbreviation")
  end

  def test_routes_every_unpitched_percussion_part_to_channel_ten
    piece = Partitura::Production.piece("Percussion Channels") do
      meter "4/4"
      key "C"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
        part :skins, "Skins", music21: "Percussion", family: :percussion
        part :metals, "Metals", music21: "Percussion", family: :percussion
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:flute_line, surface: :absolute) { events "C5:4" }
          phrase(:skins_line, surface: :absolute) { events "C2:.25 r:3.75" }
          phrase(:metals_line, surface: :absolute) { events "C#3:.25 r:3.75" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :skins_line, part: :skins, at: "bar 1 beat 1", role: :punctuation
          placement :metals_line, part: :metals, at: "bar 1 beat 1", role: :punctuation
        end
      end
    end

    channels = REXML::XPath.match(render_document(piece), "//midi-instrument/midi-channel").map(&:text)

    assert_equal %w[1 10 10], channels
  end

  def test_reserves_channel_ten_without_wrapping_later_pitched_parts
    piece = Partitura::Production.piece("Mixed Orchestra Channels") do
      meter "4/4"
      key "C"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
        part :skins, "Skins", music21: "Percussion", family: :percussion
        part :metals, "Metals", music21: "Percussion", family: :percussion
        part :violin, "Violin", music21: "Violin", family: :string
        part :cello, "Cello", music21: "Violoncello", family: :string
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:flute_line, surface: :absolute) { events "C5:4" }
          phrase(:skins_line, surface: :absolute) { events "C2:.25 r:3.75" }
          phrase(:metals_line, surface: :absolute) { events "C#3:.25 r:3.75" }
          phrase(:violin_line, surface: :absolute) { events "G5:4" }
          phrase(:cello_line, surface: :absolute) { events "C3:4" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :skins_line, part: :skins, at: "bar 1 beat 1", role: :punctuation
          placement :metals_line, part: :metals, at: "bar 1 beat 1", role: :punctuation
          placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :foreground
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :bass
        end
      end
    end

    channels = REXML::XPath.match(render_document(piece), "//midi-instrument/midi-channel").map(&:text)

    assert_equal %w[1 10 10 2 3], channels
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

end
