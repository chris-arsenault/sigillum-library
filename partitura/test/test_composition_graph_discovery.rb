# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class CompositionGraphDiscoveryTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CLI = File.join(ROOT, "partitura/bin/partitura")
  WORKFLOW_FIXTURE = File.join(ROOT, "partitura/test/fixtures/composition_workflow_study.rb")

  def test_show_and_connections_use_stable_graph_paths
    graph = Partitura.composition_graph(discovery_piece)
    shown = graph.show("span:opening")
    connections = graph.connections("span:opening")

    assert_equal "span:opening", shown.object.path.to_s
    assert_equal [:material], shown.requirements.map(&:facet)
    assert_includes connections.map { |row| [row.kind, row.direction, row.neighbor.to_s] },
                    [:contains, :incoming, "section:whole"]
    assert_includes connections.map { |row| [row.kind, row.direction, row.neighbor.to_s] },
                    [:contains, :outgoing, "phrase:theme_statement"]
  end

  def test_shortest_path_traverses_both_directions_and_retains_canonical_relations
    graph = Partitura.composition_graph(discovery_piece)
    result = graph.shortest_path("material:theme_a", "placement:theme_statement_flute")

    assert result.found
    assert_equal 2, result.steps.length
    assert_equal :incoming, result.steps.first.direction
    assert_equal "phrase:theme_statement", result.steps.first.from.to_s
    assert_equal "material:theme_a", result.steps.first.to.to_s
    assert_equal result.to_h,
                 graph.shortest_path("material:theme_a", "placement:theme_statement_flute").to_h

    bounded = graph.shortest_path(
      "material:theme_a", "placement:theme_statement_flute", max_hops: 1
    )
    refute bounded.found
    assert_nil bounded.steps
  end

  def test_queries_reject_unknown_paths_and_unbounded_hop_limits
    graph = Partitura.composition_graph(discovery_piece)

    error = assert_raises(ArgumentError) { graph.show("span:missing") }
    assert_includes error.message, "unknown graph path"
    assert_raises(ArgumentError) { graph.shortest_path("span:opening", "span:return", max_hops: 21) }
  end

  def test_cli_queries_emit_versioned_native_json
    Dir.mktmpdir do |directory|
      source = File.join(directory, "piece.rb")
      File.write(source, discovery_source)

      show = run_json("show", source, "span:opening")
      connections = run_json("connections", source, "span:opening")
      path = run_json(
        "path", source, "material:theme_a", "placement:theme_statement_flute"
      )

      assert_equal 1, show.fetch("schema_version")
      assert_equal "span:opening", show.dig("object", "path")
      assert_equal 3, connections.fetch("count")
      assert path.fetch("found")
      assert_equal 2, path.fetch("steps").length
    end
  end

  def test_cli_unknown_path_uses_structured_diagnostic
    Dir.mktmpdir do |directory|
      source = File.join(directory, "piece.rb")
      File.write(source, discovery_source)
      stdout, stderr, status = Open3.capture3(
        "ruby", CLI, "show", source, "span:missing", "--json", chdir: ROOT
      )
      payload = JSON.parse(stderr)

      refute status.success?
      assert_empty stdout
      assert_equal "composition_graph_query_error", payload.fetch("code")
      assert_equal "composition_graph", payload.fetch("help_topic")
      assert_equal "composition_graph_query_error", payload.dig("diagnostics", 0, "code")
    end
  end

  def test_cli_missing_and_invalid_ruby_sources_keep_distinct_codes_and_source_identity
    Dir.mktmpdir do |directory|
      missing = File.join(directory, "missing.rb")
      invalid = File.join(directory, "invalid.rb")
      File.write(invalid, "production_piece(")

      [
        [missing, "unreadable_source"],
        [invalid, "invalid_ruby_source"],
      ].each do |source, code|
        stdout, stderr, status = Open3.capture3(
          "ruby", CLI, "show", source, "piece:missing", chdir: ROOT
        )
        payload = JSON.parse(stderr)

        refute status.success?
        assert_empty stdout
        assert_equal code, payload.fetch("code")
        assert_equal source, payload.fetch("source_file")
        assert_equal source, payload.dig("diagnostics", 0, "source_file")
      end
    end
  end

  def test_cli_definition_failure_uses_structured_diagnostic
    Dir.mktmpdir do |directory|
      source = File.join(directory, "broken.rb")
      File.write(source, <<~RUBY)
        production_piece "Broken", id: :broken do
          no_such_dsl_call :value
        end
      RUBY
      stdout, stderr, status = Open3.capture3(
        "ruby", CLI, "show", source, "piece:broken", "--json", chdir: ROOT
      )
      payload = JSON.parse(stderr)

      refute status.success?
      assert_empty stdout
      assert_equal "invalid_production_source", payload.fetch("code")
      assert_equal source, payload.fetch("source_file")
      assert_equal "NoMethodError", payload.dig("diagnostics", 0, "details", "error_class")
    end
  end

  def test_cli_missing_source_dependency_uses_structured_diagnostic
    Dir.mktmpdir do |directory|
      source = File.join(directory, "missing_dependency.rb")
      File.write(source, <<~RUBY)
        require "partitura_missing_dependency_for_discovery_test"
        production_piece "Broken", id: :broken
      RUBY
      stdout, stderr, status = Open3.capture3(
        "ruby", CLI, "show", source, "piece:broken", "--json", chdir: ROOT
      )
      payload = JSON.parse(stderr)

      refute status.success?
      assert_empty stdout
      assert_equal "invalid_production_source", payload.fetch("code")
      assert_equal "LoadError", payload.dig("diagnostics", 0, "details", "error_class")
    end
  end

  def test_documented_fixture_supports_bounded_graph_discovery_commands
    show = run_json("show", WORKFLOW_FIXTURE, "span:statement")
    connections = run_json("connections", WORKFLOW_FIXTURE, "span:return")
    path = run_json(
      "path", WORKFLOW_FIXTURE, "material:theme_a", "placement:theme_statement_flute",
      "--max-hops", "2"
    )

    assert_equal "span:statement", show.dig("object", "path")
    assert_equal "span:return", connections.fetch("object_path")
    assert_operator connections.fetch("count"), :>, 0
    assert path.fetch("found")
    assert_operator path.fetch("steps").length, :<=, 2
  end

  private

  def run_json(*arguments)
    stdout, stderr, status = Open3.capture3("ruby", CLI, *arguments, "--json", chdir: ROOT)
    assert status.success?, stderr
    JSON.parse(stdout)
  end

  def discovery_piece
    Partitura::Production.piece("Discovery", id: :discovery) do
      material(:theme_a) { identity pitch: "minor third", rhythm: "whole note" }
      roster { part :flute, "Flute", music21: "Flute" }
      section :whole, "Whole", bars: 1..2 do
        span :opening, bars: 1..1 do
          plan { requires :material, :theme_a, relation: :statement }
          phrase :theme_statement, surface: :absolute,
                  material: :theme_a, relation: :statement do
            events "C5:4"
          end
          placement :theme_statement, id: :theme_statement_flute,
                    part: :flute, role: :foreground, at: "bar 1 beat 1"
        end
        span :return, bars: 2..2
      end
      relation :returns_to, from: ref(:span, :return), to: ref(:material, :theme_a)
    end
  end

  def discovery_source
    <<~RUBY
      production_piece "Discovery", id: :discovery do
        material(:theme_a) { identity pitch: "minor third", rhythm: "whole note" }
        roster { part :flute, "Flute", music21: "Flute" }
        section :whole, "Whole", bars: 1..1 do
          span :opening, bars: 1..1 do
            plan { requires :material, :theme_a, relation: :statement }
            phrase :theme_statement, surface: :absolute,
                    material: :theme_a, relation: :statement do
              events "C5:4"
            end
            placement :theme_statement, id: :theme_statement_flute,
                      part: :flute, role: :foreground, at: "bar 1 beat 1"
          end
        end
      end
    RUBY
  end
end
