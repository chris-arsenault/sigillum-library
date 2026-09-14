# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "tmpdir"
require_relative "../lib/partitura"

class MusicXMLHarmonyRoundtripTest < Minitest::Test
  def test_altered_and_inverted_symbols_keep_their_meaning_and_position
    xml = Partitura::Export::MusicXML.render(example)
    document = REXML::Document.new(xml)
    harmonies = REXML::XPath.match(document, "/score-partwise/part[1]/measure/harmony")
    assert_equal %w[major minor-seventh major-minor dominant], harmonies.map { |h| h.elements["kind"].text }
    assert_equal %w[root kind bass offset], harmonies.first.elements.map(&:name)
    assert_equal %w[root kind degree offset], harmonies.last.elements.map(&:name)
    assert_equal "1", harmonies.last.elements["degree/degree-alter"].text
    assert_equal "alter", harmonies.last.elements["degree/degree-type"].text
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.musicxml")
      File.write(path, xml)
      _, chords, = Partitura::Production::MusicXMLImport.load_parts(path, 2, {})
      assert_equal({ [1, Rational(1, 2)] => "A/C#", [1, Rational(3, 2)] => "Dm7/C",
                     [2, Rational(0)] => "Dm(maj7)", [2, Rational(3, 2)] => "A7#5" }, chords)
    end
  end

  def test_chord_symbols_do_not_create_a_second_rest_voice
    document = REXML::Document.new(Partitura::Export::MusicXML.render(example))
    measure = REXML::XPath.first(document, "/score-partwise/part[1]/measure")
    assert_equal 1, measure.get_elements("note/rest").length
    assert_empty measure.get_elements("backup")
  end

  private

  def example
    Partitura::Production.piece("Harmony fidelity") do
      meter "3/4"; key "d"
      roster { part :voice, "Voice", music21: "Soprano", family: :voice }
      section :one, "One", bars: 1..2 do
        span bars: 1..2 do
          phrase(:silence, surface: :absolute) { events "r:3 | r:3" }
          placement :silence, part: :voice, at: "bar 1 beat 1", role: :foreground
        end
      end
      control do
        chord "A/C#", at: "bar 1 beat 1.5"
        chord "Dm7/C", at: "bar 1 beat 2.5"
        chord "Dm(maj7)", at: "bar 2 beat 1"
        chord "A7#5", at: "bar 2 beat 2.5"
      end
    end
  end
end
