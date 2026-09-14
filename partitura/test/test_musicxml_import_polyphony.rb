# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require_relative "../lib/partitura/production/musicxml_import"

class MusicXMLImportPolyphonyTest < Minitest::Test
  Import = Partitura::Production::MusicXMLImport

  def test_names_chords_staves_and_ties_survive_import
    with_xml(score) do |path|
      result = Import.convert(path, bars: 1..2, beats: 3)
      assert_equal ["wordless basso", "bass clarinet", "pedal harp [staff 1]", "pedal harp [staff 2]"], result.parts.keys
      assert_includes result.render, "[C4,E4]:3{tie(}"
      assert_includes result.render, "[C4,E4]:3{tie)}"
      assert_equal [36], result.parts.fetch("pedal harp [staff 2]").filter_map(&:midi).uniq
      assert Import.verify(path, path, bars: 1..2, beats: 3).ok?
    end
  end

  def test_verifier_detects_a_changed_chord_member_and_a_changed_onset
    with_xml(score) do |original|
      with_xml(score.sub("<chord/><pitch><step>E", "<chord/><pitch><step>F")) do |changed|
        refute Import.verify(original, changed, bars: 1..2, beats: 3).ok?
      end
      shifted = score.sub("<note><pitch><step>D", "<forward><duration>1</duration></forward><note><pitch><step>D")
      with_xml(shifted) do |changed|
        refute Import.verify(original, changed, bars: 1..2, beats: 3).ok?
      end
    end
  end

  def test_a_longer_export_is_not_silently_truncated_to_shorter_input
    with_xml(score) do |original|
      extra = score.sub('</part></score-partwise>', '<measure number="3"><note><pitch><step>C</step><octave>4</octave></pitch><duration>3</duration><staff>1</staff></note></measure></part></score-partwise>')
      with_xml(extra) do |changed|
        refute Import.verify(original, changed, bars: 1..3, beats: 3).ok?
      end
    end
  end

  private

  def with_xml(body)
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.musicxml")
      File.write(path, body)
      yield path
    end
  end

  def score
    <<~XML
      <score-partwise><part-list>
      <score-part id="B"><part-name>Wordless Basso</part-name></score-part>
      <score-part id="C"><part-name>Bass Clarinet</part-name></score-part>
      <score-part id="H"><part-name>Pedal Harp</part-name></score-part>
      </part-list>
      <part id="B"><measure number="1"><attributes><divisions>1</divisions></attributes>
      <note><pitch><step>D</step><octave>3</octave></pitch><duration>3</duration></note>
      </measure></part>
      <part id="C"><measure number="1"><attributes><divisions>1</divisions><transpose><chromatic>-2</chromatic><octave-change>-1</octave-change></transpose></attributes>
      <note><pitch><step>E</step><octave>4</octave></pitch><duration>3</duration></note>
      </measure></part>
      <part id="H"><measure number="1"><attributes><divisions>1</divisions><staves>2</staves></attributes>
      <note><pitch><step>C</step><octave>4</octave></pitch><duration>3</duration><tie type="start"/><voice>1</voice><staff>1</staff></note>
      <note><chord/><pitch><step>E</step><octave>4</octave></pitch><duration>3</duration><tie type="start"/><voice>1</voice><staff>1</staff></note>
      <backup><duration>3</duration></backup>
      <note><pitch><step>C</step><octave>2</octave></pitch><duration>3</duration><voice>2</voice><staff>2</staff></note>
      </measure><measure number="2">
      <note><pitch><step>C</step><octave>4</octave></pitch><duration>3</duration><tie type="stop"/><voice>1</voice><staff>1</staff></note>
      <note><chord/><pitch><step>E</step><octave>4</octave></pitch><duration>3</duration><tie type="stop"/><voice>1</voice><staff>1</staff></note>
      <backup><duration>3</duration></backup><note><rest/><duration>3</duration><voice>2</voice><staff>2</staff></note>
      </measure></part></score-partwise>
    XML
  end
end
