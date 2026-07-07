# frozen_string_literal: true

require "json"
require "fileutils"
require "time"

module Partitura
  module Guided
    class RunError < StandardError; end

    # One execution of a guided procedure against one piece directory. State lives in
    # <dir>/procedure/run.json (machine state) and <dir>/procedure/log.jsonl (append-
    # only audit); musical artifacts stay as visible files that state only points to.
    class Run
      STATE_DIR = "procedure"
      STATE_FILE = "run.json"
      LOG_FILE = "log.jsonl"

      attr_reader :dir, :state, :manifest

      def self.start(dir, procedure: "dsl_composition", source: nil, miniature: false, force_new: false)
        state_path = File.join(dir, STATE_DIR, STATE_FILE)
        if File.exist?(state_path) && !force_new
          raise RunError, "a run already exists at #{state_path}; resume with `partitura status #{dir}` " \
                          "or archive it with --force-new"
        end

        archive_existing(dir) if File.exist?(state_path)
        manifest = Manifest.load(procedure)
        mode = miniature ? "miniature" : "full"
        state = {
          "procedure" => manifest.id,
          "procedure_version" => manifest.version,
          "mode" => mode,
          "source" => source,
          "started_at" => Time.now.utc.iso8601,
          "current_stage" => manifest.stages(mode).first.id,
          "stages" => manifest.stages(mode).to_h { |stage| [stage.id, { "status" => "pending" }] },
          "units" => {},
          "closed" => nil
        }
        state["stages"][state["current_stage"]]["status"] = "in_progress"
        FileUtils.mkdir_p(File.join(dir, STATE_DIR))
        run = new(dir, state, manifest)
        run.save
        run.append_log("run_started", procedure: manifest.id, version: manifest.version, mode: mode, source: source)
        run
      end

      def self.archive_existing(dir)
        stamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
        FileUtils.mv(File.join(dir, STATE_DIR), File.join(dir, "#{STATE_DIR}_archived_#{stamp}"))
      end

      # Locate a run: the given directory, or search upward from cwd.
      def self.locate(dir = nil)
        candidates = dir ? [File.expand_path(dir)] : ascending_dirs(Dir.pwd)
        found = candidates.find { |candidate| File.exist?(File.join(candidate, STATE_DIR, STATE_FILE)) }
        raise RunError, "no run found#{dir ? " at #{dir}" : " from #{Dir.pwd} upward"}; start one with " \
                        "`partitura start <dir>`" unless found

        load(found)
      end

      def self.ascending_dirs(from)
        dirs = []
        current = File.expand_path(from)
        loop do
          dirs << current
          parent = File.dirname(current)
          break if parent == current

          current = parent
        end
        dirs
      end

      def self.load(dir)
        state = JSON.parse(File.read(File.join(dir, STATE_DIR, STATE_FILE)))
        new(dir, state, Manifest.load(state.fetch("procedure")))
      end

      def initialize(dir, state, manifest)
        @dir = File.expand_path(dir)
        @state = state
        @manifest = manifest
      end

      def mode = state.fetch("mode")
      def current_stage_id = state.fetch("current_stage")
      def current_stage = manifest.stage(current_stage_id, mode)
      def closed? = !state.fetch("closed").nil?

      def source_path
        source = state["source"]
        source && File.expand_path(source, dir)
      end

      def register_source(source)
        state["source"] = source
        save
      end

      def stages_with_status(status)
        state.fetch("stages").select { |_, info| info.fetch("status") == status }.keys
      end

      def units_committed(stage_id = current_stage_id)
        state.fetch("units").fetch(stage_id, [])
      end

      # Commit the current stage (or one unit of an iterative stage). Returns the next
      # stage (nil when the run closes). Gates must have been evaluated by the caller.
      def commit(note:, gate_results:, unit: nil, stage_complete: false)
        ensure_open!
        stage = current_stage
        if stage.iterative && unit
          (state["units"][stage.id] ||= []) << unit
          append_log("unit_committed", stage: stage.id, unit: unit, pass_note: note,
                                       gates: gate_results.map(&:to_h))
          save
          return stage
        end

        state["stages"][stage.id] = { "status" => "committed", "committed_at" => Time.now.utc.iso8601 }
        append_log("stage_committed", stage: stage.id, stage_complete: stage_complete || nil,
                                      pass_note: note, gates: gate_results.map(&:to_h))
        advance_from(stage)
      end

      def skip(reason:)
        ensure_open!
        stage = current_stage
        state["stages"][stage.id] = { "status" => "skipped", "reason" => reason }
        append_log("stage_skipped", stage: stage.id, reason: reason, flag: "skipped_audit")
        advance_from(stage)
      end

      def back(to:, reason:)
        ensure_open!
        target = manifest.stage(to, mode)
        ordered = manifest.stages(mode).map(&:id)
        target_index = ordered.index(target.id)
        current_index = ordered.index(current_stage_id)
        raise RunError, "#{target.id} is not an earlier stage than #{current_stage_id}" unless
          target_index < current_index || state.dig("stages", target.id, "status") == "skipped"

        ordered[(target_index + 1)..].each do |later_id|
          info = state["stages"][later_id]
          info["status"] = "stale" if info["status"] == "committed"
        end
        state["stages"][target.id] = { "status" => "in_progress" }
        state["current_stage"] = target.id
        append_log("stage_reopened", stage: target.id, reason: reason)
        save
        target
      end

      def abandon(reason:)
        ensure_open!
        state["closed"] = { "at" => Time.now.utc.iso8601, "kind" => "abandoned", "reason" => reason }
        append_log("run_abandoned", reason: reason)
        save
      end

      def log_entries
        path = File.join(dir, STATE_DIR, LOG_FILE)
        return [] unless File.exist?(path)

        File.readlines(path).map { |line| JSON.parse(line) }
      end

      # Every committed pass note so far, in order: [stage_id, unit_or_nil, note_hash].
      def committed_notes
        log_entries.filter_map do |entry|
          next unless %w[stage_committed unit_committed].include?(entry["event"])

          [entry["stage"], entry["unit"], entry["pass_note"] || {}]
        end
      end

      # The most recent full-stage commit note for a stage (present when the stage was
      # committed earlier and has been reopened).
      def last_commit_note(stage_id)
        entry = log_entries.reverse.find do |candidate|
          candidate["event"] == "stage_committed" && candidate["stage"] == stage_id.to_s
        end
        entry && entry["pass_note"]
      end

      def append_log(event, **payload)
        entry = { "ts" => Time.now.utc.iso8601, "event" => event }.merge(payload.compact)
        File.open(File.join(dir, STATE_DIR, LOG_FILE), "a") { |file| file.puts(JSON.generate(entry)) }
      end

      def save
        File.write(File.join(dir, STATE_DIR, STATE_FILE), "#{JSON.pretty_generate(state)}\n")
      end

      private

      def ensure_open!
        raise RunError, "this run is closed (#{state.dig('closed', 'kind')}); start a new one" if closed?
      end

      def advance_from(stage)
        next_stage = manifest.stage_after(stage.id, mode)
        if next_stage
          state["current_stage"] = next_stage.id
          state["stages"][next_stage.id]["status"] = "in_progress"
        else
          state["closed"] = { "at" => Time.now.utc.iso8601, "kind" => "completed" }
          append_log("run_closed")
        end
        save
        next_stage
      end
    end
  end
end
