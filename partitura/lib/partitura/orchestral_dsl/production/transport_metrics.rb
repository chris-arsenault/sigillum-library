# frozen_string_literal: true

module Sigillum
  module OrchestralDSL
    module Production
      class TransportMetrics
        attr_reader :name, :category, :surfaces, :parts

        def self.for_piece(piece)
          new(Production.transport_hash(piece))
        end

        def self.for_manifest_entry(entry, root:)
          path = File.expand_path(fetch_value(entry, :path), root)
          piece = Production.load_file(path)
          new(
            Production.transport_hash(piece),
            name: fetch_value(entry, :name),
            category: fetch_value(entry, :category),
            surfaces: Array(fetch_value(entry, :parts)).filter_map { |part|
 fetch_value(part, :surface, required: false) }.uniq.sort
          )
        end

        def initialize(transport, name: nil, category: nil, surfaces: nil)
          @transport = transport
          @name = name || fetch_value(transport, :title)
          @category = category
          @surfaces = Array(surfaces).map(&:to_s).sort
          @parts = build_part_stats
        end

        def to_h
          {
            name: name,
            category: category,
            surfaces: surfaces,
            parts: parts
          }.compact
        end

        def render
          header = "# Transport Metrics"
          header += " #{category}/#{name}" if category
          header += " #{name}" unless category
          header += " surfaces=#{surfaces.join(',')}" unless surfaces.empty?

          lines = [header]
          if parts.empty?
            lines << "(no sounding events)"
            return lines.join("\n")
          end

          parts.each do |part, values|
            lines << format(
              "%-20s attacks %3d onsets %2d durations %2d pitches %3d",
              part,
              values.fetch(:attacks),
              values.fetch(:onset_vocab),
              values.fetch(:duration_vocab),
              values.fetch(:pitch_vocab)
            )
          end
          lines.join("\n")
        end

        def self.fetch_value(hash, key, required: true)
          return hash.fetch(key) if hash.key?(key)

          string_key = key.to_s
          return hash.fetch(string_key) if hash.key?(string_key)
          return nil unless required

          raise KeyError, "key not found: #{key.inspect}"
        end

        def fetch_value(hash, key, required: true)
          self.class.fetch_value(hash, key, required: required)
        end

        private

        def build_part_stats
          grouped = sounding_events.group_by { |event| fetch_value(event, :part) }
          grouped.transform_values do |events|
            {
              attacks: events.length,
              onset_vocab: events.map { |event| quantized_quarter(fetch_value(event, :offset_ql)) }.uniq.length,
              duration_vocab: events.map { |event| quantized_quarter(fetch_value(event, :duration_ql)) }.uniq.length,
              pitch_vocab: events.flat_map { |event|
 Array(fetch_value(event, :pitches, required: false)) }.compact.uniq.length
            }
          end.sort.to_h
        end

        def sounding_events
          Array(fetch_value(@transport, :timed_events)).reject { |event| fetch_value(event, :rest, required: false) }
        end

        def quantized_quarter(value)
          rational = Rational(value.to_s)
          (rational * 4).round / 4r
        end
      end
    end
  end
end
