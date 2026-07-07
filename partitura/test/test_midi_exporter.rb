# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class MIDIExporterTest < Minitest::Test
  def test_renders_standard_midi_file
    midi = Partitura.production_midi(simple_piece)

    assert_equal "MThd", midi.byteslice(0, 4)
    assert_equal 6, midi.byteslice(4, 4).unpack1("N")
    assert_equal 1, midi.byteslice(8, 2).unpack1("n")
    assert_equal 2, midi.byteslice(10, 2).unpack1("n")
    assert_equal 10_080, midi.byteslice(12, 2).unpack1("n")
    assert_includes midi, "MTrk"
    assert_includes midi.bytes, 0x90
    assert_includes midi.bytes, 0x80
  end

  def test_rejects_unsupported_transport_schema
    error = assert_raises(Partitura::Export::Error) do
      Partitura::Export::MIDI.render(
        "schema" => "partitura.transport",
        "schema_version" => 2
      )
    end

    assert_includes error.message, "unsupported Partitura transport"
  end

  def test_rejects_unsupported_event_pitch_inside_valid_transport
    transport = Partitura.production_transport_hash(simple_piece)
    transport.fetch(:timed_events).first[:pitches] = ["H4"]

    error = assert_raises(Partitura::Export::Error) do
      Partitura::Export::MIDI.render(transport)
    end

    assert_includes error.message, 'unsupported pitch "H4"'
  end

  def test_top_level_midi_helper_accepts_transport_hash
    transport = Partitura.production_transport_hash(simple_piece)
    midi = Partitura.production_midi(transport)

    assert_equal "MThd", midi.byteslice(0, 4)
    assert_equal transport.fetch(:parts).length + 1, midi.byteslice(10, 2).unpack1("n")
  end

  private

  def simple_piece
    Partitura::Production.piece("MIDI Export Core") do
      meter "4/4"
      key "C"
      tempo "quarter = 120"

      roster do
        part :flute, "Flute", music21: "Flute", family: :woodwind
      end

      section :s1, "Opening", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:1{mf} E5:1 G5:2" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  end
end
