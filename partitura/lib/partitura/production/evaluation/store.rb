# frozen_string_literal: true

require "fileutils"
require "json"
require_relative "models"
require_relative "preference"

module Partitura
  module Production
    module Evaluation
      class RecordStore
        attr_reader :path

        def initialize(path, record_class:, record_id:, conflict: nil)
          @path = File.expand_path(path)
          @record_class = record_class
          @record_id = record_id
          @conflict = conflict
        end

        def load
          return [] unless File.exist?(path)

          File.readlines(path, chomp: true, encoding: Encoding::UTF_8)
              .filter_map.with_index do |line, index|
            next if line.strip.empty?

            @record_class.from_h(JSON.parse(line))
          rescue JSON::ParserError, Error => e
            raise Error.new(
              "invalid_evaluation_store",
              "invalid evaluation record at line #{index + 1}: #{e.message}"
            )
          end
        end

        def fetch(record_id)
          record = load.find { |item| id_for(item) == record_id }
          return record if record

          raise Error.new("unknown_evaluation_record", "#{record_id} is absent from #{path}")
        end

        def append(record)
          FileUtils.mkdir_p(File.dirname(path))
          File.open(path, File::RDWR | File::CREAT | File::APPEND, 0o644) do |file|
            file.flock(File::LOCK_EX)
            validate_existing(file, record)
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

        def validate_existing(file, record)
          file.rewind
          file.each_line do |line|
            next if line.strip.empty?

            existing = @record_class.from_h(JSON.parse(line))
            if id_for(existing) == id_for(record)
              raise Error.new("duplicate_evaluation_record", "#{id_for(record)} is already stored")
            end
            next unless @conflict&.call(existing, record)

            raise Error.new("duplicate_evaluation_preference", "#{record.review_id} is already rated")
          end
        rescue JSON::ParserError => e
          raise Error.new("invalid_evaluation_store", "evaluation store has invalid JSON: #{e.message}")
        end

        def id_for(record)
          @record_id.call(record)
        end
      end

      class ScoreReviewStore < RecordStore
        def initialize(path)
          super(
            path, record_class: ScoreReview,
            record_id: ->(record) { record.review_id }
          )
        end
      end

      class ScorePreferenceStore < RecordStore
        def initialize(path)
          super(
            path, record_class: ScorePreference,
            record_id: ->(record) { record.preference_id },
            conflict: ->(existing, record) { existing.review_id == record.review_id }
          )
        end
      end
    end
  end
end
