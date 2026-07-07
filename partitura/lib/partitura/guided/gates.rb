# frozen_string_literal: true

module Partitura
  module Guided
    # Mechanical stage-transition gates. Gates are floors: they verify that required
    # artifacts, compiles, exports, and recorded judgments exist — never that the music
    # is good. The musical verdict lives in the pass note; gates only enforce that it
    # was written.
    module Gates
      Result = Struct.new(:gate, :ok, :detail, keyword_init: true) do
        def to_h = { gate: gate, ok: ok, detail: detail }.compact
      end

      HANDLERS = {
        "artifact_exists" => ->(run:, stage:, argument:, **) { artifact_exists(run, stage, argument) },
        "pass_note_complete" => ->(gate:, note:, **) { pass_note_complete(gate, note) },
        "source_compiles" => ->(run:, **) { source_compiles(run) },
        "lint_max" => ->(run:, argument:, **) { lint_max(run, argument) },
        "export_current" => ->(run:, **) { export_current(run) },
        "no_open_skips" => ->(run:, gate:, **) { no_flagged_stages(run, "skipped", gate) },
        "no_stale_stages" => ->(run:, gate:, **) { no_flagged_stages(run, "stale", gate) },
        "min_units" => ->(run:, stage:, argument:, **) { min_units(run, stage, argument) },
        "units_cover_source_bars" => ->(run:, stage:, gate:, **) { units_cover_source_bars(run, stage, gate) }
      }.freeze

      module_function

      def evaluate(gates, run:, stage:, note: nil)
        gates.map { |gate| evaluate_one(gate, run: run, stage: stage, note: note) }
      end

      def evaluate_one(gate, run:, stage:, note:)
        name, argument = gate.split(":", 2)
        handler = HANDLERS[name]
        return Result.new(gate: gate, ok: false, detail: "unknown gate #{gate.inspect} (manifest bug)") unless
          handler

        instance_exec(gate: gate, run: run, stage: stage, note: note, argument: argument, &handler)
      end

      def artifact_exists(run, stage, artifact_id)
        gate = "artifact_exists:#{artifact_id}"
        artifact = stage.artifacts.find { |candidate| candidate.fetch("id") == artifact_id }
        return Result.new(gate: gate, ok: false, detail: "artifact #{artifact_id} not declared (manifest bug)") unless
          artifact

        path = File.expand_path(artifact.fetch("path"), run.dir)
        ok = File.exist?(path) && !File.zero?(path)
        Result.new(gate: gate, ok: ok,
                   detail: ok ? nil : "write #{artifact.fetch('path')} (relative to the piece directory) first")
      end

      def pass_note_complete(gate, note)
        ok = note.is_a?(Hash) && !note.empty?
        Result.new(gate: gate, ok: ok, detail: ok ? nil : "provide --notes with the structured pass note")
      end

      def source_compiles(run)
        gate = "source_compiles"
        source = run.source_path
        return Result.new(gate: gate, ok: false, detail: "no source registered; rerun with --source PATH") unless
          source
        return Result.new(gate: gate, ok: false, detail: "source #{source} does not exist") unless File.exist?(source)

        response = compile_response(source)
        ok = response[:status] == "ok" || response["status"] == "ok"
        Result.new(gate: gate, ok: ok,
                   detail: ok ? nil : "compile error #{response[:code] || response['code']}: " \
                                      "#{response[:message] || response['message']}")
      end

      def lint_max(run, level)
        gate = "lint_max:#{level}"
        source = run.source_path
        return Result.new(gate: gate, ok: false, detail: "no source registered; rerun with --source PATH") unless
          source && File.exist?(source)

        offending = lint_offenders(source, level)
        Result.new(gate: gate, ok: offending.empty?, detail: offending.empty? ? nil : offending.join(", "))
      rescue Partitura::Production::CompileError => e
        Result.new(gate: gate, ok: false, detail: "compile error #{e.response[:code]}: #{e.response[:message]}")
      end

      def lint_offenders(source, level)
        piece = Partitura.load_production_file(source)
        levels = level == "warn" ? %w[warn error] : %w[error]
        Partitura::Production::Lint.run(piece)
                                   .select { |lint| levels.include?(lint[:level]) }
                                   .map { |lint| "#{lint[:rule]}(#{lint[:phrase]})" }
                                   .uniq
      end

      # Mirrors production_export's output derivation: outputs/<source-dir-rel>/<stem>/
      # under the source's git root. Requires the transport JSON to exist and be newer
      # than the source.
      def export_current(run)
        gate = "export_current"
        source = run.source_path
        return Result.new(gate: gate, ok: false, detail: "no source registered; rerun with --source PATH") unless
          source && File.exist?(source)

        transport = export_transport_path(source)
        return Result.new(gate: gate, ok: false,
                          detail: "no export found at #{transport}; run `partitura export #{source}`") unless
          File.exist?(transport)

        ok = File.mtime(transport) >= File.mtime(source)
        Result.new(gate: gate, ok: ok,
                   detail: ok ? nil : "export at #{transport} is older than the source; re-export")
      end

      def export_transport_path(source)
        source_abs = File.expand_path(source)
        repo_root = `git -C #{File.dirname(source_abs)} rev-parse --show-toplevel 2>/dev/null`.chomp
        repo_root = File.dirname(source_abs) if repo_root.empty?
        stem = File.basename(source_abs, File.extname(source_abs))
        source_rel = source_abs.delete_prefix("#{repo_root}/")
        File.join(repo_root, "outputs", File.dirname(source_rel), stem, "#{stem}.partitura_transport.json")
      end

      def min_units(run, stage, argument)
        needed = Integer(argument)
        count = run.units_committed(stage.id).length
        Result.new(gate: "min_units:#{argument}", ok: count >= needed,
                   detail: count >= needed ? nil : "#{count} #{stage.unit} unit(s) committed; at least #{needed} " \
                                                   "required before --stage-complete")
      end

      # Attention coverage, not a quality score: every bar of every section must belong
      # to some committed unit before the stage may close.
      def units_cover_source_bars(run, stage, gate)
        source = run.source_path
        return Result.new(gate: gate, ok: false, detail: "no source registered; rerun with --source PATH") unless
          source && File.exist?(source)

        needed = Partitura.load_production_file(source).sections.flat_map { |section| section.bars.to_a }.uniq
        covered = run.units_committed(stage.id).flat_map { |label| unit_bar_numbers(label) }.uniq
        missing = (needed - covered).sort
        Result.new(gate: gate, ok: missing.empty?,
                   detail: missing.empty? ? nil : "bars with no committed #{stage.unit} unit: " \
                                                  "#{compress_bars(missing)}; commit units as --span A-B until " \
                                                  "every bar has had its own pass")
      rescue Partitura::Production::CompileError => e
        Result.new(gate: gate, ok: false, detail: "compile error #{e.response[:code]}: #{e.response[:message]}")
      end

      def unit_bar_numbers(label)
        label.to_s.scan(/(\d+)\s*-\s*(\d+)|(\d+)/).flat_map do |first, last, single|
          single ? [Integer(single)] : (Integer(first)..Integer(last)).to_a
        end
      end

      def compress_bars(numbers)
        numbers.slice_when { |a, b| b > a + 1 }
               .map { |group| group.length > 1 ? "#{group.first}-#{group.last}" : group.first.to_s }
               .join(", ")
      end

      def no_flagged_stages(run, status, gate)
        flagged = run.stages_with_status(status)
        Result.new(gate: gate, ok: flagged.empty?,
                   detail: flagged.empty? ? nil : "#{status} stages: #{flagged.join(', ')} - return with " \
                                                  "`partitura back --to <stage>` and commit them")
      end

      def compile_response(source)
        Partitura.load_production_file(source).compile_response
      rescue Partitura::Production::CompileError => e
        e.response
      end
    end
  end
end
