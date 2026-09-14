# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "tmpdir"
require_relative "../lib/partitura"

class ImportedControlPositionsTest < Minitest::Test
  def test_exact_hairpins_retain_offsets_inside_rests_and_long_spans
    piece = example
    xml = Partitura::Export::MusicXML.render(piece)
    Dir.mktmpdir do |dir|
      path = File.join(dir, "score.musicxml")
      File.write(path, xml)
      _, _, meta = Partitura::Production::MusicXMLImport.load_parts(path, 3, {})
      wedges = meta.select { |row| row.part == "upper" && row.kind == "wedge" }
      assert_equal [[1, Rational(1, 2), "crescendo"], [3, Rational(7, 4), "stop"]],
                   wedges.map { |row| [row.bar, row.onset, row.text] }
    end
  end

  def test_local_signature_does_not_move_other_parts_or_the_tonal_context
    piece = example
    xml = REXML::Document.new(Partitura::Export::MusicXML.render(piece))
    upper = REXML::XPath.first(xml, '/score-partwise/part[1]/measure[@number="2"]/attributes/key')
    lower = REXML::XPath.first(xml, '/score-partwise/part[2]/measure[@number="2"]/attributes/key')
    assert_equal "-3", upper.elements['fifths'].text
    assert_equal "major", upper.elements['mode'].text
    assert_equal "-6", lower.elements['fifths'].text
    assert_equal "minor", lower.elements['mode'].text
    assert_equal "eb", piece.key_for_bar(2)
  end

  private

  def example
    Partitura::Production.piece("Exact imported controls") do
      meter "3/4"; key "C"
      roster do
        part :upper, "Upper", music21: "Soprano", family: :voice
        part :lower, "Lower", music21: "Bass", family: :voice
      end
      section :one, "One", bars: 1..3 do
        span bars: 1..3 do
          phrase(:upper, surface: :absolute) { events "C4:1 r:2 | r:3 | C4:3" }
          phrase(:lower, surface: :absolute) { events "C3:3 | Eb3:3 | Eb3:3" }
          placement :upper, part: :upper, at: "bar 1 beat 1", role: :foreground
          placement :lower, part: :lower, at: "bar 1 beat 1", role: :bass
        end
      end
      control do
        crescendo from: "bar 1 beat 1.5", to: "bar 3 beat 2.75", exact: true, for: :upper
        key_change "eb", at: "bar 2 beat 1"
        key_signature "Eb", at: "bar 2 beat 1", for: :upper
      end
    end
  end
end
