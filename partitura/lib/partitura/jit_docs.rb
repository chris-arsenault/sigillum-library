# frozen_string_literal: true

require "json"
require_relative "marks"
require_relative "jit_docs/design_topics"
require_relative "jit_docs/topics"
require_relative "jit_docs/capability_topics"
require_relative "jit_docs/workflow_topics"

module Partitura
  module JITDocs
    SCHEMA_VERSION = 1
    TOPICS = DESIGN_TOPICS.merge(SURFACE_TOPICS).merge(CAPABILITY_TOPICS).merge(WORKFLOW_TOPICS).freeze

    module_function

    def data(topic = :index)
      key = normalize(topic)
      found = TOPICS[key]
      return unknown_response(topic) unless found

      { schema_version: SCHEMA_VERSION, topic: key }.merge(found)
    end

    def render(topic = :index)
      info = data(topic)
      lines = []
      lines << "# DSL Help: #{info[:topic]}"
      lines << ""
      lines << "schema_version: #{info[:schema_version]}"
      lines << ""
      lines << "use_when: #{info[:use_when]}"
      lines << ""
      lines << "rules:"
      info[:rules].each { |rule| lines << "- #{rule}" }
      lines << ""
      lines << "example:"
      lines << "```"
      lines << info[:example].to_s
      lines << "```"
      lines << ""
      lines << "next_topics: #{info[:next_topics].join(', ')}"
      lines << "docs:"
      info[:docs].each { |doc| lines << "- #{doc}" }
      lines.join("\n")
    end

    def render_json(topic = :index)
      JSON.pretty_generate(data(topic))
    end

    def topics
      TOPICS.keys
    end

    ALIASES = { architecture: :llm_design, context: :llm_design,
                docs: :documentation_index, docs_index: :documentation_index,
                chords: :harmony, harmony_check: :harmony, run: :guided, workflow: :guided,
                score_grid: :texture, score: :texture,
                instruments: :roster, instrumentation: :roster,
                techniques: :cards, technique_cards: :cards,
                framework: :build, registry: :build,
                fill: :phrase_placement, fill_material: :phrase_placement,
                anacrusis: :phrase_placement, placement: :phrase_placement,
                graph: :composition_graph, score_tree: :composition_graph,
                composition_loop: :composition_workflow, ml_workflow: :composition_workflow,
                benchmark: :evaluation, annotations: :annotation_observation }.freeze

    def normalize(topic)
      key = topic.to_s.tr("-", "_").to_sym
      ALIASES.fetch(key, key)
    end

    def unknown_response(topic)
      {
        schema_version: SCHEMA_VERSION,
        topic: :unknown,
        use_when: "The requested topic #{topic.inspect} is not known.",
        rules: ["Ask for one of the listed next topics."],
        example: "partitura/bin/partitura help index",
        next_topics: topics,
        docs: []
      }
    end
  end
end
