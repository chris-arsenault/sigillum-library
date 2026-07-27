# frozen_string_literal: true

require "tempfile"
require_relative "executor"

module Partitura
  module Production
    module CompositionWorkflow
      class CandidatePromoter
        def initialize(executor:)
          @executor = executor
        end

        def promote(source_path:, before_snapshot:, action:, candidate:, execution:, &persistence)
          source = File.expand_path(source_path)
          original, mode = promotion_context(
            source, before_snapshot, action, candidate, execution
          )
          atomic_replace(source, execution.candidate_source, mode)
          verify_or_rollback(
            source, original, mode, execution.after_snapshot, &persistence
          )
        end

        private

        def promotion_context(source, before_snapshot, action, candidate, execution)
          candidate.validate_for(action)
          validate_execution(before_snapshot, candidate, execution)
          original = File.binread(source)
          unless digest(original) == execution.accepted_source_digest
            raise Error.new("promotion_stale", "accepted source bytes changed after candidate execution")
          end
          live = @executor.load_snapshot(source)
          unless same_snapshot?(live, before_snapshot)
            raise Error.new("promotion_stale", "accepted score snapshot changed after candidate execution")
          end

          [original, File.stat(source).mode & 0o777]
        end

        def verify_or_rollback(source, original, mode, expected, &persistence)
          promoted = @executor.load_snapshot(source)
          unless same_snapshot?(promoted, expected)
            raise Error.new(
              "promotion_verification_failed",
              "promoted source does not reproduce the sandbox snapshot"
            )
          end
          persistence&.call(promoted)
          promoted
        rescue Exception => error # SyntaxError is not a StandardError; rollback must still happen.
          rollback(source, original, mode)
          raise error if error.is_a?(Error)

          raise Error.new("promotion_verification_failed", error.message)
        end

        def rollback(source, original, mode)
          atomic_replace(source, original, mode)
        rescue StandardError => error
          raise Error.new(
            "promotion_rollback_failed",
            "promotion failed and rollback also failed: #{error.message}"
          )
        end

        def validate_execution(before_snapshot, candidate, execution)
          unless execution.passed && execution.after_snapshot &&
                 execution.candidate_id == candidate.candidate_id &&
                 same_snapshot?(execution.before_snapshot, before_snapshot)
            raise Error.new("invalid_promotion", "only the matching successful execution may be promoted")
          end
          unless digest(execution.candidate_source) == execution.candidate_source_digest
            raise Error.new("candidate_digest_mismatch", "retained candidate source digest is invalid")
          end
        end

        def same_snapshot?(left, right)
          left && right &&
            [left.graph_digest, left.snapshot_digest] == [right.graph_digest, right.snapshot_digest]
        end

        def atomic_replace(target, content, mode)
          Tempfile.create([".#{File.basename(target)}.promote-", ".rb"], File.dirname(target)) do |file|
            file.binmode
            file.write(content)
            file.flush
            file.fsync
            File.chmod(mode, file.path)
            File.rename(file.path, target)
          end
        end

        def digest(value)
          "sha256:#{Digest::SHA256.hexdigest(value)}"
        end
      end
    end
  end
end
