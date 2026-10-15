# frozen_string_literal: true

require_relative "guidance"

module Partitura
  module Composer
    class Resources
      GUIDE_URI = "partitura://composer/guide"

      def initialize(store)
        @store = store
      end

      def list
        [{ uri: GUIDE_URI, name: "Composer guide", mimeType: "text/markdown" }]
      end

      def export_links(result)
        result.fetch(:files, []).map do |file|
          digest = result.fetch(:revision).delete_prefix("sha256:")
          { type: "resource_link", uri: "partitura://exports/#{result.fetch(:piece)}/#{digest}/#{file.fetch(:name)}",
            name: file.fetch(:name), mimeType: file.fetch(:mime_type) }
        end
      end

      def read(uri)
        return { uri: uri, mimeType: "text/markdown", text: Guidance.guide } if uri == GUIDE_URI

        match = uri.match(%r{\Apartitura://exports/([a-z][a-z0-9_]{0,63})/})
        if match && @store.exploration?(match[1])
          return @store.with_lock(match[1], shared: true) { read_export(uri) }
        end
        read_export(uri)
      rescue Errno::ENOENT
        raise Error.new("unknown_resource", "That export is no longer present. Export the music again.")
      end

      def read_export(uri)
        path, filename = export_path(uri)
        if File.size(path) > 16_777_216
          raise Error.new("resource_too_large", "The export exceeds the 16 MB inline resource limit.")
        end
        resource_content(uri, path, filename)
      end

      def export_path(uri)
        match = uri.match(%r{\Apartitura://exports/([a-z][a-z0-9_]{0,63})/([0-9a-f]{64})/([^/]+)\z})
        raise Error.new("unknown_resource", "Choose an artifact resource returned by music_export.") unless match

        id, digest, filename = match.captures
        unless ["#{id}.musicxml", "#{id}.mid"].include?(filename)
          raise Error.new("unknown_resource", "Unknown musical export.")
        end
        relative = export_components(id, digest, filename)
        path = relative.reduce(@store.root) do |parent, component|
          child = File.join(parent, component)
          raise Error.new("unsafe_path", "Export resources cannot follow symbolic links.") if File.symlink?(child)

          child
        end
        [path, filename]
      end

      def export_components(id, digest, filename)
        return ["outputs", "compositions", id, digest, filename] unless @store.exploration?(id)

        marker = @store.export_revision_path(id)
        unless File.read(marker) == "sha256:#{digest}"
          raise Error.new("unknown_resource", "That current export was replaced or is incomplete. Export again.")
        end
        ["outputs", "explorations", id, id, filename]
      end

      def resource_content(uri, path, filename)
        if filename.end_with?(".mid")
          { uri: uri, mimeType: "audio/midi", blob: [File.binread(path)].pack("m0") }
        else
          { uri: uri, mimeType: "application/vnd.recordare.musicxml+xml", text: File.read(path) }
        end
      end
    end
  end
end
