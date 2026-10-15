# frozen_string_literal: true

require "minitest/autorun"
require_relative "composer_fixture"

class ReadoutMeterScopeTest < Minitest::Test
  include ComposerFixture

  def test_mcp_line_and_verticals_select_actual_bars_after_meter_changes
    write(section("opening", bars: 1), section("wide", bars: 2, meter: "3/2"), section("return", bars: 1))
    [
      ["opening", 1, "C5:4"],
      ["wide", 2, "E5:6 | F5:6"],
      ["return", 1, "G5:4"]
    ].each do |id, bars, events|
      write("type" => "write_passage", "section" => id, "passage" => {
        "id" => "line", "at" => 1, "bars" => bars,
        "voices" => [{ "id" => "lead", "part" => "cl", "events" => events }]
      })
    end
    %w[line verticals].each do |view|
      options = { "piece" => "study", "view" => view, "from_bar" => 4, "to_bar" => 4 }
      options["part"] = "cl" if view == "line"
      text = @service.call("music_inspect", options).fetch(:text)
      assert_includes text, "G5"
      refute_includes text, "E5"
      refute_includes text, "F5"
    end
  end
end
