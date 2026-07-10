# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura/production/tempo_parsing"

class ProductionTempoParsingStandaloneTest < Minitest::Test
  def test_standalone_parser_normalizes_dotted_quarter_tempo
    assert_equal 78, Partitura::Production.tempo_from_text("dotted-quarter = 52").fetch(:bpm)
  end

  def test_standalone_parser_raises_structured_tempo_errors
    error = assert_raises(Partitura::Production::CompileError) do
      Partitura::Production.tempo_from_text("quarter = 0")
    end

    assert_equal "tempo_out_of_midi_range", error.response.fetch(:code)
  end
end
