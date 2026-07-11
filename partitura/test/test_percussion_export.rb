# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/musicxml_exporter_helpers"

class PercussionExportTest < Minitest::Test
  include MusicXMLExporterHelpers

  def test_musicxml_keeps_one_part_with_per_device_unpitched_metadata
    document = render_document(mapped_percussion_piece)
    score_part = REXML::XPath.first(document, "/score-partwise/part-list/score-part")
    notes = REXML::XPath.match(document, "/score-partwise/part/measure/note[unpitched]")

    assert_equal 1, REXML::XPath.match(document, "/score-partwise/part-list/score-part").length
    assert_equal 1, REXML::XPath.match(document, "/score-partwise/part").length
    assert_equal ["Field Drum", "Concert Bass Drum", "Suspended Cymbal"],
      REXML::XPath.match(score_part, "score-instrument/instrument-name").map(&:text)
    assert_equal %w[10 10 10], REXML::XPath.match(score_part, "midi-instrument/midi-channel").map(&:text)
    assert_equal %w[39 37 50], REXML::XPath.match(score_part, "midi-instrument/midi-unpitched").map(&:text)
    assert_empty REXML::XPath.match(score_part, "midi-instrument/midi-program")
    assert_equal 3, notes.length
    assert_empty REXML::XPath.match(document, "/score-partwise/part/measure/note/pitch")
    assert_equal %w[C F A], (notes.map { |note| text_at(note, "unpitched/display-step") })
    assert_equal %w[5 4 5], (notes.map { |note| text_at(note, "unpitched/display-octave") })
    assert_equal %w[I1-1 I1-2 I1-3], (notes.map { |note| instrument_id(note) })
  end

  def test_musicxml_rejects_undeclared_source_pitch
    piece = mapped_percussion_piece(event_text: "C2:1 E2:3")

    error = assert_raises(Partitura::Production::CompileError) { Partitura::Export::MusicXML.render(piece) }

    assert_equal "unmapped_percussion_pitch", error.response.fetch(:code)
    assert_equal "E2", error.response.fetch(:pitch)
  end

  def test_midi_uses_one_channel_ten_track_and_mapped_device_notes
    midi = Partitura::Export::MIDI.render(mapped_percussion_piece)

    assert_equal 2, midi.byteslice(10, 2).unpack1("n")
    assert_includes midi, [0x99, 38, 72].pack("C*")
    assert_includes midi, [0x99, 36, 72].pack("C*")
    assert_includes midi, [0x99, 49, 72].pack("C*")
  end

  def test_decomposed_let_ring_attack_has_balanced_structural_ties
    document = render_document(mapped_percussion_piece(event_text: "C#3:3.25{lv} r:.75"))
    notes = REXML::XPath.match(document, "/score-partwise/part/measure/note[unpitched]")

    assert_equal 3, notes.length
    assert_equal ["start"], tie_types(notes[0])
    assert_equal ["stop", "start"], tie_types(notes[1])
    assert_equal ["stop"], tie_types(notes[2])
  end

  def test_midi_reserves_channel_ten_for_percussion
    midi = Partitura::Export::MIDI.render(mixed_channel_piece)

    assert_includes midi, [0x90, 60, 72].pack("C*")
    assert_includes midi, [0x99, 38, 72].pack("C*")
    assert_includes midi, [0x91, 67, 72].pack("C*")
  end

  private

  def instrument_id(note)
    REXML::XPath.first(note, "instrument").attributes["id"]
  end

  def tie_types(note)
    REXML::XPath.match(note, "tie").map { |tie| tie.attributes["type"] }
  end

  def mapped_percussion_piece(event_text: "C2:1 D2:1 C#3:2")
    Partitura::Production.piece("Mapped Percussion") do
      meter "4/4"
      key "C"
      roster do
        part :battery, "Percussion", music21: "Percussion", family: :percussion,
          percussion_map: {
            "C2" => :field_drum,
            "D2" => :concert_bass_drum,
            "C#3" => :suspended_cymbal
          }
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events event_text }
          placement :line, part: :battery, at: "bar 1 beat 1", role: :rhythm
        end
      end
    end
  end

  def mixed_channel_piece
    Partitura::Production.piece("Reserved Percussion Channel") do
      meter "4/4"
      key "C"
      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
        part :battery, "Percussion", music21: "Percussion", family: :percussion,
          percussion_map: { "C2" => :field_drum }
        part :violin, "Violin", music21: "Violin", family: :string
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:flute_line, surface: :absolute) { events "C4:4" }
          phrase(:battery_line, surface: :absolute) { events "C2:4" }
          phrase(:violin_line, surface: :absolute) { events "G4:4" }
          placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :foreground
          placement :battery_line, part: :battery, at: "bar 1 beat 1", role: :rhythm
          placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end
end
