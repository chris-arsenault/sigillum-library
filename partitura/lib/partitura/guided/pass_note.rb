# frozen_string_literal: true

module Partitura
  module Guided
    class PassNoteError < StandardError; end

    # Structured pass note: "field: value" lines (bullets allowed), later lines without
    # a key continue the previous field. Every required field must be present and
    # non-empty; "none" is an acceptable value, absence is not.
    module PassNote
      module_function

      def parse(text, required_fields)
        fields = parse_fields(text)
        missing = required_fields.reject { |field| fields[field] && !fields[field].strip.empty? }
        unless missing.empty?
          raise PassNoteError,
                "pass note is missing #{missing.join(', ')}. Provide every field " \
                "(#{required_fields.join(' | ')}) as `field: value` lines; use `none` when a field " \
                "genuinely has nothing to report."
        end

        fields
      end

      def parse_fields(text)
        fields = {}
        current = nil
        text.to_s.each_line do |line|
          stripped = line.strip.sub(/\A[-*]\s+/, "")
          if (match = stripped.match(/\A([a-z_\/]+)\s*:\s*(.*)\z/i))
            current = normalize_key(match[1])
            fields[current] = match[2]
          elsif current && !stripped.empty?
            fields[current] = "#{fields[current]}\n#{stripped}".strip
          end
        end
        fields
      end

      def normalize_key(key)
        key.downcase.tr("/", "_")
      end
    end
  end
end
