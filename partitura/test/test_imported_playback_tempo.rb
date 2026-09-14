# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require_relative "../lib/partitura"

class ImportedPlaybackTempoTest < Minitest::Test
  def test_hidden_playback_points_reach_xml_midi_and_perceptual_clock
    piece = Partitura::Production.piece("Imported tempo") do
      meter "4/4"; key "C"
      tempo do
        mark "quarter = 60"
        playback 120, at: "bar 1 beat 3"
      end
      control do
        dynamic :p, at: "bar 1 beat 1", for: :voice
      end
      roster { part :voice, "Voice", music21: "Soprano", family: :voice }
      section :one, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C4:4" }
          placement :line, part: :voice, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
    xml = REXML::Document.new(Partitura::Export::MusicXML.render(piece))
    assert_equal 1, REXML::XPath.match(xml, "//metronome").length
    assert REXML::XPath.match(xml, "//sound").any? { |sound| sound.attributes["tempo"].to_f == 120 }
    midi = Partitura::Export::MIDI.render(piece)
    assert_includes midi, [0xff, 0x51, 3, 7, 0xa1, 0x20].pack("C*")
    assert_includes midi, [0x90, 60, 48].pack("C*")
    assert_includes midi, [0xc0, 52].pack("C*")
    timing = Partitura::Production::SoundingReadout::PerceptualTiming.new(piece)
    assert_in_delta 3, timing.seconds_at(4), 0.00001
  end
end
