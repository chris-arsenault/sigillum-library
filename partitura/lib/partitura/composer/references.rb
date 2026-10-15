# frozen_string_literal: true

require_relative "guidance"

module Partitura
  module Composer
    class References
      ROOT = File.expand_path("../../../..", __dir__)

      def entries
        prose_entries + card_entries
      end

      def prose_entries
        %w[craft surveys].flat_map do |kind|
          Dir.glob(File.join(ROOT, "reference/written", kind, "*.md")).map do |path|
            { id: "#{kind}/#{File.basename(path, '.md')}", title: File.foreach(path).first.to_s.sub(/^#+\s*/, "").strip,
              path: path, kind: kind }
          end
        end
      end

      def card_entries
        path = File.join(ROOT, "technique_library/dsl/cards/manifest.json")
        JSON.parse(File.read(path)).map do |card|
          { id: "card/#{card.fetch('category')}/#{card.fetch('name')}", title: card.fetch("name"),
            description: card.fetch("behavior", ""), path: File.join(ROOT, card.fetch("path")), kind: "card" }
        end
      end

      def call(input)
        return read(input.fetch("reference")) if input["reference"]

        terms = input.fetch("query", "").downcase.split
        matches = entries.select do |entry|
          haystack = entry.values_at(:id, :title, :description).join(" ").downcase
          terms.all? { |term| haystack.include?(term) }
        end
        text = matches.map do |entry|
          "#{entry.fetch(:id)}: #{entry.fetch(:title)}#{entry[:description] && " — #{entry[:description]}"}"
        end.join("\n")
        { text: text.empty? ? "No matching references." : text }
      end

      def read(id)
        entry = entries.find { |item| item.fetch(:id) == id }
        raise Error.new("unknown_reference", "Choose a reference ID returned by composer_reference.") unless entry

        text = entry.fetch(:kind) == "card" ? card_text(entry) : File.read(entry.fetch(:path))
        { text: text, reference: id }
      end

      def card_text(entry)
        piece = Production.load_file(entry.fetch(:path))
        lines = piece.parts.keys.map { |part| Production.readout(piece, :line, part: part) }
        "#{entry.fetch(:id)}\n#{entry[:description]}\n\n" +
          lines.join("\n\n") + "\n\n" + Production.readout(piece, :ensemble_grid)
      rescue Production::CompileError, ArgumentError => e
        raise Error.new("reference_unavailable", "The technique specimen could not be read: #{e.message}")
      end
    end
  end
end
