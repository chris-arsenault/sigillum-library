# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "partitura"
require "partitura/catalog"

class CLICatalogTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CLI = File.join(ROOT, "partitura", "bin", "partitura")
  COMMANDS = %w[
    abandon annotation-observation back benchmark-preference benchmark-review
    benchmark-score build cards catalog commands commit compile connections evaluate export help
    import-musicxml lint log next observe path preference protocol review runs score-observation
    show start status step verify-musicxml-import view
  ].freeze

  def test_command_catalog_covers_consolidated_cli
    payload = Partitura::Catalog.data("commands")
    commands = payload.fetch(:commands)

    assert_equal 1, payload.fetch(:schema_version)
    assert_equal COMMANDS, commands.map { |command| command.fetch(:name) }.sort
    commands.each do |command|
      focused = Partitura::Catalog.data("commands", command.fetch(:name)).fetch(:command)
      assert_includes %w[read write_outputs write_run_state write_candidate_outputs
                         mutate_source_and_trajectory write_review_bundle append_preference],
                      focused.fetch(:effect)
      assert_kind_of Array, focused.fetch(:arguments)
      assert_kind_of Array, focused.fetch(:options)
      focused.fetch(:arguments).each do |argument|
        assert argument.key?(:name)
        assert argument.key?(:type)
        assert argument.key?(:required)
      end
      focused.fetch(:options).each do |option|
        assert option.key?(:flag)
        assert option.key?(:type)
      end
      refute_empty focused.fetch(:usage)
      refute_empty focused.fetch(:help_topic)
    end
  end

  def test_every_command_routes_to_a_focused_jit_topic
    Partitura::Catalog.data("commands").fetch(:commands).each do |command|
      focused = command.fetch(:help_topic).to_sym

      assert Partitura::JITDocs::TOPICS.key?(focused),
             "#{command.fetch(:name)} routes to unknown JIT topic #{focused}"
    end
  end

  def test_command_enums_match_runtime_contracts
    review = command("review")
    preference = command("preference")
    benchmark_review = command("benchmark-review")

    assert_equal Partitura::Production::CompositionWorkflow::HUMAN_REVIEW_SCALES.map(&:to_s),
                 option(review, "--scale").fetch(:values)
    assert_equal Partitura::Production::CompositionWorkflow::HUMAN_REVIEW_CRITERIA.map(&:to_s),
                 option(review, "--criterion").fetch(:values)
    assert_equal Partitura::Production::CompositionWorkflow::PREFERENCE_OUTCOMES.map(&:to_s),
                 option(preference, "--outcome").fetch(:values)
    assert_equal Partitura::Production::Evaluation::CRITERIA.map(&:to_s),
                 option(benchmark_review, "--criterion").fetch(:values)
  end

  def test_runtime_catalogues_expose_current_values
    views = Partitura::Catalog.data("views").fetch(:views)
    procedures = Partitura::Catalog.data("procedures").fetch(:procedures)
    profiles = Partitura::Catalog.data("annotation_profiles").fetch(:annotation_profiles)
    examples = Partitura::Catalog.data("examples").fetch(:examples)
    graph = Partitura::Catalog.data("composition-graph").fetch(:composition_graph)
    graph_contract = Partitura::Production::CompositionGraph.vocabulary.transform_values do |values|
      values.map(&:to_s)
    end

    assert_includes views.fetch(:sounding_views), "verticals"
    assert_includes views.fetch(:data_views), "composition_snapshot"
    assert_equal %w[dsl_composition section_recomposition], (procedures.map { |item| item.fetch(:id) })
    assert_equal %w[openscore_hauptstimme_v1 s3_v1], (profiles.map { |item| item.fetch(:id) })
    assert(examples.all? { |item| File.file?(File.join(ROOT, item.fetch(:path))) })
    assert_equal graph_contract, graph
    assert_equal "material_relations",
                 Partitura::Catalog.data("composition-graph", "material-relations")
                                  .dig(:composition_graph_entry, :name)
  end

  def test_procedure_and_profile_items_are_typed
    procedure = Partitura::Catalog.data("procedures", "dsl_composition").fetch(:procedure)
    profile = Partitura::Catalog.data("annotation-profiles", "s3_v1").fetch(:annotation_profile)

    assert procedure.fetch(:requires_brief)
    assert_equal %w[decisions carries improvements musical_verdict], procedure.fetch(:pass_note_fields)
    assert_equal "s0", procedure.fetch(:stages).first.fetch(:id)
    required = profile.fetch(:annotation_kinds).select { |item| item.fetch(:required) }
    assert_equal %w[s3_downbeats s3_time_signature s3_form], (required.map { |item| item.fetch(:kind) })
    assert_includes profile.fetch(:targets), "seam_boundary"
  end

  def test_cli_emits_command_and_example_catalog_json
    commands_out, commands_err, commands_status = Open3.capture3(
      "ruby", CLI, "commands", "view", "--json", chdir: ROOT
    )
    example_out, example_err, example_status = Open3.capture3(
      "ruby", CLI, "catalog", "examples", "production_hybrid", "--json", chdir: ROOT
    )
    graph_out, graph_err, graph_status = Open3.capture3(
      "ruby", CLI, "catalog", "composition-graph", "node-types", "--json", chdir: ROOT
    )

    assert commands_status.success?, commands_err
    assert example_status.success?, example_err
    assert graph_status.success?, graph_err
    assert_equal "view", JSON.parse(commands_out).dig("command", "name")
    assert_equal "canonical", JSON.parse(example_out).dig("example", "status")
    assert_includes JSON.parse(graph_out).dig("composition_graph_entry", "values"), "span"
  end

  def test_view_without_source_is_successful_discovery
    stdout, stderr, status = Open3.capture3("ruby", CLI, "view", "--json", chdir: ROOT)
    payload = JSON.parse(stdout)

    assert status.success?, stderr
    assert_empty stderr
    assert_includes payload.dig("views", "sounding_views"), "verticals"
    assert_includes payload.dig("views", "secondary_declared_intent_views"), "structure"
  end

  def test_unknown_profile_error_routes_to_runtime_profile_catalog
    error = assert_raises(Partitura::AnnotationObservation::Error) do
      Partitura.annotation_observation(
        "unused.json", profile: "not_a_profile", annotations: []
      )
    end
    response = error.to_h

    assert_equal "unknown_annotation_profile", response.fetch(:code)
    assert_includes response.fetch(:message), "openscore_hauptstimme_v1"
    assert_equal "annotation_observation", response.fetch(:help_topic)
    assert_includes response.fetch(:repair_instruction), "catalog annotation-profiles"
  end

  private

  def command(name)
    Partitura::Catalog.data("commands", name).fetch(:command)
  end

  def option(command, flag)
    command.fetch(:options).find { |candidate| candidate.fetch(:flag) == flag }
  end
end
