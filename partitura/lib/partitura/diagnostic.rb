# frozen_string_literal: true

module Partitura
  # One immutable error or lint result shared by Partitura's JSON boundaries.
  class Diagnostic
    FIELDS = %i[
      severity code message object_path source_file source_line
      repair_instruction help_topic details
    ].freeze
    RESPONSE_KEYS = %i[
      status code message object_path source_file source_line
      repair_instruction help_topic diagnostics
    ].freeze

    attr_reader(*FIELDS)

    def initialize(severity:, code:, message:, object_path: nil, source_file: nil,
                   source_line: nil, repair_instruction: nil, help_topic: nil, details: {})
      @severity = severity.to_sym
      @code = code.to_s.dup.freeze
      @message = message.to_s.dup.freeze
      @object_path = object_path && object_path.to_s.dup.freeze
      @source_file = source_file && source_file.to_s.dup.freeze
      @source_line = source_line && Integer(source_line)
      @repair_instruction = repair_instruction && repair_instruction.to_s.dup.freeze
      @help_topic = help_topic && help_topic.to_s.dup.freeze
      @details = freeze_value(details)
      freeze
    end

    alias level severity

    def to_h
      {
        severity: severity, code: code, message: message,
        object_path: object_path, source_file: source_file, source_line: source_line,
        repair_instruction: repair_instruction, help_topic: help_topic, details: details
      }
    end

    class << self
      def from_response(response, severity: :error)
        values = symbolize_keys(response)
        new(
          severity: severity,
          code: values.fetch(:code, "unknown_error"),
          message: values.fetch(:message, "Partitura operation failed."),
          object_path: values[:object_path] || inferred_object_path(values),
          source_file: values[:source_file],
          source_line: values[:source_line],
          repair_instruction: values[:repair_instruction],
          help_topic: values[:help_topic],
          details: values.reject { |key, _| RESPONSE_KEYS.include?(key) }
        )
      end

      def envelope(response)
        return response if response.key?(:diagnostics) || response.key?("diagnostics")

        response.merge(diagnostics: [from_response(response).to_h])
      end

      private

      def symbolize_keys(hash)
        hash.to_h { |key, value| [key.respond_to?(:to_sym) ? key.to_sym : key, value] }
      end

      def inferred_object_path(values)
        return "phrase:#{values[:phrase]}" if values[:phrase]
        return "section:#{values[:section]}" if values[:section]

        values[:path]
      end
    end

    private

    def freeze_value(value)
      case value
      when Hash
        value.to_h { |key, item| [freeze_value(key), freeze_value(item)] }.freeze
      when Array
        value.map { |item| freeze_value(item) }.freeze
      when String
        value.dup.freeze
      else
        value.freeze
      end
    end
  end
end
