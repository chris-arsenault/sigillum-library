# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tmpdir"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class CompositionGraphTest < Minitest::Test
  def test_graph_exposes_stable_nodes_relations_and_requirement_states
    piece = graph_piece
    before = piece.timed_events.map(&:to_h)
    graph = Partitura.composition_graph(piece)

    assert graph.node("piece:graph_study").stable
    assert_equal 1..2, graph.node("span:opening").bars
    assert_equal "phrase:theme_statement", graph.node("placement:theme_statement_flute").attributes.fetch(:phrase)
    assert_equal before, piece.timed_events.map(&:to_h), "building the graph must not change sounding events"

    requirements = graph.requirements.to_h do |requirement|
      [[requirement.owner.to_s, requirement.facet, requirement.selector], requirement]
    end
    assert_equal :bound, requirements.fetch(["span:opening", :harmony, nil]).state
    assert_equal :bound, requirements.fetch(["span:opening", :role, :foreground]).state
    assert_equal :bound, requirements.fetch(["span:opening", :role, :bass_line]).state
    assert_equal :bound, requirements.fetch(["span:opening", :material, :theme_a]).state
    assert_equal :partial, requirements.fetch(["span:return", :role, :foreground]).state

    authored = graph.relations(kind: :returns_to)
    assert_equal 1, authored.length
    assert authored.first.authored
    assert_equal "span:return", authored.first.from.to_s
    assert_equal "material:theme_a", authored.first.to.to_s
    assert(graph.relations(kind: :contains).all? { |relation| !relation.authored })
    assert(graph.relations(kind: :realizes).any? { |relation|
      relation.from.to_s == "phrase:theme_statement" && relation.to.to_s == "material:theme_a"
    })
  end

  def test_stable_paths_survive_bar_and_name_edits
    first = Partitura.composition_graph(graph_piece(bridge_bars: 1..4, section_name: "First name"))
    second = Partitura.composition_graph(graph_piece(bridge_bars: 3..6, section_name: "Changed name"))

    %w[piece:graph_study section:whole span:opening material:theme_a
       phrase:theme_statement placement:theme_statement_flute].each do |path|
      assert first.node(path)
      assert second.node(path)
    end
    refute_equal first.graph_digest, second.graph_digest
  end

  def test_graph_and_snapshot_digests_are_deterministic_and_score_sensitive
    first_piece = graph_piece(statement_pitch: "C5 D5 | E5 F5")
    second_piece = graph_piece(statement_pitch: "C5 D5 | E5 G5")

    first_graph = Partitura.composition_graph(first_piece)
    repeated_graph = Partitura.composition_graph(graph_piece(statement_pitch: "C5 D5 | E5 F5"))
    changed_graph = Partitura.composition_graph(second_piece)
    first_snapshot = Partitura.composition_snapshot(first_piece)
    repeated_snapshot = Partitura.composition_snapshot(graph_piece(statement_pitch: "C5 D5 | E5 F5"))
    changed_snapshot = Partitura.composition_snapshot(second_piece)

    assert_equal first_graph.to_h, repeated_graph.to_h
    assert_equal first_graph.graph_digest, repeated_graph.graph_digest
    assert_equal first_graph.graph_digest, changed_graph.graph_digest,
                 "note events are intentionally outside the semantic graph digest"
    assert_equal first_snapshot.fetch("snapshot_digest"), repeated_snapshot.fetch("snapshot_digest")
    refute_equal first_snapshot.fetch("snapshot_digest"), changed_snapshot.fetch("snapshot_digest")
    statement_event = first_snapshot.dig("score", "timed_events").find do |event|
      event.fetch("phrase_path") == "phrase:theme_statement"
    end
    assert_equal "placement:theme_statement_flute", statement_event.fetch("placement_path")
    assert_equal "2/1", statement_event.fetch("duration_ql")
  end

  def test_legacy_source_builds_with_unstable_generated_locations
    piece = Partitura::Production.piece("Legacy") do
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4" }
          placement :line, part: :fl, role: :foreground, at: "bar 1 beat 1"
        end
      end
    end

    graph = Partitura.composition_graph(piece)

    refute graph.node("piece:legacy_piece").stable
    refute graph.nodes.find { |node| node.type == :span }.stable
    refute graph.nodes.find { |node| node.type == :placement }.stable
    assert_empty graph.requirements
    assert_equal "ok", piece.compile_response.fetch(:status)
  end

  def test_snapshot_preserves_placement_provenance_after_anacrusis_clipping
    piece = Partitura::Production.piece("Pickup provenance", id: :pickup_provenance) do
      meter "4/4"
      roster { part :flute, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..2 do
        span :held_span, bars: 1..1 do
          phrase(:held, surface: :absolute) { events "C5:4" }
          placement :held, id: :held_flute, part: :flute,
                    role: :background, at: "bar 1 beat 1"
        end
        span :pickup_span, bars: 2..2 do
          phrase :pickup, surface: :absolute do
            anacrusis 1
            events "G4:1 | C5:4"
          end
          placement :pickup, id: :pickup_flute, part: :flute,
                    role: :foreground, at: "bar 2 beat 1"
        end
      end
    end

    held = Partitura.composition_snapshot(piece).dig("score", "timed_events").find do |event|
      event.fetch("phrase_path") == "phrase:held"
    end
    assert_equal "3/1", held.fetch("duration_ql")
    assert_equal "placement:held_flute", held.fetch("placement_path")
  end

  def test_graph_enabled_source_requires_piece_span_and_placement_ids
    piece = Partitura::Production.piece("Missing ids", id: :missing_ids) do
      roster { part :fl, "Flute", music21: "Flute" }
      section :s1, "One", bars: 1..1 do
        span bars: 1..1 do
          phrase(:line, surface: :absolute) { events "C5:4" }
          placement :line, part: :fl, role: :foreground, at: "bar 1 beat 1"
        end
      end
    end

    error = assert_raises(Partitura::Production::CompileError) { Partitura.composition_graph(piece) }
    assert_equal "composition_graph_invalid", error.response.fetch(:code)
    codes = error.response.fetch(:errors).map { |issue| issue.fetch(:code) }
    assert_includes codes, "missing_span_id"
    assert_includes codes, "missing_placement_id"
    assert_equal "ok", piece.compile_response.fetch(:status),
                 "graph validation must not silently become production compile validation"
  end

  def test_duplicate_ids_bad_references_and_dependency_cycles_are_structured_errors
    piece = Partitura::Production.piece("Invalid graph", id: :invalid) do
      section :s1, "One", bars: 1..2 do
        span :same, bars: 1..1
        span :same, bars: 2..2
      end
      relation :depends_on, from: ref(:span, :same), to: ref(:span, :missing)
    end

    error = assert_raises(Partitura::Production::CompileError) { Partitura.composition_graph(piece) }
    codes = error.response.fetch(:errors).map { |issue| issue.fetch(:code) }
    assert_includes codes, "duplicate_span_id"
    assert_includes codes, "unknown_relation_target"
    diagnostics = error.response.fetch(:diagnostics)
    assert_includes diagnostics.map { |item| item.fetch(:code) }, "duplicate_span_id"
    assert_includes diagnostics.map { |item| item.fetch(:code) }, "unknown_relation_target"
    assert(diagnostics.all? { |item| item.fetch(:object_path).include?(":") })

    cyclic = Partitura::Production.piece("Cycle", id: :cycle) do
      section :s1, "One", bars: 1..2 do
        span :a, bars: 1..1
        span :b, bars: 2..2
      end
      relation :depends_on, from: ref(:span, :a), to: ref(:span, :b)
      relation :depends_on, from: ref(:span, :b), to: ref(:span, :a)
    end
    cycle_error = assert_raises(Partitura::Production::CompileError) do
      Partitura.composition_graph(cyclic)
    end
    cycle_issue = cycle_error.response.fetch(:errors).find { |issue| issue.fetch(:code) == "depends_on_cycle" }
    assert_includes cycle_issue.fetch(:message), "span:a -> span:b -> span:a"
  end

  def test_readouts_and_cli_json_expose_the_public_contract
    piece = graph_piece
    graph_text = Partitura.production_readout(piece, :composition_graph)
    resolution = Partitura.production_readout(piece, :composition_resolution)
    parsed = JSON.parse(Partitura.production_readout(piece, :composition_snapshot, json: true))

    assert_includes graph_text, "span:opening"
    assert_includes graph_text, "returns_to"
    assert_includes resolution, "open=0 partial=1"
    assert_equal 1, parsed.fetch("schema_version")
    assert_equal "piece:graph_study", parsed.dig("graph", "piece")

    Dir.mktmpdir do |dir|
      source = File.join(dir, "graph.rb")
      File.write(source, graph_source)
      stdout, stderr, status = Open3.capture3(
        "ruby", File.expand_path("../bin/partitura", __dir__),
        "view", source, "composition_graph", "--json"
      )

      assert status.success?, stderr
      cli = JSON.parse(stdout)
      assert_equal "piece:cli_graph", cli.fetch("piece")
      assert_match(/\Asha256:[0-9a-f]{64}\z/, cli.fetch("graph_digest"))
    end
  end

  private

  def graph_piece(bridge_bars: 1..4, section_name: "Whole", statement_pitch: "C5 D5 | E5 F5")
    Partitura::Production.piece("Graph study", id: :graph_study) do
      meter "4/4"
      key "C"
      material(:theme_a) do
        identity pitch: "rising second", rhythm: "two half notes"
      end
      roster do
        part :flute, "Flute", music21: "Flute"
        part :cello, "Cello", music21: "Violoncello"
      end
      section :whole, section_name, bars: bridge_bars do
        span :opening, bars: bridge_bars.begin..(bridge_bars.begin + 1), texture: :melody_over_bass do
          plan do
            requires :harmony, coverage: :all_bars
            requires :material, :theme_a, relation: :statement
            requires :role, :foreground, coverage: :all_bars
            requires :role, :bass_line, coverage: :all_bars
          end
          chords "b#{bridge_bars.begin}:C b#{bridge_bars.begin + 1}:G7"
          phrase :theme_statement, surface: :absolute, material: :theme_a, relation: :statement do
            pitch_bars statement_pitch
            rhythm_bars "2 2 | 2 2"
          end
          placement :theme_statement, id: :theme_statement_flute, part: :flute,
                    role: :foreground, at: "bar #{bridge_bars.begin} beat 1"
          phrase :opening_bass, surface: :absolute do
            pitch_bars "C3 G2 | C3 G2"
            rhythm_bars "2 2 | 2 2"
          end
          placement :opening_bass, id: :opening_bass_cello, part: :cello,
                    role: :bass_line, at: "bar #{bridge_bars.begin} beat 1"
        end
        span :return, bars: (bridge_bars.begin + 2)..(bridge_bars.begin + 3), texture: :return do
          plan do
            requires :material, :theme_a, relation: :return
            requires :role, :foreground, coverage: :all_bars
          end
          phrase :theme_return, surface: :absolute, material: :theme_a, relation: :return do
            pitch_bars "G5 F5"
            rhythm_bars "2 2"
          end
          placement :theme_return, id: :theme_return_flute, part: :flute,
                    role: :foreground, at: "bar #{bridge_bars.begin + 2} beat 1"
        end
      end
      relation :returns_to, from: ref(:span, :return), to: ref(:material, :theme_a)
    end
  end

  def graph_source
    <<~RUBY
      production_piece "CLI graph", id: :cli_graph do
        material(:cell) { identity pitch: "minor third", rhythm: "whole note" }
        roster { part :fl, "Flute", music21: "Flute" }
        section :s1, "One", bars: 1..1 do
          span :only, bars: 1..1 do
            plan { requires :material, :cell, relation: :statement }
            phrase :line, surface: :absolute, material: :cell, relation: :statement do
              events "C5:4"
            end
            placement :line, id: :line_flute, part: :fl, role: :foreground, at: "bar 1 beat 1"
          end
        end
      end
    RUBY
  end
end
