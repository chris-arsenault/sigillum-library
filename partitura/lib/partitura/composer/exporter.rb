# frozen_string_literal: true

require "securerandom"

module Partitura
  module Composer
    class Exporter
      def initialize(store)
        @store = store
      end

      def export(piece, revision:, unwritten:)
        id = piece.id.to_s
        directory = prepare_directory(id)
        current = @store.exploration?(id)
        destination = current ? File.join(directory, id) : File.join(directory, revision.delete_prefix("sha256:"))
        raise Error.new("unsafe_path", "An export revision cannot be a symbolic link.") if File.symlink?(destination)

        if current
          publish_current(piece, destination, revision)
        else
          publish(piece, directory, destination) unless File.directory?(destination)
        end
        files = %W[#{id}.musicxml #{id}.mid].map do |filename|
          path = File.join(destination, filename)
          { name: filename, path: path,
            mime_type: filename.end_with?(".mid") ? "audio/midi" : "application/vnd.recordare.musicxml+xml" }
        end
        { piece: id, revision: revision, text: "MusicXML and MIDI exported locally.",
          files: files, unwritten: unwritten }
      end

      def prepare_directory(id)
        outputs = File.join(@store.root, "outputs")
        kind = @store.exploration?(id) ? "explorations" : "compositions"
        directory = File.join(outputs, kind, id)
        [outputs, File.dirname(directory), directory].each do |path|
          raise Error.new("unsafe_path", "Exports must stay within the workspace.") if File.symlink?(path)
        end
        FileUtils.mkdir_p(directory)
        directory
      end

      def publish_current(piece, destination, revision)
        @store.safe_path(destination)
        FileUtils.mkdir_p(destination)
        xml = Export::MusicXML.render(piece)
        midi = Export::MIDI.render(piece)
        @store.with_lock(piece.id.to_s) do
          # Invalidate the old binding first; a failed publication must not expose
          # a mixed pair under the previously published revision.
          marker = @store.export_revision_path(piece.id.to_s)
          @store.atomic_replace(marker, "")
          { "musicxml" => xml, "mid" => midi }.each do |extension, bytes|
            target = @store.safe_path(File.join(destination, "#{piece.id}.#{extension}"))
            @store.atomic_replace(target, bytes)
          end
          @store.atomic_replace(marker, revision)
        end
      end

      def publish(piece, directory, destination)
        # An immutable revision directory publishes the XML/MIDI pair together.
        temporary = File.join(directory, ".export-#{SecureRandom.hex(8)}")
        Dir.mkdir(temporary, 0o700)
        File.write(File.join(temporary, "#{piece.id}.musicxml"), Export::MusicXML.render(piece))
        File.binwrite(File.join(temporary, "#{piece.id}.mid"), Export::MIDI.render(piece))
        File.rename(temporary, destination)
      rescue Errno::EEXIST, Errno::ENOTEMPTY
        raise unless File.directory?(destination)
      ensure
        FileUtils.remove_entry(temporary) if temporary && File.directory?(temporary)
      end
    end
  end
end
