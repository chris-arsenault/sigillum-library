# frozen_string_literal: true

require "fileutils"
require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"

$LOAD_PATH.unshift(File.expand_path("../../lib", __dir__))
require "partitura/orchestral_dsl"

module ProductionSurfaceHelpers
  EXAMPLE = File.expand_path(
    "../../../experiments/orchestral_dsl/production_hybrid_study.rb",
    __dir__
  )

  MINIMAL_IMPORT_MUSICXML = <<~XML
  <?xml version="1.0" encoding="utf-8"?>
  <score-partwise version="4.0">
    <part-list>
      <score-part id="P1">
        <part-name>Flute</part-name>
      </score-part>
    </part-list>
    <part id="P1">
      <measure number="1">
        <attributes>
          <divisions>4</divisions>
          <key>
            <fifths>0</fifths>
            <mode>major</mode>
          </key>
        </attributes>
        <direction>
          <direction-type>
            <dynamics><mf/></dynamics>
          </direction-type>
          <direction-type>
            <words>cantabile</words>
          </direction-type>
          <direction-type>
            <metronome>
              <beat-unit>quarter</beat-unit>
              <per-minute>84</per-minute>
            </metronome>
          </direction-type>
        </direction>
        <harmony>
          <root><root-step>C</root-step></root>
          <kind>major</kind>
        </harmony>
        <note>
          <pitch>
            <step>C</step>
            <octave>5</octave>
          </pitch>
          <duration>4</duration>
          <notations>
            <articulations><staccato/></articulations>
          </notations>
        </note>
        <note>
          <pitch>
            <step>D</step>
            <octave>5</octave>
          </pitch>
          <duration>4</duration>
        </note>
      </measure>
    </part>
  </score-partwise>
  XML

  def load_piece
    Sigillum::OrchestralDSL.load_production_file(EXAMPLE)
  end

  def assert_event(events, piece, offset:, part:, pitch:, role:, phrase:)
    found = events.any? do |event|
      piece.format_offset(event.offset) == offset &&
        event.part == part &&
        event.pitch == pitch &&
        event.role == role &&
        event.phrase_id == phrase
    end
    assert found, "missing #{offset} #{part} #{pitch} role=#{role} phrase=#{phrase}"
  end
end
