# frozen_string_literal: true

require "json"
require "optparse"

module Partitura
  # CLI adapter for bounded queries over the existing Composition Graph projection.
  class CompositionGraphCommand
    DEFAULT_MAX_HOPS = 6
    Canonical = Production::CompositionGraph::Canonical

    class SourceEvaluationError < StandardError
      attr_reader :source, :error_class

      def initialize(source, error)
        @source = source.to_s
        @error_class = error.class.name
        super("#{source}: #{error.message}")
      end
    end

    def initialize(command)
      @command = command.to_s
    end

    def run(argv)
      options = parse_options(argv)
      source, *arguments = argv
      raise ArgumentError, usage unless source

      graph = Partitura.composition_graph(load_piece(source))
      payload = query(graph, source, arguments, options)
      puts(options.fetch(:json) ? JSON.pretty_generate(Canonical.value(payload)) : render(payload))
      0
    end

    private

    def parse_options(argv)
      options = { json: false, max_hops: DEFAULT_MAX_HOPS }
      OptionParser.new do |parser|
        parser.on("--json") { options[:json] = true }
        if @command == "path"
          parser.on("--max-hops N", Integer) { |value| options[:max_hops] = value }
        end
      end.parse!(argv)
      options
    end

    def load_piece(source)
      Partitura.load_production_file(source)
    rescue Production::CompileError, Errno::ENOENT, Errno::EACCES
      raise
    rescue LoadError, StandardError => error
      raise SourceEvaluationError.new(source, error), cause: error
    end

    def query(graph, source, arguments, options)
      result = case @command
               when "show" then show(graph, arguments)
               when "connections" then connections(graph, arguments)
               when "path" then path(graph, arguments, options)
               else raise ArgumentError, "unknown composition graph command #{@command.inspect}"
               end
      {
        schema_version: Production::CompositionGraph::Graph::SCHEMA_VERSION,
        command: @command, source: source, graph_digest: graph.graph_digest
      }.merge(result)
    end

    def show(graph, arguments)
      one_argument!(arguments)
      graph.show(arguments.fetch(0)).to_h
    end

    def connections(graph, arguments)
      one_argument!(arguments)
      path = arguments.fetch(0)
      rows = graph.connections(path)
      { object_path: graph.node(path).path.to_s, count: rows.length, connections: rows.map(&:to_h) }
    end

    def path(graph, arguments, options)
      raise ArgumentError, usage unless arguments.length == 2

      graph.shortest_path(
        arguments.fetch(0), arguments.fetch(1), max_hops: options.fetch(:max_hops)
      ).to_h
    end

    def one_argument!(arguments)
      raise ArgumentError, usage unless arguments.length == 1
    end

    def render(payload)
      case @command
      when "show" then render_show(payload)
      when "connections" then render_connections(payload)
      when "path" then render_path(payload)
      end
    end

    def render_show(payload)
      object = payload.fetch(:object)
      lines = ["#{object.fetch(:path)} (#{object.fetch(:type)})"]
      lines << "  parent: #{object.fetch(:parent)}" if object[:parent]
      lines << "  bars: #{object.fetch(:bars).begin}-#{object.fetch(:bars).end}" if object[:bars]
      lines << "  stable: #{object.fetch(:stable)}"
      lines << "  requirements: #{payload.fetch(:requirements).length}"
      lines << "  connections: #{payload.fetch(:connections).length}"
      lines.join("\n")
    end

    def render_connections(payload)
      rows = payload.fetch(:connections)
      return "#{payload.fetch(:object_path)} has no graph connections." if rows.empty?

      lines = ["#{payload.fetch(:object_path)}: #{rows.length} connection(s)"]
      rows.each do |row|
        origin = row.fetch(:authored) ? "authored" : "derived"
        lines << "  #{row.fetch(:direction)} #{row.fetch(:kind)} #{row.fetch(:neighbor)} (#{origin})"
      end
      lines.join("\n")
    end

    def render_path(payload)
      unless payload.fetch(:found)
        return "No path from #{payload.fetch(:from)} to #{payload.fetch(:to)} " \
               "within #{payload.fetch(:max_hops)} hop(s)."
      end

      lines = ["#{payload.fetch(:from)} -> #{payload.fetch(:to)}"]
      payload.fetch(:steps).each do |row|
        lines << "  #{row.fetch(:origin)} #{row.fetch(:direction)} #{row.fetch(:kind)} #{row.fetch(:neighbor)}"
      end
      lines.join("\n")
    end

    def usage
      case @command
      when "show" then "usage: partitura show SOURCE.rb PATH [--json]"
      when "connections" then "usage: partitura connections SOURCE.rb PATH [--json]"
      when "path" then "usage: partitura path SOURCE.rb FROM TO [--max-hops N] [--json]"
      end
    end
  end
end
