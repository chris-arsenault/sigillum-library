# frozen_string_literal: true

require "fileutils"
require "json"
require "tmpdir"
require_relative "review_models"

module Partitura
  module Production
    module CompositionWorkflow
      class ReviewBundle
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
            raise Error.new("duplicate_review", "review bundle already exists: #{target}")
          end

          temporary = Dir.mktmpdir(".#{review.bundle_name}-", root)
          begin
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
          target
        end

        private

        def validate_rendered
          labels = @rendered.keys.sort
          unless labels == ReviewVariant::LABELS
            raise Error.new("invalid_review", "rendered review must contain A and B")
          end
          review.variants.each do |variant|
            artifacts = @rendered.fetch(variant.label)
            actual = artifacts.to_h do |artifact|
              [artifact.kind.to_s, artifact.digest]
            end
            expected = variant.artifacts.transform_values { |item| item.fetch("digest") }
            next if actual == expected

            raise Error.new("invalid_review", "rendered artifact digests do not match review")
          end
        end

        def write_artifacts(directory)
          review.variants.each do |variant|
            @rendered.fetch(variant.label).each do |artifact|
              filename = variant.artifacts.fetch(artifact.kind.to_s).fetch("filename")
              File.binwrite(File.join(directory, filename), artifact.content)
            end
          end
        end
      end
    end
  end
end
