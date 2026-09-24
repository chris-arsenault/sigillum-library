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

    assert_equal ["xylophone"], lints.map { |l| l[:part] }
  end

  def test_lint_is_quiet_for_pitched_percussion
    piece = pitched_sound_piece(xylophone_family: :pitched_percussion)
    lints = Partitura::Production::Lint.run(piece).select { |l| l[:rule] == "pitched_percussion_family" }

    assert_empty lints
  end

  private

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
