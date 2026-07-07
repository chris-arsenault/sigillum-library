# frozen_string_literal: true

require "json"
require "pathname"

module Partitura
  module Framework
    module Transport
      module_function

      def piece_from(source_or_piece)
        return source_or_piece if source_or_piece.respond_to?(:compile_response)

        Partitura.load_production_file(source_or_piece)
      end

      def hash_for(source_or_piece)
        piece = piece_from(source_or_piece)
        transport = Partitura.production_transport_hash(piece)
        return transport unless error_transport?(transport)

        raise Partitura::Production::CompileError.new(
          code: fetch_any(transport, :code) || "transport_error",
          message: fetch_any(transport, :message) || "Transport build failed.",
          repair_instruction: fetch_any(transport, :repair_instruction) || "Fix the DSL compile error.",
          help_topic: fetch_any(transport, :help_topic) || "compile",
          docs: fetch_any(transport, :docs) || ["docs/architecture/partitura/INDEX.md"]
        )
      end

      def write(source_or_piece, out_dir, stem:)
        out_dir = Paths.ensure_dir(out_dir)
        path = Paths.transport_path(out_dir, stem)
        path.write(JSON.pretty_generate(hash_for(source_or_piece)))
        path
      end

      def read(path)
        JSON.parse(Pathname.new(path.to_s).read)
      end

      def error_transport?(transport)
        fetch_any(transport, :status) == "error"
      end

      def fetch_any(hash, key)
        hash[key] || hash[key.to_s]
      end
    end
  end
end
