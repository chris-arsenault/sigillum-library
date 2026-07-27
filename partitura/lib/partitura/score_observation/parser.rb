# frozen_string_literal: true

require_relative "part_parser"

module Partitura
  module ScoreObservation
    class Parser
      def initialize(xml)
        @document = Nokogiri::XML(xml) { |config| config.strict.nonet }
      end

      def parse
        validate_root!
        definitions = part_definitions
        parsed_parts = parse_parts(definitions)
        warnings = parsed_parts.flat_map(&:warnings)
        measure_records, offsets = measure_timeline(parsed_parts)
        events = absolute_events(parsed_parts, offsets)
        score = score_payload(parsed_parts, measure_records, events)
        {
          score: score,
          summary: summary(score, warnings),
          warnings: warnings
        }
      end

      private

      def validate_root!
        return if @document.root&.name == "score-partwise"

        raise Error.new("unsupported_musicxml_root", "MusicXML root must be score-partwise")
      end

      def part_definitions
        definitions = @document.xpath("/score-partwise/part-list/score-part").to_h do |element|
          identifier = element["id"].to_s
          raise Error.new("invalid_part", "score-part must have an id") if identifier.empty?

          [identifier, part_definition(element, identifier)]
        end
        raise Error.new("invalid_part_list", "MusicXML part-list is empty") if definitions.empty?

        definitions
      end

      def part_definition(element, identifier)
        {
          id: identifier,
          name: text_at(element, "part-name", identifier),
          abbreviation: text_at(element, "part-abbreviation"),
          instruments: element.xpath("score-instrument").map do |instrument|
            {
              id: instrument["id"].to_s,
              name: text_at(instrument, "instrument-name", instrument["id"].to_s)
            }
          end
        }.compact
      end

      def parse_parts(definitions)
        seen = {}
        parts = @document.xpath("/score-partwise/part").map do |element|
          identifier = element["id"].to_s
          definition = definitions[identifier]
          raise Error.new("unknown_part", "part is absent from part-list: #{identifier}") unless definition
          raise Error.new("duplicate_part", "part is repeated: #{identifier}") if seen[identifier]

          seen[identifier] = true
          PartParser.new(element, definition).parse
        end
        missing = definitions.keys - seen.keys
        unless missing.empty?
          raise Error.new(
            "missing_part",
            "part-list entries lack score parts: #{missing.join(', ')}"
          )
        end

        parts
      end

      def measure_timeline(parts)
        count = parts.map { |part| part.measures.length }.max || 0
        offsets = []
        records = []
        cursor = 0r
        1.upto(count) do |index|
          variants = measure_variants(parts, index)
          duration = measure_duration(variants)
          offsets << cursor
          records << {
            index: index,
            number: variants.first&.fetch(:number, index.to_s),
            implicit: variants.any? { |measure| measure.fetch(:implicit) },
            offset_ql: cursor,
            duration_ql: duration
          }
          cursor += duration
        end
        [records, offsets]
      end

      def measure_variants(parts, index)
        parts.filter_map { |part| part.measures[index - 1] }
      end

      def measure_duration(variants)
        variants.map { |measure| measure.fetch(:duration_ql) }.max || 0r
      end

      def absolute_events(parts, offsets)
        parts.flat_map(&:events).map do |event|
          event.merge(
            onset_ql: offsets.fetch(event.fetch(:measure_index) - 1) + event.fetch(:measure_onset_ql)
          )
        end.sort_by do |event|
          [
            event.fetch(:onset_ql),
            event.fetch(:part_id),
            event.fetch(:measure_index),
            event.fetch(:event_id)
          ]
        end
      end

      def score_payload(parts, measures, events)
        {
          title: title,
          creators: creators,
          parts: parts.map(&:part),
          measures: measures,
          meter_events: global_events(parts.flat_map(&:meters), %i[measure_index beats beat_type symbol]),
          key_events: parts.flat_map(&:keys),
          tempo_events: global_events(parts.flat_map(&:tempos), %i[measure_index onset_ql bpm]),
          timed_events: events
        }
      end

      def global_events(events, keys)
        events.uniq { |event| keys.map { |key| event[key] } }
              .map { |event| event.reject { |key, _| key == :part_id } }
              .sort_by { |event| keys.map { |key| event[key].to_s } }
      end

      def title
        text_at(@document, "/score-partwise/work/work-title") ||
          text_at(@document, "/score-partwise/movement-title") ||
          "Untitled"
      end

      def creators
        @document.xpath("/score-partwise/identification/creator").map do |creator|
          {
            type: creator["type"].to_s.empty? ? "unknown" : creator["type"].to_s,
            name: creator.text.to_s.strip
          }
        end
      end

      def summary(score, warnings)
        events = score.fetch(:timed_events)
        pitches = events.filter_map { |event| event[:midi] }
        measures = score.fetch(:measures)
        {
          part_count: score.fetch(:parts).length,
          measure_count: measures.length,
          event_count: events.length,
          pitched_note_count: pitches.length,
          rest_event_count: events.count { |event| event.fetch(:kind) == "rest" },
          unpitched_event_count: events.count { |event| event.fetch(:kind) == "unpitched" },
          min_midi: pitches.min,
          max_midi: pitches.max,
          duration_ql: measures.sum { |measure| measure.fetch(:duration_ql) },
          warning_count: warnings.length
        }.compact
      end

      def text_at(element, path, default = nil)
        text = element.at_xpath(path)&.text
        text.nil? || text.strip.empty? ? default : text.strip
      end
    end
  end
end
