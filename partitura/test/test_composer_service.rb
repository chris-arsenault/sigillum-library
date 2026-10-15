# frozen_string_literal: true

require "minitest/autorun"
require_relative "composer_fixture"

class ComposerServiceTest < Minitest::Test
  include ComposerFixture

  def test_compose_read_inspect_and_export
    write(section, passage)
    read = @service.read("piece" => "study", "section" => "opening", "passage" => "call")
    assert_includes read.fetch(:text), "C5:2{slur(} E5:2"
    assert_includes read.fetch(:text), "C3:4 | G2:4"
    assert_equal @revision, read.fetch(:revision)
    view = @service.inspect_music("piece" => "study", "view" => "ensemble_grid")
    assert_includes view.fetch(:text), "cl"
    exported = @service.export("piece" => "study")
    xml, midi = exported.fetch(:files).map { |file| File.binread(file.fetch(:path)) }
    assert_includes xml, "<score-partwise"
    assert_equal "MThd", midi[0, 4]
    assert_empty exported.fetch(:unwritten)
  end

  def test_related_changes_are_atomic_and_invalid_notes_preserve_the_revision
    write(section, passage)
    before = File.binread(@service.store.path("study"))
    error = assert_raises(Partitura::Composer::Error) do
      write({ "type" => "set_brief", "text" => "Must roll back." },
            { "type" => "write_voice", "section" => "opening", "passage" => "call",
              "voice" => { "id" => "lead", "part" => "cl", "events" => "Q5:4 | C5:4" } })
    end
    assert_equal "invalid_music", error.code
    assert_equal before, File.binread(@service.store.path("study"))
  end

  def test_preview_and_successful_voice_revision_preserve_other_voices
    write(section, passage)
    original = piece.timed_events.select { |event| event.part == :vc }.map { |event| [event.pitch, event.offset] }
    change = { "type" => "write_voice", "section" => "opening", "passage" => "call",
               "voice" => { "id" => "lead", "part" => "cl", "events" => "E5:4 | D5:4" } }
    preview = write(change, preview: true)
    assert preview.fetch(:preview)
    assert_equal "C5", piece.timed_events.find { |event| event.part == :cl }.pitch
    write(change)
    assert_equal "E5", piece.timed_events.find { |event| event.part == :cl }.pitch
    assert_equal(original, piece.timed_events.select { |event|
 event.part == :vc }.map { |event| [event.pitch, event.offset] })
  end

  def test_reordering_carries_music_harmony_meter_tempo_and_controls
    write(section, passage, section("answer", meter: "3/4", key: "F", tempo: "quarter = 90"),
          passage("answer", events: "F5:3 | E5:3", bass: "F3:3 | C3:3"),
          { "type" => "write_control", "section" => "answer",
            "control" => { "id" => "swell", "kind" => "crescendo", "from" => "bar 1 beat 1",
                           "to" => "bar 2 beat 3", "for" => "cl" } })
    write("type" => "arrange_sections", "order" => %w[answer opening])
    moved = piece
    assert_equal "3/4", moved.meter_for(1).meter
    assert_equal "4/4", moved.meter_for(3).meter
    assert_equal "F", moved.key_for_bar(1)
    assert_equal "C", moved.key_for_bar(3)
    assert_equal Rational(6), moved.timed_events.find { |event| event.pitch == "C5" }.offset
    assert_equal "bar 1 beat 1/1", moved.controls.first.from
    assert_equal [90, 72], moved.tempo_events.map(&:bpm)
    assert_equal "C", moved.declared_chords.fetch(3)
  end

  def test_extension_does_not_generate_notes_and_shortening_cannot_discard_music
    write(section, passage)
    notes = piece.timed_events.map(&:pitch)
    write(section(bars: 4))
    assert_equal notes, piece.timed_events.map(&:pitch)
    assert_equal 4, piece.sections.first.bars.end
    assert_includes @service.read("piece" => "study").fetch(:text), "Unwritten bars in opening: 3, 4."
    error = assert_raises(Partitura::Composer::Error) { write(section(bars: 1)) }
    assert_equal "invalid_input", error.code
    assert_equal 4, piece.sections.first.bars.end
  end

  def test_unwritten_voice_is_distinct_from_an_explicit_rest
    write(section, passage)
    write("type" => "remove_voice", "section" => "opening", "passage" => "call", "voice" => "bass")
    error = assert_raises(Partitura::Composer::Error) { @service.export("piece" => "study") }
    assert_equal "unfinished_music", error.code
    assert @service.export("piece" => "study", "draft" => true).fetch(:unwritten).any?
    write("type" => "write_voice", "section" => "opening", "passage" => "call",
          "voice" => { "id" => "bass", "part" => "vc", "events" => "r:4 | r:4" })
    assert_empty @service.export("piece" => "study").fetch(:unwritten)
  end

  def test_cold_service_resume_and_stale_write
    write(section, passage, { "type" => "remember", "decision" => { "id" => "keep_head", "text" => "Keep the head." } })
    other = Partitura::Composer::Service.new(root: @root)
    assert_includes other.read("piece" => "study").fetch(:text), "Keep the head."
    previous = @revision
    write("type" => "set_brief", "text" => "Revised brief.")
    error = assert_raises(Partitura::Composer::Error) do
      other.revise("piece" => "study", "revision" => previous,
                   "changes" => [{ "type" => "set_brief", "text" => "Stale." }])
    end
    assert_equal "stale_revision", error.code
  end

  def test_reads_have_followable_continuations
    write(section, passage)
    input = { "piece" => "study", "section" => "opening", "limit" => 70 }
    chunks = []
    loop do
      result = @service.read(input)
      chunks << result.fetch(:text)
      break if result.fetch(:complete)

      input = result.fetch(:continuation)
    end
    whole = @service.read("piece" => "study", "section" => "opening").fetch(:text)
    assert_equal whole, chunks.join
  end
end
