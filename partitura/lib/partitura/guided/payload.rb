# frozen_string_literal: true

module Partitura
  module Guided
    # Renders the work order for a run's current stage: everything a fresh-context
    # agent needs to execute exactly this stage — the stage instructions inline, the
    # committed artifacts and outstanding flags by name, and the exact next command.
    module Payload
      module_function

      def render(run)
        return closed_text(run) if run.closed?

        stage = run.current_stage
        lines = header_lines(run, stage)
        lines.concat(flag_lines(run))
        lines.concat(input_lines(run, stage))
        lines.concat(contract_lines(run, stage))
        lines << ""
        lines << "## Work"
        lines << ""
        stage.docs.each { |doc| lines << File.read(doc).strip << "" }
        lines.join("\n")
      end

      def data(run)
        return { status: "closed", closed: run.state["closed"] } if run.closed?

        stage = run.current_stage
        {
          status: "open",
          procedure: run.manifest.id,
          mode: run.mode,
          piece_dir: run.dir,
          source: run.state["source"],
          stage: stage.id,
          stage_name: stage.name,
          iterative: stage.iterative || false,
          units_committed: run.units_committed,
          artifacts: stage.artifacts,
          gates: stage.gates,
          pass_note_fields: run.manifest.pass_note_fields,
          open_flags: open_flags(run),
          next_command: next_command(stage),
          docs: stage.docs + [run.manifest.principles_path].compact
        }
      end

      def header_lines(run, stage)
        progress = run.manifest.stages(run.mode).map(&:id)
        position = "#{progress.index(stage.id) + 1}/#{progress.length}"
        unit_info = stage.iterative ? " (#{stage.unit} units committed: #{run.units_committed.length})" : ""
        [
          "# Stage #{stage.id} - #{stage.name}#{unit_info}",
          "",
          "run: #{run.manifest.id} v#{run.manifest.version} (mode: #{run.mode}, stage #{position})",
          "piece: #{run.dir}",
          "source: #{run.state['source'] || '(none registered - pass --source on commit)'}"
        ]
      end

      def flag_lines(run)
        flags = open_flags(run)
        return [] if flags.empty?

        ["", "OPEN FLAGS (must be resolved before closeout):"] +
          flags.map { |flag, stages| "- #{flag}: #{stages.join(', ')}" }
      end

      def open_flags(run)
        {
          "skipped_audits" => run.stages_with_status("skipped"),
          "stale_stages" => run.stages_with_status("stale")
        }.reject { |_, stages| stages.empty? }
      end

      def input_lines(run, stage)
        lines = ["", "inputs:"]
        committed_artifacts(run).each { |id, path| lines << "  - #{id}: #{path} (committed earlier)" }
        stage.artifacts.each do |artifact|
          lines << "  - #{artifact.fetch('id')}: #{artifact.fetch('path')} (this stage writes it)"
        end
        lines << "  - principles: #{run.manifest.principles_path} (read once per fresh context)" if
          run.manifest.principles_path
        lines
      end

      def committed_artifacts(run)
        committed = run.stages_with_status("committed")
        run.manifest.stages(run.mode)
           .select { |stage| committed.include?(stage.id) }
           .flat_map(&:artifacts)
           .to_h { |artifact| [artifact.fetch("id"), artifact.fetch("path")] }
      end

      def contract_lines(run, stage)
        lines = [
          "",
          "pass_note_schema: #{run.manifest.pass_note_fields.join(' | ')}",
          "gates: #{stage.gates.join(', ')}"
        ]
        lines << "stage_complete_gates: #{stage.stage_complete_gates.join(', ')}" if stage.iterative &&
                                                                                     stage.stage_complete_gates.any?
        lines << "next: #{next_command(stage)}"
        lines
      end

      def next_command(stage)
        if stage.iterative
          "partitura commit --#{stage.unit} A-B --notes -   (repeat per #{stage.unit}; close the stage with " \
            "`partitura commit --stage-complete --notes -`)"
        else
          "partitura commit --notes -   (or `partitura next --reason ...` to skip, logged as skipped_audit)"
        end
      end

      def closed_text(run)
        closed = run.state.fetch("closed")
        "# Run #{closed.fetch('kind')} (#{closed.fetch('at')})\n" \
          "procedure: #{run.manifest.id}; piece: #{run.dir}\n" \
          "#{closed['reason'] ? "reason: #{closed['reason']}\n" : ''}" \
          "Start a new run with `partitura start <dir>`."
      end
    end
  end
end
