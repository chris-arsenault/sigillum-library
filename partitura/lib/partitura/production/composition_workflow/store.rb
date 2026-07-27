# frozen_string_literal: true

require "fileutils"
require "json"
require_relative "state_models"

module Partitura
  module Production
    module CompositionWorkflow
      class TrajectoryStore
        attr_reader :path, :context

        def initialize(path, context: nil)
          @path = File.expand_path(path)
          @context_explicit = !context.nil?
          @context = context || default_context
        end

        def load
          return [] unless File.exist?(path)

          transitions = File.readlines(
            path, chomp: true, encoding: Encoding::UTF_8
          ).filter_map.with_index do |line, index|
            next if line.strip.empty?

            parsed = JSON.parse(line)
            Transition.from_h(parsed)
          rescue JSON::ParserError, Error => e
            raise Error.new(
              "invalid_trajectory",
              "invalid trajectory record at line #{index + 1}: #{e.message}"
            )
          end
          reconcile_context(transitions)
          transitions
        end

        def append(transition)
          validate_context(transition)
          directory = File.dirname(path)
          FileUtils.mkdir_p(directory)
          File.open(path, File::RDWR | File::CREAT | File::APPEND, 0o644) do |file|
            file.flock(File::LOCK_EX)
            validate_tail(file, transition)
            file.write(JSON.generate(transition.to_h))
            file.write("\n")
            file.flush
            file.fsync
          ensure
            file&.flock(File::LOCK_UN)
          end
          transition
        end

        private

        def default_context
          digest = Digest::SHA256.hexdigest(path)[0, 20]
          TrajectoryContext.new(
            run_id: "run:#{digest}", origin: :deterministic, quality_label: :unrated
          )
        end

        def reconcile_context(transitions)
          return if transitions.empty?

          contexts = transitions.map(&:trajectory_context).map(&:to_h).uniq
          unless contexts.one?
            raise Error.new("invalid_trajectory", "trajectory mixes incompatible run contexts")
          end
          loaded = transitions.first.trajectory_context
          if @context_explicit && loaded.to_h != context.to_h
            raise Error.new("trajectory_context_mismatch", "stored trajectory has another run context")
          end
          @context = loaded
        end

        def validate_context(transition)
          return if transition.trajectory_context.to_h == context.to_h

          raise Error.new("trajectory_context_mismatch", "transition has another run context")
        end

        def validate_tail(file, transition)
          file.rewind
          last = file.each_line.filter_map do |line|
            JSON.parse(line) unless line.strip.empty?
          rescue JSON::ParserError => e
            raise Error.new("invalid_trajectory", "trajectory contains invalid JSON: #{e.message}")
          end.last
          return unless last

          tail = Transition.from_h(last)
          unless [tail.after_graph_digest, tail.after_snapshot_digest] ==
                 [transition.before_graph_digest, transition.before_snapshot_digest]
            raise Error.new("trajectory_not_contiguous", "transition does not continue the stored trajectory")
          end
          if tail.transition_id == transition.transition_id
            raise Error.new("duplicate_transition", "transition is already present in the trajectory")
          end
        end
      end
    end
  end
end
