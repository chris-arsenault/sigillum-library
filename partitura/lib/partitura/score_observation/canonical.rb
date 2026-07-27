# frozen_string_literal: true

require "digest"
require "json"

module Partitura
  module ScoreObservation
    module Canonical
      module_function

      def value(input)
        case input
        when Hash
          input.each_with_object({}) { |(key, item), out| out[key.to_s] = value(item) }
               .sort.to_h
        when Array
          input.map { |item| value(item) }
        when Rational
          rational(input)
        when Symbol
          input.to_s
        else
          input
        end
      end

      def digest(input)
        "sha256:#{Digest::SHA256.hexdigest(JSON.generate(value(input)))}"
      end

      def rational(input)
        number = Rational(input)
        "#{number.numerator}/#{number.denominator}"
      end
    end
  end
end
