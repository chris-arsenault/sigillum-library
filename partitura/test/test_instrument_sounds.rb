# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require_relative "support/musicxml_exporter_helpers"

# Notation programs pick the imported instrument from <instrument-sound>; without
# it Dorico files unknown unpitched parts under a generic kit tom.
class InstrumentSoundsTest < Minitest::Test
  include MusicXMLExporterHelpers

  def test_single_device_parts_keep_their_names_and_sounds
    document = render_document(single_device_parts_piece)
    names = REXML::XPath.match(document, "/score-partwise/part-list/score-part/part-name").map(&:text)
    sounds = REXML::XPath.match(document, "//score-part/score-instrument/instrument-sound").map(&:text)

    assert_equal ["Concert Bass Drum", "Low Tom", "Cymbals"], names
    assert_equal %w[drum.bass-drum drum.tom-tom metal.cymbal.ride metal.cymbal.suspended], sounds
  end

  # Dorico's own export of a lone bass drum: one-line staff, note on E4, no
  # <midi-instrument>. Our channel-10 kick key made Dorico import it as a drum set.
  def test_lone_bass_drum_matches_dorico_form
    document = render_document(single_device_parts_piece)
    bass_drum = REXML::XPath.first(document, "/score-partwise/part-list/score-part[1]")
    tom = REXML::XPath.first(document, "/score-partwise/part-list/score-part[2]")
    first_note = REXML::XPath.first(document, "/score-partwise/part[1]/measure/note")

    assert_equal "Bass Drum", text_at(bass_drum, "score-instrument/instrument-name")
    assert_empty REXML::XPath.match(bass_drum, "midi-instrument")
    assert_equal "1", text_at(document, "/score-partwise/part[1]/measure/attributes/staff-details/staff-lines")
    assert_equal %w[E 4],
      [text_at(first_note, "unpitched/display-step"), text_at(first_note, "unpitched/display-octave")]
    assert_equal "46", text_at(tom, "midi-instrument/midi-unpitched")
    assert_empty REXML::XPath.match(document, "/score-partwise/part[2]/measure/attributes/staff-details")
  end

  def test_lone_bass_drum_still_sounds_in_midi
    midi = Partitura::Export::MIDI.render(single_device_parts_piece)

    assert_includes midi, [0x99, 36, 72].pack("C*")
  end

  def test_standalone_field_drum_and_cymbal_use_the_selected_non_kit_form
    document = render_document(standalone_field_and_cymbal_piece)
    score_parts = REXML::XPath.match(document, "/score-partwise/part-list/score-part")
    parts = REXML::XPath.match(document, "/score-partwise/part")

    assert_equal ["Field Drum", "Suspended Cymbal"], (score_parts.map { |part| text_at(part, "part-name") })
    assert_equal %w[drum.snare-drum metal.cymbal.suspended],
      (score_parts.map { |part| text_at(part, "score-instrument/instrument-sound") })
    score_parts.each { |part| assert_empty REXML::XPath.match(part, "midi-instrument") }
    parts.each do |part|
      assert_equal "1", text_at(part, "measure/attributes/staff-details/staff-lines")
      assert_equal "percussion", text_at(part, "measure/attributes/clef/sign")
      note = REXML::XPath.first(part, "measure/note[unpitched]")
      assert_equal %w[E 4], [text_at(note, "unpitched/display-step"), text_at(note, "unpitched/display-octave")]
    end
  end

  def test_standalone_notation_keeps_midi_device_playback
    midi = Partitura::Export::MIDI.render(standalone_field_and_cymbal_piece)

    assert_includes midi, [0x99, 38, 72].pack("C*")
    assert_includes midi, [0x99, 49, 72].pack("C*")
  end

  def test_pitched_parts_carry_instrument_sounds_and_stay_pitched
    document = render_document(pitched_sound_piece(xylophone_family: :pitched_percussion))
    sounds = REXML::XPath.match(document, "//score-part/score-instrument/instrument-sound").map(&:text)
    xylophone_note = REXML::XPath.first(document, "/score-partwise/part[3]/measure/note")
    channel = text_at(document, "/score-partwise/part-list/score-part[3]/midi-instrument/midi-channel")

    assert_equal %w[wind.reed.bassoon brass.trombone pitched-percussion.xylophone], sounds
    assert_equal %w[C 6], [text_at(xylophone_note, "pitch/step"), text_at(xylophone_note, "pitch/octave")]
    refute_equal "10", channel
  end

  def test_lint_warns_when_a_mallet_is_declared_unpitched
    piece = pitched_sound_piece(xylophone_family: :percussion)
    lints = Partitura::Production::Lint.run(piece).select { |l| l[:rule] == "pitched_percussion_family" }

    assert_equal ["xylophone"], (lints.map { |l| l[:part] })
  end

  def test_lint_is_quiet_for_pitched_percussion
    piece = pitched_sound_piece(xylophone_family: :pitched_percussion)
    lints = Partitura::Production::Lint.run(piece).select { |l| l[:rule] == "pitched_percussion_family" }

    assert_empty lints
  end

  def test_tubular_bells_keep_their_pitched_identity_and_playback_program
    piece = tubular_bells_piece
    document = render_document(piece)
    score_part = REXML::XPath.first(document, "/score-partwise/part-list/score-part")
    attributes = "/score-partwise/part/measure/attributes"

    assert_equal "Tubular Bells", text_at(score_part, "score-instrument/instrument-name")
    assert_equal "pitched-percussion.tubular-bells", text_at(score_part, "score-instrument/instrument-sound")
    assert_equal "15", text_at(score_part, "midi-instrument/midi-program")
    refute_equal "10", text_at(score_part, "midi-instrument/midi-channel")
    assert_equal "G", text_at(document, "#{attributes}/clef/sign")
    assert_empty REXML::XPath.match(document, "//unpitched | //midi-unpitched")

    midi = Partitura::Export::MIDI.render(piece)
    assert_includes midi, [0xC0, 14].pack("C*")
    assert_includes midi, [0x90, 66, 72].pack("C*")
  end

  private

  def tubular_bells_piece
    Partitura::Production.piece("Pitched Bells") do
      meter "4/4"
      key "C"
      roster do
        part :bells, "Tubular Bells", music21: "TubularBells", family: :pitched_percussion
      end
      section :opening, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:toll, surface: :absolute) { events "F#4:2 r:2" }
          placement :toll, part: :bells, at: "bar 1 beat 1", role: :color
        end
      end
    end
  end

  def standalone_field_and_cymbal_piece
    Partitura::Production.piece("Standalone Percussion") do
      meter "4/4"
      key "C"
      roster do
        part :field, "Field Drum", music21: "Percussion", family: :percussion,
          percussion_map: { "C2" => :field_drum }
        part :cymbal, "Suspended Cymbal", music21: "Percussion", family: :percussion,
          percussion_map: { "C#3" => :suspended_cymbal }
      end
      section :opening, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:field_note, surface: :absolute) { events "C2:4" }
          phrase(:cymbal_note, surface: :absolute) { events "C#3:4" }
          placement :field_note, part: :field, at: "bar 1 beat 1", role: :rhythm
          placement :cymbal_note, part: :cymbal, at: "bar 1 beat 1", role: :rhythm
        end
      end
    end
  end

  def single_device_parts_piece
    Partitura::Production.piece("Single Device Parts") do
      meter "4/4"
      key "C"
      roster do
        part :bass_drum, "Concert Bass Drum", music21: "Percussion", family: :percussion,
          percussion_map: { "C2" => :concert_bass_drum }
        part :tom, "Low Tom", music21: "Percussion", family: :percussion,
          percussion_map: { "A2" => :low_tom }
        part :cymbals, "Cymbals", music21: "Percussion", family: :percussion,
          percussion_map: { "F5" => :ride, "G5" => :suspended_cymbal }
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:kick, surface: :absolute) { events "C2:4" }
          phrase(:tom_line, surface: :absolute) { events "A2:4" }
          phrase(:cymbal_line, surface: :absolute) { events "F5:2 G5:2" }
          placement :kick, part: :bass_drum, at: "bar 1 beat 1", role: :rhythm
          placement :tom_line, part: :tom, at: "bar 1 beat 1", role: :rhythm
          placement :cymbal_line, part: :cymbals, at: "bar 1 beat 1", role: :rhythm
        end
      end
    end
  end

  def pitched_sound_piece(xylophone_family:)
    Partitura::Production.piece("Pitched Sounds") do
      meter "4/4"
      key "C"
      roster do
        part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind
        part :trombone, "Trombone", music21: "Trombone", family: :brass
        part :xylophone, "Xylophone", music21: "Xylophone", family: xylophone_family
      end
      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:low, surface: :absolute) { events "C3:4" }
          phrase(:high, surface: :absolute) { events "C6:4" }
          placement :low, part: :bassoon, at: "bar 1 beat 1", role: :foreground
          placement :low, part: :trombone, at: "bar 1 beat 1", role: :foreground
          placement :high, part: :xylophone, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end
end
