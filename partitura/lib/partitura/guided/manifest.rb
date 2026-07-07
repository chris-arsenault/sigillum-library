# frozen_string_literal: true

require "json"

module Partitura
  module Guided
    class ManifestError < StandardError; end

    # A guided procedure definition: ordered stages with docs, artifacts, and gates,
    # loaded from reference/written/procedures/partitura/<id>/manifest.json. Manifests
    # describe music-composition procedures only; the engine assumes a piece directory,
    # a DSL source, and compile/lint/export gates.
    class Manifest
      LIBRARY_ROOT = File.expand_path("../../../..", __dir__)
      PROCEDURES_DIR = File.join(LIBRARY_ROOT, "reference", "written", "procedures", "partitura")

      Stage = Struct.new(:id, :name, :docs, :artifacts, :gates, :stage_complete_gates,
                         :iterative, :unit, keyword_init: true)

      attr_reader :id, :version, :title, :principles_path, :pass_note_fields

      def self.list
        Dir[File.join(PROCEDURES_DIR, "*", "manifest.json")].map { |path| File.basename(File.dirname(path)) }.sort
      end

      def self.load(id)
        dir = File.join(PROCEDURES_DIR, id.to_s)
        path = File.join(dir, "manifest.json")
        unless File.exist?(path)
          raise ManifestError, "unknown procedure #{id.inspect}; available: #{list.join(', ')}"
        end

        new(JSON.parse(File.read(path)), dir)
      end

      def initialize(data, dir)
        @dir = dir
        @id = data.fetch("id")
        @version = data.fetch("version")
        @title = data.fetch("title")
        @principles_path = data["principles"] && File.join(dir, data.fetch("principles"))
        @pass_note_fields = data.fetch("pass_note_fields", %w[decisions verdict])
        @raw_stages = data.fetch("stages")
        @collapse = (data.dig("miniature", "collapse") || []).map { |group| group.map(&:to_s) }
      end

      # Effective ordered stages for a mode. Miniature mode merges each collapse group
      # into its head stage: docs, artifacts, and gates are unioned so one commit
      # satisfies the whole group.
      def stages(mode = "full")
        return @raw_stages.map { |raw| build_stage([raw]) } unless mode == "miniature"

        absorbed = @collapse.flat_map { |group| group[1..] }
        @raw_stages.filter_map do |raw|
          build_stage(collapse_members(raw)) unless absorbed.include?(raw.fetch("id"))
        end
      end

      def collapse_members(raw)
        group_ids = @collapse.find { |group| group.first == raw.fetch("id") } || [raw.fetch("id")]
        group_ids.filter_map { |member_id| @raw_stages.find { |candidate| candidate.fetch("id") == member_id } }
      end

      def stage(stage_id, mode = "full")
        stages(mode).find { |stage| stage.id == stage_id.to_s } ||
          raise(ManifestError, "unknown stage #{stage_id.inspect} in #{@id} (mode #{mode}); " \
                               "stages: #{stages(mode).map(&:id).join(', ')}")
      end

      def stage_after(stage_id, mode = "full")
        ordered = stages(mode)
        index = ordered.index { |stage| stage.id == stage_id.to_s }
        raise ManifestError, "unknown stage #{stage_id.inspect}" unless index

        ordered[index + 1]
      end

      def doc_path(relative)
        File.join(@dir, relative)
      end

      private

      def build_stage(members)
        Stage.new(
          id: members.first.fetch("id"),
          name: members.map { |member| member.fetch("name") }.join(" + "),
          docs: members.map { |member| doc_path(member.fetch("doc")) },
          artifacts: members.flat_map { |member| member.fetch("artifacts", []) },
          gates: merged_gates(members, "gates"),
          stage_complete_gates: merged_gates(members, "stage_complete_gates"),
          iterative: members.any? { |member| member["iterative"] },
          unit: members.filter_map { |member| member["unit"] }.first
        )
      end

      def merged_gates(members, key)
        members.flat_map { |member| member.fetch(key, []) }.uniq
      end
    end
  end
end
