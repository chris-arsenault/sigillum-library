# frozen_string_literal: true

require "minitest/autorun"
require_relative "composer_fixture"
require_relative "../lib/partitura/composer/resources"

class ComposerBoundariesTest < Minitest::Test
  include ComposerFixture

  def test_invalid_durations_beats_and_meter_leave_music_unchanged
    write(section, passage)
    before = File.binread(@service.store.path("study"))
    ["C5:0 | D5:4", "C5:1/0 | D5:4"].each do |events|
      error = assert_raises(Partitura::Composer::Error) do
        write("type" => "write_voice", "section" => "opening", "passage" => "call",
              "voice" => { "id" => "lead", "part" => "cl", "events" => events })
      end
      assert_equal "invalid_music", error.code
    end
    assert_raises(Partitura::Composer::Error) { write(section(meter: "0/4")) }
    assert_equal before, File.binread(@service.store.path("study"))
  end

  def test_control_shapes_and_section_boundaries_are_checked
    write(section, passage)
    controls = [
      { "id" => "missing", "kind" => "dynamic", "value" => "mf", "at" => "bar 1 beat 1" },
      { "id" => "beat", "kind" => "dynamic", "value" => "mf", "at" => "bar 1 beat 99", "for" => "cl" },
      { "id" => "cross", "kind" => "crescendo", "from" => "bar 1 beat 1", "to" => "bar 3 beat 2", "for" => "cl" },
      { "id" => "reverse", "kind" => "crescendo", "from" => "bar 2 beat 1", "to" => "bar 1 beat 1", "for" => "cl" }
    ]
    controls.each do |control|
      assert_raises(Partitura::Composer::Error) do
        write("type" => "write_control", "section" => "opening", "control" => control)
      end
    end
    write("type" => "write_control", "section" => "opening", "control" => {
      "id" => "boundary", "kind" => "diminuendo", "from" => "bar 2 beat 1", "to" => "bar 3 beat 1", "for" => "cl"
    })
    assert_equal 1, piece.controls.length
  end

  def test_reordering_a_pickup_before_score_start_is_refused
    write(section, passage, section("answer"))
    pickup = passage("answer")
    pickup["passage"]["voices"][0].merge!("events" => "G4:.5 | C5:4 | D5:4", "anacrusis" => 0.5)
    write(pickup)
    before = File.binread(@service.store.path("study"))
    error = assert_raises(Partitura::Composer::Error) do
      write("type" => "arrange_sections", "order" => %w[answer opening])
    end
    assert_equal "invalid_music", error.code
    assert_equal before, File.binread(@service.store.path("study"))
  end

  def test_internal_context_changes_move_with_the_section
    opening = passage(events: "C5:4 | D5:3 | E5:3", bass: "C3:4 | G2:3 | C3:3")
    opening["passage"]["bars"] = 3
    opening["passage"]["chords"] = "b1:C b2:G b3:C"
    write(section(bars: 3), opening, section("answer"), passage("answer"),
          { "type" => "write_control", "section" => "opening", "control" => {
            "id" => "waltz", "kind" => "meter", "value" => "3/4", "at" => "bar 2 beat 1"
          } },
          { "type" => "write_control", "section" => "opening", "control" => {
            "id" => "dominant", "kind" => "key", "value" => "G", "at" => "bar 2 beat 1"
          } })
    write("type" => "arrange_sections", "order" => %w[answer opening])
    assert_equal "4/4", piece.meter_for(3).meter
    assert_equal "3/4", piece.meter_for(4).meter
    assert_equal "C", piece.key_for_bar(3)
    assert_equal "G", piece.key_for_bar(4)
    assert_equal [Rational(2), Rational(15)], piece.timed_events.select { |event| event.pitch == "E5" }.map(&:offset)
  end

  def test_concurrent_writers_cannot_overwrite_each_other
    write(section, passage)
    revision = @revision
    gate = Queue.new
    writers = %w[first second].map do |text|
      Thread.new do
        gate.pop
        service = Partitura::Composer::Service.new(root: @root)
        service.revise("piece" => "study", "revision" => revision,
                       "changes" => [{ "type" => "set_brief", "text" => text }])
        :saved
      rescue Partitura::Composer::Error => e
        e.code
      end
    end
    2.times { gate << true }
    assert_equal [:saved, "stale_revision"].sort_by(&:to_s), writers.map(&:value).sort_by(&:to_s)
    assert_includes %w[first second], @service.store.read("study").first.data.fetch("brief")
  end

  def test_export_resources_refuse_symbolic_links
    write(section, passage)
    result = @service.export("piece" => "study")
    resources = Partitura::Composer::Resources.new(@service.store)
    uri = resources.export_links(result).first.fetch(:uri)
    file = result.fetch(:files).first.fetch(:path)
    File.unlink(file)
    File.symlink(@service.store.path("study"), file)
    error = assert_raises(Partitura::Composer::Error) { resources.read(uri) }
    assert_equal "unsafe_path", error.code
  end

  def test_decisions_are_not_silently_orphaned_when_deleting_music
    write(section, passage, { "type" => "remember", "decision" => {
      "id" => "head", "text" => "Keep the head.", "section" => "opening", "passage" => "call"
    } })
    assert_raises(Partitura::Composer::Error) { write("type" => "remove_section", "section" => "opening") }
    write({ "type" => "forget", "decision" => "head" }, { "type" => "remove_section", "section" => "opening" })
    assert_empty piece.sections
  end
end
