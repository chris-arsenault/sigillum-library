# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"
require "zip"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class ScoreObservationTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CLI = File.join(ROOT, "partitura", "bin", "partitura")
  CONTAINER = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
      <rootfiles>
        <rootfile full-path="score.xml" media-type="application/vnd.recordare.musicxml+xml"/>
      </rootfiles>
    </container>
  XML
  SCORE = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <score-partwise version="4.0">
      <work><work-title>Observation Study</work-title></work>
      <identification><creator type="composer">Test Composer</creator></identification>
      <part-list>
        <score-part id="P1">
          <part-name>Clarinet in B-flat</part-name>
          <score-instrument id="P1-I1"><instrument-name>Clarinet</instrument-name></score-instrument>
        </score-part>
      </part-list>
      <part id="P1">
        <measure number="1">
          <attributes>
            <divisions>4</divisions>
            <key><fifths>2</fifths><mode>major</mode></key>
            <time><beats>4</beats><beat-type>4</beat-type></time>
            <transpose><chromatic>-2</chromatic></transpose>
          </attributes>
          <direction><sound tempo="96"/></direction>
          <note>
            <pitch><step>C</step><octave>4</octave></pitch>
            <duration>4</duration><voice>1</voice>
          </note>
          <note>
            <chord/><pitch><step>E</step><octave>4</octave></pitch>
            <duration>4</duration><voice>1</voice>
          </note>
          <note><rest/><duration>4</duration><voice>1</voice></note>
          <backup><duration>8</duration></backup>
          <note>
            <pitch><step>G</step><octave>3</octave></pitch>
            <duration>16</duration><voice>2</voice>
          </note>
        </measure>
      </part>
    </score-partwise>
  XML

  def test_plain_musicxml_projection_preserves_polyphony_and_concert_pitch
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.musicxml")
      File.write(path, SCORE)

      observation = Partitura.score_observation(path)

      assert_equal 1, observation.fetch("schema_version")
      assert_match(/\Asha256:[0-9a-f]{64}\z/, observation.fetch("observation_digest"))
      assert_equal "musicxml", observation.dig("source", "format")
      assert_equal "Observation Study", observation.dig("score", "title")
      assert_equal "4/1", observation.dig("summary", "duration_ql")
      assert_equal 4, observation.dig("summary", "event_count")
      events = observation.dig("score", "timed_events")
      assert_equal [58, 62, 53], (events.filter_map { |event| event["midi"] })
      assert_equal "0/1", events.find { |event| event["chord"] }.fetch("measure_onset_ql")
      assert_equal %w[1 2], events.map { |event| event.fetch("voice") }.uniq
    end
  end

  def test_mxl_projection_uses_declared_rootfile_and_is_deterministic
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.mxl")
      write_mxl(path, container: CONTAINER, score: SCORE)

      first = Partitura.score_observation(path)
      second = Partitura.score_observation(path)

      assert_equal first, second
      assert_equal "mxl", first.dig("source", "format")
      assert_equal "score.xml", first.dig("source", "member")
      assert_equal 1, first.dig("summary", "part_count")
    end
  end

  def test_in_memory_musicxml_uses_the_same_canonical_projection
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.musicxml")
      File.write(path, SCORE)

      from_path = Partitura.score_observation(path)
      from_memory = Partitura.score_observation_from_musicxml(SCORE)

      assert_equal from_path, from_memory
      assert_equal(
        from_memory.dig("source", "source_digest"),
        from_memory.dig("source", "document_digest")
      )
    end
  end

  def test_mxl_rejects_rootfile_traversal
    Dir.mktmpdir do |directory|
      path = File.join(directory, "unsafe.mxl")
      container = CONTAINER.sub('full-path="score.xml"', 'full-path="../score.xml"')
      write_mxl(path, container: container, score: SCORE)

      error = assert_raises(Partitura::ScoreObservation::Error) do
        Partitura.score_observation(path)
      end

      assert_equal "unsafe_mxl", error.code
    end
  end

  def test_cli_emits_the_versioned_observation
    Dir.mktmpdir do |directory|
      path = File.join(directory, "score.musicxml")
      File.write(path, SCORE)

      stdout, stderr, status = Open3.capture3("ruby", CLI, "score-observation", path)

      assert status.success?, stderr
      assert_equal 1, JSON.parse(stdout).fetch("schema_version")
    end
  end

  private

  def write_mxl(path, container:, score:)
    Zip::OutputStream.open(path) do |archive|
      archive.put_next_entry("META-INF/container.xml")
      archive.write(container)
      archive.put_next_entry("score.xml")
      archive.write(score)
    end
  end
end
