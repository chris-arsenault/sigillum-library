# frozen_string_literal: true

require "digest"
require "fileutils"
require "tempfile"
require_relative "engine"

module Partitura
  module Composer
    class Store
      HEADER = "# frozen_string_literal: true\n# Application-owned Partitura score.\n" \
               "composer_piece <<'PARTITURA_COMPOSER_V1'\n"
      FOOTER = "\nPARTITURA_COMPOSER_V1\n"

      attr_reader :root

      def initialize(root)
        @root = File.realpath(root)
      end

      def path(id)
        Schema.validate!(id, Schema::ID, "piece")
        ordinary = File.join(root, "compositions", "#{id}.rb")
        exploration = File.join(root, "explorations", id, "score.rb")
        if File.exist?(ordinary) && File.exist?(exploration)
          raise Error.new("ambiguous_piece", "#{id} has two score entry points; resolve its identity before editing.")
        end
        safe_path(File.exist?(exploration) || File.symlink?(exploration) ? exploration : ordinary)
      end

      def safe_path(result)
        cursor = result
        while cursor != root
          if File.symlink?(cursor) || (File.exist?(cursor) && File.realpath(cursor) != cursor)
            raise Error.new("unsafe_path",
"The composition path must remain inside its workspace without symbolic links.")
          end
          cursor = File.dirname(cursor)
          raise Error.new("unsafe_path", "The composition path must remain inside its workspace.") if cursor == "/"
        end
        result
      end

      def ids
        directory = File.join(root, "compositions")
        raise Error.new("unsafe_path",
"The compositions directory cannot be a symbolic link.") if File.symlink?(directory)

        ordinary = Dir.glob(File.join(directory, "*.rb")).map { |file| File.basename(file, ".rb") }
        explorations = Dir.glob(File.join(root, "explorations", "*", "score.rb"))
                          .map { |file| File.basename(File.dirname(file)) }
        (ordinary + explorations).uniq.sort
      end

      def source_revision(id)
        target = path(id)
        files = if target.start_with?(File.join(root, "explorations") + "/")
                  Dir.glob(File.join(File.dirname(target), "**", "*.rb"))
                else
                  [target]
                end
        digest = Digest::SHA256.new
        files.each do |file|
          safe_path(file)
          digest.update(file.delete_prefix(root))
          digest.update("\0")
          digest.update(File.binread(file))
          digest.update("\0")
        end
        "sha256:#{digest.hexdigest}"
      end

      def exploration?(id)
        path(id) == File.join(root, "explorations", id, "score.rb")
      end

      def export_revision_path(id)
        safe_path(File.join(File.dirname(path(id)), ".composer-export-revision"))
      end

      def with_lock(id, shared: false)
        lock_path = safe_path(File.join(File.dirname(path(id)), ".composer.lock"))
        File.open(lock_path, File::RDWR | File::CREAT, 0o600) do |lock|
          lock.flock(shared ? File::LOCK_SH : File::LOCK_EX)
          yield
        end
      end

      def adopt(score, expected:)
        id = score.data.fetch("id")
        target = path(id)
        File.open(safe_path(File.join(File.dirname(target), ".composer.lock")), File::RDWR | File::CREAT,
0o600) do |lock|
          lock.flock(File::LOCK_EX)
          unless source_revision(id) == expected
            raise Error.new("stale_revision", "The source changed after adoption preview. Preview it again.")
          end
          source = HEADER + JSON.pretty_generate(score.data) + FOOTER
          atomic_replace(target, source)
          revision(source)
        end
      end

      def read(id)
        source = File.binread(path(id)).force_encoding(Encoding::UTF_8)
        unless source.start_with?(HEADER) && source.end_with?(FOOTER) && source.valid_encoding?
          raise Error.new("unmanaged_source", "#{id} is not an application-owned score; its source was left untouched.")
        end
        data = JSON.parse(source.byteslice(HEADER.bytesize, source.bytesize - HEADER.bytesize - FOOTER.bytesize))
        score = Score.new(data)
        raise Error.new("piece_identity_mismatch",
"The stored piece identity does not match #{id}.") unless data["id"] == id

        [score, revision(source)]
      rescue Errno::ENOENT
        raise Error.new("unknown_piece", "No composition named #{id}.")
      rescue JSON::ParserError => e
        raise Error.new("invalid_source", "Stored musical data is invalid: #{e.message}")
      end

      def write(score, expected:)
        id = score.data.fetch("id")
        target = path(id)
        FileUtils.mkdir_p(File.dirname(target))
        lock_path = File.join(File.dirname(target), ".composer.lock")
        raise Error.new("unsafe_path", "The workspace lock cannot be a symbolic link.") if File.symlink?(lock_path)

        File.open(lock_path, File::RDWR | File::CREAT, 0o600) do |lock|
          lock.flock(File::LOCK_EX)
          check_revision!(id, expected)
          source = HEADER + JSON.pretty_generate(score.data) + FOOTER
          atomic_replace(target, source)
          revision(source)
        end
      end

      def check_revision!(id, expected)
        exists = File.exist?(path(id))
        if expected.nil?
          raise Error.new("piece_exists", "#{id} already exists. Read it before revising.") if exists
        elsif !exists || read(id).last != expected
          raise Error.new("stale_revision", "The music changed. Read it again before applying this revision.")
        end
      end

      def revision(source)
        "sha256:#{Digest::SHA256.hexdigest(source)}"
      end

      def atomic_replace(target, source)
        Tempfile.create([".composer-", ".rb"], File.dirname(target)) do |file|
          file.binmode
          file.write(source)
          file.flush
          file.fsync
          File.rename(file.path, target)
          File.open(File.dirname(target)) { |directory| directory.fsync }
        end
      end
    end
  end
end
