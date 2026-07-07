# frozen_string_literal: true

require "json"
require_relative "marks"
require_relative "jit_docs/topics"

module Partitura
  module JITDocs

    module_function

    def data(topic = :index)
      key = normalize(topic)
      found = TOPICS[key]
      return unknown_response(topic) unless found

      { topic: key }.merge(found)
    end

    def render(topic = :index)
      info = data(topic)
      lines = []
      lines << "# DSL Help: #{info[:topic]}"
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

    def normalize(topic)
      topic.to_s.tr("-", "_").to_sym
    end

    def unknown_response(topic)
      {
        topic: :unknown,
        use_when: "The requested topic #{topic.inspect} is not known.",
        rules: ["Ask for one of the listed next topics."],
        example: "partitura_help index",
        next_topics: topics,
        docs: ["docs/architecture/partitura/INDEX.md"]
      }
    end
  end
end
