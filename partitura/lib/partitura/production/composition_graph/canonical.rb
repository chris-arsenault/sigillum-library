# frozen_string_literal: true

require "digest"
require "json"

module Partitura
  module Production
    module CompositionGraph
      module Canonical
        module_function

        def value(input)
          case input
          when Hash
            input.each_with_object({}) { |(key, item), out| out[key.to_s] = value(item) }
                 .sort.to_h
          when Array
            input.map { |item| value(item) }
          when Range
            { "first" => input.begin, "last" => input.end }
          when Rational
            rational(input)
          when Symbol
            input.to_s
          else
            input
          end
        end

        def json(input)
          JSON.generate(value(input))
        end

        def digest(input)
          "sha256:#{Digest::SHA256.hexdigest(json(input))}"
        end

        def rational(input)
          number = Rational(input)
          "#{number.numerator}/#{number.denominator}"
        end

        def immutable(input)
          case input
          when Hash
            input.each_with_object({}) { |(key, item), out| out[key] = immutable(item) }.freeze
          when Array
            input.map { |item| immutable(item) }.freeze
          when String
            input.dup.freeze
          else
            input.freeze
          end
        end
      end
    end
  end
end
