# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"

ROOT = File.expand_path("../../..", __dir__)
CARD_ROOT = File.join(ROOT, "technique_library", "dsl", "cards")
MANIFEST = File.join(CARD_ROOT, "manifest.json")

class TechniqueLibraryDSLTest < Minitest::Test
  def test_manifest_covers_dsl_card_set
    manifest = JSON.parse(File.read(MANIFEST))
    manifest_names = manifest.map { |entry| entry.fetch("name") }

    assert_equal Dir.glob(File.join(CARD_ROOT, "**", "*.rb")).length, manifest.length
    assert_equal manifest_names.uniq.length, manifest_names.length
    assert_equal(32, manifest.count { |entry| entry.fetch("category") == "figures.16th" })
    expected_categories = %w[
      piano voicing chamberstrings orchestral dialogue figuration figures.16th
      elegy callresponse forms melody
    ]
    categories = manifest.map { |entry| entry.fetch("category") }.uniq
    assert_empty expected_categories - categories
    manifest.each do |entry|
      path = File.join(ROOT, entry.fetch("path"))
      assert File.exist?(path), entry.fetch("path")
      assert_includes File.read(path), "production_piece", entry.fetch("path")
    end
  end

  def test_card_sources_use_mixed_dsl_surfaces
    manifest = JSON.parse(File.read(MANIFEST))
    surfaces = manifest.flat_map { |entry| entry.fetch("parts").map { |part| part.fetch("surface") } }.uniq

    assert_includes surfaces, "degrees"
    assert_includes surfaces, "intervals"
    assert_includes surfaces, "split_pitch_rhythm"
  end

  def test_all_dsl_card_sources_compile
    files = Dir.glob(File.join(CARD_ROOT, "**", "*.rb"))
    manifest = JSON.parse(File.read(MANIFEST))
    assert_equal manifest.length, files.length

    failures = []
    files.each do |path|
      stdout, stderr, status = Open3.capture3(
        File.join(ROOT, "partitura/bin/production_view"),
        path,
        "compile",
        chdir: ROOT
      )
      payload = JSON.parse(stdout)
      failures << [path, payload["message"], stdout, stderr] unless status.success? && payload["status"] == "ok"
    rescue JSON::ParserError
      failures << [path, "non-json response", stdout, stderr]
    end

    assert_equal [], failures
  end

  def test_ruby_library_cli_reads_dsl_manifest
    stdout, stderr, status = Open3.capture3(
      "ruby",
      "tools/lib.rb",
      "show",
      "dsl:figures.16th/F01",
      chdir: ROOT
    )

    assert status.success?, stderr
    assert_includes stdout, "DSL REF: dsl:figures.16th/F01"
    assert_includes stdout, "surface=intervals"

    terms_stdout, terms_stderr, terms_status = Open3.capture3(
      "ruby",
      "tools/lib.rb",
      "terms",
      chdir: ROOT
    )

    assert terms_status.success?, terms_stderr
    assert_includes terms_stdout, "figures.16th"
  end
end
