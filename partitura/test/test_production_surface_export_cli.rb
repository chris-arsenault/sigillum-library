# frozen_string_literal: true

require_relative "support/production_surface_helpers"

class ProductionSurfaceExportCliTest < Minitest::Test
  include ProductionSurfaceHelpers

  BAD_EXPORT_SOURCE = <<~RUBY
    production_piece "Bad" do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:call, surface: :absolute) { events "C5:1" }
          phrase(:call, surface: :absolute) { events "D5:1" }
        end
      end
    end
  RUBY

  RUBY_EXPORT_SOURCE = <<~RUBY
    production_piece "Ruby Backend Export" do
      meter "4/4"; key "C"
      roster { part :flute, "Flute", music21: "Flute", family: :woodwind }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4{mf}" }
          placement :line, part: :flute, at: "bar 1 beat 1", role: :foreground
        end
      end
    end
  RUBY

  BAD_PITCH_SOURCE = <<~RUBY
    production_piece "Bad Pitch" do
      roster { part :clarinet, "Clarinet", music21: "Clarinet" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:call, surface: :absolute) { events "H4:1" }
        end
      end
    end
  RUBY

  def test_export_refuses_compiler_error_payloads
    repo_root = File.expand_path("../..", __dir__)
    Dir.mktmpdir("production_export_error_", repo_root) do |dir|
      source_dir = File.join(dir, "dsl")
      FileUtils.mkdir_p(source_dir)
      source = File.join(source_dir, "bad_source.rb")
      out_dir = File.join(dir, "out")
      File.write(source, BAD_EXPORT_SOURCE)

      _stdout, stderr, status = Open3.capture3(
        "ruby",
        File.expand_path("../bin/production_export", __dir__),
        source,
        out_dir,
        "--transport-only"
      )

      refute status.success?
      assert_includes stderr, "duplicate_phrase_id"
      refute File.exist?(File.join(out_dir, "bad_source.partitura_transport.json"))
    end
  end

  def test_production_export_writes_musicxml_and_midi
    repo_root = File.expand_path("../..", __dir__)
    Dir.mktmpdir("production_export_ruby_", repo_root) do |dir|
      source_dir = File.join(dir, "dsl")
      FileUtils.mkdir_p(source_dir)
      source = File.join(source_dir, "ruby_source.rb")
      File.write(source, RUBY_EXPORT_SOURCE)

      stdout, stderr, status = Open3.capture3(
        "ruby",
        File.expand_path("../bin/production_export", __dir__),
        source
      )

      assert status.success?, stderr
      result = JSON.parse(stdout)
      assert File.exist?(result.fetch("transport"))
      assert File.exist?(result.fetch("musicxml"))
      assert File.exist?(result.fetch("midi"))
      assert_includes File.read(result.fetch("musicxml")), "<work-title>Ruby Backend Export</work-title>"
      assert_equal "MThd", File.binread(result.fetch("midi"), 4)
    ensure
      FileUtils.rm_rf(File.join(repo_root, "outputs", File.basename(dir))) if dir
    end
  end

  def test_production_view_compile_returns_structured_errors_from_load_failures
    Dir.mktmpdir do |dir|
      source = File.join(dir, "bad_pitch.rb")
      File.write(source, BAD_PITCH_SOURCE)

      stdout, stderr, status = Open3.capture3(
        "ruby",
        File.expand_path("../bin/production_view", __dir__),
        source,
        "compile"
      )

      assert status.success?
      assert_empty stderr
      response = JSON.parse(stdout)
      assert_equal "error", response.fetch("status")
      assert_equal "bad_pitch", response.fetch("code")
      assert_equal "absolute", response.fetch("help_topic")
    end
  end

end
