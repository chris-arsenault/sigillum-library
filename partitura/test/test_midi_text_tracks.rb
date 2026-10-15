# frozen_string_literal: true

require "minitest/autorun"
require_relative "composer_fixture"

class MIDITextTracksTest < Minitest::Test
  include ComposerFixture

  def test_player_text_directions_do_not_add_a_notes_metadata_track
    write(section, passage, {
      "type" => "write_control", "section" => "opening", "control" => {
        "id" => "solo", "kind" => "text", "value" => "Solo", "at" => "bar 1 beat 1", "for" => "cl"
      }
    })
    midi = Partitura::Export::MIDI.render(piece)

    assert_equal 3, midi.byteslice(10, 2).unpack1("n")
    refute_includes midi, "Notes"
  end
end
