# frozen_string_literal: true

require "fileutils"
require "json"
require "tmpdir"
require_relative "models"
require_relative "score_measurement"

module Partitura
  module Production
    module Evaluation
      class RenderedSubject
        attr_reader :run_id, :source_digest, :snapshot_digest, :artifacts

        def initialize(run_id:, source_digest:, snapshot_digest:, artifacts:)
          @run_id = run_id.freeze
          @source_digest = source_digest.freeze
          @snapshot_digest = snapshot_digest.freeze
          @artifacts = artifacts.freeze
          freeze
        end
      end

      class ScoreReviewBundle
        attr_reader :review

        def initialize(review:, rendered:)
          @review = review
          @rendered = rendered.freeze
          validate_rendered
          freeze
        end

        def write(output_directory)
          root = File.expand_path(output_directory)
          FileUtils.mkdir_p(root)
          target = File.join(root, review.bundle_name)
          if File.exist?(target)
            raise Error.new("duplicate_evaluation_review", "review bundle already exists: #{target}")
          end

          temporary = Dir.mktmpdir(".#{review.bundle_name}-", root)
          write_bundle(temporary, target)
          target
        end

        private

        def write_bundle(temporary, target)
          write_artifacts(temporary)
          File.write(
            File.join(temporary, "review.json"),
            JSON.pretty_generate(review.public_h)
          )
          File.rename(temporary, target)
        rescue StandardError
          FileUtils.remove_entry(temporary) if File.exist?(temporary)
          raise
        end

        def write_artifacts(directory)
          review.subjects.each do |subject|
            @rendered.fetch(subject.label).artifacts.each do |artifact|
              filename = subject.artifacts.fetch(artifact.kind.to_s).fetch("filename")
              File.binwrite(File.join(directory, filename), artifact.content)
            end
          end
        end

        def validate_rendered
          unless @rendered.keys.sort == LABELS
            raise Error.new("invalid_evaluation_record", "rendered review requires A and B")
          end
          review.subjects.each do |subject|
            actual = @rendered.fetch(subject.label).artifacts.to_h do |artifact|
              [artifact.kind.to_s, artifact.digest]
            end
            expected = subject.artifacts.transform_values { |item| item.fetch("digest") }
            unless actual == expected
              raise Error.new("invalid_evaluation_record", "rendered artifact digest mismatch")
            end
          end
        end
      end

      class ScoreReviewBuilder
        def build(benchmark_id:, case_id:, criterion:, left_run_id:, left_source:,
                  right_run_id:, right_source:, seed: "default")
          runs = validate_run_ids(left_run_id, right_run_id)
          sources = { left_run_id => left_source, right_run_id => right_source }
          review_criterion = Validation.enum(criterion, CRITERIA, "review criterion")
          seed_digest = Validation.sha256(Validation.text(seed, "review seed"))
          ordered = blind_order(benchmark_id, case_id, review_criterion, seed_digest, runs)
          rendered = ordered.each_with_index.to_h do |run_id, index|
            [LABELS.fetch(index), render_subject(run_id, sources.fetch(run_id))]
          end
          review = ScoreReview.create(
            benchmark_id: benchmark_id, case_id: case_id,
            criterion: review_criterion, seed_digest: seed_digest,
            subjects: review_subjects(rendered)
          )
          ScoreReviewBundle.new(review: review, rendered: rendered)
        end

        private

        def validate_run_ids(left_run_id, right_run_id)
          runs = [
            Validation.text(left_run_id, "left run_id"),
            Validation.text(right_run_id, "right run_id")
          ]
          return runs if runs.uniq.length == 2

          raise Error.new("invalid_evaluation_record", "review run ids must be distinct")
        end

        def blind_order(benchmark_id, case_id, criterion, seed_digest, runs)
          identity = [benchmark_id, case_id, criterion, seed_digest, runs.sort]
          digest = CompositionGraph::Canonical.digest(identity)
          digest[-1].to_i(16).odd? ? runs.sort.reverse : runs.sort
        end

        def render_subject(run_id, source_path)
          profile = ScoreMeasurement.from_source(source_path)
          unless profile.dig(:mechanical, :valid)
            raise Error.new(
              "invalid_evaluation_subject",
              "#{run_id} does not pass Partitura measurement",
              details: { measurement: profile }
            )
          end
          piece = Production.load_file(File.expand_path(source_path))
          RenderedSubject.new(
            run_id: run_id,
            source_digest: profile.fetch(:source_digest),
            snapshot_digest: profile.fetch(:snapshot_digest),
            artifacts: [
              Artifact.new(
                kind: :musicxml, filename: "score.musicxml",
                content: Partitura.production_musicxml(piece)
              ),
              Artifact.new(
                kind: :midi, filename: "score.mid",
                content: Partitura.production_midi(piece)
              )
            ]
          )
        end

        def review_subjects(rendered)
          rendered.map do |label, item|
            ReviewSubject.new(
              label: label, run_id: item.run_id,
              source_digest: item.source_digest,
              snapshot_digest: item.snapshot_digest,
              artifacts: item.artifacts.to_h do |artifact|
                extension = artifact.kind == :musicxml ? "musicxml" : "mid"
                [
                  artifact.kind.to_s,
                  { filename: "#{label}.#{extension}", digest: artifact.digest }
                ]
              end
            )
          end
        end
      end
    end
  end
end
