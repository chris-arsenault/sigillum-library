# frozen_string_literal: true

require "fileutils"
require "open3"
require "tmpdir"
require_relative "models"

module Partitura
  module Production
    module CompositionWorkflow
      class Artifact
        attr_reader :kind, :filename, :digest, :content

        def initialize(kind:, filename:, content:)
          @kind = kind.to_sym
          @filename = filename.to_s.freeze
          @content = content.b.freeze
          @digest = "sha256:#{Digest::SHA256.hexdigest(@content)}"
          freeze
        end

        def to_h
          { kind: kind, filename: filename, digest: digest }
        end
      end

      class Execution
        attr_reader :candidate_id, :passed, :stage, :before_snapshot, :after_snapshot,
                    :accepted_source_digest, :candidate_source_digest, :candidate_source,
                    :compile_response, :artifacts, :commands, :failure_code, :failure_message

        def initialize(candidate_id:, passed:, stage:, before_snapshot:, after_snapshot: nil,
                       accepted_source_digest: nil, candidate_source_digest: nil,
                       candidate_source: nil, compile_response: {}, artifacts: [], commands: [],
                       failure_code: nil, failure_message: nil)
          @candidate_id = candidate_id.to_s.freeze
          @passed = passed
          @stage = stage.to_sym
          @before_snapshot = before_snapshot
          @after_snapshot = after_snapshot
          @accepted_source_digest = accepted_source_digest
          @candidate_source_digest = candidate_source_digest
          @candidate_source = candidate_source&.b&.freeze
          @compile_response = CompositionGraph::Canonical.immutable(compile_response)
          @artifacts = artifacts.freeze
          @commands = commands.freeze
          @failure_code = failure_code&.to_s
          @failure_message = failure_message&.to_s
          validate_execution
          freeze
        end

        def score_changed?
          after_snapshot && after_snapshot.snapshot_digest != before_snapshot.snapshot_digest
        end

        def mechanical_result(action)
          CriticResult.new(
            critic: "partitura-candidate-executor",
            scale: :mechanical,
            target_path: action.target_path,
            candidate_id: candidate_id,
            findings: [
              passed ? "Partitura compile, snapshot, and export passed in an isolated source." :
                       "#{stage}: #{failure_message}"
            ],
            features: {
              score_changed: score_changed? ? 1.0 : 0.0,
              artifact_count: artifacts.length.to_f
            },
            passed: passed
          )
        end

        private

        def validate_execution
          unless passed == true || passed == false
            raise Error.new("invalid_execution", "execution passed must be boolean")
          end
          if passed
            unless stage == :complete && after_snapshot && accepted_source_digest &&
                   candidate_source_digest && candidate_source && !failure_code && !failure_message
              raise Error.new("invalid_execution", "passed execution lacks validated source provenance")
            end
          elsif failure_code.to_s.empty? || failure_message.to_s.empty?
            raise Error.new("invalid_execution", "failed execution requires a code and message")
          end
        end
      end

      class CandidateExecutor
        PATCH_HEADER = /\A(---|\+\+\+) (.+?)(?:\t.*)?\z/

        def initialize(git: "git", artifact_resolver: nil)
          @git = git
          @artifact_resolver = artifact_resolver
        end

        def load_snapshot(source_path)
          piece = Production.load_file(File.expand_path(source_path))
          CompositionGraph::Snapshot.new(piece)
        rescue SyntaxError => e
          raise Error.new("source_load_failed", e.message)
        rescue Production::CompileError => e
          raise Error.new("source_load_failed", e.message, details: e.response)
        end

        def execute(source_path:, snapshot:, action:, candidate:, export: true)
          source = File.expand_path(source_path)
          accepted, patch = execution_inputs(source, snapshot, action, candidate)
          commands = []
          Dir.mktmpdir("partitura-candidate-") do |dir|
            execute_in_sandbox(
              dir, source, accepted, patch, snapshot, candidate, commands, export
            )
          end
        ensure
          if accepted && File.file?(source) && File.binread(source) != accepted
            raise Error.new("accepted_source_changed", "accepted source changed during candidate execution")
          end
        end

        def render_accepted(source_path:, snapshot:)
          source = File.expand_path(source_path)
          unless File.file?(source)
            raise Error.new("missing_source", "accepted source does not exist: #{source}")
          end

          verify_live_snapshot(source, snapshot)
          render_artifacts(Production.load_file(source))
        rescue Production::CompileError => e
          raise Error.new("export_failed", e.message, details: e.response)
        end

        private

        def execution_inputs(source, snapshot, action, candidate)
          unless File.file?(source)
            raise Error.new("missing_source", "accepted source does not exist: #{source}")
          end
          validate_contract(snapshot, action, candidate)
          accepted = File.binread(source)
          verify_live_snapshot(source, snapshot)
          [accepted, resolve_patch(candidate)]
        end

        def verify_live_snapshot(source, expected)
          live = load_snapshot(source)
          return if [live.graph_digest, live.snapshot_digest] ==
                    [expected.graph_digest, expected.snapshot_digest]

          raise Error.new("stale_candidate", "accepted source no longer matches the supplied snapshot")
        end

        def execute_in_sandbox(dir, source, accepted, patch, snapshot, candidate, commands, export)
          candidate_path = File.join(dir, File.basename(source))
          File.binwrite(candidate_path, accepted)
          patch_failure = apply_patch(dir, File.basename(source), patch, commands)
          return patch_execution_failure(
            candidate, snapshot, patch_failure, commands, accepted
          ) if patch_failure

          evaluate_candidate(
            candidate_path, accepted, snapshot, candidate, commands, export
          )
        end

        def patch_execution_failure(candidate, snapshot, message, commands, accepted)
          failure(
            candidate, snapshot, :patch, "patch_rejected", message, commands,
            accepted_source_digest: digest(accepted)
          )
        end

        def evaluate_candidate(path, accepted, snapshot, candidate, commands, export)
          source = File.binread(path)
          source_digest = digest(source)
          piece, response = compile_candidate(path)
          return compile_failure(
            candidate, snapshot, commands, accepted, source_digest, response
          ) unless piece && response.fetch(:status) == "ok"

          complete_execution(
            candidate, snapshot, commands, accepted, source, source_digest,
            piece, response, export
          )
        end

        def compile_failure(candidate, snapshot, commands, accepted, source_digest, response)
          failure(
            candidate, snapshot, :compile, "compile_failed",
            response.fetch(:message, "Partitura compile failed"), commands,
            accepted_source_digest: digest(accepted),
            candidate_source_digest: source_digest,
            compile_response: response
          )
        end

        def complete_execution(candidate, snapshot, commands, accepted, source,
                               source_digest, piece, response, export)
          Execution.new(
            candidate_id: candidate.candidate_id,
            passed: true,
            stage: :complete,
            before_snapshot: snapshot,
            after_snapshot: CompositionGraph::Snapshot.new(piece),
            accepted_source_digest: digest(accepted),
            candidate_source_digest: source_digest,
            candidate_source: source,
            compile_response: response,
            artifacts: export ? render_artifacts(piece) : [],
            commands: commands
          )
        rescue Error, Production::CompileError => e
          output_failure(candidate, snapshot, commands, accepted, source_digest, response, e)
        end

        def output_failure(candidate, snapshot, commands, accepted, source_digest, response, error)
          code = error.respond_to?(:code) ? error.code : "candidate_output_failed"
          failure(
            candidate, snapshot, :output, code, error.message, commands,
            accepted_source_digest: digest(accepted),
            candidate_source_digest: source_digest,
            compile_response: response
          )
        end

        def validate_contract(snapshot, action, candidate)
          unless [action.base_graph_digest, action.base_snapshot_digest] ==
                 [snapshot.graph_digest, snapshot.snapshot_digest]
            raise Error.new("stale_candidate", "action targets another composition snapshot")
          end
          snapshot.graph.require_stable(action.target_path)
          candidate.validate_for(action)
          candidate.touched_paths.each { |path| snapshot.graph.require_stable(path) }
        rescue ArgumentError => e
          raise Error.new("candidate_contract_mismatch", e.message)
        end

        def resolve_patch(candidate)
          return candidate.source_patch if candidate.source_patch
          unless @artifact_resolver
            raise Error.new("missing_artifact_resolver", "external patch needs an artifact resolver")
          end

          patch = @artifact_resolver.call(candidate.artifact)
          unless patch.is_a?(String) && !patch.empty? && digest(patch) == candidate.patch_digest
            raise Error.new("candidate_digest_mismatch", "resolved patch does not match candidate digest")
          end
          patch
        end

        def apply_patch(dir, source_name, patch, commands)
          validate_patch_paths(patch, source_name)
          check = run_git(dir, %w[apply --check --whitespace=nowarn -], patch)
          commands << check
          return command_failure(check, "git apply --check rejected the patch") unless check.fetch(:success)

          applied = run_git(dir, %w[apply --whitespace=nowarn -], patch)
          commands << applied
          return command_failure(applied, "git apply rejected the patch") unless applied.fetch(:success)

          nil
        rescue Error => e
          e.message
        end

        def validate_patch_paths(patch, source_name)
          headers = patch.lines.filter_map do |line|
            match = PATCH_HEADER.match(line.chomp)
            [match[1], match[2]] if match
          end
          old = headers.select { |marker, _path| marker == "---" }.map(&:last)
          new_paths = headers.select { |marker, _path| marker == "+++" }.map(&:last)
          unless old.one? && new_paths.one?
            raise Error.new("unsafe_patch", "candidate must target exactly one source file")
          end
          (old + new_paths).each do |raw|
            path = raw.sub(%r{\A[ab]/}, "")
            if raw.start_with?("/") || path.split("/").include?("..") ||
               raw == "/dev/null" || path != source_name
              raise Error.new("unsafe_patch", "patch path must target #{source_name}, got #{raw}")
            end
          end
        end

        def run_git(dir, arguments, patch)
          stdout, stderr, status = Open3.capture3(
            @git, *arguments, stdin_data: patch, chdir: dir
          )
          {
            argv: [@git, *arguments],
            success: status.success?,
            status: status.exitstatus,
            stdout: stdout,
            stderr: stderr
          }.freeze
        rescue SystemCallError => e
          raise Error.new("executor_unavailable", "could not run #{@git}: #{e.message}")
        end

        def compile_candidate(path)
          piece = Production.load_file(path)
          response = piece.compile_response
          [piece, response]
        rescue SyntaxError => e
          [nil, {
            status: "error",
            code: "ruby_syntax_error",
            message: stable_candidate_detail(e.message, path)
          }]
        rescue Production::CompileError => e
          [nil, stable_candidate_detail(e.response, path)]
        rescue StandardError => e
          [nil, {
            status: "error",
            code: e.class.name,
            message: stable_candidate_detail(e.message, path)
          }]
        end

        def stable_candidate_detail(value, path)
          case value
          when Hash
            value.to_h { |key, item| [key, stable_candidate_detail(item, path)] }
          when Array
            value.map { |item| stable_candidate_detail(item, path) }
          when String
            value.gsub(File.expand_path(path), File.basename(path))
          else
            value
          end
        end

        def render_artifacts(piece)
          [
            Artifact.new(
              kind: :musicxml,
              filename: "candidate.musicxml",
              content: Partitura.production_musicxml(piece)
            ),
            Artifact.new(
              kind: :midi,
              filename: "candidate.mid",
              content: Partitura.production_midi(piece)
            )
          ]
        rescue Production::CompileError => e
          raise Error.new("export_failed", e.message, details: e.response)
        end

        def failure(candidate, snapshot, stage, code, message, commands, **provenance)
          Execution.new(
            candidate_id: candidate.candidate_id,
            passed: false,
            stage: stage,
            before_snapshot: snapshot,
            commands: commands,
            failure_code: code,
            failure_message: message,
            **provenance
          )
        end

        def command_failure(command, fallback)
          command.fetch(:stderr).strip.then do |detail|
            detail.empty? ? fallback : "#{fallback}: #{detail}"
          end
        end

        def digest(value)
          "sha256:#{Digest::SHA256.hexdigest(value)}"
        end
      end
    end
  end
end
