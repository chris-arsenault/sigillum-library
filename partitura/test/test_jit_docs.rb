# frozen_string_literal: true

require "json"
require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"

class JITDocsTest < Minitest::Test
  def test_index_response_has_required_contract_fields
    data = Partitura.help_data(:index)

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
    assert_includes data[:rules], "Use `production_export` for transport JSON, MusicXML, and MIDI."
    assert_includes data[:example], "production_piece"
    assert_includes data[:example], "meter do"
    assert_includes data[:example], "change \"4/4\", at: \"bar 9\""
    assert_includes data[:example], "music21: \"Clarinet\""
    assert_includes data[:example], "placement :call"
  end

  def test_hybrid_response_is_llm_actionable
    data = Partitura.help_data(:hybrid)

    assert_equal :hybrid, data[:topic]
    assert_includes data[:rules], "Phrase layer carries long thought."
    assert_includes data[:example], "placement :foreground"
    assert_includes data[:docs], "docs/architecture/partitura/surfaces/hybrid.md"
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

  def test_transport_export_topic_locks_runtime_export_commands
    data = Partitura.help_data(:transport_export)

    assert_equal :transport_export, data[:topic]
    assert_includes data[:rules], "Transport JSON is the canonical Ruby export handoff."
    assert_includes data[:rules], "Use `production_export SOURCE.rb --stem STEM` when writing JSON, MusicXML, and MIDI."
    assert_includes data[:example], "production_view"
    assert_includes data[:example], "production_export"
  end

  def test_controls_topic_documents_timeline_marks
    data = Partitura.help_data(:controls)

    assert_equal :controls, data[:topic]
    assert_includes data[:rules], "Use inline event marks only for marks tied to one event."
    assert_includes data[:example], "control do"
    assert_includes data[:example], "tempo do"
    assert_includes data[:example], "meter do"
    assert_includes data[:example], "change \"quarter = 96\", at: \"bar 9 beat 1\""
    assert_includes data[:docs], "docs/architecture/partitura/surfaces/controls.md"
  end
end
