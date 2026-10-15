# frozen_string_literal: true

require_relative "score"

module Partitura
  module Composer
    class Operations
      SECTION_FIELDS = Schema.object(Schema::SECTION.fetch("properties").reject do |key, _|
        %w[passages controls].include?(key)
      end, required: %w[id name bars]).freeze

      def self.contract(type, properties, required)
        Schema.object({ "type" => { "const" => type }, **properties }, required: ["type", *required])
      end

      CONTRACTS = [
        contract("set_brief", { "text" => Schema::TEXT }, %w[text]),
        contract("set_part", { "part" => Schema::PART }, %w[part]),
        contract("remove_part", { "part" => Schema::ID }, %w[part]),
        contract("set_section", { "section" => SECTION_FIELDS }, %w[section]),
        contract("remove_section", { "section" => Schema::ID }, %w[section]),
        contract("arrange_sections", { "order" => Schema.array(Schema::ID) }, %w[order]),
        contract("write_passage", { "section" => Schema::ID, "passage" => Schema::PASSAGE }, %w[section passage]),
        contract("remove_passage", { "section" => Schema::ID, "passage" => Schema::ID }, %w[section passage]),
        contract("write_voice", { "section" => Schema::ID, "passage" => Schema::ID, "voice" => Schema::VOICE },
                 %w[section passage voice]),
        contract("remove_voice", { "section" => Schema::ID, "passage" => Schema::ID, "voice" => Schema::ID },
                 %w[section passage voice]),
        contract("write_control", { "section" => Schema::ID, "control" => Schema::CONTROL }, %w[section control]),
        contract("remove_control", { "section" => Schema::ID, "control" => Schema::ID }, %w[section control]),
        contract("remember", { "decision" => Schema::DECISION }, %w[decision]),
        contract("forget", { "decision" => Schema::ID }, %w[decision])
      ].freeze
      SCHEMA = { "oneOf" => CONTRACTS }.freeze
      HANDLERS = {
        "set_brief" => ->(editor, operation) { editor.set_brief(operation) },
        "set_part" => ->(editor, operation) { editor.set_part(operation) },
        "remove_part" => ->(editor, operation) { editor.remove_part(operation) },
        "set_section" => ->(editor, operation) { editor.set_section(operation) },
        "remove_section" => ->(editor, operation) { editor.remove_section(operation) },
        "arrange_sections" => ->(editor, operation) { editor.arrange_sections(operation) },
        "write_passage" => ->(editor, operation) { editor.write_passage(operation) },
        "remove_passage" => ->(editor, operation) { editor.remove_passage(operation) },
        "write_voice" => ->(editor, operation) { editor.write_voice(operation) },
        "remove_voice" => ->(editor, operation) { editor.remove_voice(operation) },
        "write_control" => ->(editor, operation) { editor.write_control(operation) },
        "remove_control" => ->(editor, operation) { editor.remove_control(operation) },
        "remember" => ->(editor, operation) { editor.remember(operation) },
        "forget" => ->(editor, operation) { editor.forget(operation) }
      }.freeze

      def initialize(score)
        @score = score
      end

      def apply(operations)
        raise Error.new("empty_revision", "Submit at least one musical change.") if operations.empty?

        operations.each do |operation|
          definition = CONTRACTS.find { |item| item.dig("properties", "type", "const") == operation["type"] }
          raise Error.new("invalid_input", "Choose a documented musical operation.") unless definition

          Schema.validate!(operation, definition, "change")
          HANDLERS.fetch(operation.fetch("type")).call(self, operation)
        end
        Score.new(@score.data)
      end

      def set_brief(operation)
        @score.data["brief"] = operation.fetch("text")
      end

      def set_part(operation)
        put(@score.data.fetch("parts"), operation.fetch("part"), merge: true)
      end

      def remove_part(operation)
        remove(@score.data.fetch("parts"), operation.fetch("part"))
      end

      def set_section(operation)
        section = operation.fetch("section")
        existing = @score.data.fetch("sections").find { |item| item.fetch("id") == section.fetch("id") }
        value = existing || { "passages" => [], "controls" => [] }
        %w[meter key tempo].each { |key| value[key] ||= @score.data.fetch(key) }
        put(@score.data.fetch("sections"), value.merge(section))
      end

      def remove_section(operation)
        remove(@score.data.fetch("sections"), operation.fetch("section"))
      end

      def arrange_sections(operation)
        sections = @score.data.fetch("sections").to_h { |section| [section.fetch("id"), section] }
        order = operation.fetch("order")
        unless order.sort == sections.keys.sort
          raise Error.new("invalid_order", "Name every section exactly once in the new order.")
        end
        @score.data["sections"] = order.map { |id| sections.fetch(id) }
      end

      def write_passage(operation)
        put(@score.section(operation.fetch("section")).fetch("passages"), operation.fetch("passage"))
      end

      def remove_passage(operation)
        remove(@score.section(operation.fetch("section")).fetch("passages"), operation.fetch("passage"))
      end

      def write_voice(operation)
        voices = @score.passage(operation.fetch("section"), operation.fetch("passage")).fetch("voices")
        value = operation.fetch("voice")
        current = voices.find { |voice| voice.fetch("id") == value.fetch("id") }
        # Keep orchestration/entry unless changed, but never mix two note encodings.
        metadata = current ? current.reject { |key, _| %w[events degrees rhythm key_context].include?(key) } : {}
        put(voices, metadata.merge(value))
      end

      def remove_voice(operation)
        remove(@score.passage(operation.fetch("section"), operation.fetch("passage")).fetch("voices"),
               operation.fetch("voice"))
      end

      def write_control(operation)
        put(@score.section(operation.fetch("section")).fetch("controls"), operation.fetch("control"))
      end

      def remove_control(operation)
        remove(@score.section(operation.fetch("section")).fetch("controls"), operation.fetch("control"))
      end

      def remember(operation)
        put(@score.data.fetch("decisions"), operation.fetch("decision"))
      end

      def forget(operation)
        remove(@score.data.fetch("decisions"), operation.fetch("decision"))
      end

      private

      def put(items, value, merge: false)
        index = items.index { |item| item.fetch("id") == value.fetch("id") }
        if index
          items[index] = merge ? items.fetch(index).merge(value) : value
        else
          items << value
        end
      end

      def remove(items, id)
        index = items.index { |item| item.fetch("id") == id }
        raise Error.new("unknown_target", "No musical item named #{id}.") unless index

        items.delete_at(index)
      end
    end
  end
end
