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

  def test_export_renderer_accepts_piece_only
    midi = Partitura::Export::MIDI.render(simple_piece)

    assert_equal "MThd", midi.byteslice(0, 4)
    assert_equal simple_piece.parts.length + 1, midi.byteslice(10, 2).unpack1("n")
  end

  def test_dotted_quarter_tempo_normalizes_to_quarter_bpm
    midi = Partitura.production_midi(tempo_piece("dotted-quarter = 52"))

    assert_in_delta 769_231, first_tempo_microseconds(midi), 1
  end

  def test_quarter_tempo_preserves_its_written_bpm
    midi = Partitura.production_midi(tempo_piece("quarter = 120"))

    assert_equal 500_000, first_tempo_microseconds(midi)
  end

  def test_midi_export_rejects_unrepresentable_raw_tempo_events
    piece = tempo_piece("quarter = 120")
    piece.add_tempo_event(
      Partitura::Production::TempoEvent.new(kind: :mark, text: "raw", at: "bar 1 beat 1", bpm: 2)
    )

    error = assert_raises(Partitura::Export::Error) { Partitura.production_midi(piece) }
    assert_includes error.message, "outside the MIDI playback range"
  end

  private

  def simple_piece
    tempo_piece("quarter = 120")
  end

  def tempo_piece(tempo_mark)
    Partitura::Production.piece("MIDI Export Core") do
      meter "4/4"
      key "C"
      tempo tempo_mark

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

  def first_tempo_microseconds(midi)
    position = 14
    raise "invalid MIDI tempo track" unless midi.byteslice(position, 4) == "MTrk"

    track_length = midi.byteslice(position + 4, 4).unpack1("N")
    position += 8
    track_end = position + track_length
    while position < track_end
      _delta, position = read_variable_length(midi, position)
      raise "expected MIDI meta event" unless midi.getbyte(position) == 0xFF

      type = midi.getbyte(position + 1)
      data_length, data_position = read_variable_length(midi, position + 2)
      if type == 0x51
        raise "invalid MIDI tempo event" unless data_length == 3

        return midi.byteslice(data_position, 3).bytes.reduce(0) { |value, byte| (value << 8) | byte }
      end
      position = data_position + data_length
    end

    raise "MIDI tempo event not found"
  end

  def read_variable_length(bytes, position)
    value = 0
    loop do
      byte = bytes.getbyte(position)
      position += 1
      value = (value << 7) | (byte & 0x7F)
      return [value, position] if (byte & 0x80).zero?
    end
  end
end
