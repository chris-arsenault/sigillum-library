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

  def test_chamber_band_exports_finger_bass_at_sounding_pitch_and_maps_the_kit
    piece = chamber_band_piece
    document = render_document(piece)
    midi = Partitura::Export::MIDI.render(piece)
    bass = REXML::XPath.first(document, "/score-partwise/part-list/score-part[5]")
    kit = REXML::XPath.first(document, "/score-partwise/part-list/score-part[7]")
    kit_notes = REXML::XPath.match(document, "/score-partwise/part[7]/measure/note[unpitched]")

    assert_equal 7, REXML::XPath.match(document, "/score-partwise/part").length
    assert_equal 8, midi.byteslice(10, 2).unpack1("n")
    assert_equal "34", text_at(bass, "midi-instrument/midi-program")
    assert_equal ["F", "4"], clef_signature(document, 5)
    assert_equal "-1", text_at(document, "/score-partwise/part[5]/measure/attributes/transpose/octave-change")
    assert_equal "G", text_at(document, "/score-partwise/part[5]/measure/note/pitch/step")
    assert_equal "3", text_at(document, "/score-partwise/part[5]/measure/note/pitch/octave")
    assert_includes midi, [0xC4, 33].pack("C*")
    assert_includes midi, [0x94, 43, 72].pack("C*")

    assert_equal ["percussion", nil], clef_signature(document, 7)
    assert_equal %w[10 10 10 10 10 10], REXML::XPath.match(kit, "midi-instrument/midi-channel").map(&:text)
    assert_equal %w[37 41 43 46 51 52], REXML::XPath.match(kit, "midi-instrument/midi-unpitched").map(&:text)
    assert_empty REXML::XPath.match(document, "/score-partwise/part[7]/measure/note/pitch")
    assert_equal 9, kit_notes.length
    assert_equal %w[F G C G C A E F G], kit_notes.map { |note| text_at(note, "unpitched/display-step") }
    assert_equal %w[4 5 5 5 5 4 5 5 5], kit_notes.map { |note| text_at(note, "unpitched/display-octave") }
    assert_equal %w[I7-1 I7-3], kit_notes.first(2).map { |note| instrument_id(note) }
    refute_nil REXML::XPath.first(kit_notes[1], "chord")
    [36, 40, 42, 45, 50, 51].each do |pitch|
      assert_includes midi, [0x99, pitch, 72].pack("C*")
    end
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

  def chamber_band_piece
    Partitura::Production.piece("Chamber Band Export") do
      meter "4/4"
      key "G minor"
      roster do
        part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind
        part :violin, "Violin", music21: "Violin", family: :string
        part :viola, "Viola", music21: "Viola", family: :string
        part :cello, "Cello", music21: "Violoncello", family: :string
        part :bass, "Electric Bass", music21: "ElectricBass", family: :string
        part :voice, "Bass Voice", music21: "Bass", family: :voice
        part :kit, "Drum Kit", music21: "Percussion", family: :percussion,
          percussion_map: {
            "C2" => :concert_bass_drum,
            "E2" => :electric_snare,
            "F#2" => :closed_hi_hat,
            "A2" => :low_tom,
            "D3" => :high_tom,
            "Eb3" => :ride
          }
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:bassoon_line, surface: :absolute) { events "D3:4" }
          phrase(:violin_line, surface: :absolute) { events "Bb4:4" }
          phrase(:viola_line, surface: :absolute) { events "F4:4" }
          phrase(:cello_line, surface: :absolute) { events "G3:4" }
          phrase(:bass_line, surface: :absolute) { events "G2:4" }
          phrase(:voice_line, surface: :absolute) { events "D3:4" }
          phrase(:kit_line, surface: :absolute) do
            events "[C2,F#2]:.25 r:.75 [E2,F#2]:.25 r:.5 E2:.25 A2:.5 D3:.5 Eb3:.5 F#2:.5"
          end
          placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :foreground
          placement :violin_line, part: :violin, at: "bar 1 beat 1", role: :harmony
          placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :harmony
          placement :cello_line, part: :cello, at: "bar 1 beat 1", role: :harmony
          placement :bass_line, part: :bass, at: "bar 1 beat 1", role: :bass
          placement :voice_line, part: :voice, at: "bar 1 beat 1", role: :foreground
          placement :kit_line, part: :kit, at: "bar 1 beat 1", role: :rhythm
        end
      end
    end
  end
end
