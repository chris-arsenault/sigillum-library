# frozen_string_literal: true

require "tmpdir"
require "rexml/document"
require "rexml/xpath"
require_relative "support/production_surface_helpers"

class ProductionTexturesTest < Minitest::Test
  include ProductionSurfaceHelpers

  TEXTURE_SOURCE = <<~RUBY
    production_piece "Texture Demo" do
      meter "2/4"; key "e"
      roster do
        part :violin, "Violin", music21: "Violin", family: :strings, range: "G3-E7"
        part :cello, "Cello", music21: "Violoncello", family: :strings, range: "C2-G5"
        part :bass, "Bass", music21: "Contrabass", family: :strings, range: "E1-C4"
        part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, range: "F#3-E6"
      end
      section :s1, "Ladder", bars: 1..2 do
        span bars: 1..2 do
          texture :string_engine, bars: 1..2 do
            control { dynamic :mp, at: :start; crescendo from: :start, to: :end }
            score grid: :eighth do
              violin "E5 B5 G5 B5 | F5 C6 Ab5 C6"
              cello  "E3 _  B3 _  | F3 _  C4 _"
              bass   "E2 .  .  .  | F2 .  .  ."
            end
            line :call, part: :trumpet, role: :foreground, surface: :intervals do
              anchor "E5"
              intervals "0 +7 -5 +2 | +1 +7 -5 +2"
              rhythm ".5 .25 .25 1 | .5 .25 .25 1"
            end
          end
        end
      end
    end
  RUBY

  def test_texture_combines_score_grid_and_interval_melody
    piece = load_texture_piece
    xml = REXML::Document.new(Partitura.production_musicxml(piece))

    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_includes piece.compile_response.fetch(:surface_summary), "score_grid"
    assert_includes Partitura.production_readout(piece, :controls), "dynamic mp"
    assert_equal "Texture Demo", REXML::XPath.first(xml, "/score-partwise/work/work-title").text
    assert_equal "MThd", Partitura.production_midi(piece).byteslice(0, 4)
  end

  private

  def load_texture_piece
    Dir.mktmpdir do |dir|
      path = File.join(dir, "texture.rb")
      File.write(path, TEXTURE_SOURCE)
      return Partitura.load_production_file(path)
    end
  end
end
