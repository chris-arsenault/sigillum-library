# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "timeout"
require_relative "composer_fixture"

class ComposerMCPTest < Minitest::Test
  include ComposerFixture

  def setup
    super
    executable = File.expand_path("../bin/partitura", __dir__)
    @stdin, @stdout, @stderr, @process = Open3.popen3(RbConfig.ruby, executable, "mcp", "--root", @root)
    @error_reader = Thread.new { @stderr.read }
    @id = 0
    result = rpc("initialize", "protocolVersion" => "2025-11-25", "capabilities" => {},
                               "clientInfo" => { "name" => "integration-test", "version" => "1" })
    assert_equal "2025-11-25", result.fetch("result").fetch("protocolVersion")
    @stdin.puts(JSON.generate("jsonrpc" => "2.0", "method" => "notifications/initialized"))
    @stdin.flush
  end

  def teardown
    @stdin.close unless @stdin.closed?
    Timeout.timeout(5) { @process.value }
    @stdout.close
    @error_reader.join
    @stderr.close
    super
  rescue Timeout::Error
    Process.kill("TERM", @process.pid)
    @process.value
    super
  end

  def rpc(method, params = {})
    @id += 1
    @stdin.puts(JSON.generate("jsonrpc" => "2.0", "id" => @id, "method" => method, "params" => params))
    @stdin.flush
    receive
  end

  def receive
    line = Timeout.timeout(10) { @stdout.gets }
    raise "Composer exited: #{@error_reader.value}" unless line

    JSON.parse(line)
  end

  def tool(name, arguments = {})
    rpc("tools/call", "name" => name, "arguments" => arguments).fetch("result")
  end

  def test_complete_composition_path_uses_only_musical_tools
    tools = rpc("tools/list").fetch("result").fetch("tools")
    assert_includes tools.map { |item| item.fetch("name") }, "music_revise"
    orientation = tool("composer_start")
    assert_includes orientation.fetch("content").first.fetch("text"), "Your job is to compose"

    started = tool("piece_start", "id" => "duet", "title" => "Duet", "brief" => "An open question.",
                                 "parts" => [{ "id" => "cl", "name" => "Clarinet", "instrument" => "Clarinet" }])
    revision = started.fetch("structuredContent").fetch("revision")
    revised = tool("music_revise", "piece" => "duet", "revision" => revision, "changes" => [
      section,
      { "type" => "write_passage", "section" => "opening", "passage" => {
        "id" => "call", "at" => 1, "bars" => 2,
        "voices" => [{ "id" => "lead", "part" => "cl", "events" => "C5:2 E5:2 | D5:4" }]
      } },
      { "type" => "remember", "decision" => { "id" => "head", "text" => "Preserve the rising third." } }
    ])
    refute revised.fetch("isError")
    read = tool("music_read", "piece" => "duet", "section" => "opening", "passage" => "call")
    assert_includes read.fetch("content").first.fetch("text"), "C5:2 E5:2 | D5:4"
    assert_includes read.fetch("content").first.fetch("text"), "Preserve the rising third."
    inspected = tool("music_inspect", "piece" => "duet", "view" => "verticals")
    refute inspected.fetch("isError")

    assert_export_resources("duet")
  end

  def assert_export_resources(piece_id)
    exported = tool("music_export", "piece" => piece_id)
    links = exported.fetch("content").select { |content| content.fetch("type") == "resource_link" }
    assert_equal 2, links.length
    xml = rpc("resources/read", "uri" => links[0].fetch("uri")).fetch("result").fetch("contents").first
    assert_includes xml.fetch("text"), "<score-partwise"
    midi = rpc("resources/read", "uri" => links[1].fetch("uri")).fetch("result").fetch("contents").first
    assert_equal "MThd", midi.fetch("blob").unpack1("m0")[0, 4]
  end

  def test_domain_errors_and_schema_errors_are_readable_tool_results
    error = tool("music_read", "piece" => "missing")
    assert error.fetch("isError")
    assert_equal "unknown_piece", error.fetch("structuredContent").fetch("code")
    invalid = tool("piece_start", "id" => "../escape", "title" => "Bad", "brief" => "Bad")
    assert invalid.fetch("isError")
    assert_equal "invalid_input", invalid.fetch("structuredContent").fetch("code")
    extra = tool("composer_start", "unexpected" => true)
    assert extra.fetch("isError")
  end

  def test_existing_exploration_is_previewed_adopted_and_read_through_mcp
    path = File.join(@root, "explorations", "legacy", "score.rb")
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, <<~RUBY)
      production_piece "Legacy" do
        meter "4/4"
        key "C"
        tempo { mark "quarter = 80" }
        roster { part :cl, "Clarinet", music21: "Clarinet" }
        section :opening, "Opening", bars: 1..1 do
          span bars: 1..1 do
            phrase(:call, surface: :absolute) { events "C5:2 E5:2" }
            placement :call, part: :cl, role: :lead, at: "bar 1 beat 1"
          end
        end
      end
    RUBY
    preview = tool("piece_adopt", "piece" => "legacy", "brief" => "Keep the rising third.")
    refute preview.fetch("isError")
    revision = preview.fetch("structuredContent").fetch("source_revision")
    result = tool("piece_adopt", "piece" => "legacy", "brief" => "Keep the rising third.",
                                "preview" => false, "source_revision" => revision)
    refute result.fetch("isError")
    read = tool("music_read", "piece" => "legacy", "section" => "opening", "passage" => "passage_1")
    assert_includes read.fetch("content").first.fetch("text"), "C5:2 E5:2"
    assert_export_resources("legacy")
    assert_equal %w[legacy.mid legacy.musicxml],
                 Dir.children(File.join(@root, "outputs", "explorations", "legacy", "legacy")).sort
  end

  def test_partial_reads_and_stale_revisions
    write(section, passage)
    result = tool("music_read", "piece" => "study", "section" => "opening", "limit" => 80)
    continuation = result.fetch("structuredContent").fetch("continuation")
    assert_includes result.fetch("content").first.fetch("text"), "Partial read"
    write("type" => "set_brief", "text" => "The music changed.")
    stale = tool("music_read", continuation)
    assert stale.fetch("isError")
    assert_equal "stale_revision", stale.fetch("structuredContent").fetch("code")
  end

  def test_reference_bodies_and_focused_help_are_available_without_filesystem_tools
    help = tool("composer_help", "topic" => "notation")
    assert_includes help.fetch("content").first.fetch("text"), "Durations are quarter-note units"
    reference = tool("composer_reference", "reference" => "craft/composition_feedback", "limit" => 1000)
    assert_includes reference.fetch("content").first.fetch("text"), "Composition feedback"
    assert reference.fetch("structuredContent").fetch("continuation")
    card = tool("composer_reference", "reference" => "card/piano/K1_NOCTURNE_34", "limit" => 2000)
    refute card.fetch("isError")
    assert_includes card.fetch("content").first.fetch("text"), "# Line"
    listing = rpc("resources/list").fetch("result").fetch("resources")
    guide = rpc("resources/read", "uri" => listing.first.fetch("uri"))
    assert_includes guide.fetch("result").fetch("contents").first.fetch("text"), "Composing with Partitura"
  end

  def test_malformed_json_does_not_poison_the_connection
    @stdin.puts("{")
    @stdin.flush
    assert_equal(-32700, receive.fetch("error").fetch("code"))
    assert_equal({}, rpc("ping").fetch("result"))
    assert_equal(-32601, rpc("not/a/method").fetch("error").fetch("code"))
  end
end
