# frozen_string_literal: true

require "minitest/autorun"
require_relative "composer_fixture"
require_relative "../lib/partitura/composer/resources"

class ComposerAdoptionTest < Minitest::Test
  include ComposerFixture

  SOURCE = <<~RUBY
    production_piece "Existing study" do
      meter "4/4"
      key "C"
      tempo { mark "quarter = 88" }
      roster { part :vc, "Cello", music21: "Violoncello", range: "C2-G5" }
      section :opening, "Opening", bars: 1..2, type: :song do
        journey "A single question"
        span bars: 1..2, texture: :dialogue do
          chords "b1:C b2:G7"
          phrase(:line, surface: :absolute) { events "C3:2{slur(} E3:2 | D3:2 G2:2{slur)}" }
          placement :line, part: :vc, role: :lead, at: "bar 1 beat 1"
        end
      end
      control do
        dynamic :mf, at: "bar 1 beat 1", for: :vc
        crescendo from: "bar 1 beat 1", to: "bar 2 beat 1", for: :vc
      end
    end
  RUBY

  def existing(source = SOURCE)
    path = File.join(@root, "explorations", "existing", "score.rb")
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, source)
    path
  end

  def adopt(**options)
    @service.call("piece_adopt", { "piece" => "existing", "brief" => "Keep the connected question.",
                                   **options.transform_keys(&:to_s) })
  end

  def test_preview_round_trip_and_cold_reopen_at_original_path
    path = existing
    before = File.binread(path)
    preview = adopt
    assert preview[:musical_parity]
    assert preview[:preview]
    assert_equal before, File.binread(path)
    saved = adopt(preview: false, source_revision: preview.fetch(:source_revision))
    assert_equal path, @service.store.path("existing")
    refute File.exist?(File.join(@root, "compositions", "existing.rb"))
    reopened = Partitura::Composer::Service.new(root: @root)
    read = reopened.call("music_read", "piece" => "existing", "section" => "opening", "passage" => "passage_1")
    assert_includes read[:text], "C3:2{slur(}"
    piece = Partitura.load_production_file(path)
    assert_equal %w[C3 E3 D3 G2], piece.timed_events.map(&:pitch)
    assert_equal :song, piece.sections.first.type
    result = reopened.call("music_revise", "piece" => "existing", "revision" => saved[:revision],
                           "changes" => [{ "type" => "set_brief", "text" => "Revised brief" }])
    assert result[:revision]
    assert_includes File.read(path), "Revised brief"
  end

  def test_discovery_identifies_existing_scores_without_evaluating_them
    existing('raise "must not run"')
    entry = @service.call("composer_start")[:pieces].find { |item| item[:piece] == "existing" }
    assert entry[:needs_adoption]
    assert_equal "unmanaged_source", entry.dig(:error, :code)
  end

  def test_adoption_preserves_explicit_section_and_single_player_identity
    [true, 2, false].each do |ensemble|
      existing(SOURCE.sub('range: "C2-G5"', "range: \"C2-G5\", ensemble: #{ensemble}"))
      preview = adopt
      assert preview[:musical_parity]
      adopt(preview: false, source_revision: preview.fetch(:source_revision))
      stored, = @service.store.read("existing")
      assert_equal ensemble, stored.data.fetch("parts").first.fetch("ensemble")
      assert_equal ensemble, Partitura.load_production_file(@service.store.path("existing")).parts.fetch(:vc).ensemble
    end
  end

  def test_adoption_requires_current_preview_and_detects_dependency_changes
    path = existing
    preview = adopt
    dependency = File.join(File.dirname(path), "unused.rb")
    File.write(dependency, "# changed dependency\n")
    error = assert_raises(Partitura::Composer::Error) do
      adopt(preview: false, source_revision: preview[:source_revision])
    end
    assert_equal "stale_revision", error.code
    assert_equal SOURCE, File.read(path)
    assert_raises(Partitura::Composer::Error) { adopt(preview: false) }
  end

  def test_symlinked_parent_and_duplicate_identity_are_refused
    path = existing
    File.symlink(File.dirname(path), File.join(@root, "explorations", "linked"))
    error = assert_raises(Partitura::Composer::Error) { @service.store.path("linked") }
    assert_equal "unsafe_path", error.code
    File.write(File.join(@root, "compositions", "existing.rb"), SOURCE)
    error = assert_raises(Partitura::Composer::Error) { adopt }
    assert_equal "ambiguous_piece", error.code
  end

  def test_untargeted_global_controls_adopt_without_a_target
    existing(SOURCE.sub("dynamic :mf", 'swing :sixteenth, at: "bar 2 beat 1"' + "\n    dynamic :mf"))
    preview = adopt
    assert preview[:musical_parity]
    adopt(preview: false, source_revision: preview.fetch(:source_revision))
    stored, = @service.store.read("existing")
    swing = stored.data.fetch("sections").first.fetch("controls").find { |control| control["kind"] == "swing" }
    assert_equal({ "kind" => "swing", "value" => "sixteenth", "at" => "bar 2 beat 1/1" }, swing.except("id"))
  end

  def test_unsupported_control_is_refused_without_touching_source
    source = SOURCE.sub('key "C"', 'key "C"; anchor :start, at: "bar 1 beat 1"')
    path = existing(source)
    error = assert_raises(Partitura::Composer::Error) { adopt }
    assert_equal "unsupported_adoption", error.code
    assert_equal source, File.read(path)
  end

  def test_current_exports_replace_one_pair_and_refuse_old_resource_revisions
    existing
    preview = adopt
    accepted = adopt(preview: false, source_revision: preview[:source_revision])
    first = @service.call("music_export", "piece" => "existing")
    resources = Partitura::Composer::Resources.new(@service.store)
    old_uri = resources.export_links(first).first.fetch(:uri)
    assert_includes resources.read(old_uri)[:text], "<score-partwise"
    @service.call("music_revise", "piece" => "existing", "revision" => accepted[:revision],
                  "changes" => [{ "type" => "set_brief", "text" => "A new accepted revision" }])
    second = @service.call("music_export", "piece" => "existing")
    assert_equal first[:files].map { |file| file[:path] }, (second[:files].map { |file| file[:path] })
    assert_raises(Partitura::Composer::Error) { resources.read(old_uri) }
    new_uri = resources.export_links(second).first.fetch(:uri)
    assert_includes resources.read(new_uri)[:text], "<score-partwise"
    assert_equal 2, Dir.children(File.dirname(second[:files].first[:path])).length
  end
end
