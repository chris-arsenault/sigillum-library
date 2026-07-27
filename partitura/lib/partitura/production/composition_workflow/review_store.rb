# frozen_string_literal: true

require "fileutils"
require "json"
require_relative "review_models"

module Partitura
  module Production
    module CompositionWorkflow
      class AppendOnlyRecordStore
        attr_reader :path

        def initialize(path, record_class:, record_id:)
          @path = File.expand_path(path)
          @record_class = record_class
          @record_id = record_id
        end

        def load
          return [] unless File.exist?(path)

          File.readlines(path, chomp: true, encoding: Encoding::UTF_8)
              .filter_map.with_index do |line, index|
            next if line.strip.empty?

            @record_class.from_h(JSON.parse(line))
          rescue JSON::ParserError, Error => e
            raise Error.new(
              "invalid_evidence_store",
              "invalid evidence record at line #{index + 1}: #{e.message}"
            )
          end
        end

        def fetch(record_id)
          record = load.find { |item| id_for(item) == record_id }
          return record if record

          raise Error.new("unknown_evidence_record", "#{record_id} is absent from #{path}")
        end

        def append(record)
          FileUtils.mkdir_p(File.dirname(path))
          File.open(path, File::RDWR | File::CREAT | File::APPEND, 0o644) do |file|
            file.flock(File::LOCK_EX)
            reject_duplicate(file, record)
            file.write(JSON.generate(record.to_h))
            file.write("\n")
            file.flush
            file.fsync
          ensure
            file&.flock(File::LOCK_UN)
          end
          record
        end

        private

        def reject_duplicate(file, record)
          file.rewind
          record_id = id_for(record)
          file.each_line do |line|
            next false if line.strip.empty?

            parsed = @record_class.from_h(JSON.parse(line))
            if id_for(parsed) == record_id
              raise Error.new("duplicate_evidence_record", "#{record_id} is already stored")
            end
            validate_existing_record(parsed, record)
          end
        rescue JSON::ParserError, Error => e
          raise e if e.is_a?(Error)

          raise Error.new("invalid_evidence_store", "evidence store contains invalid JSON: #{e.message}")
        end

        def validate_existing_record(_existing, _record); end

        def id_for(record)
          @record_id.call(record)
        end
      end

      class ReviewStore < AppendOnlyRecordStore
        def initialize(path)
          super(path, record_class: PairwiseReview, record_id: ->(record) { record.review_id })
        end
      end

      class PreferenceStore < AppendOnlyRecordStore
        def initialize(path)
          super(
            path,
            record_class: PreferenceRecord,
            record_id: ->(record) { record.preference_id }
          )
        end

        private

        def validate_existing_record(existing, record)
          return unless existing.review_id == record.review_id

          raise Error.new(
            "duplicate_review_preference",
            "#{record.review_id} already has a human preference"
          )
        end
      end
    end
  end
end
