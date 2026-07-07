# frozen_string_literal: true

module Partitura
  module Guided
    # Renders the work order for a run's current stage: everything a fresh-context
    # agent needs to execute exactly this stage — the stage instructions inline, the
    # committed artifacts and outstanding flags by name, and the exact next command.
    module Payload
      module_function

      THREAD_FIELDS = %w[weaknesses outputs improvements].freeze
      THREAD_LIMIT = 240

      def render(run)
        return closed_text(run) if run.closed?

        stage = run.current_stage
        lines = header_lines(run, stage)
        lines.concat(flag_lines(run))
        lines.concat(reopened_lines(run, stage))
        lines.concat(thread_lines(run))
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
          open_threads: open_threads(run).map { |origin, field, value| { origin: origin, field: field, value: value } },
          next_command: next_command(stage),
          docs: stage.docs + [run.manifest.principles_path].compact
        }
      end

      def header_lines(run, stage)
        unit_info = stage.iterative ? " (#{stage.unit} units committed: #{run.units_committed.length})" : ""
        [
          "# Stage #{stage.id} - #{stage.name}#{unit_info}",
          "",
          "run: #{run.manifest.id} v#{run.manifest.version} (mode: #{run.mode})",
          "piece: #{run.dir}",
          "source: #{run.state['source'] || '(none registered - pass --source on commit)'}"
        ]
      end

      # A stage that was committed and reopened is re-verified in editing mode, not
      # rubber-stamped: the earlier judgment comes back so the new pass can answer it.
      def reopened_lines(run, stage)
        note = run.last_commit_note(stage.id)
        return [] unless note

        [
          "",
          "REOPENED STAGE - committed before, reopened since. Re-verification is an editing pass, not a",
          "rubber stamp: check `git diff` on the source, and the new pass note must say what changed here",
          "or what you tried to improve and why the music is better without the change.",
          "prior pass note:"
        ] + note.map { |field, value| "  #{field}: #{squeeze(value)}" }
      end

      # Pass-note content has consequences: what earlier passes recorded as weaknesses,
      # outputs, and improvement candidates comes back to every later stage until it is
      # addressed, built on, or consciously carried.
      def thread_lines(run)
        threads = open_threads(run)
        return [] if threads.empty?

        ["", "OPEN THREADS (from your own pass notes - address, build on, or consciously carry each):"] +
          threads.map { |origin, field, value| "- [#{origin}] #{field}: #{value}" }
      end

      def open_threads(run)
        run.committed_notes.flat_map do |stage_id, unit, note|
          origin = unit ? "#{stage_id} #{unit}" : stage_id
          THREAD_FIELDS.filter_map do |field|
            value = note[field].to_s.strip
            next if value.empty? || value.match?(/\Anone\b/i)

            [origin, field, squeeze(value)]
          end
        end
      end

      def squeeze(value)
        text = value.to_s.gsub(/\s+/, " ").strip
        text.length > THREAD_LIMIT ? "#{text[0, THREAD_LIMIT]}..." : text
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
        unless stage.iterative
          return "partitura commit --notes -   (or `partitura next --reason ...` to skip, logged as skipped_audit)"
        end

        flag = stage.unit == "span" ? "--span A-B" : "--unit \"<#{stage.unit} label>\""
        "partitura commit #{flag} --notes -   (repeat per #{stage.unit}; close the stage with " \
          "`partitura commit --stage-complete --notes -`)"
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
