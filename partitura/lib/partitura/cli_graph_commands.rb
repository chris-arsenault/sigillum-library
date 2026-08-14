# frozen_string_literal: true

module Partitura
  # Command metadata for bounded Composition Graph discovery.
  module CLIGraphCommands
    COMMANDS = {
      "show" => CLICatalog.command(
        category: :discover, summary: "Inspect one Composition Graph object by exact path.",
        usage: "show SOURCE.rb PATH [--json]", effect: :read,
        output: :composition_graph_object, help_topic: :composition_graph,
        arguments: [
          { name: "source", type: "ruby_source_path", required: true },
          { name: "path", type: "composition_graph_path", required: true }
        ],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "connections" => CLICatalog.command(
        category: :discover, summary: "List canonical relations incident to one graph object.",
        usage: "connections SOURCE.rb PATH [--json]", effect: :read,
        output: :composition_graph_connections, help_topic: :composition_graph,
        arguments: [
          { name: "source", type: "ruby_source_path", required: true },
          { name: "path", type: "composition_graph_path", required: true }
        ],
        options: [{ flag: "--json", type: "boolean" }]
      ),
      "path" => CLICatalog.command(
        category: :discover, summary: "Find a bounded shortest route through graph relations.",
        usage: "path SOURCE.rb FROM TO [--max-hops N] [--json]", effect: :read,
        output: :composition_graph_path, help_topic: :composition_graph,
        arguments: [
          { name: "source", type: "ruby_source_path", required: true },
          { name: "from", type: "composition_graph_path", required: true },
          { name: "to", type: "composition_graph_path", required: true }
        ],
        options: [
          { flag: "--max-hops", type: "positive_integer", default: 6, maximum: 20 },
          { flag: "--json", type: "boolean" }
        ]
      )
    }.freeze
  end
end
