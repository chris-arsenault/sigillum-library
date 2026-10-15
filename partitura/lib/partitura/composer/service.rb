# frozen_string_literal: true

require_relative "store"
require_relative "operations"
require_relative "readout"
require_relative "../export"
require_relative "exporter"
require_relative "references"
require_relative "adoption"

module Partitura
  module Composer
    class Service
      DISPATCH = {
        orient: ->(service, input) { service.orient(input) },
        start: ->(service, input) { service.start(input) },
        adopt: ->(service, input) { service.adopt(input) },
        read: ->(service, input) { service.read(input) },
        revise: ->(service, input) { service.revise(input) },
        inspect_music: ->(service, input) { service.inspect_music(input) },
        export: ->(service, input) { service.export(input) },
        help: ->(service, input) { service.help(input) },
        reference: ->(service, input) { service.reference(input) }
      }.freeze
      attr_reader :store

      def initialize(root: ENV.fetch("PARTITURA_PROJECT_ROOT", Dir.pwd))
        @store = Store.new(root)
      end

      def call(name, input = {})
        DISPATCH.fetch(Contracts.method_for(name, input)).call(self, input)
      end

      def orient(_input)
        quickstart.merge(guide: Guidance.guide)
      end

      def help(input)
        Guidance.help(input)
      end

      def reference(input)
        result = References.new.call(input)
        result.merge(paginate(result.fetch(:text), input))
      end

      def start(input)
        score = Score.create(**input.transform_keys(&:to_sym))
        checked_piece(score)
        revision = store.write(score, expected: nil)
        response(score, revision, "Composition created. Establish its form, then write its music.")
      end

      def revise(input)
        score, revision = store.read(input.fetch("piece"))
        unless revision == input.fetch("revision")
          raise Error.new("stale_revision", "The music changed. Read it before revising.")
        end
        revised = Operations.new(score).apply(input.fetch("changes"))
        piece = checked_piece(revised)
        preview = input.fetch("preview", false)
        saved_revision = preview ? revision : store.write(revised, expected: revision)
        response(revised, saved_revision, preview ? "Revision preview; music has not been saved." : "Music saved.")
          .merge(preview: preview, diagnostics: piece.compile_response.fetch(:lints, []))
      end

      def adopt(input)
        id = input.fetch("piece")
        path = adoption_path(id)
        preview = input.fetch("preview", true)
        original_revision = store.source_revision(id)
        if !preview && input["source_revision"] != original_revision
          raise Error.new("stale_revision", "Saving adoption needs the source_revision from its current preview.")
        end
        piece = Production.load_file(path)
        score = Adoption.new(piece, id: id, brief: input.fetch("brief")).convert
        unless store.source_revision(id) == original_revision
          raise Error.new("stale_revision", "The source changed during adoption. Preview it again.")
        end
        revision = preview ? nil : store.adopt(score, expected: original_revision)
        response(score, revision, preview ? "Adoption preview; musical parity passed. Source unchanged." :
                                           "Existing score adopted at its original path. Musical parity passed.")
          .merge(preview: preview, source_revision: original_revision,
                 source: path.delete_prefix(store.root + "/"), musical_parity: true)
      rescue Production::CompileError => e
        raise Error.new("invalid_music", e.message, details: { diagnostics: e.response })
      end

      def adoption_path(id)
        path = store.path(id)
        raise Error.new("unknown_piece", "No existing score named #{id}.") unless File.file?(path)
        if File.binread(path).start_with?(Store::HEADER)
          raise Error.new("already_adopted", "#{id} is already managed. Use music_read.")
        end
        path
      end

      def read(input)
        score, revision = store.read(input.fetch("piece"))
        validate_read_scope!(input)
        ensure_revision!(input, revision)
        options = input.slice("section", "passage", "voice").transform_keys(&:to_sym)
        text = Readout.new(score).render(**options)
        text += surrounding_music(score, input) unless input["voice"]
        paginate(text, input.merge("revision" => revision)).merge(piece: score.data.fetch("id"), revision: revision)
      end

      def validate_read_scope!(input)
        if (input["passage"] && !input["section"]) || (input["voice"] && !input["passage"])
          raise Error.new("invalid_scope", "Name the section for a passage, and the passage for a voice.")
        end
      end

      def ensure_revision!(input, revision)
        if input["revision"] && input["revision"] != revision
          raise Error.new("stale_revision", "The music changed during this read. Restart from its first page.")
        end
      end

      def surrounding_music(score, input)
        return "" if score.data.fetch("sections").empty?

        first = input["section"] ? score.section_start(input.fetch("section")) : 1
        length = 8
        if input["passage"]
          passage = score.passage(input.fetch("section"), input.fetch("passage"))
          first += passage.fetch("at") - 1
          length = passage.fetch("bars")
        end
        piece = checked_piece(score)
        from = [1, first - 1].max
        to = [piece.sections.last.bars.end, first + length].min
        "\n\nSounding ensemble context (bars #{from}–#{to}):\n" +
          Production.readout(piece, :ensemble_grid, bars: from..to)
      end

      def quickstart
        pieces = store.ids.map do |id|
          score, revision = store.read(id)
          { piece: id, title: score.data.fetch("title"), revision: revision,
            sections: score.data.fetch("sections").length, unwritten: Readout.new(score).coverage }
        rescue Error => e
          { piece: id, error: e.to_h, needs_adoption: e.code == "unmanaged_source" }
        end
        text = pieces.empty? ? "No compositions yet. Use piece_start with the commission and forces." :
          pieces.map { |piece| "#{piece[:piece]}: #{piece[:title] || piece.dig(:error, :message)}" }.join("\n")
        { text: text, pieces: pieces }
      end

      def inspect_music(input)
        score, revision = store.read(input.fetch("piece"))
        ensure_revision!(input, revision)
        piece = checked_piece(score)
        first = input.fetch("from_bar", 1)
        last = input.fetch("to_bar", [first + 7, [piece.sections.last&.bars&.end || 1, first].max].min)
        if last < first || last - first > 31
          raise Error.new("invalid_range", "Inspect 1–32 consecutive bars at a time.")
        end
        view = input.fetch("view", "ensemble_grid")
        text = Production.readout(piece, view.to_sym, bars: first..last, part: input["part"]&.to_sym)
        paginate(text, input.merge("revision" => revision))
          .merge(piece: score.data.fetch("id"), revision: revision, from_bar: first, to_bar: last)
      end

      def export(input)
        score, revision = store.read(input.fetch("piece"))
        piece = checked_piece(score)
        coverage = Readout.new(score).coverage
        if coverage.any? && !input.fetch("draft", false)
          raise Error.new("unfinished_music", "Unwritten music remains; request a draft export to audition it.",
                          details: { unwritten: coverage })
        end
        if piece.parts.empty? || piece.sections.empty?
          raise Error.new("empty_score", "Write music and assign forces before exporting.")
        end
        Exporter.new(store).export(piece, revision: revision, unwritten: coverage)
      end

      def checked_piece(score)
        piece = Engine.new(score).build
        result = piece.compile_response
        unless result.fetch(:status) == "ok"
          raise Error.new("invalid_music", result.fetch(:message, "The musical revision is invalid."),
                          details: { diagnostics: result })
        end
        piece
      rescue Production::CompileError => e
        raise Error.new("invalid_music", e.message, details: { diagnostics: e.response })
      rescue ArgumentError, KeyError, ZeroDivisionError => e
        raise Error.new("invalid_music", "Check the musical fields: #{e.message}")
      end

      def response(score, revision, message)
        { piece: score.data.fetch("id"), revision: revision,
          text: "#{message}\n\n#{Readout.new(score).overview}" }
      end

      def paginate(text, input)
        offset = input.fetch("offset", 0)
        limit = input.fetch("limit", 12_000)
        if offset.negative? || !limit.between?(1, 24_000) || offset > text.length
          raise Error.new("invalid_page", "Use a valid continuation offset and a limit of 1–24000 characters.")
        end
        next_offset = offset + limit
        more = next_offset < text.length
        { text: text[offset, limit], complete: !more,
          continuation: more ? input.merge("offset" => next_offset, "limit" => limit) : nil }
      end
    end
  end
end
