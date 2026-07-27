# frozen_string_literal: true

module Partitura
  module AnnotationObservation
    class SourceSet
      Source = Data.define(:kind, :path, :display_path)

      def initialize(annotations)
        @sources = annotations.map do |annotation|
          kind = annotation.fetch(:kind).to_s
          display_path = annotation.fetch(:path).to_s
          path = File.expand_path(display_path)
          raise Error.new("missing_annotation_source", "annotation source is absent: #{path}") unless File.file?(path)

          Source.new(kind:, path:, display_path:)
        end
        duplicates = @sources.group_by { |source| [source.kind, source.path] }.select { |_, items| items.length > 1 }
        return if duplicates.empty?

        raise Error.new("duplicate_annotation_source", "annotation sources must be unique")
      end

      def paths(kind)
        sources(kind).map(&:path)
      end

      def one(kind)
        matches = paths(kind)
        return matches.first if matches.length == 1

        raise Error.new(
          "annotation_source_cardinality",
          "#{kind} requires exactly one source, found #{matches.length}"
        )
      end

      def csv_rows(kind)
        sources(kind).flat_map do |source|
          CSV.read(source.path, headers: true, encoding: "bom|utf-8").each_with_index.map do |row, index|
            {
              values: row.to_h,
              source_path: source.display_path,
              source_row: index + 2
            }
          end
        end
      end

      def metadata
        @sources.sort_by { |source| [source.kind, source.path] }.map do |source|
          bytes = File.binread(source.path)
          {
            kind: source.kind,
            path: source.display_path,
            digest: "sha256:#{Digest::SHA256.hexdigest(bytes)}",
            bytes: bytes.bytesize
          }
        end
      end

      private

      def sources(kind)
        @sources.select { |source| source.kind == kind.to_s }
                .sort_by(&:display_path)
      end
    end
  end
end
