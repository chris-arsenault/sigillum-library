# frozen_string_literal: true

require_relative "guided/manifest"
require_relative "guided/run"
require_relative "guided/gates"
require_relative "guided/pass_note"
require_relative "guided/payload"

module Partitura
  # The guided procedure engine: interactive, stage-at-a-time execution of the
  # music-composition procedures under reference/written/procedures/partitura/.
  # See docs/architecture/partitura/08_cli_and_guided_runs.md for the design.
  module Guided
    class GateFailure < StandardError
      attr_reader :results

      def initialize(results)
        @results = results
        failures = results.reject(&:ok)
        super("gate(s) failed: #{failures.map { |result| "#{result.gate} (#{result.detail})" }.join('; ')}")
      end
    end

    module_function

    def start(dir, **options)
      run = Run.start(dir, **options)
      [run, Payload.render(run)]
    end

    def status(dir = nil)
      run = Run.locate(dir)
      [run, Payload.render(run)]
    end

    # Validates the pass note, evaluates the stage's gates, and commits. For iterative
    # stages pass `unit:` per unit and `stage_complete: true` to close the stage.
    def commit(dir: nil, notes:, unit: nil, stage_complete: false, source: nil)
      run = Run.locate(dir)
      raise RunError, "this run is closed (#{run.state.dig('closed', 'kind')}); start a new one" if run.closed?

      run.register_source(source) if source
      stage = run.current_stage
      assert_unit_discipline!(stage, unit, stage_complete)
      note = PassNote.parse(notes, run.manifest.pass_note_fields)
      results = Gates.evaluate(gates_for(stage, stage_complete), run: run, stage: stage, note: note)
      raise GateFailure, results unless results.all?(&:ok)

      run.commit(note: note, gate_results: results, unit: unit, stage_complete: stage_complete)
      same_stage = !run.closed? && run.current_stage_id == stage.id
      [run, Payload.render(run, work: !same_stage)]
    end

    def gates_for(stage, stage_complete)
      closing = stage.iterative && stage_complete && stage.stage_complete_gates.any?
      closing ? stage.stage_complete_gates : stage.gates
    end

    def assert_unit_discipline!(stage, unit, stage_complete)
      return unless stage.iterative && unit.nil? && !stage_complete

      raise RunError, "stage #{stage.id} is iterative: commit one #{stage.unit} at a time " \
                      "(--span A-B or --unit \"...\"), then close the stage with --stage-complete. " \
                      "A bare commit does not skip the #{stage.unit} passes."
    end

    def skip(dir: nil, reason:)
      raise RunError, "next requires --reason: say why the audit is being skipped" if reason.to_s.strip.empty?

      run = Run.locate(dir)
      run.skip(reason: reason)
      [run, Payload.render(run)]
    end

    def back(dir: nil, to:, reason:)
      raise RunError, "back requires --reason" if reason.to_s.strip.empty?

      run = Run.locate(dir)
      run.back(to: to, reason: reason)
      [run, Payload.render(run)]
    end

    def abandon(dir: nil, reason:)
      raise RunError, "abandon requires --reason" if reason.to_s.strip.empty?

      run = Run.locate(dir)
      run.abandon(reason: reason)
      run
    end

    def runs(root = Dir.pwd)
      Dir[File.join(root, "**", Run::STATE_DIR, Run::STATE_FILE)]
        .reject { |path| path.include?("_archived_") }
        .map { |path| Run.load(File.dirname(File.dirname(path))) }
    end
  end
end
