# frozen_string_literal: true

require_relative "../composer"
require_relative "resources"

module Partitura
  module Composer
    class MCP
      VERSIONS = %w[2025-11-25 2025-06-18].freeze
      MAX_MESSAGE_BYTES = 2_097_152

      def initialize(service, input: $stdin, output: $stdout, errors: $stderr)
        @service = service
        @resources = Resources.new(service.store)
        @input = input
        @output = output
        @errors = errors
        @initialized = false
        @ready = false
      end

      def run
        @output.sync = true
        while (line = @input.gets(MAX_MESSAGE_BYTES + 1))
          process_line(line)
        end
      end

      def process_line(line)
        if line.bytesize > MAX_MESSAGE_BYTES
          drain_message(line)
          emit(error(nil, -32600, "MCP message exceeds 2 MB."))
          return
        end
        response = handle(JSON.parse(line))
        emit(response) if response
      rescue JSON::ParserError
        emit(error(nil, -32700, "Invalid JSON."))
      end

      def drain_message(line)
        line = @input.gets(MAX_MESSAGE_BYTES) until !line || line.end_with?("\n")
      end

      def emit(message)
        @output.puts(JSON.generate(message))
      end

      def handle(message)
        unless request?(message)
          return error(nil, -32600, "Expected a JSON-RPC request or notification.")
        end
        id = message["id"]
        method = message.fetch("method")
        return notification(method) unless message.key?("id")
        return error(id, -32600, "Invalid request identifier.") unless request_id?(id)

        params = message.fetch("params", {})
        return error(id, -32602, "Parameters must be an object.") unless params.is_a?(Hash)

        result = dispatch(method, params)
        { jsonrpc: "2.0", id: id, result: result }
      rescue Error => e
        code = e.code == "method_not_found" ? -32601 : -32602
        error(id, code, e.message, e.to_h)
      rescue KeyError, TypeError => e
        error(id, -32602, "Invalid request parameters: #{e.message}")
      rescue StandardError => e
        @errors.puts("Partitura MCP: #{e.class}: #{e.message}")
        error(id, -32603, "Partitura could not complete this request.")
      end

      def request?(message)
        message.is_a?(Hash) && message["jsonrpc"] == "2.0" && message["method"].is_a?(String)
      end

      def request_id?(id)
        id.is_a?(String) || id.is_a?(Integer)
      end

      def notification(method)
        @ready = true if method == "notifications/initialized" && @initialized
        nil
      end

      def dispatch(method, params)
        return initialize_session(params) if method == "initialize"
        return {} if method == "ping"
        raise Error.new("not_initialized", "Initialize the composer connection first.") unless @ready

        route = { "tools/list" => -> { list_tools(params) }, "tools/call" => -> { call_tool(params) },
                  "resources/list" => -> { list_resources(params) },
                  "resources/templates/list" => -> { list_templates(params) },
                  "resources/read" => -> { read_resource(params) } }[method]
        raise Error.new("method_not_found", "Unsupported MCP method #{method}.") unless route

        route.call
      end

      def list_tools(_params)
        { tools: Contracts.tools }
      end

      def list_resources(_params)
        { resources: @resources.list }
      end

      def list_templates(_params)
        { resourceTemplates: [] }
      end

      def read_resource(params)
        Schema.validate!(params, Schema.object({ "uri" => Schema::TEXT }, required: %w[uri]))
        { contents: [@resources.read(params.fetch("uri"))] }
      end

      def initialize_session(params)
        raise Error.new("already_initialized", "This connection is already initialized.") if @initialized
        unless params["protocolVersion"].is_a?(String) && params["capabilities"].is_a?(Hash) &&
               params["clientInfo"].is_a?(Hash)
          raise Error.new("invalid_initialize", "Supply protocolVersion, capabilities and clientInfo.")
        end
        @initialized = true
        version = VERSIONS.include?(params["protocolVersion"]) ? params["protocolVersion"] : VERSIONS.first
        { protocolVersion: version, capabilities: { tools: {}, resources: {} },
          serverInfo: { name: "partitura-composer", version: "1.0.0" }, instructions: Guidance.guide }
      end

      def call_tool(params)
        name = params.fetch("name", "")
        unless Contracts::DEFINITIONS.key?(name)
          raise Error.new("unknown_tool", "Unknown composer tool #{name}.")
        end
        result = @service.call(name, params.fetch("arguments", {}))
        tool_result(result)
      rescue Error => e
        { content: [{ type: "text", text: JSON.pretty_generate(e.to_h) }],
          structuredContent: e.to_h, isError: true }
      end

      def tool_result(result)
        text = result.fetch(:text)
        text += "\n\n#{result[:guide]}" if result[:guide]
        text += "\n\nRevision: #{result[:revision]}" if result[:revision]
        if result[:continuation]
          text += "\n\nPartial read. Continue with the same tool:\n#{JSON.generate(result[:continuation])}"
        end
        metadata = result.reject { |key, _| %i[text guide].include?(key) }
        { content: [{ type: "text", text: text }, *@resources.export_links(result)],
          structuredContent: metadata, isError: false }
      end

      def error(id, code, message, data = nil)
        { jsonrpc: "2.0", id: id, error: { code: code, message: message, data: data }.compact }
      end
    end
  end
end
