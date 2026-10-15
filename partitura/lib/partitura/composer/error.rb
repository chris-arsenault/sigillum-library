# frozen_string_literal: true

module Partitura
  module Composer
    class Error < StandardError
      attr_reader :code, :details

      def initialize(code, message, details: {})
        super(message)
        @code = code
        @details = details
      end

      def to_h
        { code: code, message: message, **details }
      end
    end
  end
end
