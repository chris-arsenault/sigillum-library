# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"

require_relative "support/midi_profile_helper"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura/orchestral_dsl"

class MusicXMLExportParityTest < Minitest::Test
  include MidiProfileHelper

  ROOT = File.expand_path("../..", __dir__)
  FIXTURE_ROOT = File.join(ROOT, "tests", "fixtures", "export_parity", "explorations")

  CASES = {
    "banner_recursion_canonical" => {
      title: "The Banner Recursion",
      transport_parts: 9,
      xml_score_parts: 10,
      midi_tracks: 11,
      meter: "2/4",
      key: "d",
      musicxml_similarity: 0.93,
      midi_note_floor: 0.87
    },
    "basin_aria" => {
      title: "Basin Aria",
      transport_parts: 7,
      xml_score_parts: 6,
      midi_tracks: 8,
      meter: "6/8",
      key: "d",
      musicxml_similarity: 0.96,
      midi_note_floor: 1.0
    },
    "hammer_gate_toccata" => {
      title: "Hammer Gate Toccata",
      transport_parts: 3,
      xml_score_parts: 2,
      midi_tracks: 4,
      meter: "4/4",
      key: "a",
      musicxml_similarity: 0.97,
      midi_note_floor: 1.0
    },
    "quarry_rounds" => {
      title: "The Quarry Rounds",
      transport_parts: 5,
      xml_score_parts: 6,
      midi_tracks: 7,
      meter: "12/8",
      key: "Bb",
      musicxml_similarity: 0.98,
      midi_note_floor: 1.0
    }
  }.freeze

  def test_exploration_baselines_are_parseable_musicxml_and_transport
    CASES.each do |stem, facts|
      xml_path = baseline_xml(stem)
      transport_path = baseline_transport(stem)

      assert File.exist?(xml_path), "missing #{xml_path}"
      assert File.exist?(transport_path), "missing #{transport_path}"

      document = REXML::Document.new(File.read(xml_path))
      assert_equal "score-partwise", document.root.name
      assert_equal "4.0", document.root.attributes["version"]
      assert_equal facts.fetch(:title), REXML::XPath.first(document, "/score-partwise/work/work-title").text
      assert_equal facts.fetch(:xml_score_parts), 
REXML::XPath.match(document, "/score-partwise/part-list/score-part").length

      transport = JSON.parse(File.read(transport_path))
      assert_equal "sigillum.orchestral_dsl.transport", transport.fetch("schema")
      assert_equal facts.fetch(:title), transport.fetch("title")
      assert_equal facts.fetch(:transport_parts), transport.fetch("parts").length
      assert_equal facts.fetch(:meter), transport.fetch("meter")
      assert_equal facts.fetch(:key), transport.fetch("key")
    end
  end

  def test_exploration_baselines_include_valid_midi
    CASES.each do |stem, facts|
      bytes = File.binread(baseline_midi(stem))

      assert_operator bytes.bytesize, :>, 0
      assert_equal "MThd", bytes.byteslice(0, 4)
      assert_equal 6, bytes.byteslice(4, 4).unpack1("N")
      assert_equal 1, bytes.byteslice(8, 2).unpack1("n")
      assert_equal facts.fetch(:midi_tracks), bytes.byteslice(10, 2).unpack1("n")
      assert_equal 10_080, bytes.byteslice(12, 2).unpack1("n")
      assert_includes bytes, "MTrk"
    end
  end

  def test_ruby_exporters_render_all_exploration_transports
    CASES.each do |stem, facts|
      transport = JSON.parse(File.read(baseline_transport(stem)))

      xml = Sigillum::OrchestralDSL::Export::MusicXML.render(transport)
      document = REXML::Document.new(xml)
      assert_equal "score-partwise", document.root.name
      assert_equal facts.fetch(:xml_score_parts), xml.scan(/<score-part\b/).length

      midi = Sigillum::OrchestralDSL::Export::MIDI.render(transport)
      assert_equal "MThd", midi.byteslice(0, 4)
      assert_equal facts.fetch(:midi_tracks), midi.byteslice(10, 2).unpack1("n")
    end
  end

  def test_ruby_musicxml_export_matches_exploration_baselines
    CASES.each do |stem, facts|
      expected_xml = normalize_musicxml(File.read(baseline_xml(stem)))
      transport = JSON.parse(File.read(baseline_transport(stem)))
      actual_xml = normalize_musicxml(Sigillum::OrchestralDSL::Export::MusicXML.render(transport))

      expected_profile = musicxml_profile(expected_xml)
      actual_profile = musicxml_profile(actual_xml)
      assert_equal expected_profile.fetch(:part_names), actual_profile.fetch(:part_names), "#{stem} part names changed"
      assert_equal expected_profile.fetch(:measure_counts), actual_profile.fetch(:measure_counts), 
"#{stem} measure layout changed"
      assert_equal expected_profile.fetch(:word_counts), actual_profile.fetch(:word_counts), 
"#{stem} text direction profile changed"
      assert_equal expected_profile.fetch(:tie_counts), actual_profile.fetch(:tie_counts), "#{stem} tie profile changed"
      assert_equal expected_profile.fetch(:tied_counts), actual_profile.fetch(:tied_counts), 
"#{stem} tied-notation profile changed"
      assert_equal expected_profile.fetch(:pedal_count), actual_profile.fetch(:pedal_count), 
"#{stem} pedal profile changed"
      assert_equal expected_tempo_sound_count(transport), actual_profile.fetch(:tempo_sound_count),
        "#{stem} Ruby MusicXML tempo playback no longer follows transport tempo events"

      similarity = token_similarity(expected_xml, actual_xml)
      assert_operator similarity, :>=, facts.fetch(:musicxml_similarity),
        "#{stem} normalized MusicXML token similarity #{similarity.round(4)} fell below parity floor"
    end
  end

  def test_ruby_midi_export_matches_exploration_baselines
    CASES.each do |stem, facts|
      expected = File.binread(baseline_midi(stem))
      transport = JSON.parse(File.read(baseline_transport(stem)))
      actual = Sigillum::OrchestralDSL::Export::MIDI.render(transport)
      expected_profile = midi_profile(expected)
      actual_profile = midi_profile(actual)

      assert_equal expected_profile.values_at(:format, :tracks, :division, :names),
        actual_profile.values_at(:format, :tracks, :division, :names),
        "#{stem} MIDI header/track profile changed"
      assert_equal expected_profile.fetch(:note_on), expected_profile.fetch(:note_off), 
"#{stem} baseline MIDI note balance invalid"
      assert_equal actual_profile.fetch(:note_on), actual_profile.fetch(:note_off), 
"#{stem} Ruby MIDI note balance invalid"
      assert_operator actual_profile.fetch(:note_on), :>=,
        (expected_profile.fetch(:note_on) * facts.fetch(:midi_note_floor)).floor,
        "#{stem} Ruby MIDI note event count fell below parity floor"
    end
  end

  private

  def baseline_xml(stem)
    File.join(FIXTURE_ROOT, stem, "#{stem}.musicxml")
  end

  def baseline_transport(stem)
    File.join(FIXTURE_ROOT, stem, "#{stem}.partitura_transport.json")
  end

  def baseline_midi(stem)
    File.join(FIXTURE_ROOT, stem, "#{stem}.mid")
  end

  def normalize_musicxml(xml)
    normalized = xml.gsub(/\r\n?/, "\n")
    normalized = normalized.gsub(%r{<encoding-date>[^<]*</encoding-date>}, "<encoding-date>DATE</encoding-date>")

    id_maps = { "P" => {}, "I" => {} }
    id_counts = Hash.new(0)

    normalized.gsub(/\bid="([PI][A-Za-z0-9_.:-]+)"/) do
      source_id = Regexp.last_match(1)
      prefix = source_id[0]
      unless id_maps.fetch(prefix).key?(source_id)
        id_counts[prefix] += 1
        id_maps.fetch(prefix)[source_id] = "#{prefix}#{id_counts.fetch(prefix)}"
      end
      "id=\"#{id_maps.fetch(prefix).fetch(source_id)}\""
    end.strip
  end

  def musicxml_profile(xml)
    document = REXML::Document.new(xml)
    {
      part_names: REXML::XPath.match(document, "/score-partwise/part-list/score-part/part-name").map(&:text),
      measure_counts: REXML::XPath.match(document, "/score-partwise/part").map { |part|
 REXML::XPath.match(part, "measure").length },
      word_counts: text_counts(REXML::XPath.match(document, "//direction-type/words").map { |element|
 element.text.to_s }),
      tie_counts: text_counts(REXML::XPath.match(document, "//tie").map { |element| element.attributes["type"].to_s }),
      tied_counts: text_counts(REXML::XPath.match(document, "//tied").map { |element|
 element.attributes["type"].to_s }),
      pedal_count: REXML::XPath.match(document, "//direction-type/pedal").length,
      tempo_sound_count: REXML::XPath.match(document, "//sound[@tempo]").length
    }
  end

  def token_similarity(expected_xml, actual_xml)
    expected = xml_tokens(expected_xml).tally
    actual = xml_tokens(actual_xml).tally
    overlap = expected.sum { |token, count| [count, actual.fetch(token, 0)].min }
    overlap.to_f / expected.values.sum
  end

  def xml_tokens(xml)
    xml.scan(%r{</?[^>]+>|[^<>\s]+})
  end

  def text_counts(values)
    values.each_with_object(Hash.new(0)) { |value, counts| counts[value] += 1 }.sort.to_h
  end

  def expected_tempo_sound_count(transport)
    Array(transport["tempo_events"]).sum do |event|
      kind = event["kind"]
      if kind.nil? || kind == "mark"
        event["bpm"] ? 1 : 0
      elsif %w[ritardando accelerando].include?(kind)
        from = Rational(event.fetch("from_offset_ql").to_s)
        to = Rational(event.fetch("to_offset_ql").to_s)
        [(to - from).round, 1].max
      else
        0
      end
    end
  end

end
