# frozen_string_literal: true

require "nokogiri"
require_relative "score_observation/canonical"
require_relative "score_observation/source_reader"
require_relative "score_observation/parser"

module Partitura
  module ScoreObservation
    SCHEMA_VERSION = 1

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
          repair_instruction: "Use an unencrypted, valid score-partwise MusicXML or MXL file.",
          help_topic: "score_observation",
          docs: ["docs/architecture/partitura/10_score_observation.md"]
        }
      end
    end

    module_function

    def from_path(path)
      from_source(SourceReader.read(path))
    end

    def from_musicxml(value)
      from_source(SourceReader.read_musicxml(value))
    end

    def from_source(source)
      parsed = Parser.new(source.xml).parse
      payload = {
        schema_version: SCHEMA_VERSION,
        source: source.to_h,
        score: parsed.fetch(:score),
        summary: parsed.fetch(:summary),
        warnings: parsed.fetch(:warnings)
      }
      Canonical.value(payload.merge(observation_digest: Canonical.digest(payload)))
    rescue Nokogiri::XML::SyntaxError => error
      raise Error.new("invalid_musicxml", error.message), cause: error
    end
  end
end
