# frozen_string_literal: true

require "minitest/autorun"
require_relative "composer_fixture"

class ComposerDissonanceIntentTest < Minitest::Test
  include ComposerFixture

  def intent(**options)
    { "id" => "friction", "kind" => "intentional_dissonance",
      "value" => "Held semitone resists the expected cadence.",
      "from" => "bar 1 beat 1", "to" => "bar 1 beat 3", "for" => %w[cl vc],
      **options.transform_keys(&:to_s) }
  end

  def inspect_view(view)
    @service.inspect_music("piece" => "study", "view" => view).fetch(:text)
  end

  def test_intent_preserves_findings_and_only_marks_the_targeted_pair_inside_the_range
    write(section, passage(events: "C5:2 D5:2 | C5:4", bass: "B4:2 C#5:2 | B4:4"),
          { "type" => "set_part", "part" => { "id" => "fl", "name" => "Flute", "instrument" => "Flute" } },
          { "type" => "write_voice", "section" => "opening", "passage" => "call",
            "voice" => { "id" => "other", "part" => "fl", "events" => "C#5:4 | C#5:4" } })
    before = inspect_view("exposed_clashes")
    write("type" => "write_control", "section" => "opening", "control" => intent)
    after = inspect_view("exposed_clashes")
    assert_equal before, after.gsub(/ \| INTENTIONAL:.*$/, "")
    marked = after.lines.select { |line| line.include?("INTENTIONAL:") }
    assert_equal 1, marked.size
    assert_includes marked.first, "b1@1"
    assert_includes marked.first, "cl:C5-vc:B4"
    assert_includes marked.first, "sev"
    assert_includes inspect_view("harmony_check"), "declared dissonance intent (scoped; not a verdict)"
    assert_includes @service.read("piece" => "study", "section" => "opening").fetch(:text), "Held semitone"
    assert_includes inspect_view("controls"), "Held semitone"
    write("type" => "remove_control", "section" => "opening", "control" => "friction")
    assert_equal before, inspect_view("exposed_clashes")
  end

  def test_invalid_intent_is_rejected_atomically
    write(section, passage)
    before = File.binread(@service.store.path("study"))
    [intent(value: " "), intent(to: "bar 1 beat 1"), intent(to: "bar 3 beat 2"),
     intent(for: "missing"), intent(for: []), intent.reject { |key, _| key == "value" }].each do |control|
      assert_raises(Partitura::Composer::Error) do
        write("type" => "write_control", "section" => "opening", "control" => control)
      end
      assert_equal before, File.binread(@service.store.path("study"))
    end
  end

  def test_reordering_moves_the_intent_with_its_music
    write(section, passage, section("answer"), passage("answer"),
          { "type" => "write_control", "section" => "answer", "control" => intent })
    assert_equal "bar 3 beat 1/1", piece.controls.first.from
    write("type" => "arrange_sections", "order" => %w[answer opening])
    assert_equal "bar 1 beat 1/1", piece.controls.first.from
    assert_equal "bar 1 beat 3/1", piece.controls.first.to
  end

  def test_declaration_does_not_change_exported_music_or_hide_harmony_verdicts
    write(section, passage(events: "C#5:4 | C#5:4", bass: "F#3:4 | F#3:4"))
    before = @service.export("piece" => "study").fetch(:files).map { |file| File.binread(file.fetch(:path)) }
    harmony = inspect_view("harmony_check")
    write("type" => "write_control", "section" => "opening", "control" => intent)
    after = @service.export("piece" => "study").fetch(:files).map { |file| File.binread(file.fetch(:path)) }
    assert_equal before, after
    assert_equal harmony, inspect_view("harmony_check").gsub(/ \| declared dissonance intent.*$/, "")
  end
end
