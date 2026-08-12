# frozen_string_literal: true

require "csv"
require "digest"
require "json"
require_relative "score_observation/canonical"
require_relative "annotation_observation/source_set"
require_relative "annotation_observation/score_features"
require_relative "annotation_observation/score_index"
require_relative "annotation_observation/profile"
require_relative "annotation_observation/openscore_hauptstimme"
require_relative "annotation_observation/s3"

module Partitura
  module AnnotationObservation
    SCHEMA_VERSION = 1
    PROJECTOR = "partitura-annotation-observation-v1-r1"
    PROFILES = {
      "openscore_hauptstimme_v1" => OpenScoreHauptstimme,
      "s3_v1" => S3
    }.freeze
    PROFILE_CATALOG = {
      "openscore_hauptstimme_v1" => {
        annotation_kinds: [
          { kind: "hauptstimme_annotations", required: true, cardinality: "one_or_more" },
          { kind: "part_relations", required: false, cardinality: "zero_or_more" }
        ],
        targets: %w[prominent_part structural_part_relation material_recurrence seam_boundary],
        docs: ["docs/architecture/partitura/11_annotation_observation.md"]
      },
      "s3_v1" => {
        annotation_kinds: [
          { kind: "s3_downbeats", required: true, cardinality: "one_or_more" },
          { kind: "s3_time_signature", required: true, cardinality: "one_or_more" },
          { kind: "s3_form", required: true, cardinality: "one_or_more" },
          { kind: "s3_cadence", required: false, cardinality: "zero_or_more" },
          { kind: "s3_harmony", required: false, cardinality: "zero_or_more" },
          { kind: "s3_orchestral_texture", required: false, cardinality: "zero_or_more" }
        ],
        targets: %w[
          form_section cadence_type harmonic_function orchestral_role material_recurrence seam_boundary
        ],
        docs: ["docs/architecture/partitura/11_annotation_observation.md"]
      }
    }.transform_values do |profile|
      profile.fetch(:annotation_kinds).each(&:freeze).freeze
      profile.fetch(:targets).freeze
      profile.fetch(:docs).freeze
      profile.freeze
    end.freeze

    class Error < StandardError
      attr_reader :code

      def initialize(code, message)
        @code = code.to_s.freeze
        super(message)
      end

      def to_h
        {
          status: "error",
          code: code,
          message: message,
          repair_instruction: "Run `partitura catalog annotation-profiles --json`, then use a listed profile " \
                              "with matching, digest-stable annotation sources.",
          help_topic: "annotation_observation",
          docs: ["docs/architecture/partitura/11_annotation_observation.md"]
        }
      end
    end

    module_function

    def from_paths(score_observation_path, profile:, annotations:)
      profile_class = PROFILES[profile.to_s]
      unless profile_class
        raise Error.new(
          "unknown_annotation_profile",
          "unknown annotation profile: #{profile}; available: #{PROFILES.keys.sort.join(', ')}"
        )
      end
      observation = read_observation(score_observation_path)
      sources = SourceSet.new(annotations)

      index = ScoreIndex.new(observation)
      projection = profile_class.new(index, sources).project
      payload = {
        schema_version: SCHEMA_VERSION,
        projector: PROJECTOR,
        profile: profile.to_s,
        score_observation_digest: index.observation_digest,
        annotation_sources: sources.metadata,
        examples: projection.fetch(:examples),
        audits: projection.fetch(:audits),
        warnings: projection.fetch(:warnings),
        summary: summary(projection)
      }
      ScoreObservation::Canonical.value(
        payload.merge(annotation_observation_digest: ScoreObservation::Canonical.digest(payload))
      )
    rescue CSV::MalformedCSVError, JSON::ParserError, ArgumentError, KeyError => error
      raise Error.new("invalid_annotation_data", error.message), cause: error
    end

    def read_observation(path)
      document = JSON.parse(File.read(path, encoding: Encoding::UTF_8))
      claimed = document.fetch("observation_digest")
      payload = document.reject { |key, _| key == "observation_digest" }
      actual = ScoreObservation::Canonical.digest(payload)
      return document if claimed == actual

      raise Error.new(
        "score_observation_digest_mismatch",
        "score observation digest mismatch: #{claimed} != #{actual}"
      )
    rescue Errno::ENOENT, Errno::EACCES => error
      raise Error.new("unreadable_score_observation", error.message), cause: error
    end

    def summary(projection)
      examples = projection.fetch(:examples)
      target_counts = examples.group_by { |example| example.fetch(:target) }
                              .transform_values(&:length)
                              .sort.to_h
      {
        example_count: examples.length,
        target_counts: target_counts,
        audit_count: projection.fetch(:audits).length,
        failed_audit_count: projection.fetch(:audits).count { |audit| !audit.fetch(:passed) },
        warning_count: projection.fetch(:warnings).length,
        binding_failure_count: 0
      }
    end
  end
end
