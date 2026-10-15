# frozen_string_literal: true

require_relative "engine"
require_relative "adoption_controls"
require_relative "adoption_parity"

module Partitura
  module Composer
    # Convert existing explicit music, never synthesize new musical material.
    class Adoption
      include AdoptionControls
      include AdoptionParity
      def initialize(piece, id:, brief:)
        @piece = piece
        @id = id
        @brief = brief
      end

      def convert
        @piece.validate!
        refuse_unsupported!
        data = Score.create(id: @id, title: @piece.title, brief: @brief,
                            meter: @piece.meter_value, key: @piece.key_value,
                            tempo: opening_tempo, parts: parts).data
        data["beat_pattern"] = @piece.beat_pattern if @piece.beat_pattern
        data["sections"] = @piece.sections.map { |section| section_data(section) }
        score = Score.new(data)
        rebuilt = Engine.new(score).build
        rebuilt.validate!
        unless signature(@piece) == signature(rebuilt)
          raise Error.new("adoption_mismatch", "Conversion changed musical content; the source was left untouched.")
        end
        score
      end

      def refuse_unsupported!
        if unsupported_material?
          raise Error.new("unsupported_adoption", "This score uses graph, anchor, staff or transformed material " \
                          "that adoption cannot preserve. Its source was left untouched.")
        end
        validate_sections!
        unless @piece.tempo_events.all? { |event| %i[mark accelerando ritardando a_tempo].include?(event.kind) }
          raise Error.new("unsupported_adoption", "This score has unsupported tempo events.")
        end
      end

      def unsupported_material?
        unsupported_collections.any?(&:any?) ||
          @piece.placements.any? { |placement| placement.transform || placement.fill }
      end

      def validate_sections!
        expected = 1
        @piece.sections.each do |section|
          raise Error.new("unsupported_adoption", "Adoption requires contiguous sections starting at bar 1.") unless
            section.bars.begin == expected
          expected = section.bars.end + 1
        end
      end

      def unsupported_collections
        [@piece.materials, @piece.graph_relations, @piece.plan_requirements, @piece.anchors,
         @piece.gestures, @piece.staff_bars] + @piece.sections.map(&:plan_requirements) +
          @piece.sections.flat_map(&:spans).map(&:plan_requirements)
      end

      def opening_tempo
        @piece.tempo_events.find { |event| event.kind == :mark && @piece.offset_for_reference(event.at).zero? }&.text ||
          raise(Error.new("unsupported_adoption", "The score needs an explicit opening tempo."))
      end

      def parts
        @piece.parts.values.map do |part|
          result = { "id" => part.id.to_s, "name" => part.name, "instrument" => part.music21_instrument }
          %i[family range description abbreviation notation_group notation_staff ensemble].each do |field|
            value = part.public_send(field)
            result[field.to_s] = value.is_a?(Symbol) ? value.to_s : value unless value.nil?
          end
          unless part.percussion_map.empty?
            result["percussion_map"] = part.percussion_map.transform_values(&:to_s)
          end
          result
        end
      end

      def section_data(section)
        first = section.bars.begin
        meter = @piece.meter_for(first)
        tempo = @piece.tempo_events.select { |event| event.kind == :mark &&
          @piece.offset_for_reference(event.at) <= @piece.offset_for(first, 1) }.last
        result = { "id" => section.id.to_s, "name" => section.name, "bars" => section.bars.size,
                   "meter" => meter.meter, "key" => @piece.key_for_bar(first), "tempo" => tempo.text,
                   "passages" => section.spans.map.with_index { |span, index| passage_data(section, span, index) },
                   "controls" => controls(section) }
        result.merge(optional_section_fields(section, meter))
      end

      def optional_section_fields(section, meter)
        { "beat_pattern" => meter.beat_pattern, "type" => section.type&.to_s,
          "journey" => joined(section.journey_texts), "destination" => joined(section.destination_texts) }.compact
      end

      def joined(values)
        values.join("\n") unless values.empty?
      end

      def passage_data(section, span, index)
        result = { "id" => span.id&.to_s || "passage_#{index + 1}",
                   "at" => span.bars.begin - section.bars.begin + 1, "bars" => span.bars.size,
                   "voices" => span.placements.map.with_index { |placement, i| voice_data(span, placement, i) } }
        result.merge("texture" => span.texture&.to_s, "harmony" => joined(span.harmony_texts),
                     "purpose" => joined(span.process_texts), "chords" => chord_text(span)).compact
      end

      def chord_text(span)
        return if span.chord_track.empty?

        span.chord_track.map { |bar, chord| "b#{bar - span.bars.begin + 1}:#{chord}" }.join(" ")
      end

      def voice_data(span, placement, index)
        phrase = span.phrases.fetch(placement.phrase_id)
        tokens = phrase.events.map { |event| Production.event_token(event) }
        if phrase.segment_counts
          cursor = 0
          tokens = phrase.segment_counts.map do |count|
            text = tokens.slice(cursor, count).join(" ")
            cursor += count
            text
          end
          text = tokens.join(" | ")
        else
          text = tokens.join(" ")
        end
        result = { "id" => "voice_#{index + 1}", "part" => placement.part.to_s,
                   "role" => placement.role.to_s,
                   "entry" => "bar #{placement.bar - span.bars.begin + 1} beat #{placement.beat}",
                   "events" => text }
        result["anacrusis"] = placement.anacrusis.to_s if placement.anacrusis
        result["realization"] = placement.realization if placement.realization
        result
      end

    end
  end
end
