# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"

class MusicXMLImportCLITest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CLI = File.join(ROOT, "partitura", "bin", "partitura")
  FIXTURE = File.join(
    ROOT,
    "tests/fixtures/export_parity/explorations/basin_aria/basin_aria.musicxml"
  )

  def test_import_command_emits_rendered_and_structured_conversion
    text_out, text_err, text_status = run_import
    json_out, json_err, json_status = run_import("--json")
    payload = JSON.parse(json_out)

    assert text_status.success?, text_err
    assert json_status.success?, json_err
    assert_includes text_out, "# Converted from:"
    assert_includes text_out, "-- opening (bars 1-2):"
    assert_equal "ok", payload.fetch("status")
    assert_equal({ "first" => 1, "last" => 2 }, payload.fetch("bars"))
    assert_equal "opening", payload.fetch("segments").first.fetch("name")
    assert_equal({ "first" => 1, "last" => 2 }, payload.fetch("segments").first.fetch("bars"))
    refute_empty payload.fetch("parts")
  end

  def test_verify_command_uses_exit_status_as_zero_difference_gate
    same_out, same_err, same_status = Open3.capture3(
      "ruby", CLI, "verify-musicxml-import", FIXTURE, FIXTURE,
      "--bars", "1-2", "--beats", "4", "--json", chdir: ROOT
    )
    same = JSON.parse(same_out)

    assert same_status.success?, same_err
    assert_equal "ok", same.fetch("status")
    assert_equal 0, same.fetch("total_differing_bars")

    Dir.mktmpdir do |directory|
      changed = File.join(directory, "changed.musicxml")
      File.write(changed, changed_first_pitch(File.read(FIXTURE)))
      mismatch_out, mismatch_err, mismatch_status = Open3.capture3(
        "ruby", CLI, "verify-musicxml-import", FIXTURE, changed,
        "--bars", "1-2", "--beats", "4", "--json", chdir: ROOT
      )
      mismatch = JSON.parse(mismatch_out)

      refute mismatch_status.success?, mismatch_err
      assert_equal 1, mismatch_status.exitstatus
      assert_equal "mismatch", mismatch.fetch("status")
      assert_operator mismatch.fetch("total_differing_bars"), :>, 0
    end
  end

  def test_invalid_range_returns_focused_structured_error
    _stdout, stderr, status = Open3.capture3(
      "ruby", CLI, "import-musicxml", FIXTURE, "--bars", "2-1", chdir: ROOT
    )
    error = JSON.parse(stderr)

    refute status.success?
    assert_equal "musicxml_import_error", error.fetch("code")
    assert_equal "hand_edit_import", error.fetch("help_topic")
  end

  private

  def run_import(*extra)
    Open3.capture3(
      "ruby", CLI, "import-musicxml", FIXTURE,
      "--bars", "1-2", "--segments", "opening:1-2", "--beats", "4",
      *extra, chdir: ROOT
    )
  end

  def changed_first_pitch(xml)
    xml.sub(%r{<step>([A-G])</step>}) do
      replacement = Regexp.last_match(1) == "C" ? "D" : "C"
      "<step>#{replacement}</step>"
    end
  end
end
