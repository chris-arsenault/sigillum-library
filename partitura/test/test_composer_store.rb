# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require_relative "../lib/partitura"
require_relative "../lib/partitura/composer"

class ComposerStoreTest < Minitest::Test
  def setup
    @root = Dir.mktmpdir("partitura-composer-test-")
    @store = Partitura::Composer::Store.new(@root)
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def score
    Partitura::Composer::Score.new(
      "schema_version" => 1, "id" => "study", "title" => "Study", "brief" => "Keep \#{system(\"false\")} literal.",
      "meter" => "4/4", "key" => "C", "tempo" => "quarter = 72",
      "parts" => [{ "id" => "clarinet", "name" => "Clarinet", "instrument" => "Clarinet" }],
      "sections" => [{
        "id" => "opening", "name" => "Opening", "bars" => 2,
        "passages" => [{ "id" => "call", "at" => 1, "bars" => 2, "chords" => "b1:C b2:G7",
                         "voices" => [{ "id" => "lead", "part" => "clarinet", "role" => "foreground",
                                        "events" => "C5:1{accent} D5:1 E5:2 | D5:2 G4:2" }] }],
        "controls" => [{ "id" => "entry", "kind" => "dynamic", "value" => "mf",
                         "at" => "bar 1 beat 1", "for" => "clarinet" }]
      }],
      "decisions" => [{ "id" => "identity", "text" => "Retain the rising head.", "section" => "opening" }]
    )
  end

  def test_cold_reopen_preserves_musical_text_and_compiles_with_existing_loader
    revision = @store.write(score, expected: nil)
    reopened, reopened_revision = Partitura::Composer::Store.new(@root).read("study")
    assert_equal score.data, reopened.data
    assert_equal revision, reopened_revision
    piece = Partitura.load_production_file(@store.path("study"))
    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_equal %w[C5 D5 E5 D5 G4], piece.timed_events.map(&:pitch)
    assert_equal({ 1 => "C", 2 => "G7" }, piece.declared_chords)
    assert_equal "mf", piece.controls.first.value
  end

  def test_degrees_rhythm_and_rational_values_use_production_parser
    data = score.data
    voice = data["sections"][0]["passages"][0]["voices"][0]
    voice.delete("events")
    voice.merge!("degrees" => "1 3 5 | 4 2", "rhythm" => "1 1 2 | 2 2", "key_context" => "F4")
    piece = Partitura::Composer::Engine.new(Partitura::Composer::Score.new(data)).build
    assert_equal "ok", piece.compile_response.fetch(:status)
    assert_equal %w[F4 A4 C5 Bb4 G4], piece.timed_events.map(&:pitch)
    assert_equal Rational(2), piece.timed_events.last.duration
  end

  def test_stale_save_and_creation_overwrite_leave_accepted_music_unchanged
    revision = @store.write(score, expected: nil)
    changed = score
    changed.data["title"] = "Revised"
    @store.write(changed, expected: revision)
    error = assert_raises(Partitura::Composer::Error) { @store.write(score, expected: revision) }
    assert_equal "stale_revision", error.code
    assert_equal "Revised", @store.read("study").first.data["title"]
    assert_raises(Partitura::Composer::Error) { @store.write(score, expected: nil) }
  end

  def test_path_escape_and_symbolic_links_are_refused
    assert_raises(Partitura::Composer::Error) { @store.read("../study") }
    File.symlink(@root, File.join(@root, "compositions"))
    error = assert_raises(Partitura::Composer::Error) { @store.write(score, expected: nil) }
    assert_equal "unsafe_path", error.code
  end

  def test_unmanaged_source_is_never_evaluated_by_service
    FileUtils.mkdir_p(File.dirname(@store.path("study")))
    File.write(@store.path("study"), 'raise "must not run"')
    error = assert_raises(Partitura::Composer::Error) { @store.read("study") }
    assert_equal "unmanaged_source", error.code
  end

  def test_duplicate_id_and_unknown_fields_are_not_silently_discarded
    data = score.data
    data["sections"] << data["sections"][0].dup
    assert_raises(Partitura::Composer::Error) { Partitura::Composer::Score.new(data) }
    data = score.data.merge("unexpected" => true)
    assert_raises(Partitura::Composer::Error) { Partitura::Composer::Score.new(data) }
  end
end
