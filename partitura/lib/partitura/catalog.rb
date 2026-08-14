# frozen_string_literal: true

require "json"
require_relative "cli_catalog"
require_relative "examples_catalog"

module Partitura
  module Catalog
    SCHEMA_VERSION = 1
    NAMES = %w[commands views procedures annotation_profiles examples composition_graph].freeze
    DATA_READERS = {
      "commands" => :commands_data,
      "views" => :views_data,
      "procedures" => :procedures_data,
      "annotation_profiles" => :annotation_profiles_data,
      "examples" => :examples_data,
      "composition_graph" => :composition_graph_data
    }.freeze
    RENDERERS = {
      "commands" => :render_commands,
      "views" => :render_views,
      "procedures" => :render_procedures,
      "annotation_profiles" => :render_annotation_profiles,
      "examples" => :render_examples,
      "composition_graph" => :render_composition_graph
    }.freeze

    module_function

    def data(name = nil, item = nil)
      return { schema_version: SCHEMA_VERSION, catalogs: NAMES } unless name

      reader = DATA_READERS[normalize(name)]
      raise KeyError, "unknown catalog #{name.inspect}; available: #{NAMES.join(', ')}" unless reader

      public_send(reader, item)
    end

    def render(name = nil, item = nil)
      payload = data(name, item)
      return payload.fetch(:catalogs).join("\n") unless name

      public_send(RENDERERS.fetch(normalize(name)), payload)
    end

    def normalize(name)
      name.to_s.tr("-", "_")
    end

    def commands_data(item)
      CLICatalog.data(item)
    end

    def examples_data(item)
      ExamplesCatalog.data(item)
    end

    def views_data(item)
      catalog = Production::Readout.view_catalog.transform_values { |values| values.map(&:to_s) }
      if item
        name = item.to_s
        category = catalog.find { |_key, values| values.include?(name) }&.first
        raise KeyError, "unknown view #{name.inspect}" unless category

        return {
          schema_version: SCHEMA_VERSION,
          view: { name:, category: category.to_s, effect: "read" }
        }
      end
      { schema_version: SCHEMA_VERSION, views: catalog }
    end

    def procedures_data(item)
      ids = Guided::Manifest.list
      if item
        raise KeyError, "unknown procedure #{item.inspect}; available: #{ids.join(', ')}" unless ids.include?(item.to_s)

        return { schema_version: SCHEMA_VERSION, procedure: procedure_data(item) }
      end
      {
        schema_version: SCHEMA_VERSION,
        procedures: ids.map do |id|
          procedure = procedure_data(id)
          procedure.slice(:id, :version, :title, :requires_brief).merge(
            stage_ids: procedure.fetch(:stages).map { |stage| stage.fetch(:id) }
          )
        end
      }
    end

    def procedure_data(id)
      manifest = Guided::Manifest.load(id)
      {
        id: manifest.id,
        version: manifest.version,
        title: manifest.title,
        requires_brief: manifest.requires_brief?,
        principles: relative_path(manifest.principles_path),
        pass_note_fields: manifest.pass_note_fields,
        stages: manifest.stages.map do |stage|
          {
            id: stage.id,
            name: stage.name,
            iterative: stage.iterative,
            unit: stage.unit,
            docs: stage.docs.map { |path| relative_path(path) },
            artifacts: stage.artifacts,
            gates: stage.gates,
            stage_complete_gates: stage.stage_complete_gates
          }
        end
      }
    end

    def annotation_profiles_data(item)
      profiles = AnnotationObservation::PROFILE_CATALOG
      if item
        profile = profiles[item.to_s]
        unless profile
          raise KeyError,
                "unknown annotation profile #{item.inspect}; available: #{profiles.keys.join(', ')}"
        end

        return {
          schema_version: SCHEMA_VERSION,
          annotation_profile: profile.merge(id: item.to_s)
        }
      end
      {
        schema_version: SCHEMA_VERSION,
        annotation_profiles: profiles.map { |id, profile| profile.merge(id:) }
      }
    end

    def composition_graph_data(item)
      values = Production::CompositionGraph.vocabulary.transform_values do |items|
        items.map(&:to_s)
      end
      if item
        name = normalize(item).to_sym
        selected = values[name]
        raise KeyError, "unknown composition graph vocabulary #{item.inspect}" unless selected

        return {
          schema_version: SCHEMA_VERSION,
          composition_graph_entry: { name: name.to_s, values: selected }
        }
      end
      { schema_version: SCHEMA_VERSION, composition_graph: values }
    end

    def relative_path(path)
      return unless path

      path.to_s.delete_prefix("#{Guided::Manifest::LIBRARY_ROOT}/")
    end

    def render_commands(payload)
      commands = payload[:commands] || [payload.fetch(:command)]
      commands.map do |command|
        "#{command.fetch(:name)}  #{command.fetch(:usage)}\n  #{command.fetch(:summary)}"
      end.join("\n")
    end

    def render_views(payload)
      return "#{payload.dig(:view, :name)}  #{payload.dig(:view, :category)}" if payload[:view]

      payload.fetch(:views).map do |category, names|
        "#{category}: #{names.join(', ')}"
      end.join("\n")
    end

    def render_procedures(payload)
      procedures = payload[:procedures] || [payload.fetch(:procedure)]
      procedures.map do |procedure|
        stages = procedure[:stages]&.length || procedure.fetch(:stage_ids).length
        "#{procedure.fetch(:id)} v#{procedure.fetch(:version)}  #{procedure.fetch(:title)} (#{stages} stages)"
      end.join("\n")
    end

    def render_annotation_profiles(payload)
      profiles = payload[:annotation_profiles] || [payload.fetch(:annotation_profile)]
      profiles.map do |profile|
        kinds = profile.fetch(:annotation_kinds).map { |entry| entry.fetch(:kind) }
        "#{profile.fetch(:id)}  annotations: #{kinds.join(', ')}"
      end.join("\n")
    end

    def render_examples(payload)
      examples = payload[:examples] || [payload.fetch(:example)]
      examples.map do |example|
        "#{example.fetch(:id)}  #{example.fetch(:status)}  #{example.fetch(:path)}"
      end.join("\n")
    end

    def render_composition_graph(payload)
      if payload[:composition_graph_entry]
        entry = payload.fetch(:composition_graph_entry)
        return "#{entry.fetch(:name)}: #{entry.fetch(:values).join(', ')}"
      end

      payload.fetch(:composition_graph).map do |name, values|
        "#{name}: #{values.join(', ')}"
      end.join("\n")
    end
  end
end
