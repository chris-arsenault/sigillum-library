# frozen_string_literal: true

module Partitura
  module Guided
    # Renders the work order for a run's current stage: everything a fresh-context
    # agent needs to execute exactly this stage — the stage instructions inline, the
    # committed artifacts and outstanding flags by name, and the exact next command.
    module Payload
      module_function

      THREAD_LIMIT = 320
      THREAD_RECENT_WINDOW = 10

      # work: false renders the compact between-units payload (an iterative stage's
      # instructions do not change between unit commits).
      def render(run, work: true)
        return closed_text(run) if run.closed?

        stage = run.current_stage
        lines = header_lines(run, stage)
        lines.concat(commission_lines(run, stage))
        lines.concat(flag_lines(run))
        lines.concat(reopened_lines(run, stage))
        lines.concat(thread_lines(run))
        lines.concat(input_lines(run, stage))
        lines.concat(contract_lines(run, stage))
        lines << ""
        if work
          lines << "## Work"
          lines << ""
          stage.docs.each { |doc| lines << File.read(doc).strip << "" }
        else
          lines << "(work instructions unchanged since stage entry - `partitura status` reprints them)"
        end
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
          open_threads: open_threads(run)
            .map { |origin, field, value| { origin: origin, field: field, value: value } },
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
          "source: #{run.state['source'] || '(none registered - pass --source on commit)'}",
          "cli: #{cli_path} (commands below assume it is on PATH; otherwise use this full path)"
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

      # A carry has consequences: an item an earlier pass could not close - a cross-stage
      # dependency, an unknown, or half-finished material - comes back to later stages until
      # one closes it or consciously carries it on. Carries decay mechanically by recency -
      # agents reliably build on what is fresh and reliably never "close" a long list, so
      # working stages see only the recent window while the full ledger returns once, at the
      # merge/closeout stages, where disposition of every carry is the actual work.
      def thread_lines(run)
        stage = run.current_stage
        threads = open_threads(run)
        return [] if threads.empty?

        full_ledger = stage.full_ledger
        shown = full_ledger ? threads : threads.last(THREAD_RECENT_WINDOW)
        header = full_ledger ? "OPEN THREADS - FULL LEDGER (dispose of every carry: close it in source, or " \
                               "consciously carry it forward with a reason):" \
                             : "OPEN THREADS (carries from earlier pass notes - close each here unless it " \
                               "genuinely depends on a later stage; the full ledger returns at merge/closeout):"
        older = threads.length - shown.length
        lines = ["", header] + shown.map { |origin, field, value| "- [#{origin}] #{field}: #{value}" }
        lines << "  (+#{older} older carries held back for the merge/closeout ledger)" if older.positive?
        lines
      end

      def open_threads(run, fields = Manifest::THREAD_FIELDS)
        run.committed_notes.flat_map do |stage_id, unit, note|
          origin = unit ? "#{stage_id} #{unit}" : stage_id
          fields.filter_map do |field|
            value = note[field].to_s.strip
            next if value.empty? || value.match?(/\Anone\b/i)

            [origin, field, squeeze(value)]
          end
        end
      end

      def squeeze(value)
        text = value.to_s.gsub(/\s+/, " ").strip
        return text unless text.length > THREAD_LIMIT

        cut = text.rindex(" ", THREAD_LIMIT) || THREAD_LIMIT
        "#{text[0, cut]}..."
      end

      def cli_path
        File.join(Manifest::LIBRARY_ROOT, "partitura", "bin", "partitura")
      end

      # The caller's commission; it shows while the opening stage is in progress and
      # then lives on in the brief the agent writes.
      def commission_lines(run, stage)
        brief = run.state["brief"]
        return [] unless brief && stage.id == run.manifest.stages(run.mode).first.id

        ["", "COMMISSION: #{brief}",
         "Treat this as the commission. Deviate only where the music demands it, and say why in the brief."]
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
          "  (carries feed forward to later stages as OPEN THREADS - record only what genuinely " \
          "cannot be closed here, e.g. a cross-stage dependency or half-finished material; fix " \
          "anything fixable now rather than logging it. Realized material lives in the score, " \
          "not the pass note - read it with `partitura view <source> material_map`)",
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
