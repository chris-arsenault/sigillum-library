# frozen_string_literal: true

require "json"
require_relative "schema"

module Partitura
  module Composer
    class Score
      attr_reader :data

      def initialize(data)
        @data = JSON.parse(JSON.generate(data))
        Schema.validate!(@data, Schema::SCORE)
        validate_structure!
      end

      def self.create(id:, title:, brief:, meter: "4/4", key: "C", tempo: "quarter = 72", parts: [])
        new("schema_version" => 1, "id" => id, "title" => title, "brief" => brief,
            "meter" => meter, "key" => key, "tempo" => tempo,
            "parts" => parts, "sections" => [], "decisions" => [])
      end

      def section(id)
        data.fetch("sections").find { |item| item.fetch("id") == id } ||
          raise(Error.new("unknown_section", "No section named #{id}."))
      end

      def passage(section_id, passage_id)
        section(section_id).fetch("passages").find { |item| item.fetch("id") == passage_id } ||
          raise(Error.new("unknown_passage", "No passage #{passage_id} in #{section_id}."))
      end

      def section_start(id)
        1 + data.fetch("sections").take_while { |item| item.fetch("id") != id }.sum { |item| item.fetch("bars") }
      end

      def validate_structure!
        unique!(data.fetch("parts"), "part")
        unique!(data.fetch("sections"), "section")
        unique!(data.fetch("decisions"), "decision")
        data.fetch("sections").each { |item| validate_section!(item) }
        data.fetch("decisions").each do |decision|
          section(decision["section"]) if decision["section"]
          next unless decision["passage"]

          Schema.fail!("decision", "with a passage must name its section") unless decision["section"]
          passage(decision.fetch("section"), decision.fetch("passage"))
        end
      end

      private

      def unique!(items, name)
        ids = items.map { |item| item.fetch("id") }
        Schema.fail!(name, "identifiers must be unique") unless ids.uniq == ids
      end

      def validate_section!(item)
        unique!(item.fetch("passages"), "passage in #{item['id']}")
        unique!(item.fetch("controls"), "control in #{item['id']}")
        item.fetch("passages").each { |passage| validate_passage!(item, passage) }
        item.fetch("controls").each { |control| validate_control!(control) }
      end

      def validate_passage!(section, passage)
        if passage.fetch("at") + passage.fetch("bars") - 1 > section.fetch("bars")
          Schema.fail!(passage.fetch("id"), "extends beyond section #{section['id']}")
        end
        unique!(passage.fetch("voices"), "voice in #{passage['id']}")
        passage.fetch("voices").each { |voice| validate_voice!(voice) }
      end

      def validate_voice!(voice)
        unless data.fetch("parts").any? { |part| part.fetch("id") == voice.fetch("part") }
          Schema.fail!(voice.fetch("id"), "names unknown part #{voice['part']}")
        end
        fields = voice.keys & %w[events degrees rhythm key_context]
        valid = fields == ["events"] || fields.sort == %w[degrees key_context rhythm]
        Schema.fail!(voice.fetch("id"), "needs events, or degrees with rhythm and key_context") unless valid
      end

      def validate_control!(control)
        Schema.validate!(control["value"], Schema::METER, "meter") if control["kind"] == "meter"
        required = required_control_fields(control)
        allowed = %w[id kind] + required
        allowed << "exact" if %w[crescendo diminuendo].include?(control["kind"])
        allowed << "beat_pattern" if control["kind"] == "meter"
        fields = Schema::CONTROL.fetch("properties").slice(*allowed)
        Schema.validate!(control, Schema.object(fields, required: required + %w[id kind]), control.fetch("id"))
      end

      def required_control_fields(control)
        ranged = %w[crescendo diminuendo accelerando ritardando intentional_dissonance].include?(control.fetch("kind"))
        required = ranged ? %w[from to] : %w[at]
        required << "value" unless ranged || control["kind"] == "a_tempo"
        required << "value" if control["kind"] == "intentional_dissonance"
        targeted = %w[dynamic crescendo diminuendo text pedal clef harp_pedals key_signature
                      intentional_dissonance].include?(control["kind"])
        required << "for" if targeted
        required
      end
    end
  end
end
