# frozen_string_literal: true

require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"
require_relative "composer_fixture"
require_relative "support/musicxml_exporter_helpers"

class InstrumentIdentityTest < Minitest::Test
  include ComposerFixture
  include MusicXMLExporterHelpers

  def test_standard_instrument_names_are_independent_of_staff_labels
    write(section, passage,
          { "type" => "set_part", "part" => {
            "id" => "cl", "name" => "Clarinets 1-2", "instrument" => "Clarinet", "abbreviation" => "Cl. 1-2"
          } },
          { "type" => "set_part", "part" => {
            "id" => "vc", "name" => "Violoncellos", "instrument" => "Violoncello", "abbreviation" => "Vc."
          } })
    document = render_document(piece)
    assert_equal ["Clarinets 1-2", "Violoncellos"], xml_values(document, "part-name")
    assert_equal %w[Clarinet Violoncello], xml_values(document, "score-instrument/instrument-name")
    assert_equal %w[wind.reed.clarinet strings.cello], xml_values(document, "score-instrument/instrument-sound")
    assert_empty REXML::XPath.match(document, "//ensemble | //solo")
  end

  def test_section_size_and_single_player_survive_save_reopen_and_export
    write(section, passage, { "type" => "set_part", "part" => {
      "id" => "vc", "name" => "Violoncellos", "instrument" => "Violoncello"
    } })
    original_midi = Partitura::Export::MIDI.render(piece)
    [true, 2, false].each do |value|
      write("type" => "set_part", "part" => {
        "id" => "vc", "name" => "Violoncellos", "instrument" => "Violoncello", "ensemble" => value
      })
      assert_ensemble_identity(value)
      assert_equal original_midi, Partitura::Export::MIDI.render(piece)
    end
    assert_includes @service.read("piece" => "study").fetch(:text), "single player"
  end

  def test_invalid_ensemble_values_leave_the_score_unchanged
    write(section, passage)
    before = File.binread(@service.store.path("study"))
    [0, -1, 1.5, "section"].each do |value|
      assert_raises(Partitura::Composer::Error) do
        write("type" => "set_part", "part" => {
          "id" => "vc", "name" => "Cello", "instrument" => "Violoncello", "ensemble" => value
        })
      end
      assert_raises(ArgumentError) do
        Partitura::Production::Part.new(id: :vc, name: "Cello", music21_instrument: "Violoncello", ensemble: value)
      end
    end
    assert_equal before, File.binread(@service.store.path("study"))
  end

  private

  def assert_ensemble_identity(value)
    reopened = Partitura::Composer::Service.new(root: @root)
    stored = reopened.store.read("study").first.data.fetch("parts").last
    assert_equal value, stored.fetch("ensemble")
    assert_equal value, Partitura::Production.export_part(piece.parts.fetch(:vc)).fetch(:ensemble)
    instrument = REXML::XPath.first(render_document(piece), "//score-part[2]/score-instrument")
    if value == false
      refute_nil instrument.elements["solo"]
      assert_nil instrument.elements["ensemble"]
    else
      refute_nil instrument.elements["ensemble"]
      assert_equal(value == true ? "" : "2", instrument.elements["ensemble"].text.to_s)
      assert_nil instrument.elements["solo"]
    end
  end

  def xml_values(document, path)
    REXML::XPath.match(document, "/score-partwise/part-list/score-part/#{path}").map(&:text)
  end
end
