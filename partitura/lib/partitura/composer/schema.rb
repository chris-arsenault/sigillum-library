# frozen_string_literal: true

require_relative "error"

module Partitura
  module Composer
    # The same closed schemas validate service requests and describe MCP tool arguments.
    module Schema
      module_function

      def object(properties, required: [])
        { "type" => "object", "properties" => properties, "required" => required,
          "additionalProperties" => false }
      end

      def string(description = nil, **options)
        { "type" => "string", **options.transform_keys(&:to_s) }.tap do |value|
          value["description"] = description if description
        end
      end

      def integer(min: 1, max: 4096)
        { "type" => "integer", "minimum" => min, "maximum" => max }
      end

      def array(items, max: 4096)
        { "type" => "array", "items" => items, "maxItems" => max }
      end

      def enum(*values)
        { "type" => "string", "enum" => values }
      end

      ID = string("Stable musical identifier", pattern: "^[a-z][a-z0-9_]{0,63}$").freeze
      TEXT = string(nil, maxLength: 200_000).freeze
      METER = string("Meter, for example 4/4 or 7/8", pattern: "^[1-9][0-9]*/[1-9][0-9]*$").freeze
      LOCATION = string("Position within the section: bar 1 beat 1", pattern: "^bar [1-9][0-9]* beat [0-9./]+$").freeze
      NUMBER = { "oneOf" => [{ "type" => "number" }, string(nil, pattern: "^[0-9]+(?:/[1-9][0-9]*)?$")] }.freeze
      PART = object({
        "id" => ID, "name" => TEXT, "instrument" => TEXT, "family" => TEXT, "range" => TEXT,
        "description" => TEXT, "abbreviation" => TEXT, "notation_group" => ID,
        "ensemble" => { "oneOf" => [{ "type" => "boolean" }, integer] },
        "notation_staff" => { "oneOf" => [integer(max: 2), enum("auto")] },
        "percussion_map" => { "type" => "object", "additionalProperties" => TEXT }
      }, required: %w[id name instrument]).freeze
      VOICE = object({
        "id" => ID, "part" => ID, "role" => TEXT, "realization" => TEXT,
        "entry" => LOCATION, "anacrusis" => NUMBER,
        "events" => string("Explicit pitches, durations and marks, with | barlines", maxLength: 200_000),
        "degrees" => TEXT, "rhythm" => TEXT, "key_context" => TEXT
      }, required: %w[id part]).freeze
      CONTROL = object({
        "id" => ID,
        "kind" => enum("dynamic", "crescendo", "diminuendo", "text", "pedal", "clef",
                       "chord", "harp_pedals", "key_signature", "swing", "key", "meter",
                       "tempo", "accelerando", "ritardando", "a_tempo"),
        "value" => TEXT, "at" => LOCATION, "from" => LOCATION, "to" => LOCATION,
        "for" => { "oneOf" => [TEXT, array(TEXT, max: 128)] },
        "beat_pattern" => array(integer(max: 64), max: 64), "exact" => { "type" => "boolean" }
      }, required: %w[id kind]).freeze
      PASSAGE = object({
        "id" => ID, "at" => integer, "bars" => integer, "texture" => TEXT,
        "harmony" => TEXT, "chords" => TEXT, "purpose" => TEXT,
        "voices" => array(VOICE, max: 128)
      }, required: %w[id at bars voices]).freeze
      SECTION = object({
        "id" => ID, "name" => TEXT, "bars" => integer, "meter" => METER, "key" => TEXT,
        "tempo" => TEXT, "beat_pattern" => array(integer(max: 64), max: 64),
        "journey" => TEXT, "destination" => TEXT, "type" => TEXT,
        "passages" => array(PASSAGE), "controls" => array(CONTROL)
      }, required: %w[id name bars passages controls]).freeze
      DECISION = object({ "id" => ID, "text" => TEXT, "section" => ID, "passage" => ID },
                        required: %w[id text]).freeze
      SCORE = object({
        "schema_version" => { "const" => 1 }, "id" => ID, "title" => TEXT, "brief" => TEXT,
        "meter" => METER, "key" => TEXT, "tempo" => TEXT,
        "beat_pattern" => array(integer(max: 64), max: 64),
        "parts" => array(PART, max: 128), "sections" => array(SECTION),
        "decisions" => array(DECISION)
      }, required: %w[schema_version id title brief meter key tempo parts sections decisions]).freeze

      def validate!(value, schema, path = "input")
        return validate_union!(value, schema, path) if schema.key?("oneOf")

        validate_values!(value, schema, path)
        validate_type!(value, schema, path)
      end

      def validate_union!(value, schema, path)
        matches = schema.fetch("oneOf").count { |choice| valid?(value, choice) }
        fail!(path, "must match exactly one allowed shape") unless matches == 1
      end

      def validate_values!(value, schema, path)
        fail!(path, "must equal #{schema['const'].inspect}") if schema.key?("const") && value != schema["const"]
        return unless schema["enum"] && !schema["enum"].include?(value)

        fail!(path, "must be one of #{schema['enum'].join(', ')}")
      end

      def valid?(value, schema)
        validate!(value, schema)
        true
      rescue Error
        false
      end

      def validate_type!(value, schema, path)
        case schema["type"]
        when "object" then validate_object!(value, schema, path)
        when "array" then validate_array!(value, schema, path)
        when "string" then validate_string!(value, schema, path)
        when "integer", "number" then validate_number!(value, schema, path)
        when "boolean" then fail!(path, "must be boolean") unless [true, false].include?(value)
        end
      end

      def validate_object!(value, schema, path)
        validate_object_keys!(value, path)
        missing = schema.fetch("required", []) - value.keys
        fail!(path, "missing #{missing.join(', ')}") unless missing.empty?
        value.each do |key, item|
          child = object_field(schema, key)
          fail!("#{path}.#{key}", "is unknown") unless child
          validate!(item, child, "#{path}.#{key}") if child.is_a?(Hash)
        end
      end

      def object_field(schema, key)
        schema.fetch("properties", {})[key] || schema["additionalProperties"]
      end

      def validate_object_keys!(value, path)
        return if value.is_a?(Hash) && value.keys.all? { |key| key.is_a?(String) }

        fail!(path, "must be an object with string keys")
      end

      def validate_array!(value, schema, path)
        fail!(path, "must be an array") unless value.is_a?(Array)
        fail!(path, "has too many items") if value.length > schema.fetch("maxItems", 4096)
        value.each_with_index { |item, index| validate!(item, schema.fetch("items"), "#{path}[#{index}]") }
      end

      def validate_string!(value, schema, path)
        fail!(path, "must be text") unless value.is_a?(String) && value.valid_encoding?
        fail!(path, "is too long") if value.length > schema.fetch("maxLength", 200_000)
        fail!(path,
"has an invalid format") if schema["pattern"] && !Regexp.new("\\A(?:#{schema['pattern']})\\z").match?(value)
      end

      def validate_number!(value, schema, path)
        type = schema["type"] == "integer" ? Integer : Numeric
        fail!(path, "must be a finite #{schema['type']}") unless value.is_a?(type) && value.finite?
        validate_bounds!(value, schema, path)
      end

      def validate_bounds!(value, schema, path)
        fail!(path, "is below #{schema['minimum']}") if schema["minimum"] && value < schema["minimum"]
        fail!(path, "is above #{schema['maximum']}") if schema["maximum"] && value > schema["maximum"]
      end

      def fail!(path, message)
        raise Error.new("invalid_input", "#{path} #{message}")
      end
    end
  end
end
