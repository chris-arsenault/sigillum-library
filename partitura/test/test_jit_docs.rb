# frozen_string_literal: true

require "json"
require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class JITDocsTest < Minitest::Test
  REPOSITORY_ROOT = File.expand_path("../..", __dir__)
  REQUIRED_FIELDS = %i[use_when rules example next_topics docs].freeze

  def test_index_response_has_required_contract_fields
    data = Partitura.help_data(:index)

    assert_equal 1, data[:schema_version]
    assert_equal :index, data[:topic]
    assert_includes data.keys, :use_when
    assert_includes data.keys, :rules
    assert_includes data.keys, :example
    assert_includes data.keys, :next_topics
    assert_includes data.keys, :docs
  end

  def test_decision_response_names_hybrid_default_and_surface_choices
    text = Partitura.help(:decision)

    assert_includes text, "Default long-line surface is degrees plus rhythm"
    assert_includes text, "Use hybrid for most orchestral passages"
    assert_includes text, "degrees"
    assert_includes text, "absolute"
    assert_includes text, "staff_grid"
  end

  def test_production_response_names_executable_surface
    data = Partitura.help_data(:production)

    assert_equal :production, data[:topic]
    assert_includes data[:rules], "Use `production_piece` in source files loaded by `load_production_file`."
    assert_includes data[:rules], "Use `partitura/bin/partitura export` for MusicXML and MIDI."
    assert(data[:rules].any? { |rule| rule.include?("do not use helpers, loops, repeaters") })
    assert_includes data[:example], "production_piece"
    assert_includes data[:example], "meter do"
    assert_includes data[:example], "change \"4/4\", at: \"bar 9\""
    assert_includes data[:example], "music21: \"Clarinet\""
    assert_includes data[:example], "placement :call"
    assert_includes data[:docs], "docs/architecture/partitura/00_llm_contract.md"
  end

  def test_index_keeps_expanded_markdown_catalogue_optional
    data = Partitura.help_data(:index)

    assert_empty data[:docs]
    assert_includes data[:next_topics], :documentation_index
    assert_equal ["docs/architecture/partitura/INDEX.md"],
                 Partitura.help_data(:documentation_index)[:docs]
  end

  def test_capability_topics_cover_roster_cards_and_build
    roster = Partitura.help_data(:roster)
    cards = Partitura.help_data(:cards)
    build = Partitura.help_data(:build)

    assert_includes roster[:rules].join(" "), "notation_group"
    assert_includes roster[:rules].join(" "), "music21:"
    assert_includes cards[:example], "cards terms"
    assert_includes cards[:docs], "technique_library/dsl/README.md"
    assert_includes build[:example], "partitura/bin/partitura build"
    assert_includes build[:docs], "docs/architecture/partitura/06_ruby_framework.md"
  end

  def test_hybrid_response_is_llm_actionable
    data = Partitura.help_data(:hybrid)

    assert_equal :hybrid, data[:topic]
    assert_includes data[:rules], "Phrase layer carries long thought."
    assert_includes data[:example], "placement :foreground"
    assert_includes data[:docs], "docs/architecture/partitura/surfaces/hybrid.md"
  end

  def test_composition_graph_response_locks_plan_and_realization_boundary
    data = Partitura.help_data(:composition_graph)

    assert_equal :composition_graph, data[:topic]
    assert_includes data[:rules],
                    "The production Ruby source remains authoritative; the Composition Graph is a derived projection."
    assert_includes data[:rules], "A bound requirement proves authored coverage only, never musical quality."
    assert_includes data[:example], "plan do"
    assert_includes data[:example], "material: :theme_a"
    assert_includes data[:docs], "docs/architecture/partitura/09_composition_graph.md"
    assert_equal :composition_graph, Partitura.help_data(:score_tree)[:topic]
  end

  def test_json_renderer_returns_parseable_response
    parsed = JSON.parse(Partitura::JITDocs.render_json(:staff_grid))

    assert_equal "staff_grid", parsed.fetch("topic")
    assert_includes parsed.fetch("rules").join(" "), "`_` sustains"
  end

  def test_unknown_topic_returns_indexable_guidance
    data = Partitura.help_data(:not_a_topic)

    assert_equal :unknown, data[:topic]
    assert_includes data[:next_topics], :index
  end

  def test_compile_api_topic_locks_llm_error_contract
    data = Partitura.help_data(:compile_api)

    assert_equal :compile_api, data[:topic]
    assert_includes data[:rules], "Every error includes a repair instruction and focused docs."
    assert_includes data[:example], "surface_event_count_mismatch"
    assert_includes data[:docs], "docs/architecture/partitura/05_compile_api.md"
  end

  def test_export_topic_locks_runtime_export_commands
    data = Partitura.help_data(:export)

    assert_equal :export, data[:topic]
    assert_includes data[:rules], "Exporters consume the compiled model directly; there is no serialized handoff."
    assert_includes data[:rules],
                    "Use `partitura/bin/partitura export SOURCE.rb --stem STEM` when writing MusicXML and MIDI."
    assert_includes data[:example], "partitura/bin/partitura export"
  end

  def test_controls_topic_documents_timeline_marks
    data = Partitura.help_data(:controls)

    assert_equal :controls, data[:topic]
    assert_includes data[:rules], "Use inline event marks only for marks tied to one event."
    assert_includes data[:example], "control do"
    assert_includes data[:example], "tempo do"
    assert_includes data[:example], "meter do"
    assert_includes data[:example], "mark \"dotted-quarter = 52\", at: \"bar 1 beat 1\""
    assert_includes data[:example], "change \"quarter = 96\", at: \"bar 9 beat 1\""
    assert_includes data[:rules], "Tempo beat units are semantic: `dotted-quarter = 52` means 52 " \
      "dotted-quarter beats per minute (quarter = 78 for playback)."
    assert_includes data[:docs], "docs/architecture/partitura/surfaces/controls.md"
  end

  def test_llm_design_explains_inference_time_capability_boundary
    data = Partitura.help_data(:llm_design)

    assert_equal :llm_design, data[:topic]
    assert_includes data[:rules],
                    "Partitura supplies domain capability at inference time; it does not change model weights."
    assert_includes data[:rules],
                    "Mechanical validation prevents representational errors; it does not prove musical " \
                    "quality or expertise."
    assert_equal :llm_design, Partitura.help_data(:architecture)[:topic]
  end

  def test_guided_topic_matches_current_pass_note_manifest
    data = Partitura.help_data(:guided)
    manifest = Partitura::Guided::Manifest.load("dsl_composition")

    assert_equal %w[decisions carries improvements musical_verdict], manifest.pass_note_fields
    parsed = Partitura::Guided::PassNote.parse(data.fetch(:example), manifest.pass_note_fields)
    assert_equal manifest.pass_note_fields.sort, (parsed.keys - ["graph_paths"]).sort
    assert_includes data[:rules], "Only carries feed forward as OPEN THREADS; realized music stays in source, " \
                                  "and fixable weaknesses are fixed now."
  end

  def test_external_workflow_and_observation_topics_are_independently_routable
    assert_equal :composition_workflow, Partitura.help_data(:composition_workflow)[:topic]
    assert_equal :evaluation, Partitura.help_data(:benchmark)[:topic]
    assert_equal :annotation_observation, Partitura.help_data(:annotations)[:topic]
    assert_includes Partitura.help_data(:score_observation)[:next_topics], :annotation_observation
  end

  def test_every_topic_has_valid_contract_links_and_next_topics
    topics = Partitura::JITDocs::TOPICS

    topics.each do |topic, data|
      REQUIRED_FIELDS.each { |field| assert data.key?(field), "#{topic} is missing #{field}" }
      assert_equal Partitura::JITDocs::SCHEMA_VERSION,
                   Partitura.help_data(topic).fetch(:schema_version), topic
      assert_kind_of String, data.fetch(:use_when), topic
      assert_kind_of Array, data.fetch(:rules), topic
      assert_kind_of Array, data.fetch(:next_topics), topic
      assert_kind_of Array, data.fetch(:docs), topic

      data.fetch(:next_topics).each do |next_topic|
        assert topics.key?(next_topic), "#{topic} points to unknown topic #{next_topic}"
      end
      data.fetch(:docs).each do |doc|
        assert File.file?(File.join(REPOSITORY_ROOT, doc)), "#{topic} points to missing doc #{doc}"
      end
    end
  end

  def test_jit_command_examples_use_the_consolidated_cli
    Partitura::JITDocs::TOPICS.each do |topic, data|
      text = ([data.fetch(:example)] + data.fetch(:rules)).join("\n")
      refute_match(%r{partitura/bin/(?:partitura_help|production_view|production_export|partitura_build)}, text,
                   topic)
      refute_match(/\bpartitura_help\b/, text, topic)
    end
  end
end
